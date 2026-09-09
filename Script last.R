# ============================================================
# SCRIPT FINAL PENGOLAHAN DATA TA
# KLASIFIKASI RUMAH TANGGA BERDASARKAN POLA KONSUMSI LISTRIK
# DAN KARAKTERISTIK SOSIAL EKONOMI DI DKI JAKARTA
#
# Versi metodologis:
# - Konsumsi listrik aktual dalam kWh tidak tersedia memadai.
# - Estimasi konsumsi listrik dihitung dari pengeluaran listrik bulanan
#   dibagi tarif rata-rata rumah tangga DKI Jakarta berdasarkan
#   Statistik PLN 2024.
# - Tarif acuan: Rp1.493,62/kWh.
# - Variabel pembentuk klaster:
#   1. ln_estimasi_konsumsi_listrik
#   2. ln_pengeluaran_nonmakanan_selain_listrik
#   3. ukuran rumah tangga
#   4. pendidikan KRT
# - Variabel profiling:
#   AC, share listrik terhadap nonmakanan, estimasi kWh per kapita,
#   pengeluaran listrik rupiah, dan daya meter.
# ============================================================


# ============================================================
# 0. KONFIGURASI AWAL
# ============================================================

folder_data <- "C:/Documents/Tugas Akhir/Pengolahan"
folder_output <- file.path(folder_data, "output_final_estimasi_kwh_pln2024")

file_kor_ind1 <- file.path(folder_data, "bv2_2026_05_06_13_50_02_ssn202503_kor_ind1.dbf")
file_kor_ind2 <- file.path(folder_data, "bv2_2026_05_06_13_51_02_ssn202503_kor_ind2.dbf")
file_kor_rt   <- file.path(folder_data, "bv2_2026_05_06_13_52_02_ssn202503_kor_rt.dbf")
file_kp       <- file.path(folder_data, "bv2_2026_05_06_13_59_02_ssn202503_kp_blok42_11_31.dbf")

seed_kmeans <- 123

# Isi manual bila jumlah klaster ingin ditetapkan sendiri.
# Contoh:
# k_opt <- 3
# Bila tetap NA, script memilih K berdasarkan silhouette tertinggi.
k_opt <- NA

# Tarif rata-rata listrik rumah tangga DKI Jakarta berdasarkan Statistik PLN 2024.
tarif_kwh_acuan <- 1493.62

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


# ============================================================
# 2.1 RECODE PENDIDIKAN KRT
# ============================================================
# Catatan:
# - Jika R615 tersedia, digunakan sebagai pendekatan ijazah/STTB tertinggi.
# - Jika R615 tidak tersedia, digunakan R613 sebagai jenjang pendidikan
#   tertinggi yang sedang/pernah diikuti.
# - Untuk final TA, pemetaan kode tetap perlu dicocokkan dengan layout
#   atau kamus variabel Susenas 2025.

recode_lama_sekolah_r615 <- function(x) {
  x <- safe_num(x)
  
  case_when(
    is.na(x) ~ NA_real_,
    
    x %in% c(0, 1, 2) ~ 0,
    
    x %in% c(3, 4, 5) ~ 6,
    
    x %in% c(6, 7, 8) ~ 9,
    
    x %in% c(9, 10, 11) ~ 12,
    
    x %in% c(12) ~ 14,
    
    x %in% c(13) ~ 15,
    
    x %in% c(14, 15) ~ 16,
    
    x %in% c(16) ~ 18,
    
    x %in% c(17, 18, 19, 20) ~ 22,
    
    TRUE ~ NA_real_
  )
}

recode_lama_sekolah_r613 <- function(x) {
  x <- safe_num(x)
  
  case_when(
    is.na(x) ~ NA_real_,
    
    x %in% c(0, 1, 2, 21) ~ 0,
    
    x %in% c(3, 4) ~ 6,
    
    x %in% c(5, 6) ~ 9,
    
    x %in% c(7, 8, 9, 10) ~ 12,
    
    x %in% c(11) ~ 14,
    
    x %in% c(12) ~ 15,
    
    x %in% c(13, 14) ~ 16,
    
    x %in% c(15) ~ 18,
    
    x %in% c(16, 17, 18, 19, 20) ~ 22,
    
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

print(diag_kode_listrik, width = Inf)
write_csv(diag_kode_listrik, file.path(folder_output, "03_diagnostik_kode_233_234.csv"))

diag_r613_krt <- kor_ind1 |>
  filter(safe_num(r403) == 1) |>
  mutate(r613_num = safe_num(r613)) |>
  count(r613_num, name = "n") |>
  mutate(persen = 100 * n / sum(n)) |>
  arrange(r613_num)

print(as.data.frame(diag_r613_krt), row.names = FALSE)
write_csv(diag_r613_krt, file.path(folder_output, "04_distribusi_r613_krt.csv"))

if ("r615" %in% names(kor_ind1)) {
  diag_r615_krt <- kor_ind1 |>
    filter(safe_num(r403) == 1) |>
    mutate(r615_num = safe_num(r615)) |>
    count(r615_num, name = "n") |>
    mutate(persen = 100 * n / sum(n)) |>
    arrange(r615_num)
  
  print(as.data.frame(diag_r615_krt), row.names = FALSE)
  write_csv(diag_r615_krt, file.path(folder_output, "05_distribusi_r615_krt.csv"))
}


# ============================================================
# 6. BENTUK DATA KRT DAN DATA RUMAH TANGGA
# ============================================================

if ("r615" %in% names(kor_ind1)) {
  krt <- kor_ind1 |>
    filter(safe_num(r403) == 1) |>
    group_by(idrt) |>
    slice(1) |>
    ungroup() |>
    transmute(
      idrt,
      r613_asli = safe_num(r613),
      r615_asli = safe_num(r615),
      sumber_pendidikan = "R615",
      pendidikan_krt = recode_lama_sekolah_r615(r615)
    )
} else {
  krt <- kor_ind1 |>
    filter(safe_num(r403) == 1) |>
    group_by(idrt) |>
    slice(1) |>
    ungroup() |>
    transmute(
      idrt,
      r613_asli = safe_num(r613),
      r615_asli = NA_real_,
      sumber_pendidikan = "R613",
      pendidikan_krt = recode_lama_sekolah_r613(r613)
    )
}

diag_pendidikan_krt <- krt |>
  summarise(
    n_krt = n(),
    missing_pendidikan_krt = sum(is.na(pendidikan_krt)),
    prop_missing_pendidikan_krt = mean(is.na(pendidikan_krt)) * 100,
    min_pendidikan = min(pendidikan_krt, na.rm = TRUE),
    median_pendidikan = median(pendidikan_krt, na.rm = TRUE),
    max_pendidikan = max(pendidikan_krt, na.rm = TRUE),
    sumber_pendidikan = first(sumber_pendidikan)
  )

print(diag_pendidikan_krt)
write_csv(diag_pendidikan_krt, file.path(folder_output, "06_diagnostik_pendidikan_krt_recode.csv"))

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
    
    ac = case_when(
      safe_num(r1801c) == 1 ~ 1L,
      safe_num(r1801c) %in% c(0, 2, 5) ~ 0L,
      TRUE ~ NA_integer_
    ),
    
    daya_meter_1 = if ("r1616b1" %in% names(kor_rt)) safe_num(r1616b1) else NA_real_,
    daya_meter_2 = if ("r1616b2" %in% names(kor_rt)) safe_num(r1616b2) else NA_real_,
    daya_meter_3 = if ("r1616b3" %in% names(kor_rt)) safe_num(r1616b3) else NA_real_
  ) |>
  mutate(
    daya_meter_total = rowSums(
      cbind(
        replace_na(daya_meter_1, 0),
        replace_na(daya_meter_2, 0),
        replace_na(daya_meter_3, 0)
      ),
      na.rm = TRUE
    ),
    daya_meter_total = if_else(daya_meter_total == 0, NA_real_, daya_meter_total)
  )


# ============================================================
# 7. BENTUK DATA LISTRIK DAN NONMAKANAN DARI KP
# ============================================================

# Pemeriksaan kWh tercatat.
# Berdasarkan hasil diagnostik sebelumnya, kode kWh bernilai nol,
# sehingga tidak digunakan sebagai variabel utama.
listrik_kwh_tercatat <- kp |>
  filter(kode == 233) |>
  group_by(idrt) |>
  summarise(
    kwh_listrik_tercatat = sum(safe_num(b42k4), na.rm = TRUE),
    kwh_listrik_alt_b42k5 = sum(safe_num(b42k5), na.rm = TRUE),
    kwh_listrik_alt_sebulan = sum(safe_num(sebulan), na.rm = TRUE),
    .groups = "drop"
  )

# Nilai pengeluaran listrik bulanan.
listrik_rp <- kp |>
  filter(kode == 234) |>
  group_by(idrt) |>
  summarise(
    pengeluaran_listrik_rp = sum(safe_num(b42k4), na.rm = TRUE),
    pengeluaran_listrik_rp_alt_sebulan = sum(safe_num(sebulan), na.rm = TRUE),
    .groups = "drop"
  )

# Total pengeluaran nonmakanan dari subtotal kelompok besar.
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
  mutate(wert = if_else(is.infinite(wert), NA_real_, wert)) |>
  left_join(listrik_kwh_tercatat, by = "idrt") |>
  left_join(listrik_rp, by = "idrt") |>
  left_join(nonfood_total, by = "idrt") |>
  mutate(
    kwh_listrik_tercatat = if_else(is.na(kwh_listrik_tercatat), 0, kwh_listrik_tercatat),
    pengeluaran_listrik_rp = if_else(is.na(pengeluaran_listrik_rp), 0, pengeluaran_listrik_rp),
    pengeluaran_nonmakanan = if_else(is.na(pengeluaran_nonmakanan), 0, pengeluaran_nonmakanan),
    
    estimasi_kwh_listrik = pengeluaran_listrik_rp / tarif_kwh_acuan,
    
    pengeluaran_nonmakanan_nonlistrik = pengeluaran_nonmakanan - pengeluaran_listrik_rp,
    pengeluaran_nonmakanan_nonlistrik = if_else(
      pengeluaran_nonmakanan_nonlistrik < 0,
      NA_real_,
      pengeluaran_nonmakanan_nonlistrik
    ),
    
    sumber_kwh_final = "Estimasi_pengeluaran_listrik_dibagi_tarif_PLN_2024",
    listrik_kwh_final = estimasi_kwh_listrik
  )

prop_kwh_positif <- kp_hh |>
  summarise(prop = mean(kwh_listrik_tercatat > 0, na.rm = TRUE)) |>
  pull(prop)

if (is.na(prop_kwh_positif)) {
  prop_kwh_positif <- 0
}

write_csv(
  tibble(
    prop_kwh_tercatat_positif = prop_kwh_positif,
    sumber_kwh_final = "Estimasi_pengeluaran_listrik_dibagi_tarif_PLN_2024",
    tarif_kwh_acuan = tarif_kwh_acuan,
    catatan = "kWh aktual tidak tersedia memadai sehingga digunakan estimasi berbasis pengeluaran listrik"
  ),
  file.path(folder_output, "07_keputusan_sumber_kwh.csv")
)


# ============================================================
# 8. GABUNG DATA FINAL
# ============================================================

ta <- rt |>
  left_join(krt, by = "idrt") |>
  left_join(kp_hh, by = "idrt") |>
  mutate(
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
  ) |>
  filter(r101 == 31)

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

write_csv(ta, file.path(folder_output, "08_data_gabungan_awal.csv"))

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
write_csv(diag_missing_ta, file.path(folder_output, "09_diagnostik_missing_ta.csv"))


# ============================================================
# 9. CLEANING DATA ANALISIS
# ============================================================

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
    listrik_kwh_final_w = winsorize(listrik_kwh_final, probs = c(0.01, 0.99)),
    pengeluaran_listrik_rp_w = winsorize(pengeluaran_listrik_rp, probs = c(0.01, 0.99)),
    pengeluaran_nonmakanan_w = winsorize(pengeluaran_nonmakanan, probs = c(0.01, 0.99)),
    pengeluaran_nonmakanan_nonlistrik_w = winsorize(pengeluaran_nonmakanan_nonlistrik, probs = c(0.01, 0.99)),
    ukuran_rt_w = winsorize(ukuran_rt, probs = c(0.01, 0.99)),
    
    ln_listrik_kwh = log1p(listrik_kwh_final_w),
    ln_pengeluaran_nonmakanan_nonlistrik = log1p(pengeluaran_nonmakanan_nonlistrik_w),
    ln_pengeluaran_listrik_rp = log1p(pengeluaran_listrik_rp_w),
    
    listrik_kwh_perkapita_w = listrik_kwh_final_w / ukuran_rt_w,
    pengeluaran_listrik_perkapita_w = pengeluaran_listrik_rp_w / ukuran_rt_w,
    share_listrik_nonfood_w = pengeluaran_listrik_rp_w / pengeluaran_nonmakanan_w
  )

if (nrow(ta_clean) < 10) {
  stop("Observasi valid setelah cleaning terlalu sedikit. Cek kembali recode pendidikan dan aturan cleaning.")
}

cek_data <- ta_clean |>
  summarise(
    n_awal = nrow(ta),
    n_setelah_cleaning = n(),
    n_dibuang = n_awal - n_setelah_cleaning,
    sumber_kwh = first(sumber_kwh_final),
    tarif_kwh_acuan = tarif_kwh_acuan,
    
    listrik_kwh_min = min(listrik_kwh_final_w, na.rm = TRUE),
    listrik_kwh_q1 = quantile(listrik_kwh_final_w, 0.25, na.rm = TRUE),
    listrik_kwh_median = median(listrik_kwh_final_w, na.rm = TRUE),
    listrik_kwh_q3 = quantile(listrik_kwh_final_w, 0.75, na.rm = TRUE),
    listrik_kwh_max = max(listrik_kwh_final_w, na.rm = TRUE),
    
    listrik_rp_median = median(pengeluaran_listrik_rp_w, na.rm = TRUE),
    nonfood_nonlistrik_median = median(pengeluaran_nonmakanan_nonlistrik_w, na.rm = TRUE),
    prop_ac = mean(ac, na.rm = TRUE) * 100,
    missing_pendidikan_setelah_cleaning = sum(is.na(pendidikan_krt))
  )

print(cek_data)
write_csv(cek_data, file.path(folder_output, "10_cek_data_setelah_cleaning.csv"))


# ============================================================
# 10. ANALISIS DESKRIPTIF TERTIMBANG
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
capture.output(deskriptif_mean, file = file.path(folder_output, "11_deskriptif_mean_tertimbang.txt"))

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
capture.output(deskriptif_quantile, file = file.path(folder_output, "12_deskriptif_kuantil_tertimbang.txt"))

proporsi_ac <- survey::svymean(~factor(ac), desain, na.rm = TRUE)
print(proporsi_ac)
capture.output(proporsi_ac, file = file.path(folder_output, "13_proporsi_ac_tertimbang.txt"))

tabel_deskriptif_unweighted <- ta_clean |>
  summarise(
    n = n(),
    mean_estimasi_kwh = mean(listrik_kwh_final_w, na.rm = TRUE),
    median_estimasi_kwh = median(listrik_kwh_final_w, na.rm = TRUE),
    mean_listrik_rp = mean(pengeluaran_listrik_rp_w, na.rm = TRUE),
    median_listrik_rp = median(pengeluaran_listrik_rp_w, na.rm = TRUE),
    mean_nonfood_nonlistrik = mean(pengeluaran_nonmakanan_nonlistrik_w, na.rm = TRUE),
    median_nonfood_nonlistrik = median(pengeluaran_nonmakanan_nonlistrik_w, na.rm = TRUE),
    mean_ukuran_rt = mean(ukuran_rt_w, na.rm = TRUE),
    mean_pendidikan_krt = mean(pendidikan_krt, na.rm = TRUE),
    proporsi_ac = mean(ac, na.rm = TRUE) * 100,
    mean_share_listrik_nonfood = mean(share_listrik_nonfood_w, na.rm = TRUE) * 100
  )

print(tabel_deskriptif_unweighted)
write_csv(tabel_deskriptif_unweighted, file.path(folder_output, "14_deskriptif_tidak_tertimbang.csv"))


# ============================================================
# 11. VISUALISASI DESKRIPTIF
# ============================================================

p_hist_kwh <- ggplot(ta_clean, aes(x = listrik_kwh_final_w)) +
  geom_histogram(bins = 40) +
  labs(
    title = "Distribusi Estimasi Konsumsi Listrik Rumah Tangga",
    subtitle = "Estimasi kWh = pengeluaran listrik / tarif acuan Statistik PLN 2024",
    x = "Estimasi listrik sebulan terakhir (kWh)",
    y = "Jumlah rumah tangga sampel"
  ) +
  theme_minimal()

ggsave(file.path(folder_output, "15_hist_estimasi_kwh.png"), p_hist_kwh, width = 8, height = 5, dpi = 300)

p_box_kwh_ac <- ggplot(
  ta_clean,
  aes(
    x = factor(ac, labels = c("Tidak memiliki AC", "Memiliki AC")),
    y = listrik_kwh_final_w
  )
) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.15, alpha = 0.15, size = 0.5) +
  labs(
    title = "Estimasi Konsumsi Listrik Menurut Kepemilikan AC",
    x = "Kepemilikan AC",
    y = "Estimasi listrik sebulan terakhir (kWh)"
  ) +
  theme_minimal()

ggsave(file.path(folder_output, "16_boxplot_estimasi_kwh_ac.png"), p_box_kwh_ac, width = 8, height = 5, dpi = 300)

p_scatter_kwh_nonfood <- ggplot(
  ta_clean,
  aes(x = pengeluaran_nonmakanan_nonlistrik_w, y = listrik_kwh_final_w)
) +
  geom_point(alpha = 0.35, size = 0.8) +
  scale_x_continuous(labels = scales::comma) +
  labs(
    title = "Pengeluaran Nonmakanan Selain Listrik dan Estimasi Konsumsi Listrik",
    x = "Pengeluaran nonmakanan selain listrik (Rp)",
    y = "Estimasi listrik sebulan terakhir (kWh)"
  ) +
  theme_minimal()

ggsave(file.path(folder_output, "17_scatter_estimasi_kwh_nonfood.png"), p_scatter_kwh_nonfood, width = 8, height = 5, dpi = 300)


# ============================================================
# 12. DATA UNTUK K-MEANS
# ============================================================

cluster_vars <- c(
  "ln_listrik_kwh",
  "ln_pengeluaran_nonmakanan_nonlistrik",
  "ukuran_rt_w",
  "pendidikan_krt"
)

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
    r615_asli,
    sumber_pendidikan,
    ac,
    daya_meter_total,
    all_of(cluster_vars)
  )

x_scaled <- data_cluster |>
  select(all_of(cluster_vars)) |>
  scale() |>
  as.data.frame()

names(x_scaled) <- paste0("z_", cluster_vars)

data_model <- bind_cols(data_cluster, x_scaled)

x <- data_model |>
  select(starts_with("z_")) |>
  as.matrix()

if (any(!is.finite(x))) {
  stop("Matriks K-Means masih memiliki NA/NaN/Inf. Cek cleaning data.")
}


# ============================================================
# 13. EVALUASI JUMLAH KLASTER
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
write_csv(evaluasi_k, file.path(folder_output, "18_evaluasi_jumlah_klaster.csv"))

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

ggsave(file.path(folder_output, "19_elbow_wcss.png"), p_elbow, width = 8, height = 5, dpi = 300)

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

ggsave(file.path(folder_output, "20_silhouette.png"), p_sil, width = 8, height = 5, dpi = 300)

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
# 14. K-MEANS FINAL
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
write_csv(centroid_z, file.path(folder_output, "21_centroid_zscore.csv"))

p_cluster <- factoextra::fviz_cluster(
  km_final,
  data = x,
  geom = "point",
  ellipse.type = "convex"
) +
  theme_minimal()

ggsave(file.path(folder_output, "22_visualisasi_cluster_pca.png"), p_cluster, width = 8, height = 6, dpi = 300)


# ============================================================
# 15. PROFILING KLASTER
# ============================================================

profil_klaster <- data_hasil |>
  group_by(cluster) |>
  summarise(
    n_sampel = n(),
    n_tertimbang = sum(bobot, na.rm = TRUE),
    persen_tertimbang = 100 * n_tertimbang / sum(data_hasil$bobot, na.rm = TRUE),
    
    rata_estimasi_kwh = weighted.mean(listrik_kwh_final_w, bobot, na.rm = TRUE),
    median_estimasi_kwh = median(listrik_kwh_final_w, na.rm = TRUE),
    
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
  arrange(rata_estimasi_kwh)

print(profil_klaster)
write_csv(profil_klaster, file.path(folder_output, "23_profil_klaster_tertimbang.csv"))

profil_klaster_unweighted <- data_hasil |>
  group_by(cluster) |>
  summarise(
    n = n(),
    rata_estimasi_kwh = mean(listrik_kwh_final_w, na.rm = TRUE),
    median_estimasi_kwh = median(listrik_kwh_final_w, na.rm = TRUE),
    rata_kwh_perkapita = mean(listrik_kwh_perkapita_w, na.rm = TRUE),
    rata_listrik_rp = mean(pengeluaran_listrik_rp_w, na.rm = TRUE),
    rata_nonfood_nonlistrik = mean(pengeluaran_nonmakanan_nonlistrik_w, na.rm = TRUE),
    rata_ukuran_rt = mean(ukuran_rt_w, na.rm = TRUE),
    rata_pendidikan_krt = mean(pendidikan_krt, na.rm = TRUE),
    proporsi_ac = mean(ac, na.rm = TRUE) * 100,
    rata_share_listrik_nonfood = mean(share_listrik_nonfood_w, na.rm = TRUE) * 100,
    .groups = "drop"
  )

write_csv(profil_klaster_unweighted, file.path(folder_output, "24_profil_klaster_tidak_tertimbang.csv"))


# ============================================================
# 16. VISUALISASI PROFIL KLASTER
# ============================================================

p_profil_kwh <- ggplot(profil_klaster, aes(x = cluster, y = rata_estimasi_kwh)) +
  geom_col() +
  labs(
    title = "Rata-Rata Estimasi Konsumsi Listrik Menurut Klaster",
    subtitle = "Estimasi kWh = pengeluaran listrik / tarif acuan Statistik PLN 2024",
    x = "Klaster",
    y = "Rata-rata estimasi listrik tertimbang (kWh)"
  ) +
  theme_minimal()

ggsave(file.path(folder_output, "25_profil_rata_estimasi_kwh.png"), p_profil_kwh, width = 8, height = 5, dpi = 300)

p_profil_ac <- ggplot(profil_klaster, aes(x = cluster, y = proporsi_ac)) +
  geom_col() +
  labs(
    title = "Proporsi Kepemilikan AC Menurut Klaster",
    x = "Klaster",
    y = "Proporsi rumah tangga memiliki AC (%)"
  ) +
  theme_minimal()

ggsave(file.path(folder_output, "26_profil_proporsi_ac.png"), p_profil_ac, width = 8, height = 5, dpi = 300)

profil_z_long <- data_hasil |>
  group_by(cluster) |>
  summarise(across(starts_with("z_"), \(x) mean(x, na.rm = TRUE)), .groups = "drop") |>
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

ggsave(file.path(folder_output, "27_heatmap_zscore_klaster.png"), p_heatmap, width = 9, height = 5, dpi = 300)

p_box_kwh_cluster <- ggplot(data_hasil, aes(x = cluster, y = listrik_kwh_final_w)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.15, alpha = 0.10, size = 0.5) +
  labs(
    title = "Sebaran Estimasi Konsumsi Listrik per Klaster",
    x = "Klaster",
    y = "Estimasi listrik sebulan terakhir (kWh)"
  ) +
  theme_minimal()

ggsave(file.path(folder_output, "28_boxplot_estimasi_kwh_cluster.png"), p_box_kwh_cluster, width = 8, height = 5, dpi = 300)

p_scatter_cluster <- ggplot(
  data_hasil,
  aes(x = pengeluaran_nonmakanan_nonlistrik_w, y = listrik_kwh_final_w, color = cluster)
) +
  geom_point(alpha = 0.45, size = 0.8) +
  scale_x_continuous(labels = scales::comma) +
  labs(
    title = "Pengeluaran Nonmakanan Selain Listrik dan Estimasi Konsumsi Listrik Menurut Klaster",
    x = "Pengeluaran nonmakanan selain listrik (Rp)",
    y = "Estimasi listrik sebulan terakhir (kWh)",
    color = "Klaster"
  ) +
  theme_minimal()

ggsave(file.path(folder_output, "29_scatter_cluster.png"), p_scatter_cluster, width = 8, height = 5, dpi = 300)

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

ggsave(file.path(folder_output, "30_pendidikan_krt_bar.png"), p_pendidikan_bar, width = 8, height = 5, dpi = 300)


# ============================================================
# 17. UJI BEDA UNIVARIAT ANTAR KLASTER
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
write_csv(uji_kruskal, file.path(folder_output, "31_uji_kruskal.csv"))

uji_anova <- purrr::map_dfr(uji_vars, function(v) {
  formula <- as.formula(paste(v, "~ cluster"))
  fit <- stats::aov(formula, data = data_hasil)
  broom::tidy(fit) |>
    mutate(variabel = v)
})

print(uji_anova)
write_csv(uji_anova, file.path(folder_output, "32_uji_anova.csv"))

tab_ac <- table(data_hasil$cluster, data_hasil$ac)
uji_chi_ac <- broom::tidy(stats::chisq.test(tab_ac))

print(tab_ac)
print(uji_chi_ac)

write_csv(as.data.frame(tab_ac), file.path(folder_output, "33_tabel_cluster_ac.csv"))
write_csv(uji_chi_ac, file.path(folder_output, "34_uji_chi_square_ac.csv"))

pairwise_wilcox_kwh <- pairwise.wilcox.test(
  data_hasil$listrik_kwh_final_w,
  data_hasil$cluster,
  p.adjust.method = "bonferroni"
)

capture.output(pairwise_wilcox_kwh, file = file.path(folder_output, "35_pairwise_wilcox_estimasi_kwh.txt"))


# ============================================================
# 18. EVALUASI MULTIVARIAT
# ============================================================

formula_manova <- as.formula(
  paste("cbind(", paste(uji_vars, collapse = ", "), ") ~ cluster")
)

fit_manova <- manova(formula_manova, data = data_hasil)

wilks_result <- summary(fit_manova, test = "Wilks")
pillai_result <- summary(fit_manova, test = "Pillai")

print(wilks_result)
print(pillai_result)

capture.output(wilks_result, file = file.path(folder_output, "36_manova_wilks.txt"))
capture.output(pillai_result, file = file.path(folder_output, "37_manova_pillai.txt"))

boxm_result <- biotools::boxM(
  data_hasil |> select(all_of(uji_vars)),
  grouping = data_hasil$cluster
)

print(boxm_result)
capture.output(boxm_result, file = file.path(folder_output, "38_box_m.txt"))


# ============================================================
# 19. ANALISIS DISKRIMINAN
# ============================================================

lda_data <- data_hasil |>
  select(cluster, starts_with("z_"))

lda_fit <- MASS::lda(cluster ~ ., data = lda_data)

print(lda_fit)
capture.output(lda_fit, file = file.path(folder_output, "39_lda_model.txt"))

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
  file.path(folder_output, "40_confusion_matrix_lda.csv")
)

write_csv(
  tibble(akurasi_lda = akurasi_lda),
  file.path(folder_output, "41_akurasi_lda.csv")
)


# ============================================================
# 20. SIMPAN HASIL AKHIR PER RUMAH TANGGA
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
    r615_asli,
    sumber_pendidikan,
    ac,
    daya_meter_total,
    bobot
  )

write_csv(hasil_ruta, file.path(folder_output, "42_hasil_klaster_rumah_tangga.csv"))


# ============================================================
# 21. RINGKASAN AKHIR
# ============================================================

cat("\n============================================================\n")
cat("RINGKASAN HASIL PENGOLAHAN FINAL\n")
cat("============================================================\n")
cat("Jumlah observasi awal gabungan:", nrow(ta), "\n")
cat("Jumlah observasi setelah cleaning:", nrow(ta_clean), "\n")
cat("Jumlah observasi dibuang:", nrow(ta) - nrow(ta_clean), "\n")
cat("Sumber kWh final:", unique(ta_clean$sumber_kwh_final), "\n")
cat("Tarif acuan estimasi kWh:", tarif_kwh_acuan, "\n")
cat("Sumber pendidikan:", unique(ta_clean$sumber_pendidikan), "\n")
cat("Jumlah klaster final:", k_opt, "\n")
cat("Akurasi diskriminan:", round(akurasi_lda * 100, 2), "%\n")
cat("Output tersimpan di:", folder_output, "\n")
cat("============================================================\n")