# BANK PERTANYAAN DAN JAWABAN SIDANG TUGAS AKHIR

| Item | Isi |
|---|---|
| Penulis | Rafli Hibriansyah Siregar (112313326, 3D33) |
| Sidang | Rabu, 14 Oktober 2026 · Sesi 3, 11.00–12.00 WIB · Ruang 321 |
| Penguji | Bu Fitri (pembimbing), Pak Yaya, Pak Azka (ketat soal pilihan metode: "kenapa tidak ini?") |
| Disusun | Sesi BD, 11 Oktober 2026 · ditambah bagian I (11 pertanyaan) dan J, Sesi BE, 13 Oktober 2026 |
| Status | **Bahan latihan lisan. Bukan isi naskah.** Tidak ada satu kalimat pun dari file ini yang dipindahkan ke `.docx` tanpa keputusan Rafli |

---

## 0. CARA MEMAKAI FILE INI

| Aturan | Penjelasan |
|---|---|
| Nomor tabel dan gambar | Mengikuti `.docx` **Rev BC** (Gambar 11 = grafik *centroid*, Gambar 12 = komponen utama, Gambar 13–17 = profil klaster). `Draft TA Pasca SE.md` di repo belum disinkronkan dan masih memakai nomor lama |
| Sitasi | **Tanpa "hlm."** (arahan Bu Fitri). Saat lisan cukup "Everitt dan kawan-kawan, 2011" |
| Label sumber | `[TERVERIFIKASI]` boleh disebut · `[PERLU VERIFIKASI]` cek dulu, sebelum dicek sampaikan sebagai penalaran sendiri tanpa nama sumber · `[PENALARAN]` argumen logis, bukan kutipan |
| Angka bertanda (hitung) | Dihitung dari angka naskah/output, bukan keluaran R langsung. Boleh diucapkan sebagai hitungan sederhana |
| Bila tidak tahu | "Terima kasih, Pak/Bu. Hal itu belum saya periksa dalam penelitian ini dan akan saya catat sebagai masukan." **Jangan mengarang** |
| Pola menjawab | (1) jawab langsung satu kalimat → (2) alasan → (3) tunjuk bukti di naskah (tabel/gambar/subbab) → berhenti. Jangan menambah hal yang tidak ditanya |

**Prioritas:** ★★★ hampir pasti · ★★ mungkin · ★ cadangan

### Peta naskah (Rev BC, nomor halaman MS Word)

| Bagian | Mulai halaman |
|---|---|
| Bab I | 1 |
| Bab II | 19 |
| Bab III | 49 |
| Bab IV | 73 |
| Bab V | 105 |
| Daftar Pustaka | 109 |
| Lampiran | 115 |

### Kartu angka kunci

| Angka | Arti | Letak |
|---|---|---|
| 5.079 → 78 → 5.001 | RT gabungan → dikeluarkan (66 PLN tanpa meteran, 12 non-PLN) → dianalisis | 3.4; awal Bab IV |
| 553 / 1.573 / 2.875 | RT 450 / 900 / ≥1.300 VA | 3.4 |
| 512 PSU · 6 strata | Rancangan sampel | 3.4 |
| 369,61 kWh (SE 15,83) | Rata-rata tertimbang konsumsi listrik | Tabel 3 |
| 327,45 / 222,19 kWh | Rata-rata / median sampel | Tabel 3 |
| Rp5.825.672 / Rp2.714.820 | Rata-rata tertimbang / median pengeluaran nonmakanan selain listrik | 4.1 |
| 11,39 tahun · 3,68 orang | Lama sekolah KRT · ukuran RT (tertimbang) | 4.1 |
| 15.000 → 8.806,23 | WCSS K = 1 → K = 2 | Tabel 4 |
| 0,3640 / 0,3149 / 0,2907 / 0,2848 | *Silhouette* K = 2 / 3 / 4 / 5 | Tabel 4 |
| 3.329 / 1.672 | RT sampel Klaster 1 / 2 (66,57% / 33,43%) | Tabel 5 |
| 60,11% / 39,89% | Komposisi tertimbang Klaster 1 / 2 | Tabel 5, 7 |
| 1,5251 · 1,3603 · 1,1782 | Jarak *centroid* (simpangan baku): nonmakanan · listrik · lama sekolah | 4.2 |
| 65,42% + 23,88% = 89,31% | Keragaman KU1 + KU2 | Tabel 6 |
| −0,7887 / 1,5703 | *Centroid* KU1 Klaster 1 / 2 (KU2 ≈ 0) | 4.2 |
| 186,61 vs 645,34 kWh (3,46×) | Konsumsi listrik | Tabel 7 |
| 60,08 vs 198,88 kWh (3,31×) | Konsumsi per kapita | Tabel 7 |
| Rp180.146 vs Rp789.474 (4,38×) | Pengeluaran listrik | Tabel 7 |
| Rp2.509.606 vs Rp10.821.847 (4,31×) | Nonmakanan selain listrik | Tabel 7 |
| 9,83 vs 13,74 tahun | Lama sekolah KRT | Tabel 7 |
| 7,05% vs 7,63% | Pangsa listrik thd nonmakanan | Tabel 7 |
| 17,02% vs 76,07% · V 0,553 | AC | Tabel 8, 9 |
| 87,27% vs 98,25% · V 0,214 | Lemari es | Tabel 8, 9 |
| 42,52 vs 106,17 m² (median 30 vs 80) | Luas lantai | Tabel 8 |
| 3,65 vs 3,71 orang · *p* = 0,362 | Ukuran RT (berbasis desain, tidak signifikan) | Tabel 8, 9 |

---

## A. PENDAHULUAN DAN POSISI PENELITIAN

### A1 · Apa kebaruan penelitian ini? ★★★

> "Kebaruannya ada pada tiga hal. Pertama, unit dan cakupannya: rumah tangga di seluruh DKI Jakarta dari mikrodata Susenas yang bertimbang, bukan satu jenis hunian seperti apartemen pada Takata dan kawan-kawan. Kedua, pendekatannya: penelitian terdahulu tentang determinan sosial ekonomi memakai regresi, sedangkan penelitian ini menghasilkan tipologi rumah tangga. Ketiga, klaster yang terbentuk diuji pada variabel penciri yang tidak dipakai algoritme, yaitu AC, lemari es, dan luas lantai."

| Bukti | 1.2 (paragraf *research gap*); 2.2 Tabel 1 dan paragraf posisi penelitian |
|---|---|
| Sumber | Takata et al. (2025); Nazer & Handra (2016); Ali et al. (2021) — sudah di naskah |
| Hindari | "Belum pernah ada penelitian…" (klaim mutlak). Pakai "belum banyak yang secara khusus…" sesuai naskah |

### A2 · Kenapa klasifikasi, bukan regresi determinan konsumsi listrik? ★★★

> "Regresi menjawab berapa rata-rata pengaruh tiap variabel terhadap konsumsi listrik, tetapi tidak menunjukkan kelompok rumah tangga mana yang perlu disasar. Kebijakan efisiensi energi yang saya kritik di latar belakang masih berlaku umum, dan Mills dan Schleich menunjukkan bahwa rumah tangga dengan pendidikan berbeda terdorong menghemat karena alasan yang berbeda. Jadi yang dibutuhkan adalah peta kelompok, dan itu tujuan analisis klaster."

| Bukti | 1.2 paragraf terakhir (RUEN; Mills & Schleich, 2012); 2.2 arus kedua |
|---|---|
| Jika didesak | "Regresi dan klaster saling melengkapi. Penelitian determinan sudah ada; yang belum ada adalah tipologinya." |

### A3 · Gambar 4 turun di 2025, kok disebut meningkat? ★★

> "Benar, Pak/Bu, pada 2025 ada penurunan tipis dari 16,41 menjadi 16,36 miliar kWh. Yang saya sebut adalah kecenderungan selama 2018–2025: dari 13,20 menjadi 16,36 miliar kWh, naik sekitar 24 persen. Penurunan satu tahun itu sekitar 0,3 persen."

| Bukti | 1.2, Gambar 4 dan tabel datanya |
|---|---|
| Angka (hitung) | 16,36 / 13,20 = 1,239 → naik ±24%; (16,36 − 16,41) / 16,41 = −0,3% |
| Hindari | Membantah ada penurunan. Akui dulu, baru jelaskan tren |

### A4 · Kenapa DKI Jakarta dan Susenas Maret 2025? ★★

> "DKI Jakarta mencatat rata-rata pengeluaran listrik per kapita tertinggi nasional, Rp120.220 per bulan, sekitar tiga kali rata-rata nasional. Rumah tangga mencakup 92,49 persen pelanggan listrik DKI dan menyerap 42,84 persen konsumsinya. Susenas Maret 2025 dipilih karena dalam satu sumber memuat pengeluaran listrik, kepemilikan AC dan lemari es, luas lantai, pendidikan, serta penimbang dan rancangan sampel sehingga hasilnya dapat menggambarkan tingkat provinsi."

| Bukti | 1.1 (Gambar 2; BPS 2025a; BPS Provinsi DKI Jakarta 2026); 3.1–3.2 |
|---|---|
| Hindari | Kata "estimasi" (arahan Bu Fitri). Pakai "menggambarkan" |

### A5 · *Urban Heat Island* dibahas, padahal suhu tidak diukur. Relevansinya? ★★

> "UHI dipakai sebagai konteks yang menjelaskan mengapa pendinginan menjadi bagian dari kebutuhan listrik rumah tangga di Jakarta, sehingga kepemilikan AC relevan sebagai penciri. Suhu pada tingkat rumah tangga memang tidak diukur, dan itu saya nyatakan sebagai keterbatasan. Karena itu, pembacaan *adaptation cooling deficit* saya sebut indikasi, bukan pengukuran."

| Bukti | 2.1 UHI dan ACD (Siswanto et al., 2023; De Cian et al., 2025; Pavanello et al., 2021); 1.4; 3.1 |
|---|---|

---

## B. DATA DAN VARIABEL

### B1 · Bagaimana kWh diperoleh? Kenapa tarif per golongan daya? ★★★

> "Isian kWh di Susenas Maret 2025 untuk DKI Jakarta tidak terisi, sedangkan pengeluaran listrik terisi pada seluruh rumah tangga. Karena itu kWh diperoleh dari pengeluaran listrik dibagi tarif menurut golongan daya: Rp415 untuk 450 VA dan Rp605 untuk 900 VA dari Permen ESDM Nomor 7 Tahun 2024, serta Rp1.444,70 untuk 1.300 VA ke atas dari penetapan tarif PLN triwulan I 2025. Tarif per golongan dipakai karena tarifnya berjenjang. Buktinya ada di Tabel 7: rasio pengeluaran listrik antarklaster 4,38 kali, sedangkan rasio konsumsinya 3,46 kali. Kalau hanya satu tarif rata-rata, kedua rasio itu dipaksa sama."

| Bukti | 3.3 Tabel 2; 3.4 Persiapan Data; 1.4; 4.3 paragraf rasio 4,38 vs 3,46 |
|---|---|
| Sumber | Kementerian ESDM (2024); PT PLN (Persero) (2025) — sudah di naskah |
| Hindari | Menyebut hasil konversi sebagai "kWh aktual" atau "hasil meteran" |

### B2 · Kenapa ≥1.300 VA memakai satu tarif R-1/1.300 VA? Bukankah R-2/R-3 lebih mahal? ★★★

> "Susenas hanya mencatat tiga kategori daya, sedangkan tarif memuat tujuh golongan, sehingga 1.300 VA ke atas tidak bisa dipisah. Akibatnya, rumah tangga yang sebenarnya R-2 atau R-3 memperoleh kWh hasil konversi sekitar 18 persen lebih tinggi daripada seharusnya. Arah biasnya jelas dan saya nyatakan di keterbatasan. Dampaknya pada klaster terbatas karena rumah tangga ini memang sudah berada di ujung atas; di dalam kategori yang sama urutan antarrumah tangga juga tidak berubah karena tarifnya seragam."

| Bukti | 1.4 penyederhanaan pertama; 3.4 Persiapan Data |
|---|---|
| Angka (hitung) | 1.699,53 / 1.444,70 = 1,176 → ±18% lebih tinggi |
| Status | Bagian "dampak terbatas" = `[PENALARAN]`, tidak diuji |

### B3 · 40,87% RT 450 VA melampaui kapasitas meteran. Data masih bisa dipercaya? ★★★

> "Itu saya temukan dan laporkan sendiri di keterbatasan: 226 dari 553 rumah tangga 450 VA dan 64 dari 1.573 rumah tangga 900 VA, jadi 290 rumah tangga atau sekitar 5,8 persen dari seluruh data. Penyebabnya tidak dapat dipastikan dari mikrodata, dengan tiga kemungkinan: golongan daya tercatat tidak sesuai, rumah tangga sebenarnya bertarif nonsubsidi, atau token dibeli untuk lebih dari sebulan. Ketiganya membuat kWh lebih tinggi daripada sebenarnya. Data tetap dipakai karena tidak ada dasar sah untuk mengganti nilainya; *winsorizing* dan logaritma menekan pengaruhnya pada jarak."

| Bukti | 1.4 paragraf kapasitas meteran |
|---|---|
| Angka (hitung) | 290 / 5.001 = 5,8% |
| Hindari | "Datanya pasti salah" atau "tidak berpengaruh". Katakan "penyebab tidak dapat dipastikan" |

### B4 · Kenapa pengeluaran nonmakanan, bukan pendapatan atau total pengeluaran? Kenapa listrik dikurangkan? ★★★

> "Susenas mengukur pengeluaran, bukan pendapatan. Haughton dan Khandker menjelaskan bahwa konsumsi periode pendek lebih mewakili kesejahteraan daripada pendapatan yang bergejolak, dan pengeluaran lebih mudah diukur. Nazer dan Handra juga memakai pengeluaran sebagai proksi pendapatan. Saya memakai bagian nonmakanan sebagai proksi kemampuan belanja di luar kebutuhan pangan. Komponen listrik dikurangkan supaya informasi yang sama tidak masuk dua kali ke perhitungan jarak, karena konsumsi listrik sudah menjadi variabel pembentuk sendiri."

| Bukti | 2.1 Determinan Sosial Ekonomi; 2.3; 3.3 |
|---|---|
| Sumber | Haughton & Khandker (2009); Nazer & Handra (2016) `[TERVERIFIKASI di naskah]` |
| Jika didesak "kenapa bukan total?" | `[PENALARAN]` "Listrik termasuk pengeluaran nonmakanan, dan bagian nonmakanan lebih mencerminkan ruang belanja di luar kebutuhan pokok. Total pengeluaran tidak saya uji sebagai pembanding." |

### B5 · Kenapa ukuran RT dikeluarkan dari variabel pembentuk? ★★★

> "Ada dua alasan konseptual dan satu bukti empiris. Pertama, ukuran rumah tangga mencerminkan skala kebutuhan, bukan kapasitas ekonomi atau modal manusia. Kalau dimasukkan dengan bobot setara, dua rumah tangga yang ekonomi dan pendidikannya mirip bisa terpisah hanya karena jumlah anggotanya berbeda. Kedua, pada Kubota dan kawan-kawan, ukuran rumah tangga menjelaskan konsumsi LPG, sedangkan konsumsi energi AC dijelaskan luas lantai dan pendapatan. Secara empiris, di Lampiran 1, mengeluarkan ukuran rumah tangga tidak melemahkan hubungan klaster dengan AC: Cramér's V 0,5454 dengan ukuran RT dan 0,5530 tanpa. Ukuran rumah tangga tetap diperiksa sebagai penciri, dan hasilnya tidak berbeda antarklaster setelah desain sampel diperhitungkan."

| Bukti | 3.4 Penetapan Variabel Pembentuk; Lampiran 1 Tabel L1.1 (baris 1 vs 17); Tabel 9 |
|---|---|
| Sumber | Everitt et al. (2011); Kubota et al. (2014); Ali et al. (2021) — sudah di naskah |

### B6 · Kenapa tidak bentuk per kapita (S1)? *Silhouette* S1 malah lebih tinggi ★★

> "Bentuk per kapita melemahkan hubungan klaster dengan kepemilikan AC: Cramér's V turun menjadi 0,4364 dibanding 0,5530 pada S2. Kriteria pemilihan saya berurutan: pertama hubungan dengan AC, kedua klaster terkecil minimal 10 persen, ketiga *silhouette* sebagai penentu bila dua kriteria pertama tidak membedakan. *Silhouette* S1 memang 0,3666, tetapi selisihnya dengan S2 hanya 0,0026, sedangkan Cramér's V-nya turun jelas. Unit analisis penelitian juga rumah tangga, sehingga bentuk total sejalan dengan unitnya."

| Bukti | 3.4 (tiga kriteria berurutan); Lampiran 1 baris 9 vs 17 |
|---|---|
| Waspada | Kriteria AC ini yang membuat AC "tidak sepenuhnya bebas" (lihat C7) |

### B7 · Prabayar vs pascabayar, dan 900 VA-RTM? ★★

> "Golongan 450 dan 900 VA punya dua skema, reguler berlapis blok dengan biaya beban dan prabayar bertarif tunggal. Susenas tidak mencatat skemanya, jadi saya memakai tarif prabayar. Untuk 900 VA, Susenas juga tidak bisa membedakan bersubsidi dan RTM yang bertarif Rp1.352, jadi semuanya memakai tarif bersubsidi. Arah biasnya sama: rumah tangga yang sebenarnya bertarif lebih tinggi memperoleh kWh hasil konversi lebih tinggi daripada aktual. Keduanya saya nyatakan di keterbatasan."

| Bukti | 1.4 penyederhanaan kedua dan ketiga; 3.4 |
|---|---|

### B8 · 78 RT dibuang. Dampaknya ke kesimpulan? ★★

> "Sebanyak 78 rumah tangga, atau 1,54 persen, tidak memiliki golongan tarif yang sah: 66 pengguna PLN tanpa meteran dan 12 pengguna non-PLN, sehingga kWh-nya tidak bisa dihitung. Profil mereka lebih rendah: ukuran rumah tangga 2,64 orang, lama sekolah KRT 9,62 tahun, kepemilikan AC 10,3 persen. Karena itu kesimpulan saya berlaku untuk rumah tangga bermeteran PLN di DKI Jakarta, bukan seluruh rumah tangga."

| Bukti | Awal Bab IV; 1.4; 3.1 |
|---|---|

### B9 · Lama sekolah dari jenjang yang diikuti, bukan ijazah. Dampaknya? ★★

> "Keterangan ijazah dan kelas tertinggi tidak tersedia pada data yang saya peroleh, sehingga nilai konversi BPS diterapkan pada jenjang tertinggi yang sedang atau pernah diikuti. Akibatnya, KRT yang tidak tamat memperoleh nilai setara lulusan jenjang itu, jadi lama sekolah cenderung lebih tinggi daripada ketentuan BPS. Ini saya nyatakan di metodologi."

| Bukti | 3.4 Persiapan Data (BPS Kota Yogyakarta, 2026) |
|---|---|
| ⚠️ Cek sebelum sidang | Script membaca R611, R613, **R615** dan membuat kolom `sumber_pendidikan` (output `06_diagnostik_pendidikan_krt_recode.csv`). Pastikan di kuesioner apa isi R615 dan dari rincian mana `pendidikan_krt` akhirnya diambil, supaya jawaban ini tidak bertentangan dengan script bila Pak Azka bertanya "R615 itu apa?" |

### B10 · Tunjukkan rincian kuesioner tiap variabel. Di mana isian kWh yang kosong? ★★

> Tunjuk langsung di kuesioner VSEN25.K dan VSEN25.KP sesuai Tabel 2.

| Variabel | Rincian |
|---|---|
| KRT · jenjang pendidikan | R403 · R613 |
| Jumlah ART · luas lantai | R301 · R1604 |
| Sumber penerangan · daya meteran 1 | R1616 · R1616B1 |
| Lemari es · AC | R1801B · R1801C |
| Pengeluaran listrik | KP Blok IV.2 R234 |
| Isian kWh | Di output diagnostik script, rincian **kode 233** pada KP bernilai nol pada seluruh 5.079 RT, sedangkan kode 234 (pengeluaran listrik) positif pada seluruhnya. **Cek di kuesioner KP bahwa kode 233 adalah isian kWh** sebelum menyebutnya |

### B11 · Daya tercatat dalam watt, tarif dalam VA. Kok disamakan? ★

> "Kuesioner mencatat kategori 450, 900, dan 1.300 watt ke atas, sedangkan peraturan tarif memakai VA. Yang saya padankan adalah kategorinya, yaitu golongan pelanggan yang sama, bukan konversi angka watt ke VA."

| Bukti | 3.4 Persiapan Data (kalimat satuan watt vs VA); Tabel 2 baris 9 |
|---|---|

---

## C. METODE KLASTER (WILAYAH PAK AZKA)

### C1 · Kenapa K-Means, bukan K-Medoids? ★★★ ✅

> "K-Medoids sudah saya coba sebagai pembanding, dengan data dan matriks jarak yang sama. Kedua metode sama-sama menunjuk dua klaster. Rata-rata *silhouette* K-Means 0,3640, lebih tinggi daripada K-Medoids 0,3227, jadi dengan kriteria yang saya pakai K-Means memberi pemisahan yang lebih baik. Keunggulan utama K-Medoids adalah ketahanan terhadap pencilan, dan itu sudah saya tangani dengan *winsorizing* dan logaritma; pengaruhnya pun kecil, karena *silhouette* dengan dan tanpa *winsorizing* hanya 0,3640 dan 0,3627. Temuan utamanya juga bertahan: pada K-Medoids, klaster konsumsi tinggi tetap memiliki AC, lemari es, dan luas lantai yang lebih tinggi, dengan Cramér's V untuk AC 0,51."

| Bukti | Bab II Metode Nonhierarki K-Means; 3.4 Persiapan Data; Lampiran 1; output `Script R Pembanding K-Medoids.R` (tidak di naskah) |
|---|---|
| Sumber | Everitt et al. (2011): kriteria *trace*(**W**) dan *k-median* sebagai alternatif tahan pencilan `[TERVERIFIKASI]` |
| Hindari | "K-Medoids terlalu berat komputasinya" (matriks jarak penuh sudah dihitung untuk *silhouette*) · "hasilnya sama" |

**Hasil pembanding K-Medoids (untuk jawaban lanjutan, tidak di naskah)**

| Aspek | K-Means | K-Medoids |
|---|---|---|
| K terbaik (*silhouette*) | 2 | 2 (0,3227 > 0,3064 > 0,2872 > 0,2481) |
| *Silhouette* K = 2 | 0,3640 | 0,3227 |
| RT di klaster bernomor sama | — | 84,18% |
| RT berpindah | — | 791, seluruhnya dari Klaster 1 K-Means ke Klaster 2 K-Medoids |
| *Silhouette* K-Means RT yang berpindah | — | 0,1765 (yang tetap 0,3992) → RT perbatasan |
| Komposisi tertimbang | 60,11% / 39,89% | 43,43% / 56,57% |
| AC | 17,02% → 76,07% (V 0,553) | 11,37% → 63,01% (V 0,512) |
| Lemari es | 87,27% → 98,25% (V 0,214) | 84,92% → 96,82% (V 0,241) |
| Luas lantai | 42,52 → 106,17 m² | 38,24 → 90,71 m² |
| Medoid (RT nyata) | — | K1: ±140 kWh, Rp1,8 juta, 9 tahun · K2: ±341 kWh, Rp4,6 juta, 12 tahun |
| Padanan Lampiran 1 | — | Pola bertahan: S1 melemahkan V(AC) (0,4267 vs 0,5124), S0→S2 tidak melemahkan (0,5044 vs 0,5124), *winsorizing* hampir tidak berpengaruh (0,3227 vs 0,3196), tanpa ln V(AC) turun (0,3253) |

### C2 · Kenapa jarak Euclidean? Kenapa tidak Manhattan atau Mahalanobis? ★★★ ✅

> "Jarak Euclidean sepaket dengan K-Means. K-Means memperbarui pusat klaster dengan rata-rata anggotanya, dan rata-rata adalah titik yang meminimumkan jumlah kuadrat jarak Euclidean, sesuai kriteria *trace* W pada Everitt dan kawan-kawan. Kalau jaraknya Manhattan, pusat yang konsisten adalah median, sehingga metodenya menjadi K-Median. Ketiga variabel pembentuk numerik dan sudah distandardisasi sehingga satuannya setara. Jarak yang sama juga saya pakai untuk *silhouette*, jadi pembentukan dan penilaian klasternya konsisten."

| Jarak lain | Jawaban singkat |
|---|---|
| Manhattan | Pusat konsistennya median → K-Median; masalah selisih besar sudah ditangani *winsorizing* + ln |
| Gower | Untuk data campuran; ketiga pembentuk numerik, variabel kategorik dijadikan penciri |
| Korelasi/kosinus | Mengukur kesamaan pola, bukan besaran; penelitian ini justru tentang perbedaan tingkat |

**Bila ditanya Mahalanobis (variabel berkorelasi):**

> "Benar, Pak, ketiganya berkorelasi positif; komponen utama pertama menjelaskan 65,42 persen keragaman dengan ketiga muatan positif. Gerak bersama itu justru fenomena yang ingin saya petakan, sesuai *energy ladder*. Mahalanobis dengan kovarians seluruh data akan mengecilkan bobot arah bersama itu, padahal arah itulah yang membedakan kedua klaster. Hasilnya juga konsisten: kedua klaster berbeda pada komponen pertama, sedangkan pada komponen kedua *centroid*-nya hampir nol."

| Bukti | Bab II (Pers. 2.1–2.2); Tabel 6; 4.2 (*centroid* KU2 0,0002 dan −0,0004) |
|---|---|
| Status | Argumen "kovarians di dalam klaster belum diketahui sebelum klaster terbentuk" = `[PERLU VERIFIKASI]` di Everitt et al. (2011) bab ukuran kedekatan. Sebelum dicek, sampaikan tanpa nama buku |
| Waspada | Hassan et al. (2021) menulis K-Means dapat memakai "Euclidean, Manhattan, or any other defined measure". Bila dikutip balik: "Secara prosedur bisa, Pak, tetapi pembaruan pusat dengan rata-rata hanya optimal untuk jarak Euclidean kuadrat; dengan Manhattan pusat yang sesuai adalah median." |

### C3 · Kenapa tidak klaster hierarki (misalnya Ward)? ★★★

> "Ada tiga alasan. Pertama, K-Means langsung meminimumkan WCSS, yaitu kriteria yang sama dengan yang saya baca di metode *elbow*. Kedua, dengan 5.001 rumah tangga, dendrogram tidak dapat dibaca untuk menentukan jumlah kelompok. Ketiga, Pasaribu dan kawan-kawan pada data indikator sosial ekonomi BPS menemukan K-Means menghasilkan pengelompokan yang lebih rinci daripada metode hierarki. Perbandingan langsung dengan metode hierarki belum saya lakukan."

| Bukti | 2.2 Tabel 1 (Pasaribu et al., 2024); Bab II K-Means (Pers. 2.4) |
|---|---|
| Status | "Penggabungan pada metode hierarki tidak dapat dibatalkan" dan "Ward juga meminimumkan pertambahan WCSS" = `[PERLU VERIFIKASI]` (Everitt et al., 2011; Johnson & Wichern, 2014). Sebelum dicek, jangan sebut nama buku |
| Hindari | Alasan komputasi (lihat C1) |

### C4 · *Silhouette* 0,3640 lemah. Kenapa tetap dua klaster? ★★★

> "Saya tidak menyembunyikan bahwa strukturnya lemah. Nilai 0,3640 berada di antara ambang 0,2 dan 0,5 dari Kaufman dan Rousseeuw, artinya struktur nyata tetapi lemah. Dua klaster tetap dipilih karena *elbow* menunjuk rentang dua sampai tiga dan *silhouette* tertinggi ada pada dua klaster. Lemahnya struktur saya jelaskan dengan Gambar 12: rumah tangga tersebar menerus di satu sumbu tanpa celah. Karena itu hasilnya saya baca sebagai perbedaan kecenderungan, bukan penggolongan tegas, dan itu tertulis di kesimpulan."

| Bukti | 4.2 (Tabel 4; Gambar 9, 10, 12); Bab II *silhouette*; 5.1 butir kedua |
|---|---|
| Sumber | Kaufman & Rousseeuw (1990, dalam Everitt et al., 2011) `[TERVERIFIKASI]` |

### C5 · Dua klaster terlalu kasar untuk kebijakan. Kenapa tidak tiga? ★★★

> "Tiga klaster sudah saya evaluasi: *silhouette*-nya 0,3149, lebih rendah dari 0,3640. Aturan penetapan di Bab III mengutamakan konfigurasi dengan *silhouette* tertinggi bila *elbow* menunjuk rentang. Pada Lampiran 1, tiga klaster juga tidak memperkuat hubungan dengan AC secara berarti: Cramér's V 0,5567 berbanding 0,5530. Karena rumah tangga tersebar menerus, menambah klaster pada dasarnya memotong sumbu yang sama menjadi lebih banyak segmen. Untuk saran yang saya ajukan, yaitu membedakan sasaran kelompok konsumsi tinggi dan rendah, dua kelompok sudah memadai."

| Bukti | Tabel 4; 3.4 Penentuan Jumlah Klaster; Lampiran 1 baris 18 |
|---|---|
| Status | "Memotong sumbu yang sama" = `[PENALARAN]` dari Gambar 12; profil K = 3 tidak dibuat |
| Hindari | Menyebut isi profil tiga klaster (tidak pernah dihitung) |

### C6 · *Elbow* subjektif. Kenapa tidak *gap statistic*, Calinski–Harabasz, atau Davies–Bouldin? ★★★

> "Saya memakai dua kriteria yang saling melengkapi: *elbow* membaca kekompakan, *silhouette* membaca kekompakan sekaligus keterpisahan, dan keduanya menunjuk arah yang sama. Hassan dan kawan-kawan membandingkan tujuh teknik, termasuk *gap statistic*, Calinski–Harabasz, dan Davies–Bouldin, dan tidak ada satu teknik yang selalu tepat pada semua data. Sebagai tambahan, indeks Calinski–Harabasz dapat dihitung langsung dari WCSS pada Tabel 4, dan nilainya juga tertinggi pada dua klaster."

| Bukti | Bab II Penentuan Jumlah Klaster (Hassan et al., 2021; Rousseeuw, 1987); Tabel 4 |
|---|---|
| Calinski–Harabasz (hitung dari Tabel 4) | K = 2: 3.516 · K = 3: 3.199 · K = 4: 2.993 · K = 5: 2.786 · K = 6: 2.601 · K = 7: 2.496 · K = 8: 2.403 → tertinggi K = 2. Rumus: [(15.000 − WCSS)/(K − 1)] / [WCSS/(5.001 − K)] (Hassan et al., 2021, Pers. 8–10) |
| ⚠️ Verifikasi sebelum diucapkan | Jalankan di R sesudah script utama: `ch <- ((15000 - evaluasi_k$wss)/(evaluasi_k$k - 1)) / (evaluasi_k$wss/(nrow(x) - evaluasi_k$k)); print(round(ch, 1))` |
| ⚠️ Jebakan dari sumbermu sendiri | Pada data *benchmark* UCI, Hassan et al. (2021) melaporkan ketepatan *silhouette* hanya 14,29%, *elbow* 42,86%, Calinski–Harabasz 71,43%. Bila Pak Azka mengutipnya: "Benar, Pak. Ketepatan itu diukur terhadap label kelas yang sudah diketahui pada tujuh data *benchmark*, dan hasilnya berbeda antardata; pada data simulasi, *silhouette*, Calinski–Harabasz, dan Davies–Bouldin sama-sama 42,86%. Kesimpulan Hassan sendiri menyatakan ketujuh teknik memberi hasil yang diharapkan pada data kecil. Karena itu saya tidak bersandar pada satu kriteria, dan pada data saya Calinski–Harabasz juga menunjuk dua klaster." |

### C7 · AC dipakai memilih spesifikasi lalu diuji lagi. Sirkular? ★★★

> "Benar, Pak/Bu, dan itu saya akui di Bab III dan Bab IV. Karena itu bukti dari AC saya sebut tidak sepenuhnya bebas. Bukti yang sepenuhnya bebas datang dari lemari es dan luas lantai, yang tidak dipakai pada tahap mana pun sebelum *profiling*, dan keduanya searah dengan hipotesis. Luas lantai memberi dukungan paling tegas: rata-rata 42,52 berbanding 106,17 meter persegi, median 30 berbanding 80, signifikan pada uji berbasis desain."

| Bukti | 3.4 (paragraf pemilihan spesifikasi dan *profiling*); 4.3 paragraf keputusan hipotesis; Tabel 8–9 |
|---|---|
| Hindari | Membantah bahwa ada sirkularitas |

### C8 · Klaster tanpa penimbang, profil tertimbang: klaster ini mewakili sampel atau populasi? ★★★

> "Pembentukan klaster bersifat eksploratif, yaitu mencari kemiripan antarrumah tangga, sehingga dijalankan pada rumah tangga sampel tanpa penimbang. Aturan keanggotaannya, yaitu masuk ke pusat terdekat, berlaku untuk rumah tangga mana pun. Penimbang dipakai pada tahap pelaporan komposisi dan profil agar angkanya menggambarkan rumah tangga DKI Jakarta. Pengujian juga dilakukan dalam dua versi, dan kesimpulan untuk AC, lemari es, dan luas lantai sama pada keduanya. Saya akui pusat klaster ditentukan sampel, sehingga cara memasukkan desain sampel ke tahap pengelompokan saya tuliskan sebagai saran penelitian lanjutan."

| Bukti | 1.4 (paragraf pertama); 3.4 *Profiling*; 4.2 (Jain, 2010); Tabel 9; 5.2 |
|---|---|
| Sumber | Jain (2010) `[PERLU VERIFIKASI]`; Lumley & Scott (2012) |
| Jika didesak "pusatnya bias?" | "Karena Klaster 2 terwakili lebih kecil dalam sampel (33,43% sampel vs 39,89% tertimbang), K-Means tertimbang kemungkinan menggeser pusat. Besarnya belum saya periksa." `[PENALARAN]` |

### C9 · Struktur lemah. Kenapa tidak GMM, *fuzzy*, atau *latent class*? ★★

> "Saya setuju bahwa struktur yang lemah membuka ruang bagi metode yang tidak memaksakan batas tegas, dan itu saya tulis sebagai saran penelitian selanjutnya. Untuk tujuan penelitian ini, yaitu memetakan kelompok untuk penyasaran kebijakan, K-Means sudah memenuhi syarat sahih: variabelnya numerik, sudah distandardisasi, dan hasilnya diperiksa dengan dua kriteria serta diuji pada penciri."

| Bukti | 5.2 saran penelitian kedua |
|---|---|
| Hindari | Mengklaim metode lain "pasti lebih baik" atau "pasti sama" |

### C10 · Kenapa *winsorizing* persentil 1–99, bukan membuang pencilan atau batas lain? ★★

> "*Winsorizing* menahan pengaruh nilai ekstrem tanpa membuang rumah tangga, sehingga jumlah data tetap 5.001. Pentingnya bagi K-Means karena kriteria jumlah kuadrat memberi bobot besar pada pengamatan yang jauh. Hasilnya pun tidak sensitif terhadap perlakuan ini: dengan dan tanpa *winsorizing*, *silhouette* 0,3640 dan 0,3627, klaster terkecil 33,43 dan 33,15 persen."

| Bukti | 3.4 Persiapan Data (Dixon, 1960; Mair & Wilcox, 2020; Everitt et al., 2011); Lampiran 1 baris 17 vs 21 |
|---|---|
| Jika ditanya "kenapa 1 dan 99, bukan 5 dan 95?" | "Batas lain tidak saya uji. Karena ada atau tidaknya *winsorizing* hampir tidak mengubah hasil, pergeseran batas kemungkinan besar juga tidak mengubah kesimpulan, tetapi itu belum saya periksa." |

### C11 · Kenapa ln(1 + x) kalau tidak ada nilai nol? ★★

> "Setelah *winsorizing*, nilai terkecil memang positif, 37,38 kWh dan Rp618.667, jadi ln biasa pun terdefinisi. Pada besaran sebesar itu, ln(1 + x) dan ln(x) praktis sama; selisih terbesarnya sekitar 0,026 pada konsumsi listrik, dan setelah standardisasi tidak mengubah jarak secara berarti. Fungsinya sama, yaitu memampatkan nilai besar pada sebaran yang menceng ke kanan."

| Bukti | 3.4 Persiapan Data (revisi Sesi BB); awal Bab IV (rentang setelah *winsorizing*) |
|---|---|
| Angka (hitung) | ln(1 + 1/37,38) = 0,026 |

### C12 · Kenapa *Z-score*, bukan *min-max*? ★★

> "Everitt dan kawan-kawan menyebut standardisasi ke ragam satu sebagai solusi yang paling sering disarankan bila variabel kontinu bersatuan berbeda. *Min-max* bergantung pada dua nilai paling ekstrem, sehingga rentangnya mudah digeser oleh pencilan."

| Bukti | Bab II Ukuran Kemiripan dan Standardisasi (Everitt et al., 2011) `[TERVERIFIKASI]` |
|---|---|
| ⚠️ Jebakan | Di literatur ada temuan bahwa standardisasi dengan rentang dapat lebih baik daripada *Z-score* untuk pemulihan klaster (Milligan & Cooper, 1988, yang dibahas Everitt et al., 2011, bab ukuran kedekatan) `[PERLU VERIFIKASI]`. Cek dulu. Bila Pak Azka menyebutnya: "Terima kasih, Pak. Perbandingan itu belum saya uji. Setelah *winsorizing* dan logaritma, rentang tidak lagi ditentukan pencilan ekstrem, sehingga perbedaannya kemungkinan kecil, tetapi itu belum saya periksa." |
| Status "min-max mudah digeser pencilan" | `[PENALARAN]` |

### C13 · Stabilitas klaster sudah diuji? ★★

> "Ada empat pemeriksaan. K-Means final dijalankan dengan 100 inisialisasi acak dan dipilih WCSS terendah. Hasilnya hampir sama dengan dan tanpa *winsorizing*. Spesifikasi alternatif di Lampiran 1 menunjuk dua klaster juga. Pembanding K-Medoids memilih dua klaster dengan 84 persen rumah tangga di klaster yang sama. Uji stabilitas formal seperti *bootstrap* belum saya lakukan."

| Bukti | 3.4 Pengelompokan K-Means (Everitt et al., 2011); Lampiran 1; output K-Medoids (lisan saja) |
|---|---|

### C14 · Algoritme di R itu MacQueen atau Hartigan–Wong? Peringatan Quick-TRANSfer itu apa? ★★

> "Fungsi `kmeans` di R secara bawaan memakai algoritme Hartigan–Wong. Langkah yang saya tulis di Bab II adalah gambaran umum K-Means. Keduanya meminimumkan WCSS yang sama; Hartigan–Wong hanya cara memindahkan titik yang lebih teliti. Peringatan Quick-TRANSfer muncul pada sebagian titik awal acak, sedangkan solusi final yang dipilih berstatus konvergen, kode galat nol."

| Bukti | Script blok 14 (`[CEK] ifault kmeans: 0`) |
|---|---|
| Status | `[PERLU VERIFIKASI]`: buka `?kmeans` di R, pastikan *default* `algorithm = "Hartigan-Wong"` |

### C15 · PCA untuk apa? Kenapa batas klaster di Gambar 12 lurus tegak? ★★

> "PCA hanya untuk menampilkan data tiga dimensi di bidang datar, bukan untuk membentuk klaster; dua komponen menjelaskan 89,31 persen keragaman. Batasnya tegak lurus karena K-Means dua klaster membelah ruang dengan satu bidang datar di tengah-tengah kedua pusat, dan kedua pusat itu berada di sumbu komponen pertama (−0,7887 dan 1,5703), dengan komponen kedua hampir nol."

| Bukti | 4.2 (Tabel 6; Gambar 12); Bab II Analisis Komponen Utama untuk Visualisasi Klaster |
|---|---|

### C16 · Kenapa titik di Gambar 12 membentuk garis-garis miring? ★

> "Karena lama sekolah KRT bernilai diskret, yaitu 0, 6, 9, 12, 14, 15, 16, dan 18 tahun. Rumah tangga dengan lama sekolah yang sama berjajar membentuk pita."

| Bukti | 3.4 Persiapan Data (tabel konversi lama sekolah) |
|---|---|

### C17 · `nstart` 50 saat evaluasi, 100 saat final. Kenapa berbeda? ★

> "Evaluasi dijalankan untuk delapan nilai K, jadi 50 inisialisasi per K sudah cukup untuk membandingkan. Model final ditambah menjadi 100 untuk kepastian solusi terbaik. *Silhouette* model final tetap 0,3640, sama dengan tahap evaluasi."

| Bukti | Script blok 13–14; output konsol |
|---|---|

---

## D. HASIL DAN INTERPRETASI

### D1 · Tidak punya AC belum tentu kekurangan pendinginan ★★★

> "Setuju, Pak/Bu. Karena itu saya menyebutnya indikasi, bukan pengukuran. Indikasi itu dibaca dari dua hal: lebih dari empat dari lima rumah tangga Klaster 1 tidak memiliki AC, dan kapasitas ekonominya kurang dari seperempat Klaster 2. Paparan suhu pada tingkat rumah tangga tidak diukur, dan itu tertulis di ruang lingkup, keterbatasan, dan kesimpulan."

| Bukti | 3.1; 4.3 paragraf terakhir; 5.1 butir ketiga (Pavanello et al., 2021) |
|---|---|

### D2 · Kenapa variabel pembentuk tidak diuji beda? ★★

> "Karena klaster dibentuk justru untuk memisahkan rumah tangga pada variabel itu, ujinya pasti signifikan dan tidak membuktikan apa pun. Everitt dan kawan-kawan mengingatkan bahwa uji baku seperti analisis ragam tidak tepat dipakai untuk membandingkan variabel pembentuk. Bukti dicari pada penciri yang tidak dilihat algoritme."

| Bukti | Bab II *Profiling* Klaster; 3.4; 2.4 (Everitt et al., 2011) `[TERVERIFIKASI]` |
|---|---|

### D3 · Pangsa listrik ~7% di kedua klaster. Artinya apa? ★★

> "Kedua kelompok membelanjakan porsi yang kurang lebih sama dari pengeluaran nonmakanannya untuk listrik, 7,05 dan 7,63 persen. Jadi perbedaannya ada pada besarnya anggaran, bukan porsinya: anggaran nonmakanan Klaster 2 sekitar 4,3 kali Klaster 1."

| Bukti | Tabel 7; 4.3 |
|---|---|

### D4 · Rata-rata tertimbang 369,61 vs sampel 327,45. Kenapa berbeda? ★★

> "Rata-rata tertimbang lebih tinggi karena rumah tangga berkonsumsi besar memiliki bobot lebih besar dalam populasi daripada porsinya dalam sampel. Hal yang sama terlihat pada komposisi klaster: Klaster 2 33,43 persen dalam sampel tetapi 39,89 persen setelah ditimbang. Untuk menggambarkan provinsi, angka tertimbang yang dipakai."

| Bukti | 4.1 (Tabel 3); 4.2 (Tabel 5) |
|---|---|

### D5 · Klaster 1 "konsumsi rendah" padahal rata-ratanya 186 kWh. Rendah menurut ukuran apa? ★★

> "Rendah secara relatif terhadap Klaster 2 dan terhadap rata-rata seluruh rumah tangga: ketiga *centroid* Klaster 1 berada di bawah nol pada skala *Z-score*. Penamaannya deskriptif dan tidak menyiratkan urutan nilai, sebagaimana saya tulis di akhir profil klaster."

| Bukti | Tabel 5; Gambar 11; 4.3 paragraf penamaan |
|---|---|

### D6 · Kalau pakai K-Medoids, komposisinya 43/57. Mana yang benar? ★★ (hanya bila C1 muncul)

> "Keduanya sah sebagai potongan, Pak. Rumah tangga tersebar menerus tanpa batas alami, terlihat dari *silhouette* yang lemah dan Gambar 12. Persentase pasti tiap klaster bergantung pada aturan pembagiannya: K-Means memakai rata-rata yang tertarik ke ujung atas, K-Medoids memakai rumah tangga nyata di tengah. Yang konsisten di kedua metode adalah jumlah klaster, urutannya pada satu sumbu, dan arah perbedaan penciri. Itu sebabnya di kesimpulan saya membaca kedua klaster sebagai pembagian atas sebaran yang menerus."

| Catatan revisi pascasidang | Frasa "sekitar dua dari setiap lima rumah tangga" di 4.3 dan 5.2 bergantung pada metode; pertimbangkan ditambah "pada pembagian *K-Means*". **Jangan diubah sebelum sidang** |
|---|---|

---

## E. UJI HIPOTESIS DAN PENIMBANG

### E1 · Kenapa Kruskal–Wallis dan *chi-square* Rao–Scott, bukan ANOVA atau uji t? ★★★

> "Luas lantai dan ukuran rumah tangga menceng ke kanan, sehingga saya memakai uji berbasis peringkat Kruskal–Wallis yang tidak mengandaikan kenormalan. AC, lemari es, dan golongan daya kategorik, sehingga memakai uji independensi *chi-square*. Karena rumah tangga Susenas terkumpul dalam PSU dan strata, statistik *chi-square* Pearson tidak lagi berdistribusi *chi-square*, sehingga versi berbasis desain memakai koreksi Rao–Scott. Untuk peringkat, versi berbasis desainnya mengikuti Lumley dan Scott, yang mengganti peringkat sampel dengan dugaan peringkat populasi."

| Bukti | Bab II Pengujian Hipotesis (Pers. 2.9–2.12); 3.4 *Profiling* dan Uji Perbedaan |
|---|---|
| Sumber | Kruskal & Wallis (1952); Rao & Scott (1984) `[PERLU VERIFIKASI]`; Lumley & Scott (2012) |
| Hindari | Kata "estimasi peringkat"; pakai "dugaan peringkat" |

### E2 · Derajat bebas 505 dan 506 dari mana? ★★

> "Derajat bebas desain adalah banyaknya PSU dikurangi banyaknya strata, 512 dikurangi 6 sama dengan 506; itu yang dipakai uji F Rao–Scott sebagai penyebut. Uji Kruskal–Wallis berbasis desain dijalankan sebagai regresi atas peringkat, sehingga derajat bebasnya dikurangi satu lagi menjadi 505."

| Bukti | 3.4 (revisi Sesi BB); Tabel 9 |
|---|---|
| Sumber | Lumley (2024) `[PERLU VERIFIKASI]` — cek `survey:::svyranktest.survey.design` |

### E3 · Cramér's V tanpa penimbang, padahal ujinya tertimbang. Konsisten? ★★

> "Keputusan signifikansi diambil dari uji berbasis desain. Cramér's V hanya dipakai untuk mengurutkan kekuatan hubungan antarpenciri pada sampel yang sama, tidak dibandingkan dengan ambang tertentu. Urutannya juga sejalan dengan selisih persentase tertimbang di Tabel 8: AC paling kuat, lalu golongan daya, lalu lemari es."

| Bukti | 3.4 (paragraf *Cramér's V*); Tabel 8–9 (Bergsma, 2013) |
|---|---|

### E4 · Asumsi Kruskal–Wallis (bentuk sebaran serupa) sudah dicek? ★★

> "Tidak saya uji secara formal. Secara deskriptif, luas lantai pada kedua klaster sama-sama menceng ke kanan, terlihat dari rata-rata yang lebih besar dari median pada keduanya. Keputusan hipotesis juga bersandar pada versi berbasis desain, dan selisih pada luas lantai sangat besar, sehingga kesimpulannya tidak bergantung pada asumsi itu."

| Bukti | Tabel 8 (42,52 vs median 30; 106,17 vs median 80); Tabel 9 |
|---|---|
| Status | Kalimat terakhir = `[PENALARAN]` |

### E5 · Ukuran RT tidak signifikan. Apa artinya? ★★

> "Setelah desain sampel diperhitungkan, ukuran rumah tangga tidak berbeda antarklaster, *p* = 0,362, dan selisihnya hanya 0,06 orang. Uji tanpa penimbang signifikan karena memperlakukan 5.001 rumah tangga sebagai saling bebas, padahal mereka terkumpul dalam 512 PSU. Artinya, perbedaan konsumsi antarklaster tidak bersumber dari jumlah penghuni, dan itu sejalan dengan konsumsi per kapita yang tetap berbeda sekitar 3,31 kali."

| Bukti | 4.3; Tabel 7–9 |
|---|---|

### E6 · Golongan daya kenapa hanya deskriptif? ★★

> "Golongan daya dipakai untuk menetapkan tarif konversi, jadi ikut menentukan nilai konsumsi listrik yang menjadi variabel pembentuk. Karena tidak bebas dari proses pembentukan klaster, golongan daya saya laporkan sebagai deskripsi karakteristik kelistrikan, bukan bukti."

| Bukti | 3.3; 3.4; 4.3 paragraf golongan daya |
|---|---|

### E7 · Kenapa taraf nyata 1%, bukan 5%? ★

> "Dengan 5.001 rumah tangga, selisih kecil pun mudah signifikan, sehingga saya memakai taraf yang lebih ketat. Kesimpulannya juga tidak bergantung pada pilihan itu: seluruh *p-value* untuk ketiga variabel hipotesis di bawah 0,001."

| Bukti | Tabel 9 |
|---|---|
| Status | Alasan "selisih kecil mudah signifikan" = `[PENALARAN]`; cek apakah alasannya tertulis di `.docx` |

---

## F. KESIMPULAN DAN SARAN

### F1 · Bagaimana PLN atau Pemprov memakai hasil ini secara praktis? ★★

> "Programnya dibedakan per kelompok. Untuk kelompok konsumsi tinggi, yang tiga dari empat rumah tangganya memiliki AC, intervensi diarahkan pada efisiensi peralatan pendingin dan peralatan berdaya besar. Untuk kelompok konsumsi rendah, penghematan bukan sasaran yang wajar. Luas lantai dan kepemilikan AC berbeda tajam dan mudah diamati, sehingga dapat dipertimbangkan sebagai penanda sasaran yang lebih praktis daripada data pengeluaran."

| Bukti | 5.2 saran pertama |
|---|---|

### F2 · Kesimpulan berlaku untuk siapa? ★★

> "Untuk rumah tangga bermeteran PLN di DKI Jakarta pada Maret 2025, pada satu titik waktu. Tidak untuk rumah tangga tanpa meteran atau non-PLN, dan tidak menjelaskan perubahan antarwaktu."

| Bukti | 1.4 (paragraf 78 RT dan *cross-section*) |
|---|---|

### F3 · Kenapa saran untuk BPS soal isian kWh penting? ★

> "Karena seluruh asumsi tarif dalam penelitian ini muncul akibat isian kWh yang kosong. Bila isian itu terisi, konsumsi listrik dapat dianalisis langsung pada besaran fisiknya."

| Bukti | 5.2 saran kedua |
|---|---|

### F4 · Golongan daya sebagai indikator penyasaran? ★

> Sudah dibuang pada Sesi BB. **Pastikan kalimat Saran PLN di `.docx` tidak lagi menyebut golongan daya.** Bila masih ada: "Terima kasih, Pak/Bu, itu tidak konsisten dengan pembacaan saya di 4.3 dan akan saya perbaiki."

---

## G. LAIN-LAIN

### G1 · Script menjalankan MANOVA dan analisis diskriminan. Kenapa tidak ada di naskah? ★★

> "Analisis itu saya jalankan saat eksplorasi, tetapi tidak menjawab tujuan mana pun. MANOVA atas variabel pembentuk akan menguji perbedaan yang sudah pasti ada karena klaster dibentuk dari variabel itu, sama seperti peringatan Everitt tentang analisis ragam. Analisis diskriminan atas variabel pembentuk hanya akan mengulang aturan K-Means. Pendalaman analisis saya wujudkan lewat uji pada variabel penciri dan visualisasi komponen utama."

| Bukti | Script blok 19–20; Bab II *Profiling* (Everitt et al., 2011) |
|---|---|
| Status | "Analisis diskriminan mengulang aturan K-Means" = `[PENALARAN]` |

### G2 · Naskah lebih dari 100 halaman ★★

> "Bab I sampai Bab V sekitar 108 halaman, termasuk dua halaman kosong untuk awal bab di halaman ganjil. Penambahan terutama berasal dari landasan teori untuk setiap metode yang dipakai di Bab III dan IV. Saya siap memangkasnya pada revisi tanpa mengubah alur tujuan, metode, hasil, dan kesimpulan."

| Bukti | Progress BC (halaman mulai tiap bab) |
|---|---|

### G3 · Kaufman & Rousseeuw dikutip lewat Everitt. Sudah baca aslinya? ★

> "Belum, Pak/Bu. Karena itu saya menuliskannya sebagai kutipan dari kutipan, yaitu Kaufman dan Rousseeuw dalam Everitt dan kawan-kawan."

### G4 · Gambar 2 dibuat bagaimana? ★

> "Datanya dari publikasi BPS 2025a, rata-rata pengeluaran listrik per kapita menurut provinsi, lalu saya olah menjadi grafik."

| ⚠️ | Script Gambar 2 tidak ada di repo (`Script R Gambar Bab I.R` hanya Gambar 1, 3, 4). Bila diminta datanya, tunjukkan tabel BPS sumbernya |
|---|---|

---

## I. TAMBAHAN SESI BE (13 OKTOBER MALAM)

Pertanyaan baru dari pemeriksaan PDF paparan dan latihan naskah ucapan. Belum ada di bagian A–G.

### I1 · Susenas Maret 2025 bertepatan dengan diskon listrik 50 persen. Sudah dikoreksi? ★★

> "Benar, Pak. Pencacahan Susenas Maret 2025 berlangsung pada Februari 2025, bersamaan dengan diskon tarif 50 persen bagi rumah tangga sampai 2.200 VA pada Januari–Februari 2025. Konversi saya memakai tarif normal dan belum mengoreksi diskon itu, karena Susenas tidak mencatat apakah pengeluaran listrik yang dilaporkan sudah terdiskon. Bila sudah terdiskon, konsumsi rumah tangga sampai 2.200 VA tercatat lebih rendah daripada sebenarnya, dan hal ini saya catat sebagai keterbatasan untuk revisi."

| Bukti | **Tidak ada di naskah.** Pencacahan 8–27 Februari 2025 (BPS Kabupaten Lahat, berita 19 Feb 2025); diskon 50% Januari–Februari 2025 untuk 450–2.200 VA (Kepmen ESDM 348.K/TL.01/MEM.L/2024, via pemberitaan) |
|---|---|
| Status | Fakta diskon dan tanggal pencacahan `[PERLU VERIFIKASI]` ke Kepmen dan pedoman Susenas · arah bias `[PENALARAN]` |
| Jangan | Mengangkat sendiri saat paparan · mengklaim "pasti terdiskon" atau "pasti tidak terdiskon" |
| Bila didesak "lalu hasilnya salah?" | "Ketiga penciri, yaitu AC, lemari es, dan luas lantai, diukur langsung dari kuesioner, dan dua dari tiga variabel pembentuk, yaitu pengeluaran nonmakanan dan lama sekolah, tidak bergantung pada konversi tarif. Yang terdampak terutama besaran kWh dan posisi rumah tangga yang berada di perbatasan klaster; besarnya belum saya periksa." `[PENALARAN]` |
| Revisi pascasidang | Tambahkan ke Keterbatasan (1.4) |

### I2 · Kalau pemisahannya hanya di satu sumbu, kenapa tidak dipotong saja di median pengeluaran? ★★★

> "Batasnya ditentukan selisih ketiga *centroid* sekaligus, yaitu 1,36; 1,53; dan 1,18 simpangan baku, bukan satu variabel yang saya pilih. Titik potongnya juga ditentukan data, bukan kuantil yang saya tetapkan di awal. Rumah tangga yang konsumsinya tinggi tetapi pengeluarannya rendah tidak akan tertangkap oleh pembagian satu variabel. Saya akui, karena strukturnya lemah, hasilnya mendekati pemotongan satu indeks gabungan, dan itu sebabnya saya membacanya sebagai perbedaan kecenderungan."

| Bukti | 4.2 (jarak *centroid*; Tabel 6; Gambar 12); 5.1 butir kedua |
|---|---|
| Status | `[PENALARAN]` |
| Hindari | "K-Means pasti lebih baik daripada kuantil" |

### I3 · Ambang asli Kaufman–Rousseeuw itu 0,25/0,50/0,70, bukan 0,2/0,5 ★★

> "Saya mengikuti ambang sebagaimana dikutip Everitt dan kawan-kawan. Pada tabel asli pun, 0,3640 jatuh di kelas struktur lemah yang bisa saja artifisial. Karena itu saya tidak berhenti di *silhouette*, tetapi menguji variabel penciri di luar pembentuk untuk melihat apakah pembagian itu bermakna, dan luas lantai serta lemari es berbeda signifikan."

| Bukti | Bab II *silhouette*; Tabel 9 |
|---|---|
| Status | Ambang tabel asli (0,71–1 kuat; 0,51–0,70 wajar; 0,26–0,50 lemah, bisa artifisial; ≤ 0,25 tidak ada struktur berarti) `[PERLU VERIFIKASI]`: dari ingatan Claude, buku aslinya belum dipegang. Lihat juga G3 |

### I4 · Simpangan baku lebih besar daripada rata-rata. Apa artinya? ★★★

> "Konsumsi listrik tidak mungkin negatif. Kalau sebarannya simetris, rata-rata dikurangi satu simpangan baku menjadi minus 26 kWh, yang mustahil. Jadi sebarannya melebar ke kanan: sebagian besar rumah tangga berkonsumsi rendah, dan segelintir rumah tangga berkonsumsi sangat tinggi menarik rata-rata ke atas. Itu juga sebabnya median sampel 222,19 kWh jauh di bawah rata-rata 327,45 kWh, dan sebabnya data saya transformasi logaritma sebelum pengelompokan."

| Bukti | Tabel 3; Gambar 7; 3.4 Persiapan Data |
|---|---|
| Angka (hitung) | 327,45 − 353,88 = −26,43 · koefisien variasi: listrik 353,88/327,45 = 1,08; nonmakanan 5.918.258/4.654.809 = 1,27 |
| Analogi untuk diri sendiri | Sembilan orang bergaji Rp5 juta dan satu orang Rp100 juta: rata-rata Rp14,5 juta, median Rp5 juta |

### I5 · "Timpang" diukur dengan apa? Gini? ★★

> "Yang saya maksud timpang adalah sebarannya sangat lebar dan menceng ke kanan, terlihat dari simpangan baku yang melampaui rata-rata dan median yang jauh di bawah rata-rata. Ukuran ketimpangan formal seperti indeks Gini tidak saya hitung."

| Bukti | Tabel 3; 5.1 butir pertama |
|---|---|
| Revisi pascasidang | Pertimbangkan "sebaran lebar dan menceng" menggantikan "timpang" bila penguji meminta |

### I6 · Komponen utama: arti skor minus, arti sumbu tegak, arti berimpit ★★★

> "Data sudah distandardisasi, jadi nol adalah rata-rata seluruh rumah tangga sampel; skor minus berarti di bawah rata-rata. Komponen pertama memuat ketiga variabel dengan tanda positif, jadi makin ke kanan ketiganya sama-sama makin tinggi. Komponen kedua membandingkan konsumsi listrik dengan lama sekolah: makin ke atas, konsumsi listriknya relatif tinggi dibanding pendidikan KRT-nya. Kedua pusat klaster berimpit di sekitar nol pada komponen kedua, artinya kedua klaster berbeda tingkat, bukan berbeda pola."

| Butir | Isi |
|---|---|
| KU1 | Muatan 0,5822 · 0,6397 · 0,5018 (semua positif) → tingkat konsumsi dan sosial ekonomi. Pendidikan **tidak** turun di KU1 |
| KU2 | Muatan 0,5566 · 0,1363 · −0,8195 → selisih berbobot listrik vs lama sekolah, **bukan rasio**. Atas = listrik tinggi relatif terhadap pendidikan; bawah = pendidikan tinggi relatif terhadap listrik |
| Berimpit | *Centroid* KU2 0,0002 dan −0,0004 → keseimbangan listrik–pendidikan sama pada kedua klaster; pemisahan hanya di KU1 |
| Analogi untuk diri sendiri | KU1 = nilai total dua mata pelajaran; KU2 = condong ke mata pelajaran mana. Klaster 1 dan 2 berbeda nilai total, tetapi sama-sama seimbang |
| Bukti | Tabel 6; Gambar 12; 4.2 |

### I7 · Kenapa pusat KU1 −0,79 dan 1,57, tidak simetris? ★

> "Rata-rata seluruh skor komponen utama sama dengan nol, jadi klaster yang lebih besar duduk lebih dekat ke nol. Tiga ribu tiga ratus dua puluh sembilan kali minus 0,7887 ditambah seribu enam ratus tujuh puluh dua kali 1,5703 hasilnya hampir nol."

| Angka (hitung) | 3.329 × (−0,7887) + 1.672 × 1,5703 = −2.625,6 + 2.625,5 ≈ 0 |
|---|---|

### I8 · WCSS satu klaster tepat 15.000. Dari mana? ★

> "Setiap variabel terstandardisasi memiliki jumlah kuadrat simpangan sebesar n dikurangi satu, yaitu 5.000. Dengan tiga variabel, totalnya 15.000. Jadi angka ini sekaligus tanda bahwa standardisasi berjalan benar."

| Status | `[PENALARAN]`: *Z-score* dengan penyebut n − 1 (fungsi `scale` di R) |
|---|---|

### I9 · Dua kelompok kok memakai Kruskal–Wallis, bukan Mann–Whitney? ★★

> "Untuk dua kelompok, Kruskal–Wallis setara dengan uji Mann–Whitney atau Wilcoxon *rank-sum*, jadi kesimpulannya sama. Saya memakai Kruskal–Wallis karena rumusan metode di Bab III berlaku untuk jumlah klaster berapa pun, sebelum jumlah klaster ditentukan."

| Status | Kesetaraan untuk dua kelompok `[PERLU VERIFIKASI]` (Kruskal & Wallis, 1952) |
|---|---|

### I10 · Cramér's V untuk tabel 2 × 2? ★

> "Untuk tabel dua kali dua, Cramér's V sama dengan nilai mutlak koefisien phi. Saya memakainya untuk mengurutkan kekuatan hubungan antarpenciri, bukan dibandingkan dengan ambang tertentu."

| Status | `[PENALARAN]` dari rumus V = √(χ² / (n(min(K, J) − 1))) dengan min = 2 |
|---|---|

### I11 · Maksud saran untuk penelitian selanjutnya? ★★

> "Setiap saran berangkat dari satu keterbatasan. Konsumsi listrik saya peroleh dari konversi tarif, jadi penelitian berikutnya lebih kuat bila memakai kWh hasil pencatatan meteran. Struktur klaster saya lemah dan sebarannya menerus, sehingga metode yang memberi derajat keanggotaan lebih sesuai untuk rumah tangga di perbatasan. Klaster saya dibentuk tanpa penimbang, sehingga penelitian berikutnya dapat memasukkan desain sampel sejak tahap pengelompokan."

| Saran | Kelemahan asal | Contoh bila ditanya lebih lanjut |
|---|---|---|
| Data meteran | kWh = pengeluaran ÷ tarif; 40,87% RT 450 VA melampaui kapasitas | Data kWh tercatat PLN |
| Batas tidak tegas | Setiap RT 100% di satu klaster; *silhouette* 0,3640 | *Fuzzy C-Means*, *Gaussian Mixture Model* (lihat C9) |
| Desain sampel | Klaster 2: 33,43% sampel vs 39,89% tertimbang | *K-Means* tertimbang (lihat C8) |

---

## J. PERTANYAAN DARI CATATAN RAFLI

*(Diisi pada Sesi BE setelah Rafli mengirim rekap pertanyaannya.)*

---

## H. DAFTAR CEK SEBELUM SELASA 13 OKTOBER

| # | Cek | Untuk |
|---|---|---|
| 1 | `?kmeans` di R: *default* Hartigan–Wong | C14 |
| 2 | Hitung Calinski–Harabasz di R (baris kode di C6) | C6 |
| 3 | Everitt et al. (2011) bab ukuran kedekatan: Mahalanobis dan Milligan & Cooper | C2, C12 |
| 4 | Everitt / Johnson & Wichern: penggabungan hierarki tidak dapat dibatalkan; Ward | C3 |
| 5 | Kuesioner KP: kode 233 = isian kWh? | B10 |
| 6 | Kuesioner KOR: isi R615; output `06_…` kolom `sumber_pendidikan` | B9 |
| 7 | `.docx`: Saran PLN tanpa golongan daya; alasan taraf 1% | F4, E7 |
| 8 | Sumber `[PERLU VERIFIKASI]` lama dari Progress BB: Johnson & Wichern, Mair & Wilcox, Jain, Fisher, Rao & Scott, Lumley (2024) | Seluruh bagian |
