# ============================================================
# SCRIPT GAMBAR BAB I — DATA PUBLIKASI (TANPA MIKRODATA SUSENAS)
# KLASIFIKASI RUMAH TANGGA BERDASARKAN POLA KONSUMSI LISTRIK
# DAN KARAKTERISTIK SOSIAL EKONOMI DI DKI JAKARTA
#
# Dibuat pada Sesi AX (4 Oktober 2026) untuk mengganti skrip lama yang
# hilang. Skrip ini berdiri sendiri: tidak membaca berkas apa pun dan
# tidak bergantung pada "Script R Pasca SE Bimbingan.R". Seluruh angka
# ditulis langsung di bawah beserta sumbernya, sehingga skrip ini juga
# berfungsi sebagai catatan asal-usul data Gambar 1, 3, dan 4.
#
# KELUARAN (nama berkas = nama aset di folder gambar/bab-1 repo)
#   gambar-01-rasio-elektrifikasi.png
#   gambar-03a-komposisi-pelanggan.png
#   gambar-03b-distribusi-konsumsi.png
#   gambar-04-energi-listrik-terjual.png  (dibuat bila data 2018-2024
#                                          sudah lengkap; lihat Bagian 5)
#
# FORMAT (sama dengan Gambar 7-16 di skrip utama)
#   desimal koma, ribuan titik, huruf Times New Roman, tanpa judul di
#   dalam grafik (judul dan sumber ditulis di naskah).
#
# DAFTAR PERUBAHAN TERHADAP GAMBAR LAMA
# 1. Gambar 1: Papua Tengah dikoreksi dari 99,49 menjadi 94,49 sesuai
#    sumber (Gambar 7.1 publikasi Indikator TPB Indonesia 2025). Nilai
#    99,49 pada gambar lama adalah salah ketik.
# 2. Gambar 3: bentuk treemap diganti diagram batang mendatar, dengan
#    urutan sektor dan warna yang sama pada panel (a) dan (b).
# 3. Gambar 4: label sumbu tegak "Daya Terjual" diganti "Energi Listrik
#    Terjual", karena kWh adalah satuan energi, bukan daya.
# ============================================================


# ============================================================
# 0. KONFIGURASI
# ============================================================

# Folder tempat PNG disimpan. Ganti bila perlu.
folder_output <- "gambar/bab-1"
if (!dir.exists(folder_output)) dir.create(folder_output, recursive = TRUE)


# ============================================================
# 1. PACKAGE
# ============================================================

packages <- c("ggplot2", "scales", "ragg")
installed <- packages %in% rownames(installed.packages())
if (any(!installed)) install.packages(packages[!installed])

library(ggplot2)
library(scales)


# ============================================================
# 2. FUNGSI BANTU (disalin dari skrip utama agar formatnya sama)
# ============================================================

font_naskah <- "Times New Roman"

# Angka untuk label di dalam grafik, mis. angka_id(92.4929, 2) -> "92,49"
angka_id <- function(x, digits = 0) {
  ifelse(is.na(x), NA_character_,
         formatC(x, format = "f", digits = digits,
                 big.mark = ".", decimal.mark = ","))
}

# Angka untuk sumbu grafik, mis. 15000 -> "15.000"
sumbu_id <- function(accuracy = 1) {
  scales::label_number(accuracy = accuracy, big.mark = ".", decimal.mark = ",")
}

simpan_grafik <- function(nama_file, plot, width, height) {
  ggsave(file.path(folder_output, nama_file), plot,
         width = width, height = height, dpi = 300,
         device = ragg::agg_png, bg = "white")
}

# Warna (palet Okabe-Ito, aman buta warna; sama dengan skrip utama)
warna_sorot  <- "#0072B2"   # biru: provinsi 100 persen / sektor rumah tangga
warna_lain   <- "grey65"    # abu-abu: kategori pembanding

tema_naskah <- theme_minimal(base_size = 12, base_family = font_naskah) +
  theme(panel.grid.minor = element_blank())


# ============================================================
# 3. GAMBAR 1 — RASIO ELEKTRIFIKASI MENURUT PROVINSI, 2024
# ------------------------------------------------------------
# Sumber: Badan Pusat Statistik & Kementerian PPN/Bappenas (2025).
#   Indikator Tujuan Pembangunan Berkelanjutan Indonesia 2025,
#   Gambar 7.1 "Peta Sebaran Rasio Elektrifikasi, 2024", dengan data
#   Kementerian Energi dan Sumber Daya Mineral (Triwulan IV 2024).
#   Rasio elektrifikasi nasional pada gambar sumber: 99,83 persen.
# Angka disalin dari label peta pada gambar sumber (satuan persen).
# ============================================================

re_2024 <- data.frame(
  provinsi = c(
    "Aceh", "Sumatera Utara", "Sumatera Barat", "Riau", "Jambi",
    "Sumatera Selatan", "Bengkulu", "Lampung",
    "Kepulauan Bangka Belitung", "Kepulauan Riau",
    "DKI Jakarta", "Jawa Barat", "Jawa Tengah", "DI Yogyakarta",
    "Jawa Timur", "Banten", "Bali", "Nusa Tenggara Barat",
    "Nusa Tenggara Timur", "Kalimantan Barat", "Kalimantan Tengah",
    "Kalimantan Selatan", "Kalimantan Timur", "Kalimantan Utara",
    "Sulawesi Utara", "Sulawesi Tengah", "Sulawesi Selatan",
    "Sulawesi Tenggara", "Gorontalo", "Sulawesi Barat", "Maluku",
    "Maluku Utara", "Papua Barat", "Papua Barat Daya", "Papua",
    "Papua Selatan", "Papua Tengah", "Papua Pegunungan"
  ),
  rasio = c(
    99.99, 99.99, 99.99, 99.99, 99.99,
    99.99, 99.99, 99.99,
    99.99, 99.99,
    100.00, 99.99, 99.99, 99.99,
    99.67, 99.99, 100.00, 99.99,
    96.35, 99.85, 98.05,
    99.99, 99.99, 99.99,
    99.99, 99.99, 99.99,
    99.78, 99.99, 99.99, 99.08,
    99.99, 99.99, 99.99, 99.81,
    99.08, 94.49, 94.02          # Papua Tengah 94,49 (bukan 99,49)
  )
)

stopifnot(nrow(re_2024) == 38, !anyDuplicated(re_2024$provinsi))

# Urutan: rasio tertinggi di atas; bila sama, urut abjad
re_2024 <- re_2024[order(-re_2024$rasio, re_2024$provinsi), ]
re_2024$provinsi <- factor(re_2024$provinsi, levels = rev(re_2024$provinsi))

# Sorotan = provinsi yang mencapai 100 persen (DKI Jakarta dan Bali).
# Sorotan mengikuti NILAI, bukan wilayah penelitian, karena paragraf
# setelah Gambar 1 menyebut kedua provinsi tersebut bersama-sama.
re_2024$sorot <- re_2024$rasio >= 100

p_gambar01 <- ggplot(re_2024, aes(y = provinsi, x = rasio)) +
  geom_segment(aes(x = 93, xend = rasio, yend = provinsi),
               colour = "grey80", linewidth = 0.4) +
  geom_point(aes(colour = sorot), size = 2.2, show.legend = FALSE) +
  geom_text(aes(label = angka_id(rasio, 2)),
            family = font_naskah, size = 3, hjust = -0.25) +
  scale_colour_manual(values = c(`FALSE` = warna_lain, `TRUE` = warna_sorot)) +
  scale_x_continuous(limits = c(93, 100.6), breaks = 93:100,
                     labels = sumbu_id(), expand = c(0, 0)) +
  labs(x = "Rasio elektrifikasi (persen)", y = NULL) +
  tema_naskah +
  theme(panel.grid.major.y = element_blank(),
        axis.text.y = element_text(
          face = ifelse(levels(re_2024$provinsi) %in%
                          re_2024$provinsi[re_2024$sorot],
                        "bold", "plain")))

simpan_grafik("gambar-01-rasio-elektrifikasi.png",
              p_gambar01, width = 7, height = 8.5)


# ============================================================
# 4. GAMBAR 3 — PELANGGAN DAN ENERGI LISTRIK TERJUAL MENURUT
#    SEKTOR DI DKI JAKARTA, 2025
# ------------------------------------------------------------
# Sumber: Badan Pusat Statistik Provinsi DKI Jakarta (2026).
#   Provinsi DKI Jakarta dalam Angka 2026, Tabel 6.4 (jumlah pelanggan)
#   dan Tabel 6.5 (kWh terjual) menurut golongan tarif, kolom Gabungan,
#   dengan data PT PLN (Persero) Distribusi DKI Jakarta dan Tangerang.
# Pengelompokan sektor mengikuti pengelompokan pada kedua tabel sumber
# (termasuk P3 di bawah Perkantoran). Tanda "-" pada S1 dibaca 0.
# ============================================================

# --- Tabel 6.4: jumlah pelanggan (Gabungan) ------------------
pelanggan_2025 <- list(
  "Rumah tangga" = c(R1 = 4495751, R2 = 478869, R3_6600VA = 185195,
                     R3_200kVA = 54),
  "Usaha"        = c(B1 = 97738, B2 = 232802, B3 = 2856),
  "Industri"     = c(I1_1300VA = 1449, I1_200kVA = 3622, I1_gt200kVA = 771,
                     I1_30000kVA = 5),
  "Sosial"       = c(S1 = 0, S2_2200VA = 22769, S2_200kVA = 30680,
                     S3 = 479),
  "Perkantoran"  = c(P1 = 7894, P2 = 745, P3 = 10511),
  "Lainnya"      = c(TTM = 38, CTR = 1085, CTM = 25, L = 5326)
)
total_pelanggan_tabel <- 5578664   # baris Jumlah/Total Tabel 6.4

# --- Tabel 6.5: kWh terjual (Gabungan) -----------------------
kwh_2025 <- list(
  "Rumah tangga" = c(R1 = 10062007805, R2 = 3381190940,
                     R3_6600VA = 2848405014, R3_200kVA = 71720452),
  "Usaha"        = c(B1 = 200078092, B2 = 4320282535, B3 = 9425525732,
                     B3_20000kVA = 17775615),
  "Industri"     = c(I1_1300VA = 105999, I1_200kVA = 410208670,
                     I1_gt200kVA = 2399391301, I1_30000kVA = 1110387762),
  "Sosial"       = c(S1 = 0, S2_2200VA = 69271356, S2_200kVA = 732772772,
                     S3 = 966613428),
  "Perkantoran"  = c(P1 = 267204474, P2 = 1143266400, P3 = 190396425),
  "Lainnya"      = c(TTM = 225731485, CTM = 143694202, L = 209528396)
)
total_kwh_tabel <- 38195558854     # baris Jumlah/Total Tabel 6.5

sektor_2025 <- data.frame(
  sektor    = names(pelanggan_2025),
  pelanggan = sapply(pelanggan_2025, sum),
  kwh       = sapply(kwh_2025, sum)
)

# Pemeriksaan: jumlah komponen harus sama dengan baris Jumlah/Total.
# Tabel 6.5 berselisih 1 kWh akibat pembulatan di sumber; persentase
# dihitung terhadap baris Jumlah/Total yang tercetak.
stopifnot(sum(sektor_2025$pelanggan) == total_pelanggan_tabel,
          abs(sum(sektor_2025$kwh) - total_kwh_tabel) <= 1)

sektor_2025$persen_pelanggan <- 100 * sektor_2025$pelanggan / total_pelanggan_tabel
sektor_2025$persen_kwh       <- 100 * sektor_2025$kwh / total_kwh_tabel

print(transform(sektor_2025,
                kwh_miliar = round(kwh / 1e9, 2),
                persen_pelanggan = round(persen_pelanggan, 2),
                persen_kwh = round(persen_kwh, 2)))

# Urutan sektor tetap pada kedua panel: menurut energi terjual
urutan_sektor <- sektor_2025$sektor[order(sektor_2025$kwh)]
sektor_2025$sektor <- factor(sektor_2025$sektor, levels = urutan_sektor)
sektor_2025$sorot  <- sektor_2025$sektor == "Rumah tangga"

grafik_sektor <- function(data, kolom_persen, label, judul_sumbu) {
  ggplot(data, aes(y = sektor, x = .data[[kolom_persen]], fill = sorot)) +
    geom_col(width = 0.65, show.legend = FALSE) +
    geom_text(aes(label = label), family = font_naskah, size = 3.3,
              hjust = -0.08) +
    scale_fill_manual(values = c(`FALSE` = warna_lain, `TRUE` = warna_sorot)) +
    scale_x_continuous(limits = c(0, 128), breaks = seq(0, 100, 20),
                       labels = sumbu_id(), expand = c(0, 0)) +
    labs(x = judul_sumbu, y = NULL) +
    tema_naskah +
    theme(panel.grid.major.y = element_blank())
}

p_gambar03a <- grafik_sektor(
  sektor_2025, "persen_pelanggan",
  label = paste0(angka_id(sektor_2025$persen_pelanggan, 2), " (",
                 angka_id(sektor_2025$pelanggan, 0), ")"),
  judul_sumbu = "Persentase terhadap jumlah pelanggan (persen)"
)

p_gambar03b <- grafik_sektor(
  sektor_2025, "persen_kwh",
  label = paste0(angka_id(sektor_2025$persen_kwh, 2), " (",
                 angka_id(sektor_2025$kwh / 1e9, 2), " miliar kWh)"),
  judul_sumbu = "Persentase terhadap energi listrik terjual (persen)"
)

simpan_grafik("gambar-03a-komposisi-pelanggan.png",
              p_gambar03a, width = 6, height = 3.6)
simpan_grafik("gambar-03b-distribusi-konsumsi.png",
              p_gambar03b, width = 6, height = 3.6)


# ============================================================
# 5. GAMBAR 4 — ENERGI LISTRIK TERJUAL KEPADA PELANGGAN RUMAH
#    TANGGA DI PROVINSI DKI JAKARTA, 2018-2025
# ------------------------------------------------------------
# Sumber: Badan Pusat Statistik Provinsi DKI Jakarta (2019-2026).
#   Provinsi DKI Jakarta dalam Angka edisi 2019 s.d. 2026, tabel
#   "Jumlah Daya (kWh) Listrik menurut Golongan Tarif dan Cabang di
#   Provinsi DKI Jakarta", kolom Gabungan. Edisi tahun t memuat data
#   tahun t-1 (edisi 2026 -> data 2025).
# Golongan: R1 = 450-2.200 VA; R2 = >3.500-5.500 VA;
#           R3 = 6.600 VA ke atas (6.600 VA + >200 kVA).
# Satuan: kWh. Isi angka persis seperti tercetak, tanpa pembulatan.
#
# Halaman tabel (nomor halaman PDF, bukan halaman cetak): edisi 2019
# Tabel 6.5 hlm. cetak 390; edisi 2020 hlm. PDF 551; edisi 2021 hlm. PDF
# 553; edisi 2022 hlm. PDF 583; edisi 2023 hlm. PDF 569; edisi 2024 hlm. PDF 638; edisi 2025 hlm.
# PDF 613; edisi 2026 hlm. PDF 609. Seluruhnya diunduh dari
# https://jakarta.bps.go.id/ (Sesi AX, 4 Oktober 2026).
#
# Pemeriksaan transkripsi (Sesi AX): untuk seluruh tahun 2018-2025,
# jumlah seluruh baris tabel (semua sektor) sama persis dengan baris
# Jumlah/Total yang tercetak (selisih 0 kWh; 2025 selisih 1 kWh akibat
# pembulatan di sumber).
#
# Catatan definisi golongan pada sumber:
# - Edisi 2019 (data 2018) mencetak R2 sebagai ">2,2 kVA - 6.600 VA";
#   edisi berikutnya ">3,5 kVA - 5.500 VA". Angka dipakai apa adanya.
# - Baris R3 ">200 kVA" baru muncul mulai data 2024; sebelumnya R3
#   hanya memuat 6.600 VA.
#
# Bila kelak ada angka yang dihapus (NA), Bagian 5 dilewati dan Gambar 4
# lama tidak ditimpa.
# ============================================================

kwh_rt <- data.frame(
  tahun = 2018:2025,
  #  tahun data : edisi -> 2018:2019  2019:2020  2020:2021  2021:2022
  #               2022:2023  2023:2024  2024:2025  2025:2026
  r1 = c(8594062121, 9066393205, 9351892284, 9265311456,
         9230632755, 9700216113, 10070955981, 10062007805),
  r2 = c(2484355238, 2666271182, 2906589350, 3050434614,
         3073163466, 3241758845, 3440779741, 3381190940),
  r3 = c(2120477433, 2262831766, 2346267911, 2408774717,
         2520200173, 2702776809,
         2766367177 + 135765416,   # 2024: 6.600 VA + >200 kVA
         2848405014 + 71720452)    # 2025: 6.600 VA + >200 kVA
)

if (anyNA(kwh_rt)) {
  message("Gambar 4 dilewati: data kWh rumah tangga ",
          paste(kwh_rt$tahun[!complete.cases(kwh_rt)], collapse = ", "),
          " belum diisi.")
} else {
  kwh_rt$total <- kwh_rt$r1 + kwh_rt$r2 + kwh_rt$r3

  seri <- c(total = "Total rumah tangga",
            r1 = "R1 (450\u20132.200 VA)",
            r2 = "R2 (3.500\u20135.500 VA)",
            r3 = "R3 (6.600 VA ke atas)")

  kwh_panjang <- do.call(rbind, lapply(names(seri), function(k)
    data.frame(tahun = kwh_rt$tahun, seri = seri[[k]],
               miliar_kwh = kwh_rt[[k]] / 1e9)))
  kwh_panjang$seri <- factor(kwh_panjang$seri, levels = unname(seri))

  akhir <- kwh_panjang[kwh_panjang$tahun == max(kwh_panjang$tahun), ]
  # Geser label R2 ke atas dan R3 ke bawah agar tidak berdempet
  akhir$geser <- ifelse(grepl("^R2", akhir$seri), 0.3,
                        ifelse(grepl("^R3", akhir$seri), -0.3, 0))

  p_gambar04 <- ggplot(kwh_panjang,
                       aes(x = tahun, y = miliar_kwh, colour = seri,
                           linetype = seri)) +
    geom_line(linewidth = 0.8) +
    geom_point(size = 2) +
    geom_text(data = akhir, aes(y = miliar_kwh + geser,
                                label = angka_id(miliar_kwh, 2)),
              colour = "grey15", family = font_naskah, size = 3.3,
              hjust = -0.3, show.legend = FALSE) +
    scale_colour_manual(values = c("grey20", "#0072B2", "#E69F00",
                                   "#009E73")) +
    scale_linetype_manual(values = c("dashed", "solid", "solid", "solid")) +
    scale_x_continuous(breaks = 2018:2025,
                       expand = expansion(add = c(0.3, 0.7))) +
    scale_y_continuous(limits = c(0, 18), breaks = seq(0, 18, 2),
                       labels = sumbu_id(),
                       expand = expansion(mult = c(0, 0.08))) +
    labs(x = "Tahun", y = "Energi listrik terjual (miliar kWh)",
         colour = NULL, linetype = NULL) +
    tema_naskah +
    theme(legend.position = "bottom")

  simpan_grafik("gambar-04-energi-listrik-terjual.png",
                p_gambar04, width = 8, height = 5)
}
