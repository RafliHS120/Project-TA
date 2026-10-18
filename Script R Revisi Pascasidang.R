# ============================================================
# SCRIPT REVISI PASCASIDANG (SESI BF, 18 OKTOBER 2026)
# Menjawab Lembar Perbaikan Hasil Sidang (14 Okt 2026):
#   (a) "Pemisah klaster bukan kWh tetapi pengeluaran nonmakanan
#        -> histogram"            -> BAGIAN 1, 2, dan 4
#   (b) "Uji kestabilan klaster"  -> BAGIAN 3
#   (c) "Silhouette 0,3640 kurang kuat, dipertegas dengan uji"
#                                 -> BAGIAN 3 (kestabilan bootstrap)
#   (d) "Alasan pemilihan K-Means / K-Medoids" -> BAGIAN 0 dan 3
#        (K-Medoids dijalankan pada data yang sama persis)
#
# CARA MENJALANKAN (wajib berurutan, dalam satu sesi R yang sama)
#   1. Jalankan "Script R Pasca SE Bimbingan.R" sampai selesai.
#   2. (Disarankan) jalankan "Script R Pembanding K-Medoids.R".
#      Bila dilewati, script ini membuat ulang K-Medoids sendiri.
#   3. Tanpa Restart R, jalankan script ini.
#
# ANALOGI
#   - Kontribusi variabel (Bagian 1): seperti menanyakan mata pelajaran
#     mana yang paling membedakan kelas A dan kelas B. Variabel dengan
#     R-kuadrat paling besar adalah "pemisah" terkuat.
#   - Uji tanpa satu variabel (Bagian 2): kelas dibagi ulang tanpa
#     melihat satu mata pelajaran. Bila pembagiannya hampir sama
#     (ARI mendekati 1), mata pelajaran itu tidak banyak berperan.
#   - Kestabilan bootstrap (Bagian 3): data "dikocok ulang" 100 kali
#     (diambil acak dengan pengembalian), dikelompokkan lagi, lalu
#     dicek apakah klaster yang sama muncul kembali (indeks Jaccard).
#
# PERKIRAAN WAKTU
#   Seluruh script sekitar 5-15 menit (diuji dengan data buatan
#   berukuran sama, 5.001 baris: B = 5 selesai < 30 detik). Selama tanda
#   ">" belum muncul, R masih bekerja. Bila terlalu lama, ubah B_boot
#   menjadi 50 dan laporkan B yang dipakai.
#
# KELUARAN (folder_output yang sama dengan script utama)
#   70_kontribusi_variabel_pembentuk.csv
#   71_klaster_tanpa_satu_variabel.csv
#   72_kestabilan_bootstrap_jaccard.csv
#   73_ringkasan_revisi_pascasidang.txt
#   gambar-12-histogram-pembentuk-klaster.png   (nomor gambar naskah Rev BF-2)
#
# Paket tambahan: fpc (install.packages("fpc") bila belum ada).
# ============================================================


# ============================================================
# 0. CEK PRASYARAT
# ============================================================

objek_wajib <- c("x", "d_x", "km_final", "folder_output", "seed_kmeans",
                 "k_opt", "warna_klaster")
objek_hilang <- objek_wajib[!vapply(objek_wajib, exists, logical(1))]
if (length(objek_hilang) > 0) {
  stop(paste0("Objek berikut belum ada: ", paste(objek_hilang, collapse = ", "),
              ".\nJalankan dulu 'Script R Pasca SE Bimbingan.R' sampai selesai ",
              "pada sesi R yang sama."))
}
if (!requireNamespace("fpc", quietly = TRUE)) {
  stop("Paket fpc belum terpasang. Jalankan: install.packages(\"fpc\")")
}
stopifnot(nrow(x) == length(km_final$cluster), attr(d_x, "Size") == nrow(x))

opsi_lama <- options(width = 200)
B_boot <- 100            # banyaknya ulangan bootstrap (Hennig, 2007)
jalankan_boot_pam <- TRUE

label_var <- c(
  z_ln_listrik_kwh = "ln konsumsi listrik",
  z_ln_pengeluaran_nonmakanan_nonlistrik = "ln pengeluaran nonmakanan selain listrik",
  z_pendidikan_krt = "Lama sekolah KRT"
)
stopifnot(all(names(label_var) %in% colnames(x)))
x <- x[, names(label_var)]

hitung_ari <- function(a, b) {
  tab <- table(a, b)
  pasangan <- function(v) sum(choose(v, 2))
  indeks <- pasangan(tab)
  baris <- pasangan(rowSums(tab)); kolom <- pasangan(colSums(tab))
  harapan <- baris * kolom / choose(sum(tab), 2)
  (indeks - harapan) / ((baris + kolom) / 2 - harapan)
}

# Penomoran klaster dikunci: Klaster 1 = pusat ln konsumsi listrik terendah
urut_label <- function(cl, pusat_listrik) {
  urutan <- order(pusat_listrik)
  peta <- integer(length(urutan)); peta[urutan] <- seq_along(urutan)
  peta[cl]
}

# --- K-Medoids pada data yang sama (pakai hasil script pembanding bila ada)
if (!exists("klaster_pam")) {
  cat("[INFO] klaster_pam belum ada -> menjalankan PAM (1-3 menit)...\n")
  pam_final <- cluster::pam(d_x, k = k_opt, diss = TRUE)
  klaster_pam <- urut_label(pam_final$clustering,
                            x[pam_final$id.med, "z_ln_listrik_kwh"])
}
cat("[CEK] Ukuran klaster K-Means  :", paste(table(km_final$cluster), collapse = " / "), "\n")
cat("[CEK] Ukuran klaster K-Medoids:", paste(table(klaster_pam), collapse = " / "), "\n")


# ============================================================
# 1. KONTRIBUSI SETIAP VARIABEL PEMBENTUK
# ------------------------------------------------------------
# Untuk setiap variabel j: jumlah kuadrat total (T_j) dipecah menjadi
# jumlah kuadrat dalam klaster (W_j) dan antarklaster (B_j = T_j - W_j).
# R2_j = B_j / T_j = porsi keragaman variabel j yang "dijelaskan" oleh
# pembagian klaster. Jumlah W_j seluruh variabel = WCSS (Tabel 4).
# Statistik F_j hanya ukuran deskriptif, BUKAN uji (variabel pembentuk
# tidak diuji karena klaster dibentuk dari variabel itu sendiri).
# ============================================================

kontribusi <- function(xm, cl, metode) {
  K <- length(unique(cl)); n <- nrow(xm)
  do.call(rbind, lapply(colnames(xm), function(v) {
    z <- xm[, v]
    T_j <- sum((z - mean(z))^2)
    W_j <- sum(tapply(z, cl, function(u) sum((u - mean(u))^2)))
    B_j <- T_j - W_j
    rata <- tapply(z, cl, mean)
    data.frame(
      metode = metode, variabel = label_var[[v]],
      rata_z_klaster1 = round(rata[1], 4), rata_z_klaster2 = round(rata[2], 4),
      selisih_rata_z = round(rata[K] - rata[1], 4),
      jk_dalam_W = round(W_j, 2), jk_antar_B = round(B_j, 2),
      R2_persen = round(100 * B_j / T_j, 2),
      F_deskriptif = round((B_j / (K - 1)) / (W_j / (n - K)), 1),
      row.names = NULL
    )
  }))
}

tabel_kontribusi <- rbind(
  kontribusi(x, km_final$cluster, "K-Means"),
  kontribusi(x, klaster_pam, "K-Medoids")
)
cat("\n[BAGIAN 1] Kontribusi variabel pembentuk (R2 = porsi keragaman antarklaster):\n")
print(tabel_kontribusi)
cat("[CEK] Jumlah W_j K-Means =", round(sum(tabel_kontribusi$jk_dalam_W[tabel_kontribusi$metode == "K-Means"]), 2),
    "| WCSS km_final =", round(km_final$tot.withinss, 2), "(harus sama)\n")
write.csv(tabel_kontribusi, file.path(folder_output, "70_kontribusi_variabel_pembentuk.csv"),
          row.names = FALSE)


# ============================================================
# 2. PENGELOMPOKAN ULANG TANPA SATU VARIABEL
# ------------------------------------------------------------
# K-Means dijalankan ulang (K sama, nstart 100, seed sama) dengan dua
# variabel saja. ARI membandingkan keanggotaannya dengan klaster final:
# ARI = 1 berarti identik; makin kecil makin berbeda. Variabel yang bila
# dikeluarkan paling menurunkan ARI adalah variabel yang paling
# menentukan keanggotaan klaster.
# ============================================================

tanpa_satu <- do.call(rbind, lapply(colnames(x), function(v) {
  x_j <- x[, setdiff(colnames(x), v), drop = FALSE]
  set.seed(seed_kmeans)
  km_j <- kmeans(x_j, centers = k_opt, nstart = 100, iter.max = 1000)
  sil_j <- mean(cluster::silhouette(km_j$cluster, dist(x_j))[, 3])
  data.frame(
    variabel_dikeluarkan = label_var[[v]],
    ari_terhadap_klaster_final = round(hitung_ari(km_final$cluster, km_j$cluster), 4),
    persen_rumah_tangga_tetap = round(100 * max(
      mean(km_j$cluster == km_final$cluster),
      mean((3 - km_j$cluster) == km_final$cluster)), 2),
    rata_silhouette = round(sil_j, 4),
    ukuran_klaster = paste(sort(as.integer(table(km_j$cluster))), collapse = " / "),
    row.names = NULL
  )
}))
cat("\n[BAGIAN 2] K-Means tanpa satu variabel pembentuk:\n")
print(tanpa_satu)
if (k_opt != 2) cat("[PERINGATAN] kolom persen_rumah_tangga_tetap hanya tepat untuk K = 2.\n")
write.csv(tanpa_satu, file.path(folder_output, "71_klaster_tanpa_satu_variabel.csv"),
          row.names = FALSE)


# ============================================================
# 3. UJI KESTABILAN KLASTER: BOOTSTRAP + INDEKS JACCARD
# ------------------------------------------------------------
# fpc::clusterboot mengambil sampel bootstrap, mengelompokkan ulang,
# lalu untuk setiap klaster asli mencari klaster paling mirip dan
# menghitung indeks Jaccard (irisan / gabungan anggota).
# Ambang bacaan (Hennig, 2007; dokumentasi fpc::clusterboot):
#   rata-rata Jaccard <= 0,50 : klaster "larut" (tidak stabil)
#   0,60 - 0,75              : ada pola, tetapi belum dapat dipercaya
#   > 0,75                   : stabil;   > 0,85 : sangat stabil
# Kedua metode memakai sampel bootstrap yang sama (seed sama).
# ============================================================

km_cbi <- function(data, k) {
  km <- kmeans(data, centers = k, nstart = 50, iter.max = 1000)
  list(result = km, nc = k,
       clusterlist = lapply(seq_len(k), function(i) km$cluster == i),
       partition = km$cluster, clustermethod = "kmeans")
}
pam_cbi <- function(data, k) {
  # pamonce = 3 (FastPAM1) mempercepat PAM tanpa mengubah hasilnya
  p <- cluster::pam(data, k = k, pamonce = 3)
  list(result = p, nc = k,
       clusterlist = lapply(seq_len(k), function(i) p$clustering == i),
       partition = p$clustering, clustermethod = "pam")
}

# Cek bahwa PAM cepat (pamonce = 3) memberi keanggotaan yang sama
cek_pam <- cluster::pam(x, k = k_opt, pamonce = 3)
cat("\n[CEK] ARI PAM cepat vs K-Medoids naskah =",
    round(hitung_ari(cek_pam$clustering, klaster_pam), 4), "(harus 1)\n")

ringkas_boot <- function(cb, metode, cl_asli) {
  # cb$partition memakai nomor klaster asli fungsi; samakan dengan label naskah
  peta <- tapply(cl_asli, cb$partition, function(u) as.integer(names(which.max(table(u)))))
  data.frame(
    metode = metode, B = cb$B,
    klaster_naskah = as.integer(peta),
    ukuran = as.integer(table(cb$partition)),
    rata_jaccard = round(cb$bootmean, 4),
    kali_larut_jaccard_le_0_5 = cb$bootbrd,
    kali_pulih_jaccard_gt_0_75 = cb$bootrecover,
    row.names = NULL
  ) -> hasil
  hasil <- hasil[order(hasil$klaster_naskah), ]
  rownames(hasil) <- NULL
  hasil
}

cat("\n[BAGIAN 3] Bootstrap K-Means, B =", B_boot, "...\n")
t_km <- system.time(
  cb_km <- fpc::clusterboot(x, B = B_boot, bootmethod = "boot",
                            clustermethod = km_cbi, k = k_opt,
                            seed = seed_kmeans, count = FALSE)
)
stab <- ringkas_boot(cb_km, "K-Means", km_final$cluster)
cat("   selesai dalam", round(t_km[3] / 60, 1), "menit\n")

if (jalankan_boot_pam) {
  cat("[BAGIAN 3] Bootstrap K-Medoids, B =", B_boot, "(lama)...\n")
  t_pam <- system.time(
    cb_pam <- fpc::clusterboot(x, B = B_boot, bootmethod = "boot",
                               clustermethod = pam_cbi, k = k_opt,
                               seed = seed_kmeans, count = FALSE)
  )
  stab <- rbind(stab, ringkas_boot(cb_pam, "K-Medoids", klaster_pam))
  cat("   selesai dalam", round(t_pam[3] / 60, 1), "menit\n")
}
cat("\nRata-rata indeks Jaccard per klaster:\n")
print(stab)
write.csv(stab, file.path(folder_output, "72_kestabilan_bootstrap_jaccard.csv"),
          row.names = FALSE)


# ============================================================
# 4. HISTOGRAM VARIABEL PEMBENTUK MENURUT KLASTER (K-MEANS)
# ------------------------------------------------------------
# Skala Z = skala yang "dilihat" algoritme. Variabel yang histogram
# kedua klasternya paling sedikit tumpang tindih adalah pemisah terkuat.
# ============================================================

font_pakai <- if (exists("font_naskah")) font_naskah else "serif"
data_hist <- do.call(rbind, lapply(names(label_var), function(v) {
  data.frame(variabel = label_var[[v]], nilai_z = x[, v],
             klaster = factor(km_final$cluster))
}))
data_hist$variabel <- factor(data_hist$variabel, levels = unname(label_var))

p_hist <- ggplot2::ggplot(data_hist, ggplot2::aes(x = nilai_z, fill = klaster)) +
  ggplot2::geom_histogram(bins = 40, alpha = 0.6, position = "identity",
                          colour = NA) +
  ggplot2::facet_wrap(~ variabel, ncol = 1, scales = "free_y") +
  ggplot2::scale_fill_manual(values = warna_klaster, name = "Klaster") +
  ggplot2::scale_x_continuous(labels = function(b) format(b, decimal.mark = ",")) +
  ggplot2::labs(x = "Nilai terstandardisasi (Z-score)",
                y = "Banyaknya rumah tangga") +
  ggplot2::theme_minimal(base_size = 12, base_family = font_pakai) +
  ggplot2::theme(legend.position = "bottom")

ggplot2::ggsave(file.path(folder_output, "gambar-12-histogram-pembentuk-klaster.png"),
                p_hist, width = 8, height = 8, dpi = 300, bg = "white")


# ============================================================
# 5. RINGKASAN UNTUK DISALIN KE CHAT / NASKAH
# ============================================================

ringkasan <- c(
  "RINGKASAN REVISI PASCASIDANG",
  paste("K =", k_opt, "| n =", nrow(x), "| B bootstrap =", B_boot),
  "", "Bagian 1 - Kontribusi variabel:",
  capture.output(print(tabel_kontribusi)),
  "", "Bagian 2 - Tanpa satu variabel:",
  capture.output(print(tanpa_satu)),
  "", "Bagian 3 - Kestabilan (Jaccard):",
  capture.output(print(stab))
)
writeLines(ringkasan, file.path(folder_output, "73_ringkasan_revisi_pascasidang.txt"))
cat("\n", paste(ringkasan, collapse = "\n"), "\n")
cat("\nSalin seluruh teks di atas (atau dokumen 73) ke chat untuk diisikan ke naskah.\n")
options(opsi_lama)
