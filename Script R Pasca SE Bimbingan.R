# ============================================================
# SCRIPT PENGOLAHAN DATA TA — REVISI PASCA BIMBINGAN 14 SEPTEMBER 2026
# KLASIFIKASI RUMAH TANGGA BERDASARKAN POLA KONSUMSI LISTRIK
# DAN KARAKTERISTIK SOSIAL EKONOMI DI DKI JAKARTA
#
# DAFTAR PERUBAHAN TERHADAP VERSI SEBELUMNYA
# 1. [PERBAIKAN GALAT] ggsave grafik elbow sebelumnya tidak memiliki
#    kurung penutup sehingga blok p_sil ikut tertelan sebagai argumen.
# 2. [PERBAIKAN GALAT] objek p_elbow sebelumnya didefinisikan dua kali.
# 3. Rumah tangga tanpa golongan daya (R1616B1 = 0) DIBUANG dari analisis.
#    Tarif fallback Rp1.493,62 tidak lagi dipakai untuk membentuk kWh.
# 4. Grafik elbow dimulai dari K = 1. Silhouette tidak terdefinisi pada
#    K = 1 sehingga tetap dihitung mulai K = 2 dan ditandai NA pada K = 1.
# 5. Transformasi ln DIPERTAHANKAN. Versi tanpa ln dijalankan sebagai
#    analisis sensitivitas untuk lampiran (berkas 18d dan 18e).
# 6. Matriks jarak dihitung satu kali, tidak berulang di dalam perulangan.
# 7. Tambahan blok 23: tabel penjelas visualisasi PCA (kontribusi tiap
#    variabel pada sumbu Dim1/Dim2 dan posisi centroid klaster).
# 8. Perbaikan keterbacaan grafik: label nilai, label variabel berbahasa
#    Indonesia, dan keterangan persentase keragaman pada sumbu PCA.
#
# CATATAN METODOLOGIS
# - Konsumsi listrik aktual dalam kWh tidak tersedia memadai (kode 233 = 0).
# - Estimasi konsumsi listrik = pengeluaran listrik bulanan dibagi tarif
#   tenaga listrik sesuai golongan daya terpasang rumah tangga.
# - Variabel pembentuk klaster (spesifikasi S2):
#     1. ln estimasi konsumsi listrik (kWh)
#     2. ln pengeluaran nonmakanan selain listrik
#     3. lama sekolah kepala rumah tangga
# - Variabel penciri (penjawab Tujuan 3): AC, lemari es, luas lantai,
#   ukuran rumah tangga, golongan daya terpasang.
# ============================================================


# ============================================================
# 0. KONFIGURASI AWAL
# ============================================================

folder_data <- "C:/Documents/Tugas Akhir/Pengolahan"

file_kor_ind1 <- file.path(folder_data, "bv2_2026_05_06_13_50_02_ssn202503_kor_ind1.dbf")
file_kor_ind2 <- file.path(folder_data, "bv2_2026_05_06_13_51_02_ssn202503_kor_ind2.dbf")
file_kor_rt   <- file.path(folder_data, "bv2_2026_05_06_13_52_02_ssn202503_kor_rt.dbf")
file_kp       <- file.path(folder_data, "bv2_2026_05_06_13_59_02_ssn202503_kp_blok42_11_31.dbf")

seed_kmeans <- 123

# Isi manual bila jumlah klaster ingin ditetapkan sendiri (contoh: k_opt <- 3).
# Bila tetap NA, script memilih K dengan silhouette tertinggi pada K >= 2.
k_opt <- NA

# --- Tarif tenaga listrik golongan RUMAH TANGGA (Rp/kWh) ---------------
# Sumber: [PERLU VERIFIKASI] Permen/Kepmen ESDM tentang Tarif Tenaga Listrik
#         beserta penetapan tarif adjustment triwulanan.
# Pemetaan kategori R1616B1 Susenas -> golongan tarif PLN:
#   1 = 450 watt              -> R-1/TR 450 VA bersubsidi        =   415,00
#   2 = 900 watt              -> R-1/TR 900 VA bersubsidi        =   605,00
#                                (alternatif: 900 VA-RTM         = 1.352,00)
#   3 = 1.300 watt atau lebih -> R-1/TR 1.300-2.200 VA           = 1.444,70
#                                (alternatif: R-2/R-3            = 1.699,53)
#   0 = tanpa meteran PLN     -> TIDAK DIPAKAI, rumah tangga dibuang
#
# Skenario utama sesuai kesepakatan. Skenario lain tersedia untuk uji
# sensitivitas dan cukup diganti pada satu baris di bawah.
skenario_tarif <- "utama"   # "utama" | "s900_rtm" | "s_atas" | "tarif_tunggal"

tarif_golongan <- switch(
  skenario_tarif,
  utama         = c("1" =  415.00, "2" =  605.00, "3" = 1444.70),
  s900_rtm      = c("1" =  415.00, "2" = 1352.00, "3" = 1444.70),
  s_atas        = c("1" =  415.00, "2" = 1352.00, "3" = 1699.53),
  tarif_tunggal = c("1" = 1493.62, "2" = 1493.62, "3" = 1493.62),
  stop("skenario_tarif tidak dikenal.")
)

# Tarif rata-rata RT UID Jakarta Raya (Statistik PLN 2024, Tabel 9, hlm. 22).
# Setelah revisi, angka ini hanya dipakai sebagai PEMBANDING deskriptif,
# bukan lagi sebagai tarif pembentuk kWh bagi rumah tangga mana pun.
tarif_kwh_acuan <- 1493.62

folder_output <- file.path(folder_data,
                           paste0("output_revisi_", skenario_tarif))

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
  "tidyverse", "foreign", "janitor", "skimr", "cluster",
  "factoextra", "survey", "broom", "biotools", "MASS", "scales"
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

cramer_v <- function(klaster, ac) {
  tab <- table(klaster, ac)
  khi <- suppressWarnings(chisq.test(tab, correct = FALSE))$statistic
  as.numeric(sqrt(khi / (sum(tab) * (min(dim(tab)) - 1))))
}


# ============================================================
# 2.1 RECODE PENDIDIKAN KRT
# ------------------------------------------------------------
# Kode R613/R615 mengikuti layout Susenas Maret 2025
# (sheet "value label individu").
# [PERLU VERIFIKASI] cocokkan tabel konversi lama sekolah dengan
# metadata RLS di Sirusa BPS sebelum ditulis di naskah.
# ============================================================

tahun_sekolah <- c("0" = 0,
                   "1" = 6,  "2" = 6,  "3" = 6,  "4" = 6,  "5" = 6,
                   "6" = 9,  "7" = 9,  "8" = 9,  "9" = 9,  "10" = 9,
                   "11" = 12, "12" = 12, "13" = 12, "14" = 12,
                   "15" = 12, "16" = 12, "17" = 12,
                   "18" = 14, "19" = 15, "20" = 16, "21" = 16,
                   "22" = 16, "23" = 18, "24" = 18,
                   "25" = 0)

konversi_tahun <- function(x) {
  unname(tahun_sekolah[as.character(safe_num(x))])
}

ambil_var_ind <- function(nama_var) {
  if (nama_var %in% names(kor_ind1)) {
    sumber <- kor_ind1
  } else if (nama_var %in% names(kor_ind2)) {
    sumber <- kor_ind2
  } else {
    return(NULL)
  }
  stop_if_missing(sumber, c("idrt", "r401", nama_var),
                  paste("berkas individu untuk", nama_var))
  sumber |>
    transmute(idrt, r401 = safe_num(r401), nilai = safe_num(.data[[nama_var]])) |>
    distinct(idrt, r401, .keep_all = TRUE) |>
    rename(!!nama_var := nilai)
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

write_csv(
  tibble(
    data = c("kor_ind1", "kor_ind2", "kor_rt", "kp"),
    n_baris = c(nrow(kor_ind1), nrow(kor_ind2), nrow(kor_rt), nrow(kp)),
    n_ruta_unik = c(n_distinct(kor_ind1$idrt), n_distinct(kor_ind2$idrt),
                    n_distinct(kor_rt$idrt), n_distinct(kp$idrt))
  ),
  file.path(folder_output, "00_ringkasan_jumlah_data.csv")
)


# ============================================================
# 4. CEK VARIABEL WAJIB
# ============================================================

stop_if_missing(kor_ind1, c("idrt", "r403", "r613", "r401", "fwt"), "KOR IND1")
stop_if_missing(kor_rt, c("idrt", "r301", "r1801c", "fwt"), "KOR RT")
stop_if_missing(kp, c("idrt", "kode", "klp", "b42k4", "b42k5", "sebulan", "wert"),
                "KP Blok IV.2")


# ============================================================
# 5. DIAGNOSTIK AWAL
# ============================================================

diag_id <- tibble(
  sumber = c("KOR_IND1", "KOR_IND2", "KOR_RT", "KP"),
  n_baris = c(nrow(kor_ind1), nrow(kor_ind2), nrow(kor_rt), nrow(kp)),
  n_idrt_unik = c(n_distinct(kor_ind1$idrt), n_distinct(kor_ind2$idrt),
                  n_distinct(kor_rt$idrt), n_distinct(kp$idrt))
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

write_csv(diag_r613_krt, file.path(folder_output, "04_distribusi_r613_krt.csv"))

if ("r615" %in% names(kor_ind1)) {
  diag_r615_krt <- kor_ind1 |>
    filter(safe_num(r403) == 1) |>
    mutate(r615_num = safe_num(r615)) |>
    count(r615_num, name = "n") |>
    mutate(persen = 100 * n / sum(n)) |>
    arrange(r615_num)
  write_csv(diag_r615_krt, file.path(folder_output, "05_distribusi_r615_krt.csv"))
}


# ============================================================
# 6. BENTUK DATA KRT DAN DATA RUMAH TANGGA
# ============================================================

krt <- kor_ind1 |>
  filter(safe_num(r403) == 1) |>
  group_by(idrt) |>
  slice(1) |>
  ungroup() |>
  transmute(idrt, r401 = safe_num(r401))

for (v in c("r611", "r613", "r615")) {
  tambahan <- ambil_var_ind(v)
  if (is.null(tambahan)) {
    krt[[v]] <- NA_real_
  } else {
    krt <- krt |> left_join(tambahan, by = c("idrt", "r401"))
  }
}

krt <- krt |>
  mutate(
    r613_asli = r613,
    r615_asli = r615,
    thn_r615 = konversi_tahun(r615),
    thn_r613 = konversi_tahun(r613),
    pendidikan_krt = case_when(
      r611 == 1 ~ 0,
      !is.na(thn_r615) ~ thn_r615,
      !is.na(thn_r613) ~ thn_r613,
      TRUE ~ NA_real_
    ),
    sumber_pendidikan = case_when(
      r611 == 1 ~ "R611_tidak_pernah_sekolah",
      !is.na(thn_r615) ~ "R615",
      !is.na(thn_r613) ~ "R613",
      TRUE ~ "Tidak_terkonversi"
    )
  ) |>
  select(idrt, r613_asli, r615_asli, sumber_pendidikan, pendidikan_krt)

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
write_csv(diag_pendidikan_krt,
          file.path(folder_output, "06_diagnostik_pendidikan_krt_recode.csv"))

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
      cbind(replace_na(daya_meter_1, 0),
            replace_na(daya_meter_2, 0),
            replace_na(daya_meter_3, 0)),
      na.rm = TRUE
    ),
    daya_meter_total = if_else(daya_meter_total == 0, NA_real_, daya_meter_total)
  )


# ============================================================
# 7. BENTUK DATA LISTRIK DAN NONMAKANAN DARI KP
# ============================================================

listrik_kwh_tercatat <- kp |>
  filter(kode == 233) |>
  group_by(idrt) |>
  summarise(
    kwh_listrik_tercatat = sum(safe_num(b42k4), na.rm = TRUE),
    kwh_listrik_alt_b42k5 = sum(safe_num(b42k5), na.rm = TRUE),
    kwh_listrik_alt_sebulan = sum(safe_num(sebulan), na.rm = TRUE),
    .groups = "drop"
  )

listrik_rp <- kp |>
  filter(kode == 234) |>
  group_by(idrt) |>
  summarise(
    pengeluaran_listrik_rp = sum(safe_num(b42k4), na.rm = TRUE),
    pengeluaran_listrik_rp_alt_sebulan = sum(safe_num(sebulan), na.rm = TRUE),
    .groups = "drop"
  )

nonfood_total <- kp |>
  filter(klp == 0) |>
  group_by(idrt) |>
  summarise(
    pengeluaran_nonmakanan = sum(safe_num(sebulan), na.rm = TRUE),
    .groups = "drop"
  )

kp_hh <- kp |>
  group_by(idrt) |>
  summarise(wert = max(safe_num(wert), na.rm = TRUE), .groups = "drop") |>
  mutate(wert = if_else(is.infinite(wert), NA_real_, wert)) |>
  left_join(listrik_kwh_tercatat, by = "idrt") |>
  left_join(listrik_rp, by = "idrt") |>
  left_join(nonfood_total, by = "idrt") |>
  mutate(
    kwh_listrik_tercatat = if_else(is.na(kwh_listrik_tercatat), 0, kwh_listrik_tercatat),
    pengeluaran_listrik_rp = if_else(is.na(pengeluaran_listrik_rp), 0, pengeluaran_listrik_rp),
    pengeluaran_nonmakanan = if_else(is.na(pengeluaran_nonmakanan), 0, pengeluaran_nonmakanan),
    estimasi_kwh_tarif_tunggal = pengeluaran_listrik_rp / tarif_kwh_acuan,
    pengeluaran_nonmakanan_nonlistrik = pengeluaran_nonmakanan - pengeluaran_listrik_rp,
    pengeluaran_nonmakanan_nonlistrik = if_else(
      pengeluaran_nonmakanan_nonlistrik < 0, NA_real_, pengeluaran_nonmakanan_nonlistrik
    ),
    sumber_kwh_final = "Estimasi_pengeluaran_listrik_dibagi_tarif_golongan_daya"
  )

prop_kwh_positif <- kp_hh |>
  summarise(prop = mean(kwh_listrik_tercatat > 0, na.rm = TRUE)) |>
  pull(prop)

if (is.na(prop_kwh_positif)) prop_kwh_positif <- 0

write_csv(
  tibble(
    skenario_tarif = skenario_tarif,
    tarif_450 = unname(tarif_golongan["1"]),
    tarif_900 = unname(tarif_golongan["2"]),
    tarif_1300_plus = unname(tarif_golongan["3"]),
    tarif_rata2_pembanding = tarif_kwh_acuan,
    prop_kwh_tercatat_positif = prop_kwh_positif,
    sumber_kwh_final = "Estimasi_pengeluaran_listrik_dibagi_tarif_golongan_daya",
    catatan = paste("kWh aktual (kode 233) bernilai nol seluruhnya sehingga",
                    "digunakan estimasi pengeluaran listrik dibagi tarif",
                    "golongan daya terpasang. Rumah tangga tanpa golongan",
                    "daya dikeluarkan dari analisis.")
  ),
  file.path(folder_output, "07_keputusan_sumber_kwh.csv")
)


# ============================================================
# 8. GABUNG DATA DAN PENYARINGAN GOLONGAN DAYA
# ============================================================

ta_semua <- rt |>
  left_join(krt, by = "idrt") |>
  left_join(kp_hh, by = "idrt") |>
  mutate(
    bobot = case_when(
      !is.na(wert) & wert > 0 ~ wert,
      !is.na(fwt) & fwt > 0 ~ fwt,
      TRUE ~ NA_real_
    ),
    kode_daya = daya_meter_1,
    punya_golongan_daya = kode_daya %in% c(1, 2, 3)
  ) |>
  filter(r101 == 31)

# --- REVISI: buang rumah tangga tanpa golongan daya ------------------
# Rumah tangga tanpa meteran PLN tidak memiliki tarif yang sah, sehingga
# kWh-nya hanya dapat diduga dengan tarif rata-rata. Jumlahnya kecil dan
# perlakuannya berbeda dari rumah tangga lain, sehingga dikeluarkan.
diag_golongan <- ta_semua |>
  summarise(
    n_total = n(),
    n_punya_golongan_daya = sum(punya_golongan_daya),
    n_tanpa_golongan_daya = sum(!punya_golongan_daya),
    persen_tanpa_golongan_daya = 100 * mean(!punya_golongan_daya)
  )

print(diag_golongan)
write_csv(diag_golongan, file.path(folder_output, "07c_ruta_tanpa_golongan_daya.csv"))

# Profil singkat rumah tangga yang dibuang, untuk lampiran dan keterbatasan.
profil_dibuang <- ta_semua |>
  filter(!punya_golongan_daya) |>
  summarise(
    n = n(),
    rata_ukuran_rt = mean(ukuran_rt, na.rm = TRUE),
    rata_pendidikan_krt = mean(pendidikan_krt, na.rm = TRUE),
    rata_pengeluaran_listrik_rp = mean(pengeluaran_listrik_rp, na.rm = TRUE),
    proporsi_ac = mean(ac, na.rm = TRUE) * 100
  )

print(profil_dibuang)
write_csv(profil_dibuang, file.path(folder_output, "07d_profil_ruta_dibuang.csv"))

ta <- ta_semua |>
  filter(punya_golongan_daya) |>
  mutate(
    tarif_rt = unname(tarif_golongan[as.character(kode_daya)]),
    tarif_sumber = "golongan_daya",
    listrik_kwh_final = pengeluaran_listrik_rp / tarif_rt,
    listrik_kwh_perkapita = listrik_kwh_final / ukuran_rt,
    pengeluaran_listrik_perkapita = pengeluaran_listrik_rp / ukuran_rt,
    share_listrik_nonfood = pengeluaran_listrik_rp / pengeluaran_nonmakanan,
    rp_per_kwh_estimasi_cek = if_else(
      listrik_kwh_final > 0, pengeluaran_listrik_rp / listrik_kwh_final, NA_real_
    )
  )

stopifnot(all(ta$kode_daya %in% c(1, 2, 3)))
cat("\nJumlah rumah tangga setelah penyaringan golongan daya:", nrow(ta), "\n")

cat("\n=== Sebaran tarif yang diterapkan ===\n")
print(ta |> count(kode_daya, tarif_rt, tarif_sumber))

# Kapasitas maksimum teoretis meteran bila menyala 24 jam sebulan (kWh):
#   450 VA -> 0,45 kW x 24 x 30 = 324 kWh | 900 VA -> 648 kWh
kapasitas_maks <- c("1" = 324, "2" = 648)

anomali <- ta |>
  filter(kode_daya %in% c(1, 2)) |>
  mutate(batas = unname(kapasitas_maks[as.character(kode_daya)])) |>
  filter(listrik_kwh_final > batas)

cat("\nRT dengan estimasi kWh melampaui kapasitas meteran:", nrow(anomali), "\n")
write_csv(anomali |> select(idrt, kode_daya, tarif_rt,
                            pengeluaran_listrik_rp, listrik_kwh_final),
          file.path(folder_output, "07b_anomali_kwh_melebihi_kapasitas.csv"))

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
    !is.na(bobot), bobot > 0,
    !is.na(listrik_kwh_final), listrik_kwh_final >= 0,
    !is.na(pengeluaran_listrik_rp), pengeluaran_listrik_rp >= 0,
    !is.na(pengeluaran_nonmakanan), pengeluaran_nonmakanan > 0,
    !is.na(pengeluaran_nonmakanan_nonlistrik), pengeluaran_nonmakanan_nonlistrik >= 0,
    !is.na(ukuran_rt), ukuran_rt > 0,
    !is.na(pendidikan_krt), pendidikan_krt >= 0,
    !is.na(ac), ac %in% c(0, 1)
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
  stop("Observasi valid setelah cleaning terlalu sedikit.")
}

cek_data <- ta_clean |>
  summarise(
    n_gabungan_awal = nrow(ta_semua),
    n_tanpa_golongan_daya_dibuang = nrow(ta_semua) - nrow(ta),
    n_sebelum_cleaning = nrow(ta),
    n_setelah_cleaning = n(),
    n_dibuang_cleaning = nrow(ta) - n(),
    sumber_kwh = first(sumber_kwh_final),
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
write_csv(cek_data, file.path(folder_output, "10_cek_data_setelah_cleaning.csv"))


# ============================================================
# 10. ANALISIS DESKRIPTIF TERTIMBANG
# ============================================================

options(survey.lonely.psu = "adjust")

desain <- survey::svydesign(ids = ~1, weights = ~bobot, data = ta_clean)

deskriptif_mean <- survey::svymean(
  ~listrik_kwh_final_w + pengeluaran_listrik_rp_w +
    pengeluaran_nonmakanan_nonlistrik_w + ukuran_rt_w + pendidikan_krt +
    ac + listrik_kwh_perkapita_w + share_listrik_nonfood_w,
  desain, na.rm = TRUE
)

print(deskriptif_mean)
capture.output(deskriptif_mean,
               file = file.path(folder_output, "11_deskriptif_mean_tertimbang.txt"))

deskriptif_quantile <- survey::svyquantile(
  ~listrik_kwh_final_w + pengeluaran_listrik_rp_w +
    pengeluaran_nonmakanan_nonlistrik_w + listrik_kwh_perkapita_w,
  desain, quantiles = c(0.25, 0.5, 0.75), na.rm = TRUE
)

capture.output(deskriptif_quantile,
               file = file.path(folder_output, "12_deskriptif_kuantil_tertimbang.txt"))

proporsi_ac <- survey::svymean(~factor(ac), desain, na.rm = TRUE)
capture.output(proporsi_ac,
               file = file.path(folder_output, "13_proporsi_ac_tertimbang.txt"))

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

write_csv(tabel_deskriptif_unweighted,
          file.path(folder_output, "14_deskriptif_tidak_tertimbang.csv"))

vars_desk <- c("listrik_kwh_final_w", "listrik_kwh_perkapita_w",
               "pengeluaran_listrik_rp_w", "pengeluaran_nonmakanan_nonlistrik_w",
               "ukuran_rt_w", "pendidikan_krt", "share_listrik_nonfood_w")

desk_w <- purrr::map_dfr(vars_desk, function(v) {
  f <- as.formula(paste0("~", v))
  m <- survey::svymean(f, desain, na.rm = TRUE)
  tibble(variabel = v,
         rata_tertimbang = as.numeric(m),
         se_rata = as.numeric(survey::SE(m)),
         stdev_tertimbang = sqrt(as.numeric(survey::svyvar(f, desain, na.rm = TRUE))))
})

desk_s <- ta_clean |>
  select(all_of(vars_desk)) |>
  tidyr::pivot_longer(everything(), names_to = "variabel", values_to = "nilai") |>
  group_by(variabel) |>
  summarise(n = sum(!is.na(nilai)),
            rata_sampel = mean(nilai, na.rm = TRUE),
            stdev_sampel = sd(nilai, na.rm = TRUE),
            min_sampel = min(nilai, na.rm = TRUE),
            maks_sampel = max(nilai, na.rm = TRUE),
            .groups = "drop")

tabel_deskriptif <- left_join(desk_s, desk_w, by = "variabel")
print(as.data.frame(tabel_deskriptif))
write_csv(tabel_deskriptif, file.path(folder_output, "14b_deskriptif_lengkap.csv"))

ekstrem_prawinsor <- ta |>
  summarise(across(c(listrik_kwh_final, pengeluaran_listrik_rp,
                     pengeluaran_nonmakanan_nonlistrik),
                   list(min = \(z) min(z, na.rm = TRUE),
                        maks = \(z) max(z, na.rm = TRUE))))
write_csv(ekstrem_prawinsor,
          file.path(folder_output, "14c_ekstrem_sebelum_winsorizing.csv"))


# ============================================================
# 11. VISUALISASI DESKRIPTIF
# ============================================================

p_hist_kwh <- ggplot(ta_clean, aes(x = listrik_kwh_final_w)) +
  geom_histogram(bins = 40, fill = "grey35", colour = "white") +
  scale_x_continuous(labels = scales::comma) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Distribusi Konsumsi Listrik Rumah Tangga",
    subtitle = "Konsumsi listrik = pengeluaran listrik dibagi tarif golongan daya terpasang",
    x = "Konsumsi listrik sebulan terakhir (kWh)",
    y = "Jumlah rumah tangga sampel"
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(folder_output, "15_Distribusi_Konsumsi_Listrik_Rumah_Tangga.png"),
       p_hist_kwh, width = 8, height = 5, dpi = 300)

p_box_kwh_ac <- ggplot(
  ta_clean,
  aes(x = factor(ac, levels = c(0, 1),
                 labels = c("Tidak memiliki AC", "Memiliki AC")),
      y = listrik_kwh_final_w)
) +
  geom_boxplot(outlier.shape = NA, fill = "grey85") +
  geom_jitter(width = 0.15, alpha = 0.12, size = 0.5) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Konsumsi Listrik Menurut Kepemilikan AC",
    x = "Kepemilikan AC",
    y = "Konsumsi listrik sebulan terakhir (kWh)"
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(folder_output, "16_boxplot_estimasi_kwh_ac.png"),
       p_box_kwh_ac, width = 8, height = 5, dpi = 300)

p_scatter_kwh_nonfood <- ggplot(
  ta_clean,
  aes(x = pengeluaran_nonmakanan_nonlistrik_w, y = listrik_kwh_final_w)
) +
  geom_point(alpha = 0.30, size = 0.8) +
  scale_x_continuous(labels = scales::comma) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Pengeluaran Nonmakanan Selain Listrik dan Konsumsi Listrik",
    x = "Pengeluaran nonmakanan selain listrik (Rp per bulan)",
    y = "Konsumsi listrik sebulan terakhir (kWh)"
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(folder_output, "17_scatter_estimasi_kwh_nonfood.png"),
       p_scatter_kwh_nonfood, width = 8, height = 5, dpi = 300)


# ============================================================
# 12. DATA UNTUK K-MEANS  (spesifikasi S2)
# ============================================================

cluster_vars <- c(
  "ln_listrik_kwh",
  "ln_pengeluaran_nonmakanan_nonlistrik",
  "pendidikan_krt"
)
stopifnot(length(cluster_vars) == 3)
cat("\n[CEK S2] Variabel pembentuk klaster:",
    paste(cluster_vars, collapse = ", "), "\n")

# Label berbahasa Indonesia untuk grafik dan tabel.
label_var <- c(
  z_ln_listrik_kwh = "ln estimasi konsumsi listrik",
  z_ln_pengeluaran_nonmakanan_nonlistrik = "ln pengeluaran nonmakanan selain listrik",
  z_pendidikan_krt = "Lama sekolah KRT"
)

data_cluster <- ta_clean |>
  select(
    idrt, bobot, sumber_kwh_final,
    listrik_kwh_final_w, pengeluaran_listrik_rp_w, pengeluaran_nonmakanan_w,
    pengeluaran_nonmakanan_nonlistrik_w, listrik_kwh_perkapita_w,
    pengeluaran_listrik_perkapita_w, share_listrik_nonfood_w,
    ukuran_rt_w, pendidikan_krt, r613_asli, r615_asli, sumber_pendidikan,
    ac, kode_daya, daya_meter_total,
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
# ------------------------------------------------------------
# Elbow dihitung mulai K = 1 sesuai arahan bimbingan.
# Koefisien Silhouette tidak terdefinisi pada K = 1 karena tidak ada
# klaster tetangga sebagai pembanding, sehingga diisi NA.
# ============================================================

set.seed(seed_kmeans)

k_range <- 1:min(8, nrow(x))

# Matriks jarak dihitung SATU KALI dan dipakai ulang.
d_x <- dist(x)

wss <- purrr::map_dbl(k_range, function(k) {
  kmeans(x, centers = k, nstart = 50, iter.max = 1000)$tot.withinss
})

sil <- purrr::map_dbl(k_range, function(k) {
  if (k < 2) return(NA_real_)
  km <- kmeans(x, centers = k, nstart = 50, iter.max = 1000)
  mean(cluster::silhouette(km$cluster, d_x)[, 3])
})

evaluasi_k <- tibble(k = k_range, wss = wss, silhouette = sil)

print(as.data.frame(evaluasi_k))
write_csv(evaluasi_k, file.path(folder_output, "18_evaluasi_jumlah_klaster.csv"))

# --- Grafik elbow: mulai K = 1, dengan label nilai -------------------
p_elbow <- ggplot(evaluasi_k, aes(x = k, y = wss)) +
  geom_line(linewidth = 0.7, colour = "grey30") +
  geom_point(size = 3, colour = "grey20") +
  geom_text(aes(label = scales::comma(round(wss, 0))),
            vjust = -1.1, size = 3.2) +
  scale_x_continuous(breaks = k_range, limits = c(0.8, max(k_range) + 0.2)) +
  scale_y_continuous(labels = scales::comma,
                     expand = expansion(mult = c(0.05, 0.12))) +
  labs(
    title = "Metode Elbow untuk Penentuan Jumlah Klaster",
    subtitle = "Dihitung mulai K = 1 pada data terstandarkan",
    x = "Jumlah klaster (K)",
    y = "Within-Cluster Sum of Squares (WCSS)"
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(folder_output, "19_elbow_wcss.png"),
       p_elbow, width = 9, height = 5, dpi = 300)

# --- Grafik silhouette: K = 2 ke atas --------------------------------
p_sil <- ggplot(filter(evaluasi_k, !is.na(silhouette)),
                aes(x = k, y = silhouette)) +
  geom_line(linewidth = 0.7, colour = "grey30") +
  geom_point(size = 3, colour = "grey20") +
  geom_text(aes(label = sprintf("%.3f", silhouette)), vjust = -1.1, size = 3.2) +
  scale_x_continuous(breaks = 2:max(k_range)) +
  scale_y_continuous(expand = expansion(mult = c(0.08, 0.15))) +
  labs(
    title = "Rata-Rata Koefisien Silhouette Menurut Jumlah Klaster",
    subtitle = "Nilai pada K = 1 tidak terdefinisi sehingga tidak ditampilkan",
    x = "Jumlah klaster (K)",
    y = "Rata-rata koefisien Silhouette"
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(folder_output, "20_silhouette.png"),
       p_sil, width = 8, height = 5, dpi = 300)

if (is.na(k_opt)) {
  k_opt <- evaluasi_k |>
    filter(!is.na(silhouette)) |>
    filter(silhouette == max(silhouette, na.rm = TRUE)) |>
    slice(1) |>
    pull(k)
  message(paste("k_opt masih NA. Digunakan K =", k_opt,
                "berdasarkan Silhouette tertinggi pada K >= 2."))
}

if (!k_opt %in% k_range || k_opt < 2) {
  stop("k_opt harus berada antara 2 sampai ", max(k_range))
}


# ============================================================
# 13b. DIAGNOSTIK KESEIMBANGAN KLASTER
# ============================================================

x_mentah <- ta_clean |>
  transmute(listrik_kwh_final, pengeluaran_nonmakanan_nonlistrik, pendidikan_krt) |>
  scale()

diag_seimbang <- purrr::map_dfr(2:5, function(k) {
  a <- kmeans(x, centers = k, nstart = 50, iter.max = 1000)
  b <- kmeans(x_mentah, centers = k, nstart = 50, iter.max = 1000)
  tibble(
    k = k,
    versi = c("ln + winsorizing (dipakai)", "mentah tanpa transformasi"),
    ukuran = c(paste(sort(a$size), collapse = " / "),
               paste(sort(b$size), collapse = " / ")),
    klaster_terkecil_persen = c(100 * min(a$size) / nrow(x),
                                100 * min(b$size) / nrow(x_mentah))
  )
})

print(as.data.frame(diag_seimbang))
write_csv(diag_seimbang, file.path(folder_output, "18b_diagnostik_keseimbangan.csv"))


# ============================================================
# 13c. EKSPLORASI SPESIFIKASI VARIABEL (S0/S1/S2 x winsor on/off)
# ============================================================

kol_ac <- "ac"

stopifnot(all(c("listrik_kwh_final", "pengeluaran_nonmakanan_nonlistrik",
                "ukuran_rt", "pendidikan_krt") %in% names(ta_clean)))
if (!kol_ac %in% names(ta_clean)) stop("Nama kolom AC salah.")

set.seed(seed_kmeans)

basis <- ta_clean |>
  dplyr::transmute(
    kwh = listrik_kwh_final,
    nonfood = pengeluaran_nonmakanan_nonlistrik,
    urt = ukuran_rt,
    didik = pendidikan_krt,
    ac = .data[[kol_ac]]
  ) |>
  dplyr::mutate(kwh_pc = kwh / urt, nonfood_pc = nonfood / urt)

spek <- list(
  S0 = c("kwh", "nonfood", "urt", "didik"),
  S1 = c("kwh_pc", "nonfood_pc", "didik"),
  S2 = c("kwh", "nonfood", "didik")
)

var_moneter <- c("kwh", "nonfood", "kwh_pc", "nonfood_pc")

buat_matriks <- function(vars, pakai_winsor) {
  m <- as.data.frame(basis[, vars, drop = FALSE])
  lv <- intersect(vars, var_moneter)
  if (pakai_winsor) m[lv] <- lapply(m[lv], winsorize)
  m[lv] <- lapply(m[lv], log1p)
  scale(m)
}

hasil <- purrr::map_dfr(names(spek), function(nm) {
  purrr::map_dfr(c(TRUE, FALSE), function(w) {
    X <- buat_matriks(spek[[nm]], w)
    d <- dist(X)
    out <- purrr::map_dfr(2:5, function(k) {
      km <- kmeans(X, centers = k, nstart = 25, iter.max = 1000)
      tibble::tibble(
        spesifikasi = nm,
        winsorizing = ifelse(w, "ya", "tidak"),
        k = k,
        silhouette = round(mean(cluster::silhouette(km$cluster, d)[, 3]), 4),
        ukuran = paste(sort(km$size), collapse = " / "),
        terkecil_pers = round(100 * min(km$size) / nrow(X), 2),
        cramerV_ac = round(cramer_v(km$cluster, basis$ac), 4)
      )
    })
    rm(d); gc()
    out
  })
})

print(as.data.frame(hasil))
write_csv(hasil, file.path(folder_output, "18c_eksplorasi_spesifikasi.csv"))


# ============================================================
# 13d. ANALISIS SENSITIVITAS: WINSORIZING TANPA ln
# ------------------------------------------------------------
# Dijalankan sebagai pembanding untuk lampiran, BUKAN spesifikasi utama.
# ============================================================

set.seed(seed_kmeans)

vars_13d <- c("listrik_kwh_final_w",
              "pengeluaran_nonmakanan_nonlistrik_w",
              "pendidikan_krt")

X13d <- ta_clean |> dplyr::select(all_of(vars_13d)) |> scale()
d13d <- dist(X13d)

hasil_13d <- purrr::map_dfr(2:5, function(k) {
  km <- kmeans(X13d, centers = k, nstart = 50, iter.max = 1000)
  tibble(
    spesifikasi = "S2 winsorizing tanpa ln",
    k = k,
    silhouette = round(mean(cluster::silhouette(km$cluster, d13d)[, 3]), 4),
    ukuran = paste(sort(km$size), collapse = " / "),
    terkecil_pers = round(100 * min(km$size) / nrow(X13d), 2),
    cramerV_ac = round(cramer_v(km$cluster, ta_clean[[kol_ac]]), 4)
  )
})

print(as.data.frame(hasil_13d))
write_csv(hasil_13d, file.path(folder_output, "18d_winsor_tanpa_ln.csv"))

# --- Tabel gabungan untuk lampiran: ln vs tanpa ln -------------------
set.seed(seed_kmeans)

hasil_ln <- purrr::map_dfr(2:5, function(k) {
  km <- kmeans(x, centers = k, nstart = 50, iter.max = 1000)
  tibble(
    spesifikasi = "S2 ln + winsorizing (dipakai)",
    k = k,
    silhouette = round(mean(cluster::silhouette(km$cluster, d_x)[, 3]), 4),
    ukuran = paste(sort(km$size), collapse = " / "),
    terkecil_pers = round(100 * min(km$size) / nrow(x), 2),
    cramerV_ac = round(cramer_v(km$cluster, ta_clean[[kol_ac]]), 4)
  )
})

sensitivitas_transformasi <- bind_rows(hasil_ln, hasil_13d) |> arrange(k, spesifikasi)
print(as.data.frame(sensitivitas_transformasi))
write_csv(sensitivitas_transformasi,
          file.path(folder_output, "18e_sensitivitas_transformasi.csv"))

rm(d13d); gc()


# ============================================================
# 14. K-MEANS FINAL
# ============================================================

set.seed(seed_kmeans)

km_final <- kmeans(x, centers = k_opt, nstart = 100, iter.max = 1000)

# --- Penguncian arah label klaster ----------------------------------
# Klaster diurutkan naik menurut centroid ln estimasi kWh, sehingga
# Klaster 1 selalu konsumsi terendah dan Klaster K selalu tertinggi.
urutan <- order(km_final$centers[, "z_ln_listrik_kwh"])
peta_label <- integer(k_opt)
peta_label[urutan] <- seq_len(k_opt)

cat("\n[CEK LABEL] Pemetaan label klaster (lama -> baru):\n")
print(data.frame(label_lama = seq_len(k_opt), label_baru = peta_label))

km_final$cluster <- peta_label[km_final$cluster]
km_final$centers <- km_final$centers[urutan, , drop = FALSE]
rownames(km_final$centers) <- seq_len(k_opt)
km_final$size <- km_final$size[urutan]
km_final$withinss <- km_final$withinss[urutan]

cat("[CEK LABEL] Ukuran klaster setelah penomoran ulang:",
    paste(km_final$size, collapse = " / "), "\n")

data_hasil <- data_model |>
  mutate(cluster = factor(km_final$cluster))

profil_klaster_lengkap <- data_hasil |>
  group_by(cluster) |>
  summarise(across(all_of(vars_desk),
                   list(rata = \(z) mean(z, na.rm = TRUE),
                        stdev = \(z) sd(z, na.rm = TRUE),
                        min = \(z) min(z, na.rm = TRUE),
                        maks = \(z) max(z, na.rm = TRUE))),
            .groups = "drop")

write_csv(profil_klaster_lengkap,
          file.path(folder_output, "23b_profil_klaster_lengkap.csv"))

print(table(data_hasil$cluster))

centroid_z <- as_tibble(km_final$centers, rownames = "cluster")
write_csv(centroid_z, file.path(folder_output, "21_centroid_zscore.csv"))


# ============================================================
# 15. VISUALISASI PCA DAN TABEL PENJELASNYA
# ------------------------------------------------------------
# Komponen utama di sini BUKAN metode analisis tambahan, melainkan alat
# penyajian: sumbu grafik sebar klaster adalah dua komponen utama dari
# tiga variabel pembentuk klaster yang sudah terstandarkan. Tabel di
# bawah menerangkan arti kedua sumbu tersebut.
# ============================================================

pca_klaster <- prcomp(x, center = FALSE, scale. = FALSE)

var_pca <- (pca_klaster$sdev^2) / sum(pca_klaster$sdev^2)

ringkas_pca <- tibble(
  komponen = paste0("Dim", seq_along(pca_klaster$sdev)),
  akar_ciri = pca_klaster$sdev^2,
  persen_keragaman = 100 * var_pca,
  persen_kumulatif = 100 * cumsum(var_pca)
)

print(as.data.frame(ringkas_pca))
write_csv(ringkas_pca, file.path(folder_output, "53a_ringkasan_komponen_pca.csv"))

# Tabel muatan: kontribusi tiap variabel pada tiap sumbu.
muatan_pca <- as_tibble(pca_klaster$rotation, rownames = "variabel_z") |>
  mutate(variabel = unname(label_var[variabel_z]), .after = variabel_z)

print(as.data.frame(muatan_pca))
write_csv(muatan_pca, file.path(folder_output, "53b_muatan_variabel_pca.csv"))

# Posisi centroid tiap klaster pada sumbu Dim1 dan Dim2.
skor_pca <- as_tibble(pca_klaster$x) |>
  mutate(cluster = data_hasil$cluster, bobot = data_hasil$bobot)

centroid_pca <- skor_pca |>
  group_by(cluster) |>
  summarise(
    n_sampel = n(),
    persen_sampel = 100 * n() / nrow(skor_pca),
    persen_tertimbang = 100 * sum(bobot, na.rm = TRUE) / sum(skor_pca$bobot, na.rm = TRUE),
    Dim1 = mean(PC1), Dim2 = mean(PC2),
    .groups = "drop"
  )

print(as.data.frame(centroid_pca))
write_csv(centroid_pca, file.path(folder_output, "53c_centroid_klaster_pca.csv"))

# Tabel gabungan siap tempel: muatan variabel + persen keragaman sumbu.
tabel_dimensi <- muatan_pca |>
  select(variabel, PC1, PC2) |>
  rename(Dim1 = PC1, Dim2 = PC2) |>
  bind_rows(
    tibble(variabel = "Persentase keragaman yang dijelaskan (%)",
           Dim1 = ringkas_pca$persen_keragaman[1],
           Dim2 = ringkas_pca$persen_keragaman[2])
  )

print(as.data.frame(tabel_dimensi))
write_csv(tabel_dimensi, file.path(folder_output, "53d_tabel_dimensi_siap_tempel.csv"))

label_dim1 <- sprintf("Dim1 (%.1f%% keragaman)", ringkas_pca$persen_keragaman[1])
label_dim2 <- sprintf("Dim2 (%.1f%% keragaman)", ringkas_pca$persen_keragaman[2])

p_cluster <- factoextra::fviz_cluster(
  km_final, data = x, geom = "point", ellipse.type = "convex",
  pointsize = 0.8, alpha = 0.5
) +
  labs(
    title = "Visualisasi Klaster pada Dua Komponen Utama",
    x = label_dim1, y = label_dim2, colour = "Klaster",
    fill = "Klaster", shape = "Klaster"
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(folder_output, "22_visualisasi_cluster_pca.png"),
       p_cluster, width = 8, height = 6, dpi = 300)


# ============================================================
# 16. PROFILING KLASTER
# ============================================================

profil_klaster <- data_hasil |>
  group_by(cluster) |>
  summarise(
    n_sampel = n(),
    n_tertimbang = sum(bobot, na.rm = TRUE),
    persen_tertimbang = 100 * sum(bobot, na.rm = TRUE) / sum(data_hasil$bobot, na.rm = TRUE),
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
    .groups = "drop"
  ) |>
  arrange(cluster)

print(as.data.frame(profil_klaster))
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

write_csv(profil_klaster_unweighted,
          file.path(folder_output, "24_profil_klaster_tidak_tertimbang.csv"))


# ============================================================
# 17. VISUALISASI PROFIL KLASTER
# ============================================================

p_profil_kwh <- ggplot(profil_klaster, aes(x = cluster, y = rata_estimasi_kwh)) +
  geom_col(fill = "grey40", width = 0.6) +
  geom_text(aes(label = scales::comma(round(rata_estimasi_kwh, 1))),
            vjust = -0.5, size = 3.5) +
  scale_y_continuous(labels = scales::comma,
                     expand = expansion(mult = c(0, 0.12))) +
  labs(
    title = "Rata-Rata Estimasi Konsumsi Listrik Menurut Klaster",
    subtitle = "Rata-rata tertimbang menurut bobot Susenas Maret 2025",
    x = "Klaster", y = "Rata-rata estimasi konsumsi listrik (kWh per bulan)"
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(folder_output, "25_profil_rata_estimasi_kwh.png"),
       p_profil_kwh, width = 8, height = 5, dpi = 300)

p_profil_ac <- ggplot(profil_klaster, aes(x = cluster, y = proporsi_ac)) +
  geom_col(fill = "grey40", width = 0.6) +
  geom_text(aes(label = sprintf("%.1f%%", proporsi_ac)), vjust = -0.5, size = 3.5) +
  scale_y_continuous(limits = c(0, 100), expand = expansion(mult = c(0, 0.08))) +
  labs(
    title = "Proporsi Kepemilikan AC Menurut Klaster",
    x = "Klaster", y = "Rumah tangga yang memiliki AC (%)"
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(folder_output, "26_profil_proporsi_ac.png"),
       p_profil_ac, width = 8, height = 5, dpi = 300)

profil_z_long <- data_hasil |>
  group_by(cluster) |>
  summarise(across(starts_with("z_"), \(z) mean(z, na.rm = TRUE)), .groups = "drop") |>
  pivot_longer(-cluster, names_to = "variabel_z", values_to = "rata_z") |>
  mutate(variabel = unname(label_var[variabel_z]))

write_csv(profil_z_long, file.path(folder_output, "27b_rata_zscore_klaster.csv"))

p_heatmap <- ggplot(profil_z_long, aes(x = variabel, y = cluster, fill = rata_z)) +
  geom_tile(colour = "white") +
  geom_text(aes(label = sprintf("%.2f", rata_z)), size = 4) +
  scale_fill_gradient2(low = "#B2182B", mid = "white", high = "#2166AC",
                       midpoint = 0) +
  labs(
    title = "Rata-Rata Skor Baku Variabel Pembentuk Klaster",
    x = "Variabel pembentuk klaster", y = "Klaster", fill = "Rata-rata Z"
  ) +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 15, hjust = 1))

ggsave(file.path(folder_output, "27_heatmap_zscore_klaster.png"),
       p_heatmap, width = 9, height = 5, dpi = 300)

p_box_kwh_cluster <- ggplot(data_hasil, aes(x = cluster, y = listrik_kwh_final_w)) +
  geom_boxplot(outlier.shape = NA, fill = "grey85") +
  geom_jitter(width = 0.15, alpha = 0.08, size = 0.5) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Sebaran Estimasi Konsumsi Listrik Menurut Klaster",
    x = "Klaster", y = "Estimasi konsumsi listrik sebulan terakhir (kWh)"
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(folder_output, "28_boxplot_estimasi_kwh_cluster.png"),
       p_box_kwh_cluster, width = 8, height = 5, dpi = 300)

p_scatter_cluster <- ggplot(
  data_hasil,
  aes(x = pengeluaran_nonmakanan_nonlistrik_w, y = listrik_kwh_final_w,
      colour = cluster)
) +
  geom_point(alpha = 0.45, size = 0.8) +
  scale_x_continuous(labels = scales::comma) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Pengeluaran Nonmakanan Selain Listrik dan Konsumsi Listrik Menurut Klaster",
    x = "Pengeluaran nonmakanan selain listrik (Rp per bulan)",
    y = "Estimasi konsumsi listrik sebulan terakhir (kWh)",
    colour = "Klaster"
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(folder_output, "29_scatter_cluster.png"),
       p_scatter_cluster, width = 8, height = 5, dpi = 300)

data_hasil <- data_hasil |>
  mutate(
    pend_cat = case_when(
      pendidikan_krt <= 6 ~ "Rendah (<= 6 tahun)",
      pendidikan_krt <= 12 ~ "Sedang (7-12 tahun)",
      pendidikan_krt > 12 ~ "Tinggi (> 12 tahun)",
      TRUE ~ NA_character_
    )
  )

p_pendidikan_bar <- ggplot(data_hasil, aes(x = cluster, fill = pend_cat)) +
  geom_bar(position = "fill", width = 0.6) +
  scale_y_continuous(labels = scales::percent_format()) +
  scale_fill_grey(start = 0.75, end = 0.25) +
  labs(
    title = "Komposisi Pendidikan Kepala Rumah Tangga Menurut Klaster",
    x = "Klaster", y = "Persentase rumah tangga", fill = "Kategori pendidikan"
  ) +
  theme_minimal(base_size = 12)

ggsave(file.path(folder_output, "30_pendidikan_krt_bar.png"),
       p_pendidikan_bar, width = 8, height = 5, dpi = 300)


# ============================================================
# 18. UJI BEDA UNIVARIAT ANTAR KLASTER
# ============================================================

uji_vars <- c("listrik_kwh_final_w",
              "pengeluaran_nonmakanan_nonlistrik_w",
              "pendidikan_krt")
stopifnot(length(uji_vars) == 3)

uji_kruskal <- purrr::map_dfr(uji_vars, function(v) {
  broom::tidy(stats::kruskal.test(as.formula(paste(v, "~ cluster")),
                                  data = data_hasil)) |>
    mutate(variabel = v)
})

print(uji_kruskal)
write_csv(uji_kruskal, file.path(folder_output, "31_uji_kruskal.csv"))

uji_anova <- purrr::map_dfr(uji_vars, function(v) {
  broom::tidy(stats::aov(as.formula(paste(v, "~ cluster")), data = data_hasil)) |>
    mutate(variabel = v)
})

write_csv(uji_anova, file.path(folder_output, "32_uji_anova.csv"))

tab_ac <- table(data_hasil$cluster, data_hasil$ac)
uji_chi_ac <- broom::tidy(stats::chisq.test(tab_ac, correct = FALSE))

print(tab_ac)
print(uji_chi_ac)
write_csv(as.data.frame(tab_ac), file.path(folder_output, "33_tabel_cluster_ac.csv"))
write_csv(uji_chi_ac, file.path(folder_output, "34_uji_chi_square_ac.csv"))

pairwise_wilcox_kwh <- pairwise.wilcox.test(
  data_hasil$listrik_kwh_final_w, data_hasil$cluster,
  p.adjust.method = "bonferroni"
)

capture.output(pairwise_wilcox_kwh,
               file = file.path(folder_output, "35_pairwise_wilcox_estimasi_kwh.txt"))


# ============================================================
# 19. EVALUASI MULTIVARIAT
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

boxm_result <- biotools::boxM(data_hasil |> select(all_of(uji_vars)),
                              grouping = data_hasil$cluster)

print(boxm_result)
capture.output(boxm_result, file = file.path(folder_output, "38_box_m.txt"))


# ============================================================
# 20. ANALISIS DISKRIMINAN
# ============================================================

lda_data <- data_hasil |> select(cluster, starts_with("z_"))

lda_fit <- MASS::lda(cluster ~ ., data = lda_data)

print(lda_fit)
capture.output(lda_fit, file = file.path(folder_output, "39_lda_model.txt"))

pred_lda <- predict(lda_fit)$class

conf_matrix <- table(Aktual = lda_data$cluster, Prediksi = pred_lda)
akurasi_lda <- sum(diag(conf_matrix)) / sum(conf_matrix)

print(conf_matrix)
print(akurasi_lda)

write_csv(as.data.frame.matrix(conf_matrix) |> rownames_to_column("Aktual"),
          file.path(folder_output, "40_confusion_matrix_lda.csv"))
write_csv(tibble(akurasi_lda = akurasi_lda),
          file.path(folder_output, "41_akurasi_lda.csv"))


# ============================================================
# 21. SIMPAN HASIL AKHIR PER RUMAH TANGGA
# ============================================================

hasil_ruta <- data_hasil |>
  mutate(cluster = as.character(cluster)) |>
  select(
    idrt, cluster, sumber_kwh_final,
    listrik_kwh_final_w, pengeluaran_listrik_rp_w, pengeluaran_nonmakanan_w,
    pengeluaran_nonmakanan_nonlistrik_w, listrik_kwh_perkapita_w,
    pengeluaran_listrik_perkapita_w, share_listrik_nonfood_w,
    ukuran_rt_w, pendidikan_krt, r613_asli, r615_asli, sumber_pendidikan,
    ac, kode_daya, daya_meter_total, bobot
  )

write_csv(hasil_ruta, file.path(folder_output, "42_hasil_klaster_rumah_tangga.csv"))


# ============================================================
# 22. BLOK VARIABEL PENCIRI (penjawab Tujuan 3)
# ============================================================

vars_kandidat <- c("r1604", "r1801b", "r1801c", "r1616b1")

cek_penciri <- tibble(variabel = vars_kandidat,
                      tersedia = vars_kandidat %in% names(kor_rt))

print(cek_penciri)
write_csv(cek_penciri, file.path(folder_output, "43_cek_ketersediaan_penciri.csv"))

punya_r1604 <- "r1604" %in% names(kor_rt)
punya_r1801b <- "r1801b" %in% names(kor_rt)

penciri <- kor_rt |>
  group_by(idrt) |>
  slice(1) |>
  ungroup() |>
  transmute(
    idrt,
    luas_lantai = if (punya_r1604) safe_num(r1604) else NA_real_,
    lemari_es = if (punya_r1801b) {
      case_when(
        safe_num(r1801b) == 1 ~ 1L,
        safe_num(r1801b) %in% c(0, 2, 5) ~ 0L,
        TRUE ~ NA_integer_
      )
    } else NA_integer_
  )

data_penciri <- data_hasil |>
  left_join(penciri, by = "idrt") |>
  mutate(
    luas_lantai_w = if (all(is.na(luas_lantai))) NA_real_ else winsorize(luas_lantai),
    ac_f = factor(ac, levels = c(0, 1), labels = c("Tidak", "Ya")),
    lemari_es_f = factor(lemari_es, levels = c(0, 1), labels = c("Tidak", "Ya"))
  )

stopifnot(nrow(data_penciri) == nrow(data_hasil))

profil_penciri <- data_penciri |>
  group_by(cluster) |>
  summarise(
    n_sampel = n(),
    persen_tertimbang = 100 * sum(bobot, na.rm = TRUE) / sum(data_penciri$bobot, na.rm = TRUE),
    rata_luas_lantai = weighted.mean(luas_lantai_w, bobot, na.rm = TRUE),
    median_luas_lantai = median(luas_lantai_w, na.rm = TRUE),
    proporsi_ac = weighted.mean(ac, bobot, na.rm = TRUE) * 100,
    proporsi_lemari_es = weighted.mean(lemari_es, bobot, na.rm = TRUE) * 100,
    n_missing_luas_lantai = sum(is.na(luas_lantai_w)),
    n_missing_lemari_es = sum(is.na(lemari_es)),
    .groups = "drop"
  )

print(profil_penciri, width = Inf)
write_csv(profil_penciri, file.path(folder_output, "44_profil_penciri_tertimbang.csv"))

desain_penciri <- survey::svydesign(ids = ~1, weights = ~bobot, data = data_penciri)

if (!all(is.na(data_penciri$luas_lantai_w))) {
  uji_luas_w <- survey::svyranktest(luas_lantai_w ~ cluster, desain_penciri,
                                    test = "KruskalWallis")
  print(uji_luas_w)
  capture.output(uji_luas_w,
                 file = file.path(folder_output, "45_uji_luas_lantai_tertimbang.txt"))
}

uji_ac_w <- survey::svychisq(~ cluster + ac_f, desain_penciri, statistic = "Chisq")
print(uji_ac_w)
capture.output(uji_ac_w, file = file.path(folder_output, "46_uji_ac_tertimbang.txt"))

if (!all(is.na(data_penciri$lemari_es))) {
  desain_es <- subset(desain_penciri, !is.na(lemari_es))
  uji_es_w <- survey::svychisq(~ cluster + lemari_es_f, desain_es, statistic = "Chisq")
  print(uji_es_w)
  capture.output(uji_es_w,
                 file = file.path(folder_output, "47_uji_lemari_es_tertimbang.txt"))
}

uji_penciri_unweighted <- list()

if (!all(is.na(data_penciri$luas_lantai_w))) {
  uji_penciri_unweighted$luas_lantai <-
    broom::tidy(kruskal.test(luas_lantai_w ~ cluster, data = data_penciri))
}

uji_penciri_unweighted$ac <-
  broom::tidy(chisq.test(table(data_penciri$cluster, data_penciri$ac), correct = FALSE))

if (!all(is.na(data_penciri$lemari_es))) {
  uji_penciri_unweighted$lemari_es <-
    broom::tidy(chisq.test(table(data_penciri$cluster, data_penciri$lemari_es),
                           correct = FALSE))
}

uji_penciri_unweighted <- bind_rows(uji_penciri_unweighted, .id = "variabel")
print(uji_penciri_unweighted)
write_csv(uji_penciri_unweighted,
          file.path(folder_output, "48_uji_penciri_tidak_tertimbang.csv"))

# Ukuran efek dirujuk berdasarkan NAMA variabel, bukan nomor baris.
ambil_stat <- function(nama) {
  nilai <- uji_penciri_unweighted$statistic[uji_penciri_unweighted$variabel == nama]
  if (length(nilai) == 0) NA_real_ else as.numeric(nilai[1])
}

ukuran_efek <- tibble(
  variabel = c("ac", "lemari_es"),
  cramers_v = c(sqrt(ambil_stat("ac") / nrow(data_penciri)),
                sqrt(ambil_stat("lemari_es") / nrow(data_penciri)))
)

print(ukuran_efek)
write_csv(ukuran_efek, file.path(folder_output, "49_ukuran_efek_penciri.csv"))

# --- Golongan daya terpasang x klaster -------------------------------
data_daya <- data_hasil |>
  select(idrt, cluster, bobot, kode_daya) |>
  filter(kode_daya %in% c(1, 2, 3)) |>
  mutate(daya_f = factor(kode_daya, levels = 1:3,
                         labels = c("450 watt", "900 watt",
                                    "1.300 watt atau lebih")))

tab_daya <- table(Klaster = data_daya$cluster, Daya = data_daya$daya_f)
cat("\nFrekuensi golongan daya (tidak tertimbang):\n"); print(tab_daya)

desain_daya <- survey::svydesign(ids = ~1, weights = ~bobot, data = data_daya)
persen_daya_w <- round(100 * prop.table(
  survey::svytable(~cluster + daya_f, desain_daya), 1), 1)
cat("\nPersen baris tertimbang:\n"); print(persen_daya_w)

uji_daya <- chisq.test(tab_daya)
v_daya <- sqrt(unname(uji_daya$statistic) / (sum(tab_daya) * (min(dim(tab_daya)) - 1)))
uji_daya_w <- survey::svychisq(~cluster + daya_f, desain_daya, statistic = "Chisq")

print(uji_daya); print(uji_daya_w)
cat("Cramer's V golongan daya terpasang:", round(v_daya, 3), "\n")

capture.output(tab_daya, persen_daya_w, uji_daya, uji_daya_w,
               paste("Cramer's V:", round(v_daya, 3)),
               file = file.path(folder_output, "50_daya_terpasang_x_klaster.txt"))

# --- Ukuran rumah tangga sebagai variabel penciri --------------------
ukuran_profil <- data_hasil |>
  group_by(cluster) |>
  summarise(
    n_sampel = n(),
    rata_tertimbang = weighted.mean(ukuran_rt_w, bobot, na.rm = TRUE),
    rata_tidak_tertimbang = mean(ukuran_rt_w, na.rm = TRUE),
    sd = sd(ukuran_rt_w, na.rm = TRUE),
    min = min(ukuran_rt_w, na.rm = TRUE),
    maks = max(ukuran_rt_w, na.rm = TRUE),
    .groups = "drop"
  )

print(ukuran_profil)
write_csv(ukuran_profil, file.path(folder_output, "51_penciri_ukuran_rt.csv"))

uji_ukuran_rt <- broom::tidy(kruskal.test(ukuran_rt_w ~ cluster, data = data_hasil))
print(uji_ukuran_rt)
write_csv(uji_ukuran_rt, file.path(folder_output, "52_uji_ukuran_rt.csv"))


# ============================================================
# 23. RINGKASAN AKHIR
# ============================================================

cat("\n============================================================\n")
cat("RINGKASAN HASIL PENGOLAHAN — REVISI 14 SEPTEMBER 2026\n")
cat("============================================================\n")
cat("Jumlah rumah tangga gabungan awal   :", nrow(ta_semua), "\n")
cat("Dibuang karena tanpa golongan daya  :", nrow(ta_semua) - nrow(ta), "\n")
cat("Jumlah setelah penyaringan daya     :", nrow(ta), "\n")
cat("Jumlah setelah cleaning             :", nrow(ta_clean), "\n")
cat("Skenario tarif                      :", skenario_tarif, "\n")
cat("Tarif per golongan (450/900/1300+)  :",
    paste(unname(tarif_golongan), collapse = " / "), "\n")
cat("Transformasi variabel klaster       : winsorizing 1%-99% lalu ln lalu Z-score\n")
cat("Jumlah klaster final                :", k_opt, "\n")
cat("Ukuran klaster                      :",
    paste(km_final$size, collapse = " / "), "\n")
cat("Rata-rata Silhouette pada K terpilih:",
    round(evaluasi_k$silhouette[evaluasi_k$k == k_opt], 4), "\n")
cat("Akurasi diskriminan                 :", round(akurasi_lda * 100, 2), "%\n")
cat("Output tersimpan di                 :", folder_output, "\n")
cat("============================================================\n")
