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
#   67_kmedoids_spesifikasi.csv         padanan Tabel L1.1 (S0/S1/S2 x winsorizing, K = 2..5)
#   68_kmedoids_transformasi.csv        padanan Tabel L1.2 (S2: ln + winsorizing vs tanpa ln)
#
# BAGIAN 9-10 (padanan Lampiran 1) menjalankan 28 PAM tambahan dan bisa
# memakan waktu lebih lama (perkiraan 5-15 menit). Bila hanya ingin
# bagian 1-8, ubah jalankan_lampiran menjadi FALSE di bawah ini.
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

# Lebarkan konsol agar tabel tidak terpotong menjadi beberapa baris
opsi_lama <- options(width = 250)

k_banding <- k_opt
jalankan_lampiran <- TRUE   # FALSE = lewati bagian 9-10 (padanan Lampiran 1)
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


# ============================================================
# 9. PADANAN TABEL L1.1: TIGA SPESIFIKASI x WINSORIZING, K-MEDOIDS
# ------------------------------------------------------------
# Resep data SAMA PERSIS dengan blok 13c script utama:
#   S0 = kwh, nonfood, ukuran RT, lama sekolah KRT
#   S1 = kwh per kapita, nonfood per kapita, lama sekolah KRT
#   S2 = kwh, nonfood, lama sekolah KRT (spesifikasi yang dipakai)
#   variabel moneter: (winsorizing bila "ya") -> ln(1 + x) -> Z-score
# Yang diganti hanya metodenya: kmeans() -> pam().
# Kolom K-Means diambil dari objek 'hasil' (blok 13c) agar bisa
# dibaca berdampingan dengan Tabel L1.1 naskah.
# ============================================================

if (jalankan_lampiran) {

  objek_lampiran <- c("ta_clean", "winsorize")
  hilang_lampiran <- objek_lampiran[!vapply(objek_lampiran, exists, logical(1))]
  if (length(hilang_lampiran) > 0) {
    stop(paste("Objek belum ada:", paste(hilang_lampiran, collapse = ", "),
               "- jalankan script utama sampai selesai terlebih dahulu."))
  }
  stopifnot(nrow(ta_clean) == nrow(x))

  ringkas_pam <- function(X, k, d, ac) {
    p <- cluster::pam(d, k = k, diss = TRUE)
    ukuran <- as.integer(table(p$clustering))
    data.frame(
      k = k,
      silhouette_kmedoids = round(mean(cluster::silhouette(p$clustering, d)[, 3]), 4),
      ukuran_kmedoids = paste(sort(ukuran), collapse = " / "),
      terkecil_pers_kmedoids = round(100 * min(ukuran) / nrow(X), 2),
      cramerV_ac_kmedoids = round(cramer_v(p$clustering, ac), 4)
    )
  }

  basis_pam <- data.frame(
    kwh = ta_clean$listrik_kwh_final,
    nonfood = ta_clean$pengeluaran_nonmakanan_nonlistrik,
    urt = ta_clean$ukuran_rt,
    didik = ta_clean$pendidikan_krt,
    ac = ta_clean$ac
  )
  basis_pam$kwh_pc <- basis_pam$kwh / basis_pam$urt
  basis_pam$nonfood_pc <- basis_pam$nonfood / basis_pam$urt

  spek_pam <- list(
    S0 = c("kwh", "nonfood", "urt", "didik"),
    S1 = c("kwh_pc", "nonfood_pc", "didik"),
    S2 = c("kwh", "nonfood", "didik")
  )
  var_moneter_pam <- c("kwh", "nonfood", "kwh_pc", "nonfood_pc")

  buat_matriks_pam <- function(vars, pakai_winsor) {
    m <- basis_pam[, vars, drop = FALSE]
    lv <- intersect(vars, var_moneter_pam)
    if (pakai_winsor) m[lv] <- lapply(m[lv], winsorize)
    m[lv] <- lapply(m[lv], log1p)
    scale(m)
  }

  daftar_spek <- list()
  for (nm in names(spek_pam)) {
    for (w in c(TRUE, FALSE)) {
      cat("[LAMPIRAN K-MEDOIDS] Spesifikasi", nm,
          "| winsorizing:", ifelse(w, "ya", "tidak"), "... ")
      waktu <- system.time({
        X <- buat_matriks_pam(spek_pam[[nm]], w)
        d <- dist(X)
        out <- do.call(rbind, lapply(2:5, function(k) ringkas_pam(X, k, d, basis_pam$ac)))
        rm(d); invisible(gc())
      })
      cat("selesai dalam", round(waktu[["elapsed"]], 1), "detik\n")
      daftar_spek[[length(daftar_spek) + 1]] <-
        cbind(spesifikasi = nm, winsorizing = ifelse(w, "ya", "tidak"), out)
    }
  }
  spesifikasi_pam <- do.call(rbind, daftar_spek)

  # Tempelkan kolom K-Means dari blok 13c (Tabel L1.1 naskah)
  if (exists("hasil") && all(c("spesifikasi", "winsorizing", "k", "silhouette",
                               "terkecil_pers", "cramerV_ac") %in% names(hasil))) {
    km_l1 <- data.frame(
      spesifikasi = hasil$spesifikasi, winsorizing = hasil$winsorizing, k = hasil$k,
      silhouette_kmeans = hasil$silhouette,
      terkecil_pers_kmeans = hasil$terkecil_pers,
      cramerV_ac_kmeans = hasil$cramerV_ac
    )
    spesifikasi_pam <- merge(spesifikasi_pam, km_l1,
                             by = c("spesifikasi", "winsorizing", "k"), all.x = TRUE)
  }
  spesifikasi_pam <- spesifikasi_pam[order(spesifikasi_pam$spesifikasi,
                                           spesifikasi_pam$winsorizing != "ya",
                                           spesifikasi_pam$k), ]

  cat("\n[LAMPIRAN K-MEDOIDS] Padanan Tabel L1.1:\n")
  print(spesifikasi_pam, row.names = FALSE)
  write.csv(spesifikasi_pam, file.path(folder_output, "67_kmedoids_spesifikasi.csv"),
            row.names = FALSE)


  # ============================================================
  # 10. PADANAN TABEL L1.2: S2 DENGAN DAN TANPA LOGARITMA, K-MEDOIDS
  # ------------------------------------------------------------
  # Resep SAMA PERSIS dengan blok 13d script utama:
  #   versi dipakai : matriks x (winsorizing -> ln -> Z-score)
  #   versi pembanding: winsorizing tanpa ln -> Z-score
  # Kolom K-Means diambil dari objek 'sensitivitas_transformasi'.
  # ============================================================

  cat("[LAMPIRAN K-MEDOIDS] S2 winsorizing tanpa ln ... ")
  waktu <- system.time({
    X_tanpa_ln <- scale(data.frame(
      ta_clean$listrik_kwh_final_w,
      ta_clean$pengeluaran_nonmakanan_nonlistrik_w,
      ta_clean$pendidikan_krt
    ))
    d_tanpa_ln <- dist(X_tanpa_ln)
    pam_tanpa_ln <- do.call(rbind, lapply(2:5, function(k)
      ringkas_pam(X_tanpa_ln, k, d_tanpa_ln, ta_clean$ac)))
    rm(d_tanpa_ln); invisible(gc())
  })
  cat("selesai dalam", round(waktu[["elapsed"]], 1), "detik\n")

  # Versi dipakai: pakai ulang hasil PAM bagian 2 (data x dan d_x yang sama)
  pam_dipakai <- do.call(rbind, lapply(k_uji, function(k) {
    p <- daftar_pam[[as.character(k)]]
    ukuran <- as.integer(table(p$clustering))
    data.frame(
      k = k,
      silhouette_kmedoids = round(mean(cluster::silhouette(p$clustering, d_x)[, 3]), 4),
      ukuran_kmedoids = paste(sort(ukuran), collapse = " / "),
      terkecil_pers_kmedoids = round(100 * min(ukuran) / nrow(x), 2),
      cramerV_ac_kmedoids = round(cramer_v(p$clustering, ta_clean$ac), 4)
    )
  }))

  transformasi_pam <- rbind(
    cbind(transformasi = "ln + winsorizing (dipakai)", pam_dipakai),
    cbind(transformasi = "winsorizing tanpa ln", pam_tanpa_ln)
  )

  if (exists("sensitivitas_transformasi")) {
    st <- as.data.frame(sensitivitas_transformasi)
    km_l2 <- data.frame(
      transformasi = ifelse(grepl("tanpa ln", st$spesifikasi),
                            "winsorizing tanpa ln", "ln + winsorizing (dipakai)"),
      k = st$k,
      silhouette_kmeans = st$silhouette,
      terkecil_pers_kmeans = st$terkecil_pers,
      cramerV_ac_kmeans = st$cramerV_ac
    )
    transformasi_pam <- merge(transformasi_pam, km_l2,
                              by = c("transformasi", "k"), all.x = TRUE)
  }
  transformasi_pam <- transformasi_pam[order(transformasi_pam$k,
                                             transformasi_pam$transformasi), ]

  cat("\n[LAMPIRAN K-MEDOIDS] Padanan Tabel L1.2:\n")
  print(transformasi_pam, row.names = FALSE)
  write.csv(transformasi_pam, file.path(folder_output, "68_kmedoids_transformasi.csv"),
            row.names = FALSE)
}

options(opsi_lama)
