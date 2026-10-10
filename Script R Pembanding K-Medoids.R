# ============================================================
# SCRIPT PEMBANDING K-MEDOIDS (PAM) TERHADAP K-MEANS
# Sesi BD, 10 Oktober 2026 - persiapan tanya jawab sidang
# ------------------------------------------------------------
# TUJUAN
#   Menjawab pertanyaan penguji "Kenapa K-Means, bukan K-Medoids?"
#   dengan bukti: apakah K-Medoids menghasilkan pengelompokan yang
#   serupa dengan K-Means pada data yang sama persis.
#
# STATUS
#   Hanya untuk bahan jawaban lisan. TIDAK masuk naskah dan TIDAK
#   mengubah satu pun angka di Bab IV.
#
# CARA MENJALANKAN (wajib berurutan, dalam satu sesi R yang sama)
#   1. Jalankan "Script R Pasca SE Bimbingan.R" sampai selesai.
#   2. Tanpa menutup R / tanpa Restart R, jalankan script ini.
#   Script ini memakai objek yang sudah dibuat script utama
#   (x, d_x, km_final, data_penciri, dst.), sehingga data, transformasi,
#   standardisasi, dan matriks jaraknya identik dengan K-Means.
#
# PERKIRAAN WAKTU
#   K-Medoids (PAM) jauh lebih lambat daripada K-Means. Untuk 5.001
#   rumah tangga dan K = 2 sampai 5, perhitungan sekitar 1-3 menit.
#   Selama konsol menampilkan tanda ">" belum muncul, R masih bekerja.
#
# ANALOGI SINGKAT
#   K-Means  : pusat klaster = RATA-RATA anggota (titik khayal).
#   K-Medoids: pusat klaster = SATU RUMAH TANGGA NYATA yang paling
#              di tengah kelompoknya (disebut medoid).
#   Rata-rata bisa tertarik oleh rumah tangga yang ekstrem; medoid tidak.
#
# KELUARAN (folder_output yang sama dengan script utama)
#   60_kmedoids_evaluasi_k.csv          silhouette K-Medoids vs K-Means, K = 2..5
#   61_kmedoids_tabel_silang.csv        keanggotaan K-Means x K-Medoids
#   62_kmedoids_pusat_klaster.csv       centroid K-Means vs medoid (skala Z)
#   63_kmedoids_medoid_satuan_asli.csv  medoid dalam kWh, rupiah, tahun
#   64_kmedoids_profil_penciri.csv      profil tertimbang + Cramer's V per metode
#   65_kmedoids_rumah_tangga_pindah.csv ringkasan rumah tangga yang berpindah klaster
#   66_kmedoids_ringkasan.txt           salinan ringkasan konsol
# ============================================================


# ============================================================
# 0. CEK PRASYARAT (apakah script utama sudah dijalankan?)
# ============================================================

objek_wajib <- c("x", "d_x", "km_final", "data_penciri", "folder_output",
                 "seed_kmeans", "k_opt", "cramer_v")

objek_hilang <- objek_wajib[!vapply(objek_wajib, exists, logical(1))]

if (length(objek_hilang) > 0) {
  stop(paste0(
    "Objek berikut belum ada: ", paste(objek_hilang, collapse = ", "),
    ".\nJalankan dulu 'Script R Pasca SE Bimbingan.R' sampai selesai ",
    "pada sesi R yang sama, lalu jalankan script ini lagi."
  ))
}

# Pastikan semua objek berasal dari olahan yang sama (urutan baris identik)
stopifnot(
  nrow(x) == length(km_final$cluster),
  attr(d_x, "Size") == nrow(x),
  nrow(data_penciri) == nrow(x),
  all(as.integer(as.character(data_penciri$cluster)) == km_final$cluster)
)

k_banding <- k_opt
cat("\n[K-MEDOIDS] Jumlah rumah tangga         :", nrow(x), "\n")
cat("[K-MEDOIDS] Jumlah klaster pembanding  :", k_banding, "\n")
cat("[K-MEDOIDS] Variabel pembentuk (Z)     :",
    paste(colnames(x), collapse = ", "), "\n")


# ============================================================
# 1. CEK ULANG SILHOUETTE K-MEANS FINAL
# ------------------------------------------------------------
# Harus sama dengan naskah (Tabel 4). Bila berbeda, BERHENTI dan
# laporkan, karena berarti datanya tidak sama dengan naskah.
# ============================================================

sil_km <- cluster::silhouette(km_final$cluster, d_x)
rata_sil_km <- mean(sil_km[, 3])

cat("\n[CEK] Silhouette K-Means final (naskah: 0,3640):",
    round(rata_sil_km, 4), "\n")


# ============================================================
# 2. K-MEDOIDS (PAM) UNTUK K = 2 SAMPAI 5
# ------------------------------------------------------------
# pam() memakai matriks jarak Euclidean d_x yang sama dengan K-Means.
# PAM tidak memakai titik awal acak (langkah BUILD-nya tetap),
# sehingga hasilnya sama setiap kali dijalankan; set.seed hanya
# dipasang untuk berjaga-jaga.
# ============================================================

set.seed(seed_kmeans)

k_uji <- 2:5
daftar_pam <- vector("list", length(k_uji))
names(daftar_pam) <- as.character(k_uji)

for (k in k_uji) {
  cat("[K-MEDOIDS] Menjalankan PAM untuk K =", k, "... ")
  waktu <- system.time(
    daftar_pam[[as.character(k)]] <- cluster::pam(d_x, k = k, diss = TRUE)
  )
  cat("selesai dalam", round(waktu[["elapsed"]], 1), "detik\n")
}

evaluasi_pam <- do.call(rbind, lapply(k_uji, function(k) {
  p <- daftar_pam[[as.character(k)]]
  ukuran <- as.integer(table(p$clustering))
  data.frame(
    k = k,
    silhouette_kmedoids = mean(cluster::silhouette(p$clustering, d_x)[, 3]),
    ukuran_kmedoids = paste(sort(ukuran), collapse = " / "),
    klaster_terkecil_persen_kmedoids = 100 * min(ukuran) / nrow(x)
  )
}))

# Silhouette K-Means dari script utama (blok 13) sebagai pembanding
if (exists("evaluasi_k")) {
  evaluasi_pam <- merge(
    evaluasi_pam,
    data.frame(k = evaluasi_k$k, silhouette_kmeans = evaluasi_k$silhouette),
    by = "k", all.x = TRUE
  )
}

cat("\n[K-MEDOIDS] Silhouette menurut jumlah klaster:\n")
print(evaluasi_pam, row.names = FALSE)
write.csv(evaluasi_pam, file.path(folder_output, "60_kmedoids_evaluasi_k.csv"),
          row.names = FALSE)


# ============================================================
# 3. K-MEDOIDS FINAL PADA K YANG SAMA DENGAN K-MEANS
# ------------------------------------------------------------
# Label diurutkan dengan aturan yang sama seperti K-Means (blok 14):
# Klaster 1 = medoid dengan ln konsumsi listrik terendah.
# Dengan begitu "Klaster 1" pada kedua metode dapat dibandingkan.
# ============================================================

pam_final <- daftar_pam[[as.character(k_banding)]]

id_medoid <- pam_final$id.med
medoid_z <- x[id_medoid, , drop = FALSE]

urutan_pam <- order(medoid_z[, "z_ln_listrik_kwh"])
peta_pam <- integer(k_banding)
peta_pam[urutan_pam] <- seq_len(k_banding)

klaster_pam <- peta_pam[pam_final$clustering]
id_medoid <- id_medoid[urutan_pam]
medoid_z <- medoid_z[urutan_pam, , drop = FALSE]

sil_pam <- cluster::silhouette(klaster_pam, d_x)
rata_sil_pam <- mean(sil_pam[, 3])


# ============================================================
# 4. SEBERAPA SAMA KEANGGOTAANNYA?
# ------------------------------------------------------------
# (a) Tabel silang: baris = K-Means, kolom = K-Medoids.
# (b) Persentase rumah tangga yang masuk klaster bernomor sama.
# (c) Adjusted Rand Index (ARI): 1 = pengelompokan identik,
#     sekitar 0 = kecocokan setara kebetulan.
#     [PERLU VERIFIKASI: Hubert & Arabie, 1985, bila dikutip lisan]
# ============================================================

tabel_silang <- table(KMeans = km_final$cluster, KMedoids = klaster_pam)
persen_sama <- 100 * sum(diag(tabel_silang)) / sum(tabel_silang)

hitung_ari <- function(a, b) {
  tab <- table(a, b)
  pasangan <- function(v) sum(choose(v, 2))
  indeks <- pasangan(tab)
  baris <- pasangan(rowSums(tab))
  kolom <- pasangan(colSums(tab))
  harapan <- baris * kolom / choose(sum(tab), 2)
  maksimum <- (baris + kolom) / 2
  (indeks - harapan) / (maksimum - harapan)
}

ari <- hitung_ari(km_final$cluster, klaster_pam)

cat("\n[K-MEDOIDS] Tabel silang keanggotaan (baris K-Means, kolom K-Medoids):\n")
print(tabel_silang)
write.csv(as.data.frame.matrix(tabel_silang),
          file.path(folder_output, "61_kmedoids_tabel_silang.csv"))


# ============================================================
# 5. PUSAT KLASTER: CENTROID K-MEANS vs MEDOID
# ------------------------------------------------------------
# Skala Z: 0 = rata-rata seluruh rumah tangga; negatif = di bawah
# rata-rata; positif = di atas rata-rata.
# Medoid juga ditampilkan dalam satuan asli karena medoid adalah
# rumah tangga nyata.
# ============================================================

pusat_klaster <- rbind(
  data.frame(metode = "K-Means (centroid)", klaster = seq_len(k_banding),
             km_final$centers, row.names = NULL, check.names = FALSE),
  data.frame(metode = "K-Medoids (medoid)", klaster = seq_len(k_banding),
             medoid_z, row.names = NULL, check.names = FALSE)
)

cat("\n[K-MEDOIDS] Pusat klaster pada skala Z:\n")
print(pusat_klaster, row.names = FALSE, digits = 4)
write.csv(pusat_klaster, file.path(folder_output, "62_kmedoids_pusat_klaster.csv"),
          row.names = FALSE)

medoid_asli <- data.frame(
  klaster = seq_len(k_banding),
  baris_data = id_medoid,
  konsumsi_listrik_kwh = data_penciri$listrik_kwh_final_w[id_medoid],
  pengeluaran_nonmakanan_selain_listrik_rp =
    data_penciri$pengeluaran_nonmakanan_nonlistrik_w[id_medoid],
  lama_sekolah_krt_tahun = data_penciri$pendidikan_krt[id_medoid]
)

cat("\n[K-MEDOIDS] Medoid (rumah tangga nyata) dalam satuan asli:\n")
print(medoid_asli, row.names = FALSE)
write.csv(medoid_asli, file.path(folder_output, "63_kmedoids_medoid_satuan_asli.csv"),
          row.names = FALSE)


# ============================================================
# 6. APAKAH TEMUAN UTAMA BERTAHAN?
# ------------------------------------------------------------
# Profil tertimbang per klaster untuk kedua metode, memakai penimbang
# dan variabel yang sama dengan blok 22 script utama.
# Cramer's V tanpa penimbang, sama dengan cara naskah (Persamaan 2.10).
# Deskriptif saja; tidak ada uji berbasis desain di sini.
# ============================================================

ringkas_profil <- function(klaster, label_metode) {
  d <- data_penciri
  d$kl <- klaster
  hasil <- do.call(rbind, lapply(sort(unique(klaster)), function(k) {
    s <- d[d$kl == k, ]
    data.frame(
      metode = label_metode,
      klaster = k,
      n_sampel = nrow(s),
      persen_tertimbang = 100 * sum(s$bobot, na.rm = TRUE) / sum(d$bobot, na.rm = TRUE),
      rata_konsumsi_kwh = weighted.mean(s$listrik_kwh_final_w, s$bobot, na.rm = TRUE),
      proporsi_ac = 100 * weighted.mean(s$ac, s$bobot, na.rm = TRUE),
      proporsi_lemari_es = 100 * weighted.mean(s$lemari_es, s$bobot, na.rm = TRUE),
      rata_luas_lantai = weighted.mean(s$luas_lantai_w, s$bobot, na.rm = TRUE)
    )
  }))
  hasil$cramer_v_ac <- cramer_v(klaster, d$ac)
  hasil$cramer_v_lemari_es <- cramer_v(klaster, d$lemari_es)
  hasil
}

profil_banding <- rbind(
  ringkas_profil(km_final$cluster, "K-Means"),
  ringkas_profil(klaster_pam, "K-Medoids")
)

cat("\n[K-MEDOIDS] Profil tertimbang per metode:\n")
print(profil_banding, row.names = FALSE, digits = 4)
write.csv(profil_banding, file.path(folder_output, "64_kmedoids_profil_penciri.csv"),
          row.names = FALSE)


# ============================================================
# 7. SIAPA YANG BERPINDAH KLASTER?
# ------------------------------------------------------------
# Bila rumah tangga yang berpindah adalah rumah tangga di perbatasan
# kedua klaster, nilai silhouette K-Means-nya mendekati 0
# (silhouette dekat 0 = berada di antara dua klaster).
# ============================================================

pindah <- km_final$cluster != klaster_pam

ringkas_pindah <- data.frame(
  kelompok = c("Berpindah klaster", "Tetap di klaster yang sama"),
  n_rumah_tangga = c(sum(pindah), sum(!pindah)),
  persen = 100 * c(mean(pindah), mean(!pindah)),
  rata_silhouette_kmeans = c(
    if (any(pindah)) mean(sil_km[pindah, 3]) else NA_real_,
    mean(sil_km[!pindah, 3])
  )
)

cat("\n[K-MEDOIDS] Rumah tangga yang berpindah klaster:\n")
print(ringkas_pindah, row.names = FALSE, digits = 4)
write.csv(ringkas_pindah, file.path(folder_output, "65_kmedoids_rumah_tangga_pindah.csv"),
          row.names = FALSE)


# ============================================================
# 8. RINGKASAN
# ============================================================

ringkasan <- c(
  "============================================================",
  "RINGKASAN PEMBANDING K-MEDOIDS (PAM) vs K-MEANS",
  "============================================================",
  paste("Jumlah klaster                         :", k_banding),
  paste("Silhouette K-Means                     :", round(rata_sil_km, 4)),
  paste("Silhouette K-Medoids                   :", round(rata_sil_pam, 4)),
  paste("Ukuran klaster K-Means                 :",
        paste(as.integer(table(km_final$cluster)), collapse = " / ")),
  paste("Ukuran klaster K-Medoids               :",
        paste(as.integer(table(klaster_pam)), collapse = " / ")),
  paste("Rumah tangga di klaster bernomor sama  :", round(persen_sama, 2), "%"),
  paste("Adjusted Rand Index                    :", round(ari, 4)),
  paste("Rumah tangga yang berpindah            :", sum(pindah)),
  "============================================================"
)

cat("\n", paste(ringkasan, collapse = "\n"), "\n", sep = "")
writeLines(ringkasan, file.path(folder_output, "66_kmedoids_ringkasan.txt"))
