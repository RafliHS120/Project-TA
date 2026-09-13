# ============================================================
# SCRIPT PENGOLAHAN DATA TUGAS AKHIR - REVISI BERBASIS DBF ASLI
# Judul  : Klasifikasi Rumah Tangga Berdasarkan Pola Konsumsi Listrik
#          dan Karakteristik Sosial Ekonomi di DKI Jakarta
#
# Fokus revisi:
# 1. Membaca langsung file DBF asli dari folder C:/Documents/Tugas Akhir/Pengolahan
# 2. Menggunakan R233 kWh listrik jika tersedia valid
# 3. Jika R233 kosong/0, membuat estimasi kWh dari R234 / tarif asumsi
# 4. Menggunakan pengeluaran nonmakanan selain listrik sebagai proksi ekonomi
# 5. Menggunakan KOR IND1 untuk pendidikan KRT
# 6. Menggunakan KOR RT untuk AC, jumlah ART, daya meter, dan bobot
# 7. K-Means memakai:
#    - kWh listrik
#    - pengeluaran nonmakanan selain listrik
#    - jumlah ART
#    - lama sekolah KRT
#
# Seluruh variabel numerik pembentuk klaster:
# winsorizing -> standardisasi Z-score -> K-Means
# Tidak menggunakan transformasi log/LN.
# ============================================================

# ============================================================
# 0. KONFIGURASI AWAL
# ============================================================

folder_data <- "C:/Documents/Tugas Akhir/Pengolahan"
folder_output <- file.path(folder_data, "output_revisi_kwh")

file_kor_ind1 <- file.path(folder_data, "bv2_2026_05_06_13_50_02_ssn202503_kor_ind1.dbf")
file_kor_ind2 <- file.path(folder_data, "bv2_2026_05_06_13_51_02_ssn202503_kor_ind2.dbf")
file_kor_rt   <- file.path(folder_data, "bv2_2026_05_06_13_52_02_ssn202503_kor_rt.dbf")
file_kp       <- file.path(folder_data, "bv2_2026_05_06_13_59_02_ssn202503_kp_blok42_11_31.dbf")

seed_kmeans <- 123

# Isi NA dulu agar script memilih berdasarkan silhouette.
# Setelah melihat grafik Elbow dan Silhouette, Anda bisa ganti menjadi 3 atau 4.
k_opt <- NA

# Tarif asumsi untuk estimasi kWh jika R233 tidak terisi.
# Ganti angka ini jika Anda punya tarif resmi yang lebih sesuai.
# ============================================================
# TARIF LISTRIK BERDASARKAN KELOMPOK DAYA SUSENAS
# ============================================================

tarif_450 <- 415
tarif_900 <- 1352
tarif_1300 <- 1444.70

# fallback untuk rumah tangga tanpa informasi daya
tarif_fallback <- 1493.62

# Minimal proporsi rumah tangga dengan kWh tercatat positif agar R233 dipakai sebagai variabel utama.
# Jika di bawah threshold ini, script memakai estimasi kWh dari rupiah listrik.
threshold_kwh_valid <- 0.50

if (!dir.exists(folder_data)) {
  stop(paste("Folder data tidak ditemukan:", folder_data))
}

if (!dir.exists(folder_output)) {
  dir.create(folder_output, recursive = TRUE)
}

# ============================================================
# 1. PACKAGE
# ============================================================

packages <- c(
  "tidyverse",
  "foreign",
  "janitor",
  "skimr",
  "cluster",
  "factoextra",
  "survey",
  "broom",
  "biotools",
  "MASS",
  "scales"
)

installed <- packages %in% rownames(installed.packages())
if (any(!installed)) {
  install.packages(packages[!installed])
}

library(tidyverse)
library(foreign)
library(janitor)
library(skimr)
library(cluster)
library(factoextra)
library(survey)
library(broom)
library(biotools)
library(MASS)
library(scales)

select <- dplyr::select
filter <- dplyr::filter
rename <- dplyr::rename
mutate <- dplyr::mutate
summarise <- dplyr::summarise

# ============================================================
# 2. FUNGSI BANTU
# ============================================================

read_dbf_clean <- function(path) {
  if (!file.exists(path)) {
    stop(paste("File tidak ditemukan:", path))
  }
  
  foreign::read.dbf(path, as.is = TRUE) |>
    janitor::clean_names()
}

safe_num <- function(x) {
  suppressWarnings(as.numeric(x))
}

safe_chr <- function(x) {
  as.character(x)
}

stop_if_missing <- function(data, vars, nama_data = "data") {
  missing_vars <- setdiff(vars, names(data))
  if (length(missing_vars) > 0) {
    stop(paste(
      "Variabel berikut tidak ditemukan pada", nama_data, ":",
      paste(missing_vars, collapse = ", ")
    ))
  }
}

make_idrt <- function(data) {
  id_vars <- c("r101", "r102", "psu", "ssu", "urut")
  stop_if_missing(data, id_vars, "data untuk ID rumah tangga")
  
  data |>
    mutate(
      across(all_of(id_vars), ~ as.character(.x)),
      idrt = str_c(r101, r102, psu, ssu, urut, sep = "_")
    )
}

winsorize <- function(x, probs = c(0.01, 0.99)) {
  qs <- quantile(x, probs = probs, na.rm = TRUE)
  pmin(pmax(x, qs[1]), qs[2])
}

# Catatan:
# Fungsi ini perlu disesuaikan lagi dengan metadata/kamus variabel resmi Susenas 2025.
# R613 = jenjang pendidikan tertinggi yang sedang/pernah diikuti.
recode_pendidikan_r613 <- function(x) {
  x <- safe_num(x)
  
  case_when(
    x %in% c(0, 1) ~ 0,   # Tidak/belum pernah sekolah atau belum tamat SD
    x == 2 ~ 6,           # SD/sederajat
    x == 3 ~ 9,           # SMP/sederajat
    x == 4 ~ 12,          # SMA/sederajat
    x == 5 ~ 14,          # DI/DII
    x == 6 ~ 15,          # DIII
    x == 7 ~ 16,          # DIV/S1
    x == 8 ~ 18,          # S2
    x == 9 ~ 22,          # S3
    TRUE ~ NA_real_
  )
}

# ============================================================
# 3. BACA DATA
# ============================================================

kor_ind1_raw <- read_dbf_clean(file_kor_ind1)
kor_ind2_raw <- read_dbf_clean(file_kor_ind2)
kor_rt_raw   <- read_dbf_clean(file_kor_rt)
kp_raw       <- read_dbf_clean(file_kp)

kor_ind1 <- make_idrt(kor_ind1_raw)
kor_ind2 <- make_idrt(kor_ind2_raw)
kor_rt   <- make_idrt(kor_rt_raw)
kp       <- make_idrt(kp_raw)

cat("\nJumlah baris KOR IND1:", nrow(kor_ind1), "\n")
cat("Jumlah baris KOR IND2:", nrow(kor_ind2), "\n")
cat("Jumlah baris KOR RT  :", nrow(kor_rt), "\n")
cat("Jumlah baris KP      :", nrow(kp), "\n")

cat("\nJumlah ruta unik KOR IND1:", n_distinct(kor_ind1$idrt), "\n")
cat("Jumlah ruta unik KOR IND2:", n_distinct(kor_ind2$idrt), "\n")
cat("Jumlah ruta unik KOR RT  :", n_distinct(kor_rt$idrt), "\n")
cat("Jumlah ruta unik KP      :", n_distinct(kp$idrt), "\n")

write_csv(
  tibble(
    data = c("kor_ind1", "kor_ind2", "kor_rt", "kp"),
    n_baris = c(nrow(kor_ind1), nrow(kor_ind2), nrow(kor_rt), nrow(kp)),
    n_ruta_unik = c(
      n_distinct(kor_ind1$idrt),
      n_distinct(kor_ind2$idrt),
      n_distinct(kor_rt$idrt),
      n_distinct(kp$idrt)
    )
  ),
  file.path(folder_output, "00_ringkasan_jumlah_data.csv")
)

# ============================================================
# 4. CEK VARIABEL WAJIB
# ============================================================

stop_if_missing(kor_ind1, c("idrt", "r403", "r613", "r401", "fwt"), "KOR IND1")
stop_if_missing(kor_rt, c("idrt", "r301", "r1801c", "fwt"), "KOR RT")
stop_if_missing(kp, c("idrt", "kode", "klp", "b42k4", "b42k5", "sebulan", "wert"), "KP Blok IV.2")

# ============================================================
# 5. DIAGNOSTIK AWAL
# ============================================================

diag_id <- tibble(
  sumber = c("KOR_IND1", "KOR_IND2", "KOR_RT", "KP"),
  n_baris = c(nrow(kor_ind1), nrow(kor_ind2), nrow(kor_rt), nrow(kp)),
  n_idrt_unik = c(
    n_distinct(kor_ind1$idrt),
    n_distinct(kor_ind2$idrt),
    n_distinct(kor_rt$idrt),
    n_distinct(kp$idrt)
  )
)

write_csv(diag_id, file.path(folder_output, "01_diagnostik_id.csv"))

# Cek jumlah KRT per rumah tangga dari KOR IND1
diag_krt <- kor_ind1 |>
  group_by(idrt) |>
  summarise(
    jumlah_krt = sum(safe_num(r403) == 1, na.rm = TRUE),
    jumlah_art_record = n(),
    .groups = "drop"
  ) |>
  mutate(
    status_krt = case_when(
      jumlah_krt == 0 ~ "Tidak ada KRT",
      jumlah_krt > 1 ~ "Lebih dari satu KRT",
      TRUE ~ "OK"
    )
  )

write_csv(diag_krt, file.path(folder_output, "02_diagnostik_krt.csv"))

# Cek isi R233 dan R234 pada KP
diag_kode_listrik <- kp |>
  filter(kode %in% c(233, 234)) |>
  group_by(kode) |>
  summarise(
    n = n(),
    n_idrt = n_distinct(idrt),
    mean_b42k4 = mean(safe_num(b42k4), na.rm = TRUE),
    median_b42k4 = median(safe_num(b42k4), na.rm = TRUE),
    min_b42k4 = min(safe_num(b42k4), na.rm = TRUE),
    max_b42k4 = max(safe_num(b42k4), na.rm = TRUE),
    prop_b42k4_positif = mean(safe_num(b42k4) > 0, na.rm = TRUE),
    mean_sebulan = mean(safe_num(sebulan), na.rm = TRUE),
    median_sebulan = median(safe_num(sebulan), na.rm = TRUE),
    .groups = "drop"
  )

print(diag_kode_listrik)
write_csv(diag_kode_listrik, file.path(folder_output, "03_diagnostik_kode_233_234.csv"))

# ============================================================
# 6. BENTUK DATA RUMAH TANGGA DARI KOR
# ============================================================

# 6.1 Data KRT dari KOR IND1
krt <- kor_ind1 |>
  filter(safe_num(r403) == 1) |>
  group_by(idrt) |>
  slice(1) |>
  ungroup() |>
  transmute(
    idrt,
    pendidikan_krt = safe_num(r613),
    r613_asli = safe_num(r613)
  )

# 6.2 Data rumah tangga dari KOR RT
rt <- kor_rt |>
  group_by(idrt) |>
  slice(1) |>
  ungroup() |>
  transmute(
    idrt,
    
    r101 = safe_num(r101),
    r102 = safe_num(r102),
    r105 = safe_num(r105),
    
    fwt = safe_num(fwt),
    
    ukuran_rt = safe_num(r301),
    
    # Kategori daya listrik Susenas
    daya_susenas = safe_num(r1616b1),
    
    # Kepemilikan AC
    ac = case_when(
      safe_num(r1801c) == 1 ~ 1L,
      safe_num(r1801c) %in% c(0,2,5) ~ 0L,
      TRUE ~ NA_integer_
    ),
    
    daya_meter_1 = if ("r1616b1" %in% names(kor_rt)) safe_num(r1616b1) else NA_real_,
    daya_meter_2 = if ("r1616b2" %in% names(kor_rt)) safe_num(r1616b2) else NA_real_,
    daya_meter_3 = if ("r1616b3" %in% names(kor_rt)) safe_num(r1616b3) else NA_real_
  ) |>
  mutate(
    
    kategori_tarif = case_when(
      daya_susenas == 1 ~ "450 VA",
      daya_susenas == 2 ~ "900 VA",
      daya_susenas >= 3 ~ ">=1300 VA",
      TRUE ~ "Tanpa meter"
    ),
    
    tarif_kwh = case_when(
      kategori_tarif == "450 VA" ~ tarif_450,
      kategori_tarif == "900 VA" ~ tarif_900,
      kategori_tarif == ">=1300 VA" ~ tarif_1300,
      kategori_tarif == "Tanpa meter" ~ tarif_fallback,
      TRUE ~ tarif_fallback
    ),
    
    daya_meter_total = rowSums(
      cbind(
        replace_na(daya_meter_1,0),
        replace_na(daya_meter_2,0),
        replace_na(daya_meter_3,0)
      ),
      na.rm = TRUE
    ),
    
    daya_meter_total =
      if_else(daya_meter_total == 0,
              NA_real_,
              daya_meter_total)
  )

# Diagnostik distribusi tarif
diag_tarif <- rt |>
  count(
    kategori_tarif,
    tarif_kwh
  )

print(diag_tarif)

write_csv(
  diag_tarif,
  file.path(folder_output,"03c_distribusi_tarif_listrik.csv")
)

# ============================================================
# 7. BENTUK DATA LISTRIK DAN PENGELUARAN DARI KP
# ============================================================

# R233 = banyaknya listrik sebulan terakhir dalam kWh
listrik_kwh_r233 <- kp |>
  filter(kode == 233) |>
  group_by(idrt) |>
  summarise(
    kwh_listrik_tercatat = sum(safe_num(b42k4), na.rm = TRUE),
    kwh_listrik_tercatat_alt_sebulan = sum(safe_num(sebulan), na.rm = TRUE),
    .groups = "drop"
  )

# R234 = nilai listrik sebulan terakhir dalam rupiah
listrik_rp_r234 <- kp |>
  filter(kode == 234) |>
  group_by(idrt) |>
  summarise(
    pengeluaran_listrik_rp = sum(safe_num(b42k4), na.rm = TRUE),
    pengeluaran_listrik_rp_alt_sebulan = sum(safe_num(sebulan), na.rm = TRUE),
    .groups = "drop"
  )

# Total bukan makanan dari subtotal kelompok besar KLP == 0
# Catatan: karena file yang tersedia adalah KP Blok IV.2, ini bukan total pengeluaran penuh.
nonfood_total <- kp |>
  filter(klp == 0) |>
  group_by(idrt) |>
  summarise(
    pengeluaran_nonmakanan = sum(safe_num(sebulan), na.rm = TRUE),
    .groups = "drop"
  )

kp_hh <- kp |>
  group_by(idrt) |>
  summarise(
    wert = max(safe_num(wert), na.rm = TRUE),
    .groups = "drop"
  ) |>
  mutate(
    wert = if_else(
      is.infinite(wert),
      NA_real_,
      wert
    )
  ) |>
  left_join(
    rt |>
      select(
        idrt,
        kategori_tarif,
        tarif_kwh
      ),
    by="idrt"
  ) |>
  left_join(
    listrik_kwh_r233,
    by="idrt"
  ) |>
  left_join(
    listrik_rp_r234,
    by="idrt"
  ) |>
  left_join(
    nonfood_total,
    by="idrt"
  ) |>
  mutate(
    kwh_listrik_tercatat =
      if_else(
        is.na(kwh_listrik_tercatat),
        0,
        kwh_listrik_tercatat
      ),
    
    pengeluaran_listrik_rp =
      if_else(
        is.na(pengeluaran_listrik_rp),
        0,
        pengeluaran_listrik_rp
      ),
    
    pengeluaran_nonmakanan =
      if_else(
        is.na(pengeluaran_nonmakanan),
        0,
        pengeluaran_nonmakanan
      ),
    
    kwh_listrik_estimasi =
      pengeluaran_listrik_rp / tarif_kwh,
    
    pengeluaran_nonmakanan_nonlistrik =
      pengeluaran_nonmakanan -
      pengeluaran_listrik_rp,
    
    pengeluaran_nonmakanan_nonlistrik =
      if_else(
        pengeluaran_nonmakanan_nonlistrik < 0,
        NA_real_,
        pengeluaran_nonmakanan_nonlistrik
      )
  )

# ============================================================
# 8. PILIH VARIABEL LISTRIK FINAL: R233 ATAU ESTIMASI
# ============================================================

prop_kwh_positif <- kp_hh |>
  summarise(prop = mean(kwh_listrik_tercatat > 0, na.rm = TRUE)) |>
  pull(prop)

if (is.na(prop_kwh_positif)) {
  prop_kwh_positif <- 0
}

gunakan_kwh_tercatat <- prop_kwh_positif >= threshold_kwh_valid

if (gunakan_kwh_tercatat) {
  message("R233 kWh terisi cukup baik. Variabel utama memakai kWh tercatat.")
} else {
  warning(
    paste0(
      "R233 kWh tidak tersedia. ",
      "Script memakai estimasi kWh = R234 / tarif berdasarkan kelompok daya Susenas."
    )
  )
}

if (gunakan_kwh_tercatat) {
  kp_hh <- kp_hh |>
    mutate(
      sumber_kwh_final = "R233_kwh_tercatat",
      listrik_kwh_final = kwh_listrik_tercatat
    )
} else {
  kp_hh <- kp_hh |>
    mutate(
      sumber_kwh_final = "Estimasi_R234_dibagi_tarif",
      listrik_kwh_final = kwh_listrik_estimasi
    )
}

diag_kode_listrik_lengkap <- kp |>
  filter(kode %in% c(233, 234)) |>
  group_by(kode) |>
  summarise(
    n = n(),
    n_idrt = n_distinct(idrt),
    
    mean_b42k4 = mean(safe_num(b42k4), na.rm = TRUE),
    median_b42k4 = median(safe_num(b42k4), na.rm = TRUE),
    min_b42k4 = min(safe_num(b42k4), na.rm = TRUE),
    max_b42k4 = max(safe_num(b42k4), na.rm = TRUE),
    prop_b42k4_positif = mean(safe_num(b42k4) > 0, na.rm = TRUE),
    
    mean_b42k5 = mean(safe_num(b42k5), na.rm = TRUE),
    median_b42k5 = median(safe_num(b42k5), na.rm = TRUE),
    min_b42k5 = min(safe_num(b42k5), na.rm = TRUE),
    max_b42k5 = max(safe_num(b42k5), na.rm = TRUE),
    prop_b42k5_positif = mean(safe_num(b42k5) > 0, na.rm = TRUE),
    
    mean_sebulan = mean(safe_num(sebulan), na.rm = TRUE),
    median_sebulan = median(safe_num(sebulan), na.rm = TRUE),
    min_sebulan = min(safe_num(sebulan), na.rm = TRUE),
    max_sebulan = max(safe_num(sebulan), na.rm = TRUE),
    prop_sebulan_positif = mean(safe_num(sebulan) > 0, na.rm = TRUE),
    
    .groups = "drop"
  )

print(diag_kode_listrik_lengkap, width = Inf)

write_csv(
  diag_kode_listrik_lengkap,
  file.path(folder_output, "03b_diagnostik_kode_233_234_lengkap.csv")
)


write_csv(
  tibble(
    prop_kwh_tercatat_positif = prop_kwh_positif,
    threshold_kwh_valid = threshold_kwh_valid,
    gunakan_kwh_tercatat = gunakan_kwh_tercatat,
    tarif_kwh_asumsi = tarif_kwh_asumsi
  ),
  file.path(folder_output, "04_keputusan_sumber_kwh.csv")
)

# ============================================================
# 9. GABUNG DATA FINAL
# ============================================================

ta <- rt |>
  left_join(krt, by = "idrt") |>
  left_join(kp_hh, by = "idrt") |>
  mutate(
    # Utamakan WERT dari KP, jika ada. Kalau tidak ada, gunakan FWT dari KOR RT.
    bobot = case_when(
      !is.na(wert) & wert > 0 ~ wert,
      !is.na(fwt) & fwt > 0 ~ fwt,
      TRUE ~ NA_real_
    ),
    
    listrik_kwh_perkapita = listrik_kwh_final / ukuran_rt,
    pengeluaran_listrik_perkapita = pengeluaran_listrik_rp / ukuran_rt,
    
    share_listrik_nonfood = pengeluaran_listrik_rp / pengeluaran_nonmakanan,
    
    rp_per_kwh_estimasi_cek = if_else(
      listrik_kwh_final > 0,
      pengeluaran_listrik_rp / listrik_kwh_final,
      NA_real_
    )
  )

cek_join_pendidikan <- ta |>
  summarise(
    total=n(),
    pendidikan_tersedia=sum(!is.na(pendidikan_krt)),
    pendidikan_missing=sum(is.na(pendidikan_krt))
  )

print(cek_join_pendidikan)

# Filter hanya DKI Jakarta bila R101 = 31.
# Jika file memang sudah DKI Jakarta, ini tetap aman.
ta <- ta |>
  filter(r101 == 31)

# Cek hasil estimasi kWh

cek_tarif_kwh <- ta |>
  summarise(
    jumlah_ruta = n(),
    median_kwh = median(
      listrik_kwh_final,
      na.rm=TRUE
    ),
    min_kwh = min(
      listrik_kwh_final,
      na.rm=TRUE
    ),
    max_kwh = max(
      listrik_kwh_final,
      na.rm=TRUE
    )
  )

print(cek_tarif_kwh)

write_csv(
  cek_tarif_kwh,
  file.path(folder_output,
            "04_validasi_estimasi_kwh.csv")
)

glimpse(ta)
skim(
  ta |>
    select(
      listrik_kwh_final,
      pengeluaran_listrik_rp,
      pengeluaran_nonmakanan,
      pengeluaran_nonmakanan_nonlistrik,
      ukuran_rt,
      pendidikan_krt,
      ac,
      bobot
    )
)

# ============================================================
# DIAGNOSTIK MISSING DAN PENDIDIKAN KRT
# ============================================================

diag_missing_ta <- ta |>
  summarise(
    n = n(),
    missing_bobot = sum(is.na(bobot) | bobot <= 0),
    missing_listrik_kwh_final = sum(is.na(listrik_kwh_final)),
    missing_pengeluaran_listrik_rp = sum(is.na(pengeluaran_listrik_rp)),
    missing_pengeluaran_nonmakanan = sum(is.na(pengeluaran_nonmakanan) | pengeluaran_nonmakanan <= 0),
    missing_pengeluaran_nonmakanan_nonlistrik = sum(is.na(pengeluaran_nonmakanan_nonlistrik) | pengeluaran_nonmakanan_nonlistrik < 0),
    missing_ukuran_rt = sum(is.na(ukuran_rt) | ukuran_rt <= 0),
    missing_pendidikan_krt = sum(is.na(pendidikan_krt)),
    missing_ac = sum(is.na(ac) | !ac %in% c(0, 1))
  )

print(diag_missing_ta)
write_csv(diag_missing_ta, file.path(folder_output, "05b_diagnostik_missing_ta.csv"))

diag_r613_krt <- kor_ind1 |>
  filter(safe_num(r403) == 1) |>
  count(r613, name = "n") |>
  mutate(persen = 100 * n / sum(n)) |>
  arrange(r613)

print(as.data.frame(diag_r613_krt))
write_csv(diag_r613_krt, file.path(folder_output, "05c_distribusi_r613_krt.csv"))

if ("r615" %in% names(kor_ind1)) {
  diag_r615_krt <- kor_ind1 |>
    filter(safe_num(r403) == 1) |>
    count(r615, name = "n") |>
    mutate(persen = 100 * n / sum(n)) |>
    arrange(r615)
  
  print(diag_r615_krt, n = Inf)
  write_csv(diag_r615_krt, file.path(folder_output, "05d_distribusi_r615_krt.csv"))
}

write_csv(ta, file.path(folder_output, "05_data_gabungan_awal.csv"))

# ============================================================
# 10. CLEANING DATA ANALISIS
# ============================================================
summary(ta$pendidikan_krt)

sum(is.na(ta$pendidikan_krt))

nrow(ta)

ta_clean <- ta |>
  filter(
    !is.na(idrt),
    !is.na(bobot),
    bobot > 0,
    
    !is.na(listrik_kwh_final),
    listrik_kwh_final >= 0,
    
    !is.na(pengeluaran_listrik_rp),
    pengeluaran_listrik_rp >= 0,
    
    !is.na(pengeluaran_nonmakanan),
    pengeluaran_nonmakanan > 0,
    
    !is.na(pengeluaran_nonmakanan_nonlistrik),
    pengeluaran_nonmakanan_nonlistrik >= 0,
    
    !is.na(ukuran_rt),
    ukuran_rt > 0,
    
    !is.na(pendidikan_krt),
    pendidikan_krt >= 0,
    
    !is.na(ac),
    ac %in% c(0, 1)
  ) |>
  mutate(
    listrik_kwh_final_w = winsorize(
      listrik_kwh_final,
      probs = c(0.01, 0.99)
    ),
    
    pengeluaran_listrik_rp_w = winsorize(
      pengeluaran_listrik_rp,
      probs = c(0.01, 0.99)
    ),
    
    pengeluaran_nonmakanan_w = winsorize(
      pengeluaran_nonmakanan,
      probs = c(0.01, 0.99)
    ),
    
    pengeluaran_nonmakanan_nonlistrik_w = winsorize(
      pengeluaran_nonmakanan_nonlistrik,
      probs = c(0.01, 0.99)
    ),
    
    ukuran_rt_w = winsorize(
      ukuran_rt,
      probs = c(0.01, 0.99)
    ),
    
    listrik_kwh_perkapita_w =
      listrik_kwh_final_w / ukuran_rt_w,
    
    pengeluaran_listrik_perkapita_w =
      pengeluaran_listrik_rp_w / ukuran_rt_w,
    
    share_listrik_nonfood_w =
      pengeluaran_listrik_rp_w / pengeluaran_nonmakanan_w
  )

if (nrow(ta_clean) < 10) {
  stop("Observasi valid setelah cleaning terlalu sedikit. Cek kembali variabel dan aturan cleaning.")
}

cek_data <- ta_clean |>
  summarise(
    n_awal = nrow(ta),
    n_setelah_cleaning = n(),
    n_dibuang = n_awal - n_setelah_cleaning,
    sumber_kwh = first(sumber_kwh_final),
    prop_kwh_tercatat_positif = prop_kwh_positif,
    listrik_kwh_min = min(listrik_kwh_final_w, na.rm = TRUE),
    listrik_kwh_q1 = quantile(listrik_kwh_final_w, 0.25, na.rm = TRUE),
    listrik_kwh_median = median(listrik_kwh_final_w, na.rm = TRUE),
    listrik_kwh_q3 = quantile(listrik_kwh_final_w, 0.75, na.rm = TRUE),
    listrik_kwh_max = max(listrik_kwh_final_w, na.rm = TRUE),
    listrik_rp_median = median(pengeluaran_listrik_rp_w, na.rm = TRUE),
    nonfood_nonlistrik_median = median(pengeluaran_nonmakanan_nonlistrik_w, na.rm = TRUE),
    prop_ac = mean(ac, na.rm = TRUE) * 100
  )

print(cek_data)
write_csv(cek_data, file.path(folder_output, "06_cek_data_setelah_cleaning.csv"))

# ============================================================
# 11. ANALISIS DESKRIPTIF TERTIMBANG
# ============================================================

options(survey.lonely.psu = "adjust")

desain <- survey::svydesign(
  ids = ~1,
  weights = ~bobot,
  data = ta_clean
)

deskriptif_mean <- survey::svymean(
  ~listrik_kwh_final_w +
    pengeluaran_listrik_rp_w +
    pengeluaran_nonmakanan_nonlistrik_w +
    ukuran_rt_w +
    pendidikan_krt +
    ac +
    listrik_kwh_perkapita_w +
    share_listrik_nonfood_w,
  desain,
  na.rm = TRUE
)

print(deskriptif_mean)
capture.output(deskriptif_mean, file = file.path(folder_output, "07_deskriptif_mean_tertimbang.txt"))

deskriptif_quantile <- survey::svyquantile(
  ~listrik_kwh_final_w +
    pengeluaran_listrik_rp_w +
    pengeluaran_nonmakanan_nonlistrik_w +
    listrik_kwh_perkapita_w,
  desain,
  quantiles = c(0.25, 0.5, 0.75),
  na.rm = TRUE
)

print(deskriptif_quantile)
capture.output(deskriptif_quantile, file = file.path(folder_output, "08_deskriptif_kuantil_tertimbang.txt"))

proporsi_ac <- survey::svymean(~factor(ac), desain, na.rm = TRUE)
print(proporsi_ac)
capture.output(proporsi_ac, file = file.path(folder_output, "09_proporsi_ac_tertimbang.txt"))

tabel_deskriptif_unweighted <- ta_clean |>
  summarise(
    n = n(),
    mean_kwh = mean(listrik_kwh_final_w, na.rm = TRUE),
    median_kwh = median(listrik_kwh_final_w, na.rm = TRUE),
    mean_listrik_rp = mean(pengeluaran_listrik_rp_w, na.rm = TRUE),
    median_listrik_rp = median(pengeluaran_listrik_rp_w, na.rm = TRUE),
    mean_nonfood_nonlistrik = mean(pengeluaran_nonmakanan_nonlistrik_w, na.rm = TRUE),
    median_nonfood_nonlistrik = median(pengeluaran_nonmakanan_nonlistrik_w, na.rm = TRUE),
    mean_ukuran_rt = mean(ukuran_rt_w, na.rm = TRUE),
    mean_pendidikan_krt = mean(pendidikan_krt, na.rm = TRUE),
    proporsi_ac = mean(ac, na.rm = TRUE) * 100,
    mean_share_listrik_nonfood = mean(share_listrik_nonfood_w, na.rm = TRUE) * 100
  )

write_csv(tabel_deskriptif_unweighted, file.path(folder_output, "10_deskriptif_tidak_tertimbang.csv"))

# ============================================================
# 12. VISUALISASI DESKRIPTIF AWAL
# ============================================================

p_hist_kwh <- ggplot(ta_clean, aes(x = listrik_kwh_final_w)) +
  geom_histogram(bins = 40) +
  labs(
    title = "Distribusi Konsumsi Listrik Rumah Tangga",
    subtitle = paste("Sumber kWh:", unique(ta_clean$sumber_kwh_final)),
    x = "Listrik sebulan terakhir (kWh)",
    y = "Jumlah rumah tangga sampel"
  ) +
  theme_minimal()

ggsave(file.path(folder_output, "11_hist_listrik_kwh.png"), p_hist_kwh, width = 8, height = 5, dpi = 300)

p_box_kwh_ac <- ggplot(
  ta_clean,
  aes(x = factor(ac, labels = c("Tidak memiliki AC", "Memiliki AC")),
      y = listrik_kwh_final_w)
) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.15, alpha = 0.15, size = 0.5) +
  labs(
    title = "Konsumsi Listrik Menurut Kepemilikan AC",
    x = "Kepemilikan AC",
    y = "Listrik sebulan terakhir (kWh)"
  ) +
  theme_minimal()

ggsave(file.path(folder_output, "12_boxplot_kwh_ac.png"), p_box_kwh_ac, width = 8, height = 5, dpi = 300)

p_scatter_kwh_nonfood <- ggplot(
  ta_clean,
  aes(x = pengeluaran_nonmakanan_nonlistrik_w, y = listrik_kwh_final_w)
) +
  geom_point(alpha = 0.35, size = 0.8) +
  scale_x_continuous(labels = scales::comma) +
  labs(
    title = "Hubungan Pengeluaran Nonmakanan Non-Listrik dan Konsumsi Listrik",
    x = "Pengeluaran nonmakanan selain listrik (Rp)",
    y = "Listrik sebulan terakhir (kWh)"
  ) +
  theme_minimal()

ggsave(file.path(folder_output, "13_scatter_kwh_nonfood.png"), p_scatter_kwh_nonfood, width = 8, height = 5, dpi = 300)

# ============================================================
# 13. DATA UNTUK K-MEANS
# ============================================================

# K-Means TANPA transformasi LN.
# Variabel pembentuk:
# 1. Konsumsi listrik setelah winsorizing
# 2. Pengeluaran nonmakanan selain listrik setelah winsorizing
# 3. Ukuran rumah tangga setelah winsorizing
# 4. Lama sekolah KRT
#
# Seluruh variabel kemudian distandardisasi menggunakan Z-score.

cluster_vars <- c(
  "listrik_kwh_final_w",
  "pengeluaran_nonmakanan_nonlistrik_w",
  "ukuran_rt_w",
  "pendidikan_krt"
)

# Pemeriksaan agar tidak ada transformasi LN/log
if (any(str_detect(cluster_vars, "^ln_|log"))) {
  stop("Masih terdapat variabel transformasi LN/log dalam model.")
}

data_cluster <- ta_clean |>
  select(
    idrt,
    bobot,
    sumber_kwh_final,
    listrik_kwh_final_w,
    pengeluaran_listrik_rp_w,
    pengeluaran_nonmakanan_w,
    pengeluaran_nonmakanan_nonlistrik_w,
    listrik_kwh_perkapita_w,
    pengeluaran_listrik_perkapita_w,
    share_listrik_nonfood_w,
    ukuran_rt_w,
    pendidikan_krt,
    r613_asli,
    ac,
    daya_meter_total,
    all_of(cluster_vars)
  )

# Standardisasi Z-score
x_scaled <- data_cluster |>
  select(all_of(cluster_vars)) |>
  scale() |>
  as.data.frame()

names(x_scaled) <- paste0("z_", cluster_vars)

data_model <- bind_cols(
  data_cluster,
  x_scaled
)

x <- data_model |>
  select(starts_with("z_")) |>
  as.matrix()

if (any(!is.finite(x))) {
  stop("Matriks K-Means masih memiliki NA/NaN/Inf. Cek cleaning data.")
}

# ============================================================
# 14. EVALUASI JUMLAH KLASTER: ELBOW DAN SILHOUETTE
# ============================================================

set.seed(seed_kmeans)

k_range <- 2:min(8, nrow(x) - 1)

wss <- purrr::map_dbl(k_range, function(k) {
  kmeans(x, centers = k, nstart = 50, iter.max = 100)$tot.withinss
})

sil <- purrr::map_dbl(k_range, function(k) {
  km <- kmeans(x, centers = k, nstart = 50, iter.max = 100)
  mean(cluster::silhouette(km$cluster, dist(x))[, 3])
})

evaluasi_k <- tibble(
  k = k_range,
  wss = wss,
  silhouette = sil
)

print(evaluasi_k)
write_csv(evaluasi_k, file.path(folder_output, "14_evaluasi_jumlah_klaster.csv"))

p_elbow <- ggplot(evaluasi_k, aes(x = k, y = wss)) +
  geom_line() +
  geom_point() +
  scale_x_continuous(breaks = k_range) +
  labs(
    title = "Metode Elbow untuk Penentuan Jumlah Klaster",
    x = "Jumlah klaster (K)",
    y = "Within-Cluster Sum of Squares (WCSS)"
  ) +
  theme_minimal()

ggsave(file.path(folder_output, "15_elbow_wcss.png"), p_elbow, width = 8, height = 5, dpi = 300)

p_sil <- ggplot(evaluasi_k, aes(x = k, y = silhouette)) +
  geom_line() +
  geom_point() +
  scale_x_continuous(breaks = k_range) +
  labs(
    title = "Rata-Rata Silhouette Menurut Jumlah Klaster",
    x = "Jumlah klaster (K)",
    y = "Rata-rata Silhouette"
  ) +
  theme_minimal()

ggsave(file.path(folder_output, "16_silhouette.png"), p_sil, width = 8, height = 5, dpi = 300)

if (is.na(k_opt)) {
  k_opt <- evaluasi_k |>
    filter(silhouette == max(silhouette, na.rm = TRUE)) |>
    slice(1) |>
    pull(k)
  
  message(paste("k_opt masih NA. Sementara digunakan K =", k_opt, "berdasarkan Silhouette tertinggi."))
}

if (!k_opt %in% k_range) {
  stop(paste("k_opt harus berada dalam rentang", min(k_range), "sampai", max(k_range)))
}

# ============================================================
# 15. K-MEANS FINAL
# ============================================================

set.seed(seed_kmeans)

km_final <- kmeans(
  x,
  centers = k_opt,
  nstart = 100,
  iter.max = 100
)

data_hasil <- data_model |>
  mutate(cluster = factor(km_final$cluster))

print(table(data_hasil$cluster))

centroid_z <- as_tibble(km_final$centers, rownames = "cluster")
write_csv(centroid_z, file.path(folder_output, "17_centroid_zscore.csv"))

p_cluster <- factoextra::fviz_cluster(
  km_final,
  data = x,
  geom = "point",
  ellipse.type = "convex"
) +
  theme_minimal()

ggsave(file.path(folder_output, "18_visualisasi_cluster_pca.png"), p_cluster, width = 8, height = 6, dpi = 300)

# ============================================================
# 16. PROFILING KLASTER
# ============================================================

profil_klaster <- data_hasil |>
  group_by(cluster) |>
  summarise(
    n_sampel = n(),
    n_tertimbang = sum(bobot, na.rm = TRUE),
    persen_tertimbang = 100 * n_tertimbang / sum(data_hasil$bobot, na.rm = TRUE),
    
    rata_kwh = weighted.mean(listrik_kwh_final_w, bobot, na.rm = TRUE),
    median_kwh = median(listrik_kwh_final_w, na.rm = TRUE),
    
    rata_kwh_perkapita = weighted.mean(listrik_kwh_perkapita_w, bobot, na.rm = TRUE),
    median_kwh_perkapita = median(listrik_kwh_perkapita_w, na.rm = TRUE),
    
    rata_listrik_rp = weighted.mean(pengeluaran_listrik_rp_w, bobot, na.rm = TRUE),
    median_listrik_rp = median(pengeluaran_listrik_rp_w, na.rm = TRUE),
    
    rata_nonfood_nonlistrik = weighted.mean(pengeluaran_nonmakanan_nonlistrik_w, bobot, na.rm = TRUE),
    median_nonfood_nonlistrik = median(pengeluaran_nonmakanan_nonlistrik_w, na.rm = TRUE),
    
    rata_ukuran_rt = weighted.mean(ukuran_rt_w, bobot, na.rm = TRUE),
    rata_pendidikan_krt = weighted.mean(pendidikan_krt, bobot, na.rm = TRUE),
    
    proporsi_ac = weighted.mean(ac, bobot, na.rm = TRUE) * 100,
    rata_share_listrik_nonfood = weighted.mean(share_listrik_nonfood_w, bobot, na.rm = TRUE) * 100,
    
    rata_daya_meter = weighted.mean(daya_meter_total, bobot, na.rm = TRUE),
    
    .groups = "drop"
  ) |>
  arrange(rata_kwh)

print(profil_klaster)
write_csv(profil_klaster, file.path(folder_output, "19_profil_klaster_tertimbang.csv"))

profil_klaster_unweighted <- data_hasil |>
  group_by(cluster) |>
  summarise(
    n = n(),
    rata_kwh = mean(listrik_kwh_final_w, na.rm = TRUE),
    median_kwh = median(listrik_kwh_final_w, na.rm = TRUE),
    rata_kwh_perkapita = mean(listrik_kwh_perkapita_w, na.rm = TRUE),
    rata_listrik_rp = mean(pengeluaran_listrik_rp_w, na.rm = TRUE),
    rata_nonfood_nonlistrik = mean(pengeluaran_nonmakanan_nonlistrik_w, na.rm = TRUE),
    rata_ukuran_rt = mean(ukuran_rt_w, na.rm = TRUE),
    rata_pendidikan_krt = mean(pendidikan_krt, na.rm = TRUE),
    proporsi_ac = mean(ac, na.rm = TRUE) * 100,
    rata_share_listrik_nonfood = mean(share_listrik_nonfood_w, na.rm = TRUE) * 100,
    .groups = "drop"
  )

write_csv(profil_klaster_unweighted, file.path(folder_output, "20_profil_klaster_tidak_tertimbang.csv"))

# ============================================================
# 17. VISUALISASI PROFIL KLASTER
# ============================================================

p_profil_kwh <- ggplot(profil_klaster, aes(x = cluster, y = rata_kwh)) +
  geom_col() +
  labs(
    title = "Rata-Rata Konsumsi Listrik Menurut Klaster",
    subtitle = paste("Sumber kWh:", unique(data_hasil$sumber_kwh_final)),
    x = "Klaster",
    y = "Rata-rata listrik tertimbang (kWh)"
  ) +
  theme_minimal()

ggsave(file.path(folder_output, "21_profil_rata_kwh.png"), p_profil_kwh, width = 8, height = 5, dpi = 300)

p_profil_ac <- ggplot(profil_klaster, aes(x = cluster, y = proporsi_ac)) +
  geom_col() +
  labs(
    title = "Proporsi Kepemilikan AC Menurut Klaster",
    x = "Klaster",
    y = "Proporsi rumah tangga memiliki AC (%)"
  ) +
  theme_minimal()

ggsave(file.path(folder_output, "22_profil_proporsi_ac.png"), p_profil_ac, width = 8, height = 5, dpi = 300)

profil_z_long <- data_hasil |>
  group_by(cluster) |>
  summarise(across(starts_with("z_"), mean, na.rm = TRUE), .groups = "drop") |>
  pivot_longer(-cluster, names_to = "variabel", values_to = "rata_z") |>
  mutate(
    variabel = str_replace_all(variabel, "z_", ""),
    variabel = str_replace_all(variabel, "_", " ")
  )

p_heatmap <- ggplot(profil_z_long, aes(x = variabel, y = cluster, fill = rata_z)) +
  geom_tile() +
  geom_text(aes(label = round(rata_z, 2)), size = 4) +
  scale_fill_gradient2(low = "red", mid = "white", high = "blue", midpoint = 0) +
  labs(
    title = "Heatmap Profil Klaster Berdasarkan Rata-Rata Z-Score",
    x = "Variabel pembentuk klaster",
    y = "Klaster",
    fill = "Rata-rata Z"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 25, hjust = 1))

ggsave(file.path(folder_output, "23_heatmap_zscore_klaster.png"), p_heatmap, width = 9, height = 5, dpi = 300)

p_box_kwh_cluster <- ggplot(data_hasil, aes(x = cluster, y = listrik_kwh_final_w)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.15, alpha = 0.10, size = 0.5) +
  labs(
    title = "Sebaran Konsumsi Listrik per Klaster",
    x = "Klaster",
    y = "Listrik sebulan terakhir (kWh)"
  ) +
  theme_minimal()

ggsave(file.path(folder_output, "24_boxplot_kwh_cluster.png"), p_box_kwh_cluster, width = 8, height = 5, dpi = 300)

p_scatter_cluster <- ggplot(
  data_hasil,
  aes(x = pengeluaran_nonmakanan_nonlistrik_w, y = listrik_kwh_final_w, color = cluster)
) +
  geom_point(alpha = 0.45, size = 0.8) +
  scale_x_continuous(labels = scales::comma) +
  labs(
    title = "Pengeluaran Nonmakanan Non-Listrik dan Konsumsi Listrik Menurut Klaster",
    x = "Pengeluaran nonmakanan selain listrik (Rp)",
    y = "Listrik sebulan terakhir (kWh)",
    color = "Klaster"
  ) +
  theme_minimal()

ggsave(file.path(folder_output, "25_scatter_cluster.png"), p_scatter_cluster, width = 8, height = 5, dpi = 300)

data_hasil <- data_hasil |>
  mutate(
    pend_cat = case_when(
      pendidikan_krt <= 6 ~ "Rendah",
      pendidikan_krt <= 12 ~ "Sedang",
      pendidikan_krt > 12 ~ "Tinggi",
      TRUE ~ NA_character_
    )
  )

p_pendidikan_bar <- ggplot(data_hasil, aes(x = cluster, fill = pend_cat)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(
    title = "Distribusi Pendidikan KRT per Klaster",
    x = "Klaster",
    y = "Persentase rumah tangga",
    fill = "Kategori pendidikan"
  ) +
  theme_minimal()

ggsave(file.path(folder_output, "26_pendidikan_krt_bar.png"), p_pendidikan_bar, width = 8, height = 5, dpi = 300)

# ============================================================
# 18. UJI BEDA UNIVARIAT ANTAR KLASTER
# ============================================================

uji_vars <- c(
  "listrik_kwh_final_w",
  "pengeluaran_nonmakanan_nonlistrik_w",
  "ukuran_rt_w",
  "pendidikan_krt"
)

uji_kruskal <- purrr::map_dfr(uji_vars, function(v) {
  formula <- as.formula(paste(v, "~ cluster"))
  broom::tidy(stats::kruskal.test(formula, data = data_hasil)) |>
    mutate(variabel = v)
})

print(uji_kruskal)
write_csv(uji_kruskal, file.path(folder_output, "27_uji_kruskal.csv"))

uji_anova <- purrr::map_dfr(uji_vars, function(v) {
  formula <- as.formula(paste(v, "~ cluster"))
  fit <- stats::aov(formula, data = data_hasil)
  broom::tidy(fit) |>
    mutate(variabel = v)
})

print(uji_anova)
write_csv(uji_anova, file.path(folder_output, "28_uji_anova.csv"))

tab_ac <- table(data_hasil$cluster, data_hasil$ac)
uji_chi_ac <- broom::tidy(stats::chisq.test(tab_ac))

print(tab_ac)
print(uji_chi_ac)
write_csv(as.data.frame(tab_ac), file.path(folder_output, "29_tabel_cluster_ac.csv"))
write_csv(uji_chi_ac, file.path(folder_output, "30_uji_chi_square_ac.csv"))

# Pairwise Wilcoxon untuk variabel utama
pairwise_wilcox_kwh <- pairwise.wilcox.test(
  data_hasil$listrik_kwh_final_w,
  data_hasil$cluster,
  p.adjust.method = "bonferroni"
)

capture.output(pairwise_wilcox_kwh, file = file.path(folder_output, "31_pairwise_wilcox_kwh.txt"))

# ============================================================
# 19. EVALUASI MULTIVARIAT: MANOVA/WILKS, PILLAI, BOX'S M
# ============================================================

formula_manova <- as.formula(
  paste("cbind(", paste(uji_vars, collapse = ", "), ") ~ cluster")
)

fit_manova <- manova(formula_manova, data = data_hasil)

wilks_result <- summary(fit_manova, test = "Wilks")
pillai_result <- summary(fit_manova, test = "Pillai")

print(wilks_result)
print(pillai_result)

capture.output(wilks_result, file = file.path(folder_output, "32_manova_wilks.txt"))
capture.output(pillai_result, file = file.path(folder_output, "33_manova_pillai.txt"))

boxm_result <- biotools::boxM(
  data_hasil |> select(all_of(uji_vars)),
  grouping = data_hasil$cluster
)

print(boxm_result)
capture.output(boxm_result, file = file.path(folder_output, "34_box_m.txt"))

# ============================================================
# 20. ANALISIS DISKRIMINAN
# ============================================================

lda_data <- data_hasil |>
  select(cluster, starts_with("z_"))

lda_fit <- MASS::lda(cluster ~ ., data = lda_data)

print(lda_fit)
capture.output(lda_fit, file = file.path(folder_output, "35_lda_model.txt"))

pred_lda <- predict(lda_fit)$class

conf_matrix <- table(
  Aktual = lda_data$cluster,
  Prediksi = pred_lda
)

akurasi_lda <- sum(diag(conf_matrix)) / sum(conf_matrix)

print(conf_matrix)
print(akurasi_lda)

write_csv(
  as.data.frame.matrix(conf_matrix) |>
    rownames_to_column("Aktual"),
  file.path(folder_output, "36_confusion_matrix_lda.csv")
)

write_csv(
  tibble(akurasi_lda = akurasi_lda),
  file.path(folder_output, "37_akurasi_lda.csv")
)

# ============================================================
# 21. SIMPAN HASIL AKHIR PER RUMAH TANGGA
# ============================================================

hasil_ruta <- data_hasil |>
  mutate(cluster = as.character(cluster)) |>
  select(
    idrt,
    cluster,
    sumber_kwh_final,
    listrik_kwh_final_w,
    pengeluaran_listrik_rp_w,
    pengeluaran_nonmakanan_w,
    pengeluaran_nonmakanan_nonlistrik_w,
    listrik_kwh_perkapita_w,
    pengeluaran_listrik_perkapita_w,
    share_listrik_nonfood_w,
    ukuran_rt_w,
    pendidikan_krt,
    r613_asli,
    ac,
    daya_meter_total,
    bobot
  )

write_csv(hasil_ruta, file.path(folder_output, "38_hasil_klaster_rumah_tangga.csv"))

# ============================================================
# 22. RINGKASAN AKHIR
# ============================================================

cat("\n============================================================\n")
cat("RINGKASAN HASIL PENGOLAHAN\n")
cat("============================================================\n")
cat("Jumlah observasi awal gabungan:", nrow(ta), "\n")
cat("Jumlah observasi setelah cleaning:", nrow(ta_clean), "\n")
cat("Jumlah observasi dibuang:", nrow(ta) - nrow(ta_clean), "\n")
cat("Sumber kWh final:", unique(ta_clean$sumber_kwh_final), "\n")
cat("Proporsi R233 kWh tercatat positif:", round(prop_kwh_positif * 100, 2), "%\n")
cat("Tarif asumsi untuk estimasi kWh:", tarif_kwh_asumsi, "\n")
cat("Jumlah klaster final:", k_opt, "\n")
cat("Akurasi diskriminan:", round(akurasi_lda * 100, 2), "%\n")
cat("Output tersimpan di:", folder_output, "\n")
cat("============================================================\n")
