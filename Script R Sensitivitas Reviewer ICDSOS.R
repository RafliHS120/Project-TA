# ============================================================
# SCRIPT SENSITIVITAS REVIEWER ICDSOS (SESI BQ, 16 NOVEMBER 2026)
# Menjawab Reviewer A, paper IFLP-ICDSOS 2026 ID 1004:
#   Komentar 1 "kWh hasil konversi melampaui kapasitas meteran"
#        -> Skenario B (kWh dipotong di 324 / 648 kWh) dan
#           Skenario C (290 rumah tangga yang melampaui dikeluarkan)
#   Komentar 3 "K-Means tanpa penimbang, profil tertimbang"
#        -> Skenario D (standardisasi + K-Means memakai penimbang Susenas)
#   Komentar di dalam naskah (Eq. 1 dan 3) "seberapa jauh centroid bergeser"
#        -> BAGIAN 4 keluaran (centroid per skenario)
#
# CARA MENJALANKAN (wajib berurutan, dalam satu sesi R yang sama)
#   1. Jalankan "Script R Pasca SE Bimbingan.R" sampai selesai
#      (skenario_tarif harus "utama").
#   2. Tanpa Restart R, jalankan script ini:
#        source("Script R Sensitivitas Reviewer ICDSOS.R")
#   3. Kirim dokumen 90_sensitivitas_reviewerA.txt dari folder output.
#
# ANALOGI
#   Barang yang sama ditimbang ulang dengan tiga timbangan lain. Bila
#   keempat timbangan memberi angka yang berdekatan, hasil utama tidak
#   bergantung pada timbangan yang dipilih. Bila berjauhan, selisihnya
#   dilaporkan apa adanya.
#   - Skenario A: analisis utama dibangun ulang (harus identik naskah).
#   - Skenario B: kWh yang melampaui kapasitas meteran diturunkan ke batas.
#   - Skenario C: rumah tangga yang melampaui kapasitas tidak diikutkan.
#   - Skenario D: setiap rumah tangga "bersuara" sebesar penimbangnya saat
#     rata-rata, simpangan baku, dan centroid dihitung.
#
# TIGA PEMERIKSAAN OTOMATIS (bila salah satu tidak cocok, hasil jangan dipakai)
#   [CEK 1]  553 / 1.573 / 2.875 rumah tangga; melampaui kapasitas 226 dan 64
#   [CEK A]  Skenario A = 3.329 / 1.672 dan sama 100% dengan klaster naskah
#   [CEK D0] fungsi K-Means tertimbang dengan bobot 1 = klaster naskah
#
# CATATAN
#   - Script ini TIDAK mengubah objek, dokumen, atau angka analisis utama.
#   - K-Means tertimbang memakai algoritme Lloyd; kmeans() bawaan R memakai
#     Hartigan-Wong. [CEK D0] memisahkan pengaruh beda algoritme dari
#     pengaruh penimbang.
#   - Uji berbasis rancangan sampel pada Skenario C memakai subset desain
#     (subpopulasi), bukan desain yang dibangun dari 4.711 rumah tangga.
#   - Diuji dengan data buatan berukuran sama (5.001 baris): selesai
#     kurang dari 1 menit.
#
# KELUARAN (folder_output yang sama dengan script utama)
#   90_sensitivitas_reviewerA.txt      (seluruh keluaran; ini yang dikirim)
#   91_sensitivitas_ringkasan.csv
#   92_sensitivitas_centroid.csv
#   93_sensitivitas_uji_desain.csv
#   94_sensitivitas_perpindahan.csv
#
# Paket: survey dan cluster (sudah dipakai script utama).
# ============================================================

jalankan_sensitivitas <- function() {

  # ---------- 0. Pemeriksaan prasyarat ----------------------------------
  butuh_objek <- c("ta_clean", "data_hasil", "data_penciri", "winsorize",
                   "buat_desain", "folder_output", "seed_kmeans")
  hilang <- butuh_objek[!vapply(butuh_objek, exists, logical(1), envir = globalenv())]
  if (length(hilang) > 0) {
    stop("Objek berikut belum ada di R: ", paste(hilang, collapse = ", "),
         ". Jalankan skrip utama sampai selesai terlebih dahulu.", call. = FALSE)
  }
  for (p in c("survey", "cluster")) {
    if (!requireNamespace(p, quietly = TRUE)) {
      stop("Package '", p, "' belum terpasang.", call. = FALSE)
    }
  }

  ta_clean     <- as.data.frame(get("ta_clean", envir = globalenv()))
  data_hasil   <- as.data.frame(get("data_hasil", envir = globalenv()))
  data_penciri <- as.data.frame(get("data_penciri", envir = globalenv()))
  winsorize    <- get("winsorize", envir = globalenv())
  buat_desain  <- get("buat_desain", envir = globalenv())
  folder_output <- get("folder_output", envir = globalenv())
  seed_kmeans  <- get("seed_kmeans", envir = globalenv())

  cek_kolom <- function(df, kolom, nama) {
    tdk <- setdiff(kolom, names(df))
    if (length(tdk) > 0) {
      stop("Kolom berikut tidak ada di ", nama, ": ", paste(tdk, collapse = ", "),
           ". Kirim pesan ini apa adanya.", call. = FALSE)
    }
  }
  cek_kolom(ta_clean, c("idrt", "bobot", "listrik_kwh_final", "pengeluaran_listrik_rp",
                        "pengeluaran_nonmakanan_nonlistrik", "pendidikan_krt", "ac"),
            "ta_clean")
  cek_kolom(data_hasil, c("idrt", "cluster"), "data_hasil")
  cek_kolom(data_penciri, c("idrt", "bobot", "ac", "lemari_es", "luas_lantai_w"),
            "data_penciri")
  if (anyDuplicated(ta_clean$idrt) > 0) stop("idrt di ta_clean tidak unik.", call. = FALSE)

  opsi_lama <- options(survey.lonely.psu = "adjust", width = 200)
  on.exit(options(opsi_lama), add = TRUE)

  berkas_txt <- file.path(folder_output, "90_sensitivitas_reviewerA.txt")
  sink(berkas_txt, split = TRUE)
  on.exit(sink(), add = TRUE)

  garis <- function(judul) cat("\n", strrep("=", 70), "\n", judul, "\n",
                               strrep("=", 70), "\n", sep = "")

  # ---------- 1. Golongan tarif dan batas kapasitas meteran -------------
  # Golongan dikenali dari tarif yang dipakai saat konversi
  # (pengeluaran listrik / kWh), sehingga tidak bergantung pada kode daya.
  tarif <- ta_clean$pengeluaran_listrik_rp / ta_clean$listrik_kwh_final
  gol <- ifelse(abs(tarif - 415) < 1, "450 VA",
         ifelse(abs(tarif - 605) < 1, "900 VA", "1.300 VA+"))
  if (anyNA(gol)) stop("Ada rumah tangga yang tarif konversinya tidak terbaca ",
                       "(kWh atau pengeluaran listrik kosong/nol).", call. = FALSE)
  batas <- ifelse(gol == "450 VA", 324, ifelse(gol == "900 VA", 648, Inf))
  lampaui <- ta_clean$listrik_kwh_final > batas

  garis("1. CEK GOLONGAN DAN RUMAH TANGGA YANG MELAMPAUI KAPASITAS METERAN")
  cat("Naskah: 553 / 1.573 / 2.875 rumah tangga; melampaui kapasitas 226 dan 64.\n\n")
  cek_gol <- data.frame(
    golongan = c("450 VA", "900 VA", "1.300 VA+"),
    n = as.integer(table(factor(gol, levels = c("450 VA", "900 VA", "1.300 VA+")))),
    melampaui = as.integer(tapply(lampaui, factor(gol, levels = c("450 VA", "900 VA", "1.300 VA+")), sum))
  )
  cek_gol$persen <- round(100 * cek_gol$melampaui / cek_gol$n, 2)
  print(cek_gol, row.names = FALSE)
  if (!identical(cek_gol$n, c(553L, 1573L, 2875L)) ||
      !identical(cek_gol$melampaui[1:2], c(226L, 64L))) {
    cat("\n[PERINGATAN] Hitungan di atas TIDAK sama dengan naskah.",
        "Jangan pakai hasil di bawah sebelum ini diperiksa.\n")
  } else {
    cat("\n[CEK 1] Sama dengan naskah.\n")
  }

  # ---------- 2. Fungsi bantu -------------------------------------------
  w_all <- ta_clean$bobot

  rata_w <- function(v, w) sum(w * v) / sum(w)

  # Menyiapkan matriks tiga variabel pembentuk klaster.
  # w = NULL  -> standardisasi biasa (seperti analisis utama)
  # w = bobot -> rata-rata dan simpangan baku tertimbang
  siapkan <- function(kwh, nonfood, didik, w = NULL) {
    ln_kwh <- log1p(winsorize(kwh, probs = c(0.01, 0.99)))
    ln_nonfood <- log1p(winsorize(nonfood, probs = c(0.01, 0.99)))
    mentah <- cbind(ln_kwh = ln_kwh, ln_nonfood = ln_nonfood, didik = didik)
    if (is.null(w)) {
      z <- scale(mentah)
    } else {
      m <- apply(mentah, 2, rata_w, w = w)
      s <- sqrt(apply(sweep(mentah, 2, m)^2, 2, rata_w, w = w))
      z <- sweep(sweep(mentah, 2, m), 2, s, "/")
    }
    list(z = unclass(z)[, , drop = FALSE], mentah = mentah,
         kwh_w = winsorize(kwh, probs = c(0.01, 0.99)),
         nonfood_w = winsorize(nonfood, probs = c(0.01, 0.99)))
  }

  # Klaster 1 selalu yang centroid ln kWh-nya lebih rendah.
  kunci_label <- function(kl, z) {
    pusat <- tapply(z[, 1], kl, mean)
    peta <- integer(length(pusat))
    peta[order(pusat)] <- seq_along(pusat)
    as.integer(peta[as.integer(factor(kl))])
  }

  # K-Means tertimbang (algoritme Lloyd): meminimalkan
  # jumlah bobot x jarak kuadrat ke centroid tertimbang.
  kmeans_tertimbang <- function(X, w, k = 2, nstart = 100, iter.max = 1000) {
    n <- nrow(X)
    terbaik <- NULL
    for (s in seq_len(nstart)) {
      pusat <- X[sample.int(n, k), , drop = FALSE]
      kl <- integer(n)
      gagal <- FALSE
      for (it in seq_len(iter.max)) {
        d2 <- vapply(seq_len(k), function(j) {
          rowSums(sweep(X, 2, pusat[j, ])^2)
        }, numeric(n))
        kl_baru <- max.col(-d2, ties.method = "first")
        if (length(unique(kl_baru)) < k) { gagal <- TRUE; break }
        if (all(kl_baru == kl)) break
        kl <- kl_baru
        pusat <- t(vapply(seq_len(k), function(j) {
          colSums(X[kl == j, , drop = FALSE] * w[kl == j]) / sum(w[kl == j])
        }, numeric(ncol(X))))
      }
      if (gagal) next
      wcss <- sum(w * d2[cbind(seq_len(n), kl)])
      if (is.null(terbaik) || wcss < terbaik$wcss) {
        terbaik <- list(cluster = kl, wcss = wcss)
      }
    }
    terbaik
  }

  ari <- function(a, b) {
    tab <- table(a, b)
    pilih2 <- function(v) sum(v * (v - 1) / 2)
    s_ij <- pilih2(tab); s_a <- pilih2(rowSums(tab)); s_b <- pilih2(colSums(tab))
    harap <- s_a * s_b / pilih2(sum(tab))
    (s_ij - harap) / (0.5 * (s_a + s_b) - harap)
  }

  cramer <- function(a, b) {
    ok <- !is.na(a) & !is.na(b)
    tab <- table(a[ok], b[ok])
    x2 <- suppressWarnings(chisq.test(tab, correct = FALSE)$statistic)
    as.numeric(sqrt(x2 / (sum(tab) * (min(dim(tab)) - 1))))
  }

  # ---------- 3. Pembentukan klaster per skenario -----------------------
  kwh <- ta_clean$listrik_kwh_final
  nonfood <- ta_clean$pengeluaran_nonmakanan_nonlistrik
  didik <- ta_clean$pendidikan_krt
  n_all <- nrow(ta_clean)

  utama <- as.integer(as.character(data_hasil$cluster[match(ta_clean$idrt, data_hasil$idrt)]))
  if (anyNA(utama)) stop("Ada rumah tangga ta_clean yang tidak ditemukan di data_hasil.",
                         call. = FALSE)

  skenario <- list()

  # A. Analisis utama dibangun ulang (harus identik dengan naskah)
  sA <- siapkan(kwh, nonfood, didik)
  set.seed(seed_kmeans)
  kmA <- kmeans(sA$z, centers = 2, nstart = 100, iter.max = 1000)
  skenario$A <- list(nama = "A. Utama (dibangun ulang)", pakai = rep(TRUE, n_all),
                     siap = sA, kl = kunci_label(kmA$cluster, sA$z))

  # B. kWh dipotong di kapasitas meteran (324 / 648 kWh)
  sB <- siapkan(pmin(kwh, batas), nonfood, didik)
  set.seed(seed_kmeans)
  kmB <- kmeans(sB$z, centers = 2, nstart = 100, iter.max = 1000)
  skenario$B <- list(nama = "B. kWh dipotong di kapasitas meteran", pakai = rep(TRUE, n_all),
                     siap = sB, kl = kunci_label(kmB$cluster, sB$z))

  # C. Rumah tangga yang melampaui kapasitas dikeluarkan
  pakaiC <- !lampaui
  sC <- siapkan(kwh[pakaiC], nonfood[pakaiC], didik[pakaiC])
  set.seed(seed_kmeans)
  kmC <- kmeans(sC$z, centers = 2, nstart = 100, iter.max = 1000)
  skenario$C <- list(nama = "C. Melampaui kapasitas dikeluarkan", pakai = pakaiC,
                     siap = sC, kl = kunci_label(kmC$cluster, sC$z))

  # D. Standardisasi dan K-Means memakai penimbang Susenas
  sD <- siapkan(kwh, nonfood, didik, w = w_all)
  set.seed(seed_kmeans)
  kmD <- kmeans_tertimbang(sD$z, w_all, k = 2, nstart = 100)
  skenario$D <- list(nama = "D. K-Means tertimbang (penimbang Susenas)", pakai = rep(TRUE, n_all),
                     siap = sD, kl = kunci_label(kmD$cluster, sD$z))

  garis("2. CEK REPRODUKSI")
  cat("[CEK A] Skenario A vs klaster di naskah (harus 3.329 / 1.672 dan sama 100%):\n")
  cat("        ukuran =", paste(table(skenario$A$kl), collapse = " / "),
      "| sama =", round(100 * mean(skenario$A$kl == utama), 2), "% | ARI =",
      round(ari(skenario$A$kl, utama), 4), "\n")
  set.seed(seed_kmeans)
  kmD0 <- kmeans_tertimbang(sA$z, rep(1, n_all), k = 2, nstart = 100)
  kl_D0 <- kunci_label(kmD0$cluster, sA$z)
  cat("[CEK D0] Fungsi K-Means tertimbang dengan bobot = 1 vs klaster di naskah\n")
  cat("        (harus sama atau hampir sama; selisih = beda algoritme, bukan beda bobot):\n")
  cat("        ukuran =", paste(table(kl_D0), collapse = " / "),
      "| sama =", round(100 * mean(kl_D0 == utama), 2), "% | ARI =",
      round(ari(kl_D0, utama), 4), "\n")

  # ---------- 4. Ringkasan per skenario ---------------------------------
  pen <- data_penciri[match(ta_clean$idrt, data_penciri$idrt), ]
  if (anyNA(pen$idrt)) stop("Ada rumah tangga ta_clean yang tidak ada di data_penciri.",
                            call. = FALSE)

  ringkas <- list(); pusat_out <- list(); uji_out <- list(); pindah_out <- list()

  for (kode in names(skenario)) {
    sk <- skenario[[kode]]
    idx <- which(sk$pakai)
    kl <- sk$kl
    w <- w_all[idx]
    z <- sk$siap$z
    sil <- mean(cluster::silhouette(kl, dist(z))[, 3])
    per_kl <- function(v, f = rata_w) vapply(1:2, function(j) f(v[kl == j], w[kl == j]), numeric(1))
    pangsa <- 100 * tapply(w, kl, sum) / sum(w)
    kwh_kl <- per_kl(sk$siap$kwh_w)
    es <- pen$lemari_es[idx]; ok_es <- !is.na(es)
    lantai <- pen$luas_lantai_w[idx]; ok_l <- !is.na(lantai)

    ringkas[[kode]] <- data.frame(
      skenario = sk$nama, n = length(idx),
      n_k1 = sum(kl == 1), n_k2 = sum(kl == 2),
      pangsa_k1 = round(pangsa[1], 2), pangsa_k2 = round(pangsa[2], 2),
      silhouette = round(sil, 4),
      sama_dgn_naskah_persen = round(100 * mean(kl == utama[idx]), 2),
      ARI_dgn_naskah = round(ari(kl, utama[idx]), 4),
      V_ac = round(cramer(kl, pen$ac[idx]), 4),
      V_lemari_es = round(cramer(kl, es), 4),
      kwh_k1 = round(kwh_kl[1], 2), kwh_k2 = round(kwh_kl[2], 2),
      rasio_kwh = round(kwh_kl[2] / kwh_kl[1], 2),
      nonfood_k1 = round(per_kl(sk$siap$nonfood_w)[1]), nonfood_k2 = round(per_kl(sk$siap$nonfood_w)[2]),
      didik_k1 = round(per_kl(sk$siap$mentah[, "didik"])[1], 2),
      didik_k2 = round(per_kl(sk$siap$mentah[, "didik"])[2], 2),
      ac_k1 = round(100 * per_kl(pen$ac[idx])[1], 2), ac_k2 = round(100 * per_kl(pen$ac[idx])[2], 2),
      es_k1 = round(100 * rata_w(es[ok_es & kl == 1], w[ok_es & kl == 1]), 2),
      es_k2 = round(100 * rata_w(es[ok_es & kl == 2], w[ok_es & kl == 2]), 2),
      lantai_k1 = round(rata_w(lantai[ok_l & kl == 1], w[ok_l & kl == 1]), 2),
      lantai_k2 = round(rata_w(lantai[ok_l & kl == 2], w[ok_l & kl == 2]), 2),
      row.names = NULL
    )

    # Centroid: skala z milik skenario itu sendiri, dan skala ln/tahun
    # (skala ln/tahun dapat dibandingkan langsung antar-skenario).
    f_pusat <- if (kode == "D") rata_w else function(v, w) mean(v)
    pusat_out[[kode]] <- data.frame(
      skenario = sk$nama,
      variabel = c("ln kWh", "ln nonmakanan selain listrik", "lama sekolah KRT"),
      z_k1 = round(apply(z, 2, function(v) f_pusat(v[kl == 1], w[kl == 1])), 4),
      z_k2 = round(apply(z, 2, function(v) f_pusat(v[kl == 2], w[kl == 2])), 4),
      asli_k1 = round(apply(sk$siap$mentah, 2, function(v) f_pusat(v[kl == 1], w[kl == 1])), 4),
      asli_k2 = round(apply(sk$siap$mentah, 2, function(v) f_pusat(v[kl == 2], w[kl == 2])), 4),
      rata_keseluruhan = round(apply(sk$siap$mentah, 2, function(v) f_pusat(v, w)), 4),
      row.names = NULL
    )

    # Uji berbasis rancangan sampel. Desain dibangun dari 5.001 rumah
    # tangga; Skenario C diperlakukan sebagai subpopulasi (subset desain).
    d_uji <- data_penciri
    kl_penuh <- rep(NA_integer_, n_all); kl_penuh[idx] <- kl
    d_uji$kl_s <- factor(kl_penuh[match(d_uji$idrt, ta_clean$idrt)])
    d_uji$ac_s <- factor(d_uji$ac)
    d_uji$es_s <- factor(d_uji$lemari_es)
    des <- buat_desain(d_uji)
    des <- subset(des, !is.na(kl_s))
    u_ac <- survey::svychisq(~ kl_s + ac_s, des, statistic = "F")
    u_es <- survey::svychisq(~ kl_s + es_s, subset(des, !is.na(es_s)), statistic = "F")
    u_l <- survey::svyranktest(luas_lantai_w ~ kl_s, subset(des, !is.na(luas_lantai_w)),
                               test = "KruskalWallis")
    uji_out[[kode]] <- data.frame(
      skenario = sk$nama,
      variabel = c("Kepemilikan AC (pembanding deskriptif)", "Kepemilikan lemari es", "Luas lantai"),
      uji = c("Rao-Scott F", "Rao-Scott F", "Kruskal-Wallis berbasis desain (t)"),
      statistik = round(c(u_ac$statistic, u_es$statistic, u_l$statistic), 3),
      db = c(paste(round(u_ac$parameter, 2), collapse = "; "),
             paste(round(u_es$parameter, 2), collapse = "; "),
             paste(round(u_l$parameter, 2), collapse = "; ")),
      p_value = signif(c(u_ac$p.value, u_es$p.value, u_l$p.value), 4),
      row.names = NULL
    )

    # Rumah tangga yang berpindah klaster dibanding naskah
    tab_pindah <- as.data.frame(table(
      klaster_naskah = utama[idx], klaster_skenario = kl,
      golongan = gol[idx], melampaui_kapasitas = ifelse(lampaui[idx], "ya", "tidak")
    ), responseName = "n")
    tab_pindah <- tab_pindah[tab_pindah$n > 0, ]
    pindah_out[[kode]] <- cbind(skenario = sk$nama, tab_pindah)
  }

  ringkas <- do.call(rbind, ringkas)
  pusat_out <- do.call(rbind, pusat_out)
  uji_out <- do.call(rbind, uji_out)
  pindah_out <- do.call(rbind, pindah_out)

  garis("3. RINGKASAN PER SKENARIO")
  cat("Pangsa, kWh, nonmakanan, lama sekolah, AC, lemari es, luas lantai = tertimbang.\n")
  cat("kWh memakai variabel kWh milik skenario itu sendiri (setelah winsorizing).\n")
  cat("Silhouette dan Cramer's V = tidak tertimbang.\n\n")
  print(t(ringkas), quote = FALSE)

  garis("4. CENTROID PER SKENARIO")
  cat("z_k1/z_k2 = skala z skenario itu sendiri.\n")
  cat("asli_k1/asli_k2 = skala ln (kWh, rupiah) dan tahun; bandingkan kolom ini antar-skenario.\n")
  cat("Skenario D: centroid dan rata-rata keseluruhan dihitung tertimbang.\n\n")
  print(pusat_out, row.names = FALSE)

  garis("5. UJI BERBASIS RANCANGAN SAMPEL PER SKENARIO")
  print(uji_out, row.names = FALSE)

  garis("6. PERPINDAHAN KLASTER TERHADAP NASKAH (menurut golongan dan status kapasitas)")
  print(pindah_out, row.names = FALSE)

  write.csv(ringkas, file.path(folder_output, "91_sensitivitas_ringkasan.csv"), row.names = FALSE)
  write.csv(pusat_out, file.path(folder_output, "92_sensitivitas_centroid.csv"), row.names = FALSE)
  write.csv(uji_out, file.path(folder_output, "93_sensitivitas_uji_desain.csv"), row.names = FALSE)
  write.csv(pindah_out, file.path(folder_output, "94_sensitivitas_perpindahan.csv"), row.names = FALSE)

  cat("\nSelesai. Kirim dokumen:", berkas_txt, "\n")
  invisible(list(ringkas = ringkas, centroid = pusat_out, uji = uji_out, pindah = pindah_out))
}

hasil_sensitivitas <- jalankan_sensitivitas()
