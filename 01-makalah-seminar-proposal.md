# Klasifikasi Rumah Tangga Berdasarkan Pola Konsumsi Listrik dan Karakteristik Sosial Ekonomi Di DKI Jakarta Tahun 2025

> *Sumber berkas:* `Makalah_Seminar_Proposal_Rafli_Hibriansyah_S_Revisi_Pasca_Sempro.docx`
> *Header dokumen (berulang tiap halaman):* Makalah Seminar Proposal Tugas Akhir – Program Studi D-III Statistika
> *Footer dokumen:* nomor halaman (Page N)

**Rafli Hibriansyah Siregar<sup>1\*</sup>, Dr. Fitri Kartiasih, S.ST, S.E, M.Si.<sup>2</sup>**

*<sup>1</sup>112313326, 3D33, Program Studi D-III Statistika, Politeknik Statistika STIS*

*<sup>2</sup>Afiliasi dosen pembimbing, E-mail:* [fkartiasih@stis.ac.id](mailto:fkartiasih@stis.ac.id)

*\*Corresponding Author: E-mail:* <112313326@stis.ac.id>

---

## Kotak Info Seminar dan Abstrak

| **INFO SEMINAR** | **Abstrak** |
|---|---|
| Hari/tgl: Selasa, 10/03/2026<br><br>Ruang/Sesi: 253 / 5<br><br>Moderator: Fitri Kartiasih<br><br>Penguji 1: Yaya Setiadi<br><br>Penguji 2: Azka Ubaidillah | Provinsi DKI Jakarta sebagai kawasan metropolitan menunjukkan konsumsi listrik rumah tangga tertinggi di Indonesia, sementara beban listrik domestik terus meningkat meskipun indikator sektor listrik dan gas sempat mengalami kontraksi. Kondisi ini mengindikasikan adanya keragaman perilaku konsumsi yang tidak terlihat pada data agregat, dan diperkuat oleh fenomena Urban Heat Island yang meningkatkan kebutuhan pendinginan. Penelitian ini bertujuan menggambarkan profil konsumsi listrik rumah tangga serta mengelompokkan rumah tangga menurut pola pengeluaran listrik dan karakteristik sosial ekonomi tahun 2025. Data yang digunakan adalah mikrodata Susenas Maret 2025 dengan unit observasi rumah tangga. Klaster dibentuk menggunakan K-Means pada peubah kontinu yang distandarkan Z-score, yaitu pengeluaran listrik bulanan, total pengeluaran, ukuran rumah tangga, dan lama sekolah KRT; jumlah klaster dipilih melalui Metode Elbow berdasarkan Within-Cluster Sum of Squares (WCSS). Perbedaan antar klaster diuji dengan ANOVA atau Kruskal–Wallis, sedangkan pemisahan multivariat divalidasi menggunakan analisis diskriminan melalui Wilks' Lambda. Kepemilikan AC (biner) digunakan pada tahap profiling untuk membaca indikasi kelompok yang berpotensi mengalami adaptation cooling deficit. Hasil penelitian diharapkan menghasilkan profil klaster konsumen guna mendukung kebijakan efisiensi energi dan perlindungan kelompok rentan. |
| ***Kata Kunci:***<br><br>Analisis Klaster; Konsumsi Listrik; Karakteristik Sosial Ekonomi; *Urban Heat Island*; DKI Jakarta. | |

---

## 1. Pendahuluan

### 1.1 *Latar Belakang*

Visi Indonesia Emas 2045 menetapkan Pembangunan Ekonomi yang Berkelanjutan sebagai salah satu pilar utama kemajuan bangsa. Dalam mewujudkan sasaran tersebut, pemantapan ketahanan energi dan air serta komitmen terhadap lingkungan hidup menjadi agenda strategis nasional [1]. Hal ini menempatkan ketahanan lingkungan sebagai prasyarat pembangunan, mengingat degradasi ekosistem akibat polusi dan pemanasan global berkorelasi langsung terhadap penurunan kualitas kesehatan serta peningkatan beban ekonomi nasional [1]. Sejalan dengan hal tersebut, pemerintah melalui Rencana Pembangunan Jangka Menengah Nasional (RPJMN) 2025–2029 menetapkan agenda ketahanan energi dan lingkungan hidup berkualitas sebagai prioritas nasional untuk menjamin daya dukung ekosistem bagi generasi mendatang [2].

Dalam dimensi pembangunan berkelanjutan, pengelolaan sektor energi memegang peranan sentral sebagai mesin penggerak ekonomi sekaligus penentu kualitas lingkungan. Ketergantungan yang tinggi terhadap sumber energi fosil dalam mendukung aktivitas pembangunan berimplikasi langsung pada peningkatan emisi Gas Rumah Kaca (GRK) nasional yang mencapai 1.360,35 juta ton $CO_{2}e$ pada tahun 2023 [3]. Guna mencapai target pengurangan emisi sebesar 31,89% yang tertuang dalam Laporan Inventarisasi GRK dan MPV Tahun 2024, strategi manajemen permintaan di sisi konsumen menjadi instrumen kebijakan yang mendesak [4]. Dengan demikian, penguatan kualitas lingkungan hidup tidak hanya dicapai melalui sisi hulu produksi, tetapi juga melalui pengendalian konsumsi secara sistematis demi mendukung komitmen iklim nasional.

Listrik, sebagai tulang punggung infrastruktur energi modern, memiliki peran vital dalam mendukung Prioritas Nasional (PN) 2 RPJMN 2025–2029 mengenai ketahanan energi. Urgensi pengelolaan di sektor ini didasarkan pada fakta bahwa konsumsi listrik per kapita nasional terus meningkat hingga mencapai 1.411 kWh/kapita pada tahun 2024 [5]. Meskipun aksesibilitas energi sudah hampir menyeluruh dengan capaian rasio elektrifikasi nasional sebesar 99,83%, tantangan pembangunan saat ini bergeser pada isu stabilitas pasokan dan efisiensi konsumsi. Hal ini didorong oleh prediksi lonjakan permintaan energi di wilayah perkotaan yang meningkat tajam seiring dengan dinamika sosial ekonomi masyarakat [6].

![Gambar 1 Peta Sebaran Rasio Elektrifikasi Tahun 2024](assets/gambar-1-rasio-elektrifikasi.png)

Sumber: Badan Pusat Statisik & Bappennas, 2025 (diolah)

**Gambar 1 Peta Sebaran Rasio Elektrifikasi Tahun 2024**

> **Deskripsi Gambar 1.** Grafik *lollipop* horizontal (garis + titik) yang mengurutkan 38 provinsi menurut rasio elektrifikasi tahun 2024, dari tertinggi di atas ke terendah di bawah. Sumbu horizontal berlabel **"Rasio Elektrifikasi (%)"** dengan skala terpotong mulai dari 90 sampai di atas 99 (tanda sumbu: 90, 93, 96, 99). Dua titik teratas diberi warna **merah** sebagai penekanan, sisanya **biru muda**. Nilai per provinsi (dari atas ke bawah):
>
> | Provinsi | Rasio Elektrifikasi (%) |
> |---|---|
> | DKI Jakarta | 100 (titik merah) |
> | Bali | 100 (titik merah) |
> | Sumatera Utara | 99,99 |
> | Sumatera Selatan | 99,99 |
> | Sumatera Barat | 99,99 |
> | Sulawesi Utara | 99,99 |
> | Sulawesi Tengah | 99,99 |
> | Sulawesi Selatan | 99,99 |
> | Sulawesi Barat | 99,99 |
> | Riau | 99,99 |
> | Papua Barat Daya | 99,99 |
> | Papua Barat | 99,99 |
> | Nusa Tenggara Barat | 99,99 |
> | Maluku Utara | 99,99 |
> | Lampung | 99,99 |
> | Kep. Riau | 99,99 |
> | Kep. Bangka Belitung | 99,99 |
> | Kalimantan Utara | 99,99 |
> | Kalimantan Timur | 99,99 |
> | Kalimantan Selatan | 99,99 |
> | Jawa Tengah | 99,99 |
> | Jawa Barat | 99,99 |
> | Jambi | 99,99 |
> | Gorontalo | 99,99 |
> | DI Yogyakarta | 99,99 |
> | Bengkulu | 99,99 |
> | Banten | 99,99 |
> | Aceh | 99,99 |
> | Kalimantan Barat | 99,85 |
> | Papua | 99,81 |
> | Sulawesi Tenggara | 99,78 |
> | Jawa Timur | 99,67 |
> | Papua Tengah | 99,49 |
> | Papua Selatan | 99,08 |
> | Maluku | 99,08 |
> | Kalimantan Tengah | 98,05 |
> | Nusa Tenggara Timur | 96,35 |
> | Papua Pegunungan | 94,02 |
>
> Pesan visual: DKI Jakarta dan Bali berada di puncak dengan capaian penuh 100%, sementara jarak terlebar ke bawah dimiliki Papua Pegunungan (94,02%).

Berdasarkan sebaran pada Gambar 1, Provinsi DKI Jakarta dan Provinsi Bali merupakan wilayah yang telah mencapai rasio elektrifikasi sebesar 100%, melampaui capaian nasional [5]. Secara spasial, wilayah dengan karakteristik metropolitan berfungsi sebagai pusat pertumbuhan ekonomi yang didorong oleh variabel konsumsi dan investasi [7]. Sebagai Ibu Kota Negara, DKI Jakarta mencatatkan nilai Produk Domestik Regional Bruto (PDRB) tertinggi di Indonesia, yang berimplikasi pada tingginya permintaan energi listrik [8]. Kondisi wilayah yang sepenuhnya merupakan kawasan perkotaan ini memicu fenomena *Urban Heat Island* (UHI), di mana peningkatan suhu udara di pusat kota mendorong kebutuhan energi listrik yang lebih besar sebagai strategi adaptasi termal masyarakat [10].

![Gambar 2 Rata-Rata Pengeluaran Listrik per Kapita Sebulan 2025](assets/gambar-2-pengeluaran-listrik-perkapita.png)

Sumber: Badan Pusat Statistik, 2026 (Data 2025)

***Gambar 2. Rata-Rata Pengeluaran Listrik per Kapita Sebulan 2025***

> **Deskripsi Gambar 2.** Diagram batang horizontal 38 provinsi, diurutkan dari pengeluaran listrik per kapita per bulan tertinggi (atas) ke terendah (bawah). Sumbu horizontal berlabel **"Pengeluaran (Rupiah)"** dengan tanda 0; 50.000; 100.000; 150.000. Batang DKI Jakarta diwarnai **merah tua** sebagai penekanan, seluruh batang lain **abu-abu**. Terdapat **garis putus-putus vertikal berwarna biru** sebagai garis acuan rata-rata nasional, dengan anotasi teks biru **"Rata-Rata Nasional: Rp 41.339"**. Nilai per provinsi (dari atas ke bawah):
>
> | Provinsi | Pengeluaran per kapita/bulan (Rp) |
> |---|---|
> | DKI Jakarta | 120.220 |
> | Kep. Riau | 107.074 |
> | Kalimantan Timur | 65.431 |
> | Kalimantan Utara | 59.111 |
> | Papua | 58.371 |
> | Riau | 53.467 |
> | Bali | 53.090 |
> | Banten | 53.067 |
> | Papua Barat Daya | 50.741 |
> | Kep. Bangka Belitung | 46.851 |
> | Jawa Barat | 45.331 |
> | Kalimantan Tengah | 41.435 |
> | Sumatera Utara | 40.200 |
> | Kalimantan Selatan | 40.105 |
> | Papua Selatan | 39.234 |
> | Papua Barat | 39.086 |
> | Papua Tengah | 38.607 |
> | DI Yogyakarta | 38.483 |
> | Kalimantan Barat | 38.237 |
> | Jambi | 36.951 |
> | Sulawesi Selatan | 35.291 |
> | Bengkulu | 35.192 |
> | Sumatera Selatan | 34.039 |
> | Jawa Timur | 34.036 |
> | Sumatera Barat | 33.550 |
> | Maluku | 31.863 |
> | Lampung | 31.189 |
> | Maluku Utara | 31.147 |
> | Sulawesi Tenggara | 30.783 |
> | Aceh | 30.161 |
> | Sulawesi Utara | 29.818 |
> | Sulawesi Tengah | 27.544 |
> | Jawa Tengah | 27.493 |
> | Gorontalo | 25.521 |
> | Sulawesi Barat | 19.731 |
> | Nusa Tenggara Barat | 19.537 |
> | Papua Pegunungan | 17.767 |
> | Nusa Tenggara Timur | 15.856 |
>
> Pesan visual: batang DKI Jakarta hampir tiga kali panjang garis rata-rata nasional, dan jaraknya terhadap peringkat kedua (Kep. Riau) masih terlihat jelas.

Besarnya beban ekonomi akibat intensitas energi di wilayah metropolitan terpotret pada Gambar 2, di mana rata-rata pengeluaran listrik per kapita di DKI Jakarta mencapai Rp120.220 per bulan. Angka ini menunjukkan perbedaan yang signifikan dibandingkan rata-rata nasional sebesar Rp41.339 per bulan [9]. Tingginya pengeluaran tersebut berkontribusi terhadap emisi tidak langsung sektor energi di Jakarta sebesar 33.420 Gg $CO_{2}e$, yang tercatat melampaui total emisi langsungnya sebesar 29.664 Gg $CO_{2}e$ [11]. Kondisi ini menjadi kendala bagi target penurunan emisi sesuai amanat Peraturan Gubernur Nomor 90 Tahun 2021 [12]. Mengingat pasokan listrik Jakarta masih bergantung pada energi fosil, strategi dekarbonisasi memerlukan kebijakan manajemen sisi permintaan yang mendalam berdasarkan pola perilaku dan aktivitas harian penghuni [13, 14].

| (a) | (b) |
|---|---|
| ![Gambar 3a Komposisi Pelanggan Listrik Menurut Sektor di DKI Jakarta 2025](assets/gambar-3a-komposisi-pelanggan.png) | ![Gambar 3b Distribusi Konsumsi Listrik Menurut Sektor di DKI Jakarta 2025](assets/gambar-3b-distribusi-konsumsi.png) |

Sumber: BPS Provinsi DKI Jakarta, 2026 (Diolah)

**Gambar 3. (a) Komposisi Pelanggan Listrik Menurut Sektor di DKI Jakarta, 2025 (b) Distribusi Konsumsi Listrik (kWh) Menurut Sektor di DKI Jakarta, 2025**

> **Deskripsi Gambar 3(a).** *Treemap* (peta pohon) komposisi **jumlah pelanggan** listrik menurut sektor di DKI Jakarta. Blok terbesar mendominasi hampir seluruh bidang gambar:
>
> | Sektor | Jumlah pelanggan | Persentase | Warna blok |
> |---|---|---|---|
> | Rumah Tangga | 5.159.869 | 92,49% | merah tua (blok raksasa, kiri) |
> | Usaha | 333.396 | 5,98% | biru (kolom kanan) |
> | Sosial | 53.928 | 0,97% | hijau tua (kanan atas) |
> | (sektor sisa, tanpa label terbaca) | — | — | ungu, oranye, biru-kehijauan (potongan tipis di pojok kanan atas) |
>
> Pesan visual: perbandingan luas blok membuat dominasi sektor rumah tangga terlihat ekstrem — sektor lain hanya menempati sebilah tipis di sisi kanan.
>
> **Deskripsi Gambar 3(b).** *Treemap* distribusi **konsumsi listrik (kWh)** menurut sektor di DKI Jakarta. Berbeda dengan panel (a), di sini blok terbagi lebih berimbang:
>
> | Sektor | Konsumsi | Persentase | Warna blok |
> |---|---|---|---|
> | Rumah Tangga | 16,36 Miliar kWh | 42,84% | hijau tua (kiri bawah, blok terbesar) |
> | Usaha | 13,96 Miliar kWh | 36,56% | biru (kiri atas) |
> | Industri | 3,92 Miliar kWh | 10,26% | merah tua (kanan bawah) |
> | Sosial | 1,77 Miliar kWh | 4,63% | oranye (kanan tengah) |
> | Perkantoran | 1,6 Miliar kWh | 4,19% | ungu (kanan atas) |
> | Lainnya | 0,18 Miliar kWh | 1,47% | abu-abu gelap (potongan tipis kanan paling atas) |
>
> Pesan visual: sektor rumah tangga tetap yang terbesar, tetapi keunggulannya atas sektor usaha jauh lebih tipis pada sisi konsumsi (42,84% vs 36,56%) dibandingkan pada sisi jumlah pelanggan (92,49% vs 5,98%).

Sektor rumah tangga di Jakarta memegang peranan paling dominan dengan cakupan 5,16 juta pelanggan atau setara dengan 92,49% dari total konsumen listrik di wilayah ibu kota [15]. Besarnya proporsi pelanggan tersebut berbanding lurus dengan total konsumsi listrik yang mencapai 16,36 TWh pada tahun 2024, yang menyumbang hampir 43 persen dari total penggunaan energi di Jakarta [15]. Nilai konsumsi domestik ini tercatat melampaui penggunaan energi pada sektor usaha sebesar 13,96 TWh maupun sektor industri sebesar 3,92 TWh [15]. Fenomena tingginya permintaan ini sejalan dengan hipotesis *Energy Ladder*, di mana peningkatan kesejahteraan mendorong transisi penggunaan energi yang diikuti oleh peningkatan intensitas akibat kepemilikan berbagai aset elektronik [16]. Karakteristik ekonomi tersebut tercermin dari tarif rata-rata listrik rumah tangga di Jakarta sebesar Rp1.493,62 per kWh, yang merupakan angka tertinggi secara nasional dan didominasi oleh kelompok tarif nonsubsidi [17]. Mengingat adanya heterogenitas pola perilaku antar kelompok daya, penerapan efisiensi energi dipandang sebagai langkah yang mampu menyelaraskan mitigasi emisi sekaligus optimasi beban pengeluaran rumah tangga secara beriringan [1, 18].

### 1.2 *Identifikasi Masalah*

![Gambar 4 Tren Total Daya Listrik Rumah Tangga Terjual di Provinsi DKI Jakarta](assets/gambar-4-tren-daya-terjual.png)

Sumber: BPS Provinsi DKI Jakarta (Data diolah)

**Gambar 4. Tren Total Daya Listrik Rumah Tangga Terjual di Provinsi DKI Jakarta**

> **Deskripsi Gambar 4.** Grafik garis dengan penanda titik, empat seri, sumbu horizontal **"Tahun"** (2018–2025) dan sumbu vertikal **"Daya Terjual (Miliar kWh)"** berskala 0 sampai 18 (tanda tiap 2). Legenda di bawah grafik memuat empat seri:
>
> | Seri | Gaya garis & warna | Pola | Nilai berlabel di ujung kanan (2025) |
> |---|---|---|---|
> | Total Rumah Tangga | merah, **garis putus-putus** | naik dari ±13,2 (2018) → ±14,0 (2019) → ±14,6 (2020) → ±14,75 (2021) → ±14,8 (2022) → ±15,6 (2023) → ±16,4 (2024) → mendatar di 2025 | **16,36** |
> | R1 (450–2200 VA) | biru, garis penuh | naik dari ±8,6 (2018) ke ±9,3 (2020), sedikit turun/mendatar 2021–2022 (±9,2), naik lagi ke ±10,1 (2024), mendatar di 2025 | **10,06** |
> | R2 (3.500–5.500 VA) | oranye/kuning, garis penuh | naik landai dari ±2,5 (2018) ke ±3,5 (2024), sedikit turun di 2025 | **3,38** |
> | R3 (6.600 VA ke atas) | hijau, garis penuh | naik landai dari ±2,1 (2018) ke ±2,9 (2024), mendatar di 2025 | **2,92** |
>
> Pesan visual: seluruh golongan daya menunjukkan tren naik selama 2018–2024, dengan golongan R1 sebagai penyumbang terbesar, dan kurva total mendatar pada tahun terakhir.

Berdasarkan Gambar 4, total daya listrik rumah tangga terjual di Provinsi DKI Jakarta meningkat dari **13,20 miliar kWh pada tahun 2018** menjadi **16,41 miliar kWh pada tahun 2024**, yang menunjukkan kenaikan beban energi pada sektor domestik dalam beberapa tahun terakhir [15]. Kondisi ini menjadi penting dalam konteks pembangunan berkelanjutan karena tanpa perubahan bauran energi, peningkatan beban listrik berpotensi mendorong kenaikan emisi gas rumah kaca hingga tiga kali lipat [13]. Di sisi lain, sektor rumah tangga di DKI Jakarta merupakan sektor pengguna listrik yang dominan, dengan **5,16 juta pelanggan** atau setara **92,49 persen** dari total konsumen listrik, serta total konsumsi mencapai **16,36 TWh** atau hampir **43 persen** dari total penggunaan energi di Jakarta [15]. Tingginya intensitas konsumsi ini juga tercermin pada rata-rata pengeluaran listrik per kapita di DKI Jakarta yang mencapai **Rp120.220 per bulan**, jauh di atas rata-rata nasional sebesar **Rp41.339 per bulan** [9]. Dengan pasokan listrik Jakarta yang masih bergantung pada energi fosil, tingginya konsumsi listrik rumah tangga menjadi relevan untuk dikaji karena berkontribusi terhadap emisi tidak langsung sektor energi di Jakarta yang tercatat sebesar **33.420 Gg CO2e**, melampaui emisi langsungnya sebesar **29.664 Gg CO2e** [11].

Namun demikian, tingginya konsumsi listrik rumah tangga di DKI Jakarta tidak dapat dijelaskan secara memadai hanya melalui indikator agregat. Pengendalian konsumsi di tingkat hilir menghadapi tantangan karena karakteristik permintaan listrik rumah tangga cenderung bersifat **inelastis terhadap harga**, bahkan harga tidak memiliki pengaruh yang signifikan terhadap permintaan listrik rumah tangga, sedangkan jumlah pelanggan dan pendapatan justru menjadi faktor yang lebih kuat dalam mendorong permintaan listrik [19]. Kondisi ini terlihat ketika laju pertumbuhan *year-on-year* PDRB Provinsi DKI Jakarta atas dasar harga konstan pada lapangan usaha **Pengadaan Listrik dan Gas** mengalami kontraksi tajam, yakni sebesar **-15,24 persen pada Triwulan I 2025** dan **-19,09 persen pada Triwulan II 2025**, sementara konsumsi listrik rumah tangga tetap berada pada tingkat yang tinggi. Hal tersebut menunjukkan bahwa data agregat sektoral belum cukup untuk menjelaskan variasi perilaku konsumsi listrik yang sesungguhnya terjadi pada tingkat unit rumah tangga, sehingga diperlukan pendekatan yang lebih rinci untuk membaca heterogenitas konsumsi listrik rumah tangga secara lebih nyata.

Variabilitas pola konsumsi listrik di tingkat rumah tangga dipengaruhi oleh perbedaan karakteristik sosial ekonomi penghuninya [18]. Dalam konteks ini, total pengeluaran rumah tangga menjadi determinan penting yang mendorong penggunaan energi modern yang lebih intensif [16]. Selain itu, jumlah anggota rumah tangga turut menentukan besarnya kebutuhan energi domestik, sedangkan pendidikan kepala rumah tangga berkaitan dengan pola perilaku, preferensi, dan kemampuan adopsi teknologi yang memengaruhi penggunaan energi [16], [21], [22]. Dalam konteks DKI Jakarta sebagai kawasan metropolitan, dinamika tersebut juga diperkuat oleh fenomena *Urban Heat Island* (UHI) yang menyebabkan suhu udara di kawasan perkotaan menjadi lebih tinggi dibandingkan wilayah sekitarnya [10]. Tekanan panas perkotaan ini mendorong kebutuhan pendinginan ruang, dan kepemilikan AC menjadi salah satu bentuk adaptasi yang relevan karena adopsinya dapat meningkatkan konsumsi listrik rumah tangga secara signifikan [20]. Namun, kemampuan rumah tangga untuk merespons tekanan termal tersebut tidak merata. Rumah tangga dengan kondisi ekonomi lebih baik, tinggal di kawasan urban, memiliki tingkat pendidikan lebih tinggi, dan kualitas hunian yang lebih baik cenderung lebih mampu mengadopsi AC, sementara rumah tangga lain berisiko mengalami *adaptation cooling deficit*, yaitu kondisi ketika kebutuhan pendinginan ada, tetapi kapasitas ekonomi untuk memenuhinya terbatas [20], [23].

Penelitian mengenai konsumsi energi rumah tangga di Indonesia sebelumnya telah menunjukkan bahwa faktor sosial ekonomi, karakteristik hunian, serta perilaku dan gaya hidup dapat memengaruhi tingkat konsumsi energi rumah tangga [6], [16]. Akan tetapi, sebagian kajian masih berfokus pada konteks hunian tertentu seperti apartemen, sehingga belum secara khusus memetakan heterogenitas rumah tangga di permukiman umum metropolitan seperti DKI Jakarta [6]. Di sisi lain, tanpa pemetaan profil rumah tangga yang lebih rinci, kebijakan efisiensi energi cenderung bersifat umum dan belum mempertimbangkan perbedaan karakteristik antar kelompok rumah tangga [24], [25]. Oleh karena itu, diperlukan penelitian yang mampu mengklasifikasikan rumah tangga di DKI Jakarta berdasarkan pola konsumsi listrik dan karakteristik sosial ekonominya untuk menghasilkan profil kelompok yang lebih jelas. Profil ini diharapkan dapat mendukung penyusunan kebijakan efisiensi energi yang lebih tepat sasaran, sekaligus membantu mengidentifikasi kelompok rumah tangga yang berpotensi rentan terhadap keterbatasan adaptasi pendinginan.

### 1.3 *Tujuan Penelitian*

Berdasarkan latar belakang dan identifikasi masalah yang telah dipaparkan, tujuan spesifik dari penelitian ini adalah sebagai berikut:

1. Menggambarkan profil konsumsi listrik serta kondisi sosial ekonomi rumah tangga di Provinsi DKI Jakarta Tahun 2025.
2. Mengidentifikasi dan mengelompokkan (klasterisasi) rumah tangga di Provinsi DKI Jakarta berdasarkan pola konsumsi listrik dan karakteristik sosial ekonomi.
3. Menganalisis perbedaan karakteristik sosial ekonomi rumah tangga di Provinsi DKI Jakarta tahun 2025.

### 1.4 *Keterbatasan Penelitian*

Penelitian ini menggunakan data sekunder Survei Sosial Ekonomi Nasional (Susenas) Maret 2025 dengan lingkup wilayah Provinsi DKI Jakarta. Variabel pembentuk klaster dibatasi pada pengeluaran listrik, total pengeluaran rumah tangga (makanan dan non-makanan), ukuran rumah tangga, dan pendidikan Kepala Rumah Tangga (KRT) sesuai justifikasi dari penelitian Kubota et al. [18] serta Takata et al. [6].

Keterbatasan utama penelitian ini terletak pada ketiadaan informasi teknis mengenai durasi penggunaan dan daya spesifik peralatan elektronik, seperti AC maupun peralatan listrik lainnya, dalam data Susenas. Oleh karena itu, hasil analisis klaster yang diperoleh merupakan pendekatan proksi berdasarkan karakteristik sosial ekonomi rumah tangga dan pola pengeluaran energi, bukan hasil observasi teknis langsung terhadap konsumsi energi per peralatan. Selain itu, kepemilikan AC dalam penelitian ini hanya digunakan pada tahap profiling untuk membantu interpretasi karakter klaster, sehingga belum dapat menggambarkan intensitas penggunaan pendinginan secara langsung.

---

## 2. Tinjauan Pustaka

### 2.1 Landasan Teori

#### Energy Ladder

Penelitian ini menggunakan Energy Ladder sebagai landasan teori utama. Teori ini menjelaskan bahwa rumah tangga cenderung bergerak dari penggunaan energi tradisional menuju energi yang lebih modern, bersih, nyaman, dan efisien seiring meningkatnya status sosial ekonomi [26], [27]. Dalam formulasi klasiknya, rumah tangga diasumsikan menaiki "tangga energi" dari bahan bakar biomassa menuju bahan bakar transisi, kemudian ke energi modern seperti LPG dan listrik [26], [27].

Meskipun demikian, teori Energy Ladder dalam penelitian ini tidak dipahami secara kaku sebagai perpindahan vertikal sempurna dari satu sumber energi ke sumber energi lain. van der Kroon et al. [26] menunjukkan bahwa hubungan antara pendapatan dan pilihan energi tidak selalu linear, dan dalam banyak kasus rumah tangga menggunakan kombinasi beberapa sumber energi secara bersamaan (fuel stacking). Leach [27] juga menegaskan bahwa proses transisi energi rumah tangga dipengaruhi oleh urbanisasi, akses terhadap energi modern, serta biaya perangkat untuk menggunakan energi tersebut, sedangkan harga energi bukan selalu faktor yang paling menentukan. Oleh karena itu, dalam konteks penelitian ini, Energy Ladder digunakan untuk menjelaskan bahwa perbedaan tingkat kesejahteraan rumah tangga berkaitan dengan perbedaan intensitas penggunaan energi modern, termasuk listrik, serta kemampuan untuk memiliki dan menggunakan perangkat listrik.

Pendekatan ini relevan untuk konteks DKI Jakarta sebagai wilayah metropolitan dengan akses listrik yang sangat tinggi, sehingga isu utamanya bukan lagi sekadar akses terhadap energi modern, melainkan perbedaan intensitas pemanfaatan energi modern antarrumah tangga. Nazer dan Handra [16] menunjukkan bahwa pada rumah tangga perkotaan Indonesia, elastisitas pendapatan terhadap konsumsi energi modern bernilai positif, yang berarti kenaikan pendapatan diikuti oleh kenaikan konsumsi energi modern. Dengan demikian, Energy Ladder tetap relevan sebagai landasan teori utama untuk menjelaskan mengapa rumah tangga dengan kondisi sosial ekonomi yang berbeda dapat menunjukkan pola konsumsi listrik yang berbeda pula [16].

#### Urban Heat Island dan Adaptation Cooling Deficit

Selain dipengaruhi oleh kondisi sosial ekonomi, konsumsi listrik rumah tangga perkotaan juga dipengaruhi oleh kondisi lingkungan termal. Dalam konteks metropolitan seperti Jakarta, fenomena Urban Heat Island (UHI) menyebabkan suhu kawasan perkotaan lebih tinggi dibandingkan wilayah sekitarnya [10]. Siswanto et al. [10] menunjukkan bahwa di Jakarta Metropolitan, intensitas surface urban heat island (SUHI) berada pada kisaran 3°C–6°C, sedangkan air urban heat island (AUHI) berada pada kisaran 1°C–2,5°C. Kondisi ini penting karena peningkatan suhu lingkungan mendorong kebutuhan pendinginan ruang, sehingga konsumsi listrik rumah tangga juga dipengaruhi oleh tekanan iklim perkotaan.

Dalam situasi tersebut, kepemilikan dan penggunaan perangkat pendingin, terutama air conditioner (AC), menjadi bentuk adaptasi rumah tangga terhadap tekanan panas. Pavanello et al. [23] menunjukkan bahwa pendapatan dan suhu yang disesuaikan dengan kelembapan merupakan faktor penting yang memengaruhi adopsi AC di negara berkembang, termasuk Indonesia. Tingkat adopsi AC lebih tinggi pada rumah tangga yang tinggal di wilayah urban, memiliki tingkat pendidikan lebih tinggi, dan menempati hunian dengan kualitas lebih baik [23]. Namun, studi yang sama juga menunjukkan adanya adaptation cooling deficit, yaitu kondisi ketika rumah tangga menghadapi kebutuhan pendinginan akibat suhu yang tinggi, tetapi tidak mampu memperoleh atau menggunakan AC secara memadai karena keterbatasan ekonomi [23].

Relevansi konsep ini diperkuat oleh De Cian et al. [20] yang menemukan bahwa kepemilikan AC meningkatkan konsumsi listrik rumah tangga rata-rata sebesar 36 persen, dan pada kondisi tertentu pengaruhnya dapat meningkat hingga 57 persen [20]. Temuan tersebut menunjukkan bahwa pendinginan rumah tangga bukan hanya persoalan teknis, melainkan juga berkaitan dengan ketimpangan akses terhadap kenyamanan termal dan kerentanan energi. Oleh karena itu, dalam penelitian ini, konsep UHI dan adaptation cooling deficit digunakan sebagai konsep pendukung untuk menjelaskan bahwa dalam konteks DKI Jakarta, pola konsumsi listrik rumah tangga juga dibentuk oleh tekanan panas perkotaan dan perbedaan kemampuan rumah tangga dalam beradaptasi terhadap kebutuhan pendinginan.

#### Determinan sosial ekonomi konsumsi listrik rumah tangga

Konsumsi listrik rumah tangga dipengaruhi oleh interaksi faktor ekonomi, demografi, karakteristik hunian, dan kondisi lingkungan. Dalam kajian rumah tangga perkotaan Indonesia, pendapatan rumah tangga merupakan faktor yang paling menentukan konsumsi energi rumah tangga, di samping faktor non-ekonomi seperti jumlah anggota rumah tangga [16]. Dalam penelitian ini, total pengeluaran rumah tangga digunakan sebagai proksi kemampuan ekonomi atau kesejahteraan, karena data pengeluaran dinilai lebih stabil untuk menggambarkan tingkat kesejahteraan dibandingkan pendapatan [16].

Selain faktor ekonomi, ukuran rumah tangga juga relevan karena berkaitan dengan skala kebutuhan domestik dan intensitas aktivitas rumah tangga. Rumah tangga dengan anggota lebih banyak cenderung membutuhkan energi lebih besar untuk penerangan, penggunaan peralatan rumah tangga, maupun kenyamanan termal. Ali et al. [22] menunjukkan bahwa tingkat pendapatan, tingkat pendidikan, dan ukuran rumah tangga memiliki hubungan positif dengan konsumsi listrik rumah tangga. Di samping itu, karakteristik hunian seperti tipe rumah dan jumlah ruang juga berhubungan dengan tingkat konsumsi listrik [22]. Temuan tersebut menguatkan bahwa konsumsi listrik rumah tangga tidak hanya ditentukan oleh pendapatan, tetapi juga oleh kebutuhan domestik yang ditentukan oleh ukuran rumah tangga dan kondisi tempat tinggal.

Pendidikan kepala rumah tangga juga diposisikan sebagai faktor penting karena dapat merefleksikan modal manusia, pengetahuan, preferensi, dan keputusan adopsi teknologi rumah tangga. Pavanello et al. [23] menunjukkan bahwa rumah tangga dengan tingkat pendidikan lebih tinggi cenderung memiliki kemungkinan adopsi AC yang lebih besar. Temuan Ali et al. [22] juga mendukung bahwa pendidikan berhubungan positif dengan konsumsi listrik rumah tangga. Dalam konteks ini, pendidikan kepala rumah tangga dapat dipahami sebagai faktor yang membedakan perilaku konsumsi listrik melalui jalur preferensi kenyamanan, pemilihan teknologi, dan pola penggunaan perangkat rumah tangga.

Berdasarkan uraian tersebut, penelitian ini menempatkan pengeluaran listrik sebagai representasi perilaku penggunaan energi rumah tangga, sedangkan total pengeluaran rumah tangga, ukuran rumah tangga, dan pendidikan kepala rumah tangga digunakan untuk menjelaskan heterogenitas sosial ekonomi yang mendasari perbedaan pola konsumsi listrik. Dengan demikian, pengeluaran listrik tidak dibaca secara terpisah, melainkan bersama indikator kesejahteraan dan karakteristik sosial ekonomi rumah tangga untuk membentuk klasifikasi rumah tangga yang lebih bermakna secara substantif.

### 2.2 Penelitian Terkait

Penelitian terdahulu menunjukkan bahwa konsumsi listrik rumah tangga tidak homogen dan dipengaruhi oleh perbedaan kondisi sosial ekonomi, demografi, dan karakteristik hunian. Pada konteks rumah tangga perkotaan di Indonesia, Nazer dan Handra menunjukkan bahwa pendapatan merupakan faktor utama yang memengaruhi konsumsi energi rumah tangga, disertai faktor non-ekonomi seperti jumlah anggota rumah tangga [16]. Studi lain juga menunjukkan bahwa ukuran rumah tangga, tingkat pendidikan, dan karakteristik hunian berhubungan dengan tingkat konsumsi listrik rumah tangga [21], [22], sedangkan permintaan listrik rumah tangga cenderung relatif inelastis terhadap harga [19]. Temuan-temuan tersebut menunjukkan bahwa rumah tangga dengan kondisi sosial ekonomi yang berbeda berpotensi memiliki pola konsumsi listrik yang berbeda pula.

Literatur juga menekankan pentingnya faktor lingkungan perkotaan, khususnya kebutuhan pendinginan, dalam membentuk konsumsi listrik rumah tangga. Pada wilayah metropolitan seperti Jakarta, fenomena Urban Heat Island meningkatkan suhu kawasan perkotaan dibandingkan wilayah sekitarnya [10]. Dalam konteks tersebut, penggunaan perangkat pendingin menjadi semakin relevan. De Cian et al. menunjukkan bahwa kepemilikan AC meningkatkan konsumsi listrik rumah tangga rata-rata sebesar 36 persen, dan pada kondisi tertentu dapat mencapai 57 persen [20]. Pavanello et al. juga menunjukkan bahwa kemampuan rumah tangga untuk mengadopsi pendinginan aktif dipengaruhi oleh kapasitas ekonomi, pendidikan, kualitas hunian, dan lokasi urban, sehingga muncul risiko adaptation cooling deficit pada rumah tangga yang membutuhkan pendinginan tetapi tidak mampu memenuhinya [23]. Dengan demikian, konsumsi listrik rumah tangga di wilayah metropolitan tidak hanya dipengaruhi oleh kesejahteraan, tetapi juga oleh tekanan panas perkotaan dan kemampuan adaptasi termal rumah tangga.

Untuk menangkap heterogenitas tersebut, sejumlah penelitian menggunakan pendekatan pengelompokan. Studi Takata et al. mengklasifikasikan pola gaya hidup harian penghuni apartemen di Indonesia dan mengaitkannya dengan konsumsi energi rumah tangga [6]. Pada konteks perkotaan Indonesia, Kubota et al. juga menunjukkan adanya perbedaan profil konsumsi energi rumah tangga antara Jakarta dan Bandung [18]. Sementara itu, Oktasandira menggunakan metode K-Means clustering untuk segmentasi pelanggan listrik sebagai dasar penyusunan kebijakan yang lebih terarah [25]. Secara metodologis, analisis klaster memang digunakan untuk menemukan struktur kelompok dalam data berdasarkan kemiripan karakteristik ketika batas kelompok belum diketahui sebelumnya [24].

Berdasarkan sintesis tersebut, belum banyak penelitian yang secara khusus mengklasifikasikan rumah tangga di DKI Jakarta berdasarkan pola konsumsi listrik dan karakteristik sosial ekonomi menggunakan pendekatan klaster. Oleh karena itu, penelitian ini diarahkan untuk mengisi celah tersebut dengan menghasilkan profil kelompok rumah tangga yang lebih jelas pada konteks metropolitan dengan tekanan panas perkotaan yang tinggi. Profil tersebut diharapkan dapat mendukung perumusan kebijakan efisiensi energi yang lebih presisi sekaligus membantu mengidentifikasi kelompok rumah tangga yang berpotensi rentan terhadap keterbatasan adaptasi pendinginan.

### 2.3 Metode Analisis

#### Analisis Klaster (Cluster Analysis)

Analisis klaster adalah teknik statistik multivariat untuk mengelompokkan objek ke dalam beberapa kelompok sehingga objek dalam satu kelompok memiliki kemiripan tinggi, sedangkan perbedaan antar kelompok relatif besar. Analisis ini bersifat eksploratori dan termasuk kategori unsupervised karena label kelompok belum tersedia pada awal analisis [24], [29], [30]. Hasil klaster tidak otomatis "benar", sehingga interpretasi dan evaluasi kualitas klaster perlu dilakukan secara sistematis melalui ukuran internal maupun evaluasi berbasis pemisahan kelompok.

#### Ukuran Kedekatan dan Standarisasi Data

Pembentukan klaster membutuhkan ukuran kedekatan (similarity) atau jarak (distance). Untuk peubah kuantitatif, jarak Euclidean sering digunakan karena merepresentasikan jarak geometrik antar titik pada ruang berdimensi p [29]. Namun, jarak Euclidean sensitif terhadap perbedaan satuan dan skala; peubah dengan skala besar dapat mendominasi perhitungan jarak. Oleh sebab itu, standardisasi (misalnya Z-score) sering diterapkan agar tiap peubah berkontribusi lebih seimbang pada jarak yang dihitung [29], [31]. Everitt menekankan bahwa standardisasi relevan ketika peubah memiliki skala sangat berbeda karena perhitungan jarak dari data mentah dapat menjadi tidak masuk akal pada kondisi tersebut [29]. Jarak Euclidean merupakan metrik yang paling umum digunakan untuk mengukur kedekatan antara objek $i$ dan objek $k$ [28]:

$$d\left( \mathbf{x}_{\mathbf{i}},\mathbf{x}_{\mathbf{k}} \right) = \sqrt{\sum_{j = 1}^{p}\left( x_{ij} - x_{kj} \right)^{2}}$$

Mengingat jarak sangat sensitif terhadap perbedaan skala, dilakukan standarisasi Z-score agar setiap variabel memiliki bobot yang setara [28]:

$$z_{ij} = \frac{x_{ij} - \overline{x_{j}}}{s_{j}}$$

#### Keluarga Metode Klaster: Hierarki dan Partisi

Metode klaster dapat dibagi menjadi dua keluarga besar:

1. Klaster hierarki (agglomerative/divisive), yang membentuk struktur pengelompokan bertingkat dari banyak klaster kecil menuju klaster besar. Prosedur agglomerative bekerja dengan menggabungkan pasangan klaster terdekat secara iteratif hingga tersisa satu klaster [29]. Kedekatan antar klaster dapat dihitung lewat berbagai aturan (misalnya single linkage dan complete linkage) [29].
2. Klaster partisi, yang langsung mempartisi data menjadi k klaster (k ditetapkan), lalu mengoptimalkan fungsi objektif tertentu; metode yang populer adalah K-Means [29], [30].

Pada praktik analisis data terapan, pemilihan keluarga metode dipengaruhi tujuan segmentasi, ukuran data, serta kebutuhan interpretasi hasil.

#### Metode Klaster Non-Hierarki (K-Means)

*K-Means* adalah metode partisi yang membagi $n$ objek ke dalam $k$ klaster dengan cara meminimalkan keragaman dalam klaster. Fungsi objektif yang umum dipakai adalah jumlah kuadrat dalam klaster (*within-cluster sum of squares*) yang dihitung dari jarak tiap objek ke pusat klaster (*centroid*) [29]. Algoritmanya berjalan iteratif: (i) inisialisasi *centroid*, (ii) alokasi objek ke *centroid* terdekat, (iii) pembaruan *centroid* sebagai rata-rata anggota klaster, lalu (iv) pengulangan sampai konvergen [29], [30]. Karena *K-Means* dapat sensitif terhadap inisialisasi awal, praktik yang baik adalah menggunakan beberapa inisialisasi atau aturan inisialisasi yang lebih stabil agar solusi tidak terjebak pada optimum lokal [29], [30].

Metode *K-Means clustering* dipilih karena tujuan penelitian ini adalah mengelompokkan rumah tangga ketika label kelompok belum diketahui sebelumnya, sehingga pendekatan yang sesuai adalah metode klaster non-hierarki yang bersifat *unsupervised* [24], [29], [30]. Selain itu, variabel pembentuk klaster yang digunakan dalam penelitian ini berupa peubah kuantitatif kontinu, yaitu pengeluaran listrik, total pengeluaran rumah tangga, ukuran rumah tangga, dan pendidikan KRT, sehingga sesuai dengan mekanisme *K-Means* yang bekerja berdasarkan kedekatan jarak antarobjek menuju pusat klaster (*centroid*) [29], [30]. Metode ini juga relatif efisien untuk diterapkan pada data rumah tangga berukuran besar dan menghasilkan segmentasi yang mudah diinterpretasikan untuk keperluan pemetaan profil kelompok rumah tangga. Jumlah klaster kemudian ditentukan menggunakan Metode Elbow agar pemilihan jumlah kelompok tidak dilakukan secara arbitrer, sedangkan kualitas pemisahan klaster dievaluasi lebih lanjut melalui uji beda dan analisis diskriminan [28]–[30].

Algoritma ini bekerja dengan meminimalkan fungsi objektif *Within-Cluster Sum of Squares* (WCSS) [30], [31]:

$$E = \sum_{k = 1}^{K}{\sum_{i \in C_{k}}^{}{\text{|}\mathbf{x}_{\mathbf{i}}} - \ \overline{\mathbf{x}_{k}\text{|}^{2}}}$$

di mana $\overline{x_{k}}$ adalah pusat klaster (centroid) ke-$k$, yang dihitung sebagai rata-rata posisi objek dalam klaster tersebut:

$$\overline{\mathbf{x}_{k}} = \frac{1}{n_{k}}\sum_{i \in C_{k}}^{}\mathbf{x}_{\mathbf{i}}$$

Algoritma ini bersifat iteratif: menetapkan objek ke centroid terdekat, memperbarui centroid, dan mengulang proses hingga tercapai konvergensi atau tidak ada lagi perpindahan objek antar klaster [30].

#### Penentuan Jumlah Klaster Optimal

Penentuan k adalah tahap penting dalam klaster partisi karena nilai k memengaruhi struktur kelompok yang terbentuk. Salah satu cara populer adalah Metode Elbow, yaitu mengamati pola penurunan within-cluster sum of squares saat k bertambah dan memilih titik ketika penurunan mulai melandai [29]. Secara teoretis, peningkatan jumlah klaster akan selalu menurunkan nilai WCSS, namun jumlah klaster optimal dipilih pada titik di mana penurunan WCSS mulai melandai secara drastis (membentuk siku).

#### Uji Perbedaan Antar Kelompok Hasil Klaster

Setelah kelompok terbentuk, evaluasi dapat dilakukan untuk melihat apakah terdapat perbedaan karakteristik antar kelompok. Untuk satu variabel respons (univariat), uji yang sering dipakai ialah ANOVA satu arah, memakai rasio ragam antar-kelompok terhadap ragam dalam-kelompok [28]. Secara umum:

$$F = \frac{MSB}{MSE}$$

dengan $MSB = SSB/(g - 1)$ dan $MSE = SSE/(n - g)$, di mana $g$ banyak kelompok, $SSB$ jumlah kuadrat antar-kelompok, dan $SSE$ jumlah kuadrat galat/dalam-kelompok [28].

Jika asumsi parametrik (mis. normalitas galat dan homogenitas ragam) tidak memadai, maka uji berbasis peringkat seperti Kruskal–Wallis dapat dipakai sebagai alternatif, Statistiknya:

$$H = \frac{12}{N(N + 1)}\sum_{i = 1}^{g}\frac{R_{i}^{2}}{n_{i}} - 3(N + 1)$$

dengan $R_{i}$ jumlah peringkat pada kelompok ke-$i$. [34]

#### Validasi Klaster dengan Analisis Diskriminan

Analisis diskriminan linear membangun kombinasi linear dari peubah-peubah untuk memisahkan beberapa kelompok yang telah terbentuk. Untuk vektor pengamatan $\mathbf{y}$, kombinasi linear dapat ditulis sebagai [31]:

$$z = \mathbf{a}^{\top}\mathbf{y}$$

Dalam pengujian pemisahan kelompok secara multivariat, salah satu statistik yang banyak dipakai adalah Wilks' Lambda, yang memakai determinan matriks dalam-kelompok dan total (atau dalam-kelompok dan antar-kelompok). Wilks' Lambda dapat ditulis [28]:

$$\Lambda = \frac{\mid W \mid}{\mid B + W \mid}$$

dengan $W$ matriks *within-group* dan $B$ matriks *between-group* [28].

Nilai $\Lambda$ kecil menunjukkan pemisahan kelompok semakin kuat (lebih "jauh" secara multivariat).

#### Uji homogenitas kovarians (Box's M)

Pada analisis diskriminan, asumsi kesamaan matriks kovarians antar kelompok sering diperiksa menggunakan Box's M. Statistik $M$ salah satunya ditulis sebagai [28]:

$$M = (N - g)\ln \mid S_{pooled} \mid - \sum_{i = 1}^{g}(n_{i} - 1)\ln \mid S_{i} \mid$$

dengan $S_{pooled}$ kovarians gabungan dan $S_{i}$ kovarians kelompok ke-$i$, $n_{i}$ ukuran kelompok, $g$ jumlah kelompok, dan $N$ total sampel.

Karena analisis diskriminan (dan banyak prosedur multivariat lain) sering memakai asumsi kovarians yang sama, Box's M-test digunakan untuk menguji kesamaan matriks kovarians [28], dengan detail formulasi dan aproksimasinya tersedia pada pembahasan Box's M [28] serta penjelasan sifat statistik $M$ pada Rencher & Christensen [31].

### 2.4 Kerangka Pikir

Kerangka pikir penelitian ini disusun untuk menjelaskan bahwa pola konsumsi listrik rumah tangga di DKI Jakarta tidak bersifat homogen, melainkan dibentuk oleh interaksi antara kondisi sosial ekonomi rumah tangga dan tekanan lingkungan perkotaan. Dalam konteks wilayah metropolitan seperti DKI Jakarta, fenomena Urban Heat Island (UHI) meningkatkan suhu kawasan perkotaan dibandingkan wilayah sekitarnya [10]. Peningkatan suhu tersebut memperbesar kebutuhan pendinginan ruang dan menjadikan konsumsi listrik rumah tangga semakin relevan untuk dianalisis, terutama dalam kaitannya dengan kemampuan rumah tangga beradaptasi terhadap tekanan panas.

Di sisi lain, perbedaan pola konsumsi listrik rumah tangga tidak hanya dipengaruhi oleh lingkungan termal, tetapi juga oleh karakteristik sosial ekonomi rumah tangga. Dalam penelitian ini, pengeluaran listrik diposisikan sebagai representasi perilaku penggunaan energi rumah tangga, sedangkan total pengeluaran rumah tangga, ukuran rumah tangga, dan pendidikan kepala rumah tangga digunakan untuk menjelaskan heterogenitas sosial ekonomi yang mendasari perbedaan pola konsumsi listrik [16], [22]. Kombinasi keempat variabel tersebut digunakan sebagai dasar untuk mengelompokkan rumah tangga ke dalam beberapa klaster yang memiliki kemiripan karakteristik.

Setelah klaster rumah tangga terbentuk, kepemilikan air conditioner (AC) digunakan pada tahap profiling untuk membaca karakter adaptasi pendinginan pada masing-masing klaster [20], [23]. Dengan demikian, kepemilikan AC dalam penelitian ini tidak digunakan sebagai variabel pembentuk klaster, tetapi sebagai variabel pendukung untuk membantu interpretasi hasil pengelompokan, khususnya dalam mengidentifikasi kelompok rumah tangga yang berpotensi mengalami adaptation cooling deficit. Melalui kerangka pikir ini, penelitian diarahkan untuk menghasilkan profil kelompok rumah tangga di DKI Jakarta berdasarkan pola konsumsi listrik dan karakteristik sosial ekonomi, sehingga dapat mendukung perumusan kebijakan efisiensi energi yang lebih tepat sasaran.

![Gambar 5 Kerangka Pikir Penelitian](assets/gambar-5-kerangka-pikir.png)

**Gambar 5. Kerangka Pikir Penelitian**

> **Deskripsi Gambar 5.** Diagram alur horizontal berisi kotak-kotak bersudut membulat dan panah berarah, tanpa warna (hitam-putih), mengalir dari kiri ke kanan. Susunannya:
>
> - **Empat kotak input di kolom kiri**, tersusun vertikal dari atas ke bawah: **"Pengeluaran Listrik"**, **"Total Pengeluaran Rumah Tangga"**, **"Ukuran Rumah Tangga"**, dan **"Pendidikan KRT"**. Keempatnya masing-masing memiliki panah yang menuju satu kotak yang sama.
> - **Kotak proses tengah:** **"Klaster Rumah Tangga"** — titik temu keempat panah input.
> - **Kotak kelima yang terpisah**, terletak di bawah-tengah: **"Kepemilikan AC (Variabel Profiling)"**. Panahnya tidak menuju kotak "Klaster Rumah Tangga", melainkan langsung ke kotak berikutnya — inilah penegasan visual bahwa AC bukan variabel pembentuk klaster.
> - **Kotak hasil:** **"Profil Karakter Tiap Klaster"**, menerima panah dari "Klaster Rumah Tangga" dan dari "Kepemilikan AC".
> - **Kotak keluaran akhir (paling kanan):** **"Indikasi Kelompok yang Berpotensi Mengalami Adaptation Cooling Deficit"**.
>
> Alur ringkas: 4 variabel pembentuk → Klaster Rumah Tangga → Profil Karakter Tiap Klaster (+ masukan kepemilikan AC) → Indikasi kelompok berpotensi *adaptation cooling deficit*.
>
> *Catatan berkas:* gambar ini tersimpan dua kali di dalam dokumen asli — versi raster `gambar-5-kerangka-pikir.png` dan versi vektor `gambar-5-kerangka-pikir.svg` (keduanya disertakan).

---

## 3. Metodologi

### 3.1 *Ruang Lingkup Penelitian*

Ruang lingkup penelitian ini berfokus pada klasifikasi rumah tangga di Provinsi DKI Jakarta Tahun 2025 berdasarkan pola konsumsi listrik dan karakteristik sosial ekonomi. Penelitian ini menggunakan data mikro Survei Sosial Ekonomi Nasional (Susenas) Maret 2025 sebagai basis data utama dalam prosedur analisis multivariat. Variabel pembentuk klaster dibatasi pada pengeluaran listrik rumah tangga, total pengeluaran rumah tangga, ukuran rumah tangga, dan tingkat pendidikan Kepala Rumah Tangga (KRT). Adapun kepemilikan *air conditioner* (AC) tidak digunakan dalam pembentukan klaster, melainkan digunakan pada tahap *profiling* untuk membantu membaca karakter adaptasi pendinginan pada masing-masing kelompok rumah tangga. Fokus penelitian diarahkan pada identifikasi heterogenitas rumah tangga di DKI Jakarta, sehingga dapat diperoleh profil kelompok rumah tangga yang lebih jelas pada konteks wilayah metropolitan. Selain itu, hasil pengelompokan diharapkan dapat membantu mengidentifikasi kelompok rumah tangga yang berpotensi mengalami *adaptation cooling deficit*.

### 3.2 Metode Pengumpulan Data

Data penelitian ini merupakan data sekunder berupa mikrodata Susenas Maret 2025 Provinsi DKI Jakarta dari Badan Pusat Statistik. Variabel yang dikumpulkan meliputi:

1. **VSEN25.K:** Banyaknya ART (R301), jenjang pendidikan tertinggi yang sedang/pernah diikuti (R613), dan barang-barang yang dimiliki rumah tangga (R1801).
2. **VSEN25.KP:** Biaya listrik sebulan terakhir (B4.2R234) dan total pengeluaran rumah tangga sebulan (B4.3.3R9).

### 3.3 *Variabel Penelitian*

Variabel yang digunakan dalam penelitian ini dipilih untuk merepresentasikan perilaku penggunaan listrik rumah tangga dan karakteristik sosial ekonomi yang mendasarinya. Data yang dianalisis bersumber dari hasil Survei Sosial Ekonomi Nasional (Susenas) Maret 2025 di Provinsi DKI Jakarta. Pemilihan variabel didasarkan pada integrasi antara kapasitas ekonomi, skala kebutuhan rumah tangga, dan karakteristik sosial ekonomi yang secara teoretis memengaruhi pola konsumsi listrik rumah tangga di wilayah metropolitan.

Dalam penelitian ini, pengeluaran listrik diposisikan sebagai variabel perilaku utama. Variabel pembentuk klaster terdiri atas total pengeluaran rumah tangga, ukuran rumah tangga, dan tingkat pendidikan Kepala Rumah Tangga (KRT), yang masing-masing merepresentasikan kemampuan ekonomi, skala kebutuhan domestik, dan modal manusia. Adapun kepemilikan air conditioner (AC) tidak digunakan sebagai variabel pembentuk klaster, melainkan digunakan pada tahap profiling untuk membantu membaca karakter adaptasi pendinginan pada masing-masing kelompok rumah tangga. Rincian definisi operasional serta satuan pengukuran dari masing-masing variabel disajikan pada Tabel 1.

**Tabel 1. Variabel Penelitian**

| **No** | **Variabel** | **Definisi Operasional / Indikator** | **Satuan** | **Peran dalam Analisis** |
|---|---|---|---|---|
| 1 | Pengeluaran Listrik | Rata-rata nilai pengeluaran untuk pembayaran tagihan listrik atau pembelian token dalam sebulan terakhir. | Rupiah (Rp) | Variabel pembentuk klaster |
| 2 | Kepemilikan AC | Keberadaan aset penyejuk udara (AC) yang masih berfungsi sebagai instrumen adaptasi aktif terhadap suhu lingkungan. | Biner (0=Tidak Memiliki, 1=Memiliki) | Variabel profiling |
| 3 | Total Pengeluaran | Akumulasi pengeluaran konsumsi makanan dan non-makanan sebulan sebagai proksi tingkat kesejahteraan. | Rupiah (Rp) | Variabel pembentuk klaster |
| 4 | Ukuran Rumah Tangga | Jumlah seluruh Anggota Rumah Tangga (ART) yang tinggal dan makan dalam satu rumah tangga. | Jiwa | Variabel pembentuk klaster |
| 5 | Tingkat Pendidikan KRT | Lama sekolah yang berhasil diselesaikan oleh Kepala Rumah Tangga (KRT). | Tahun | Variabel pembentuk klaster |

### 3.4 *Langkah-langkah Metode Analisis*

Penelitian ini menggunakan dua pendekatan analisis, yaitu analisis deskriptif dan analisis inferensia.

Analisis deskriptif bertujuan untuk memberikan gambaran umum mengenai karakteristik rumah tangga di DKI Jakarta berdasarkan pengeluaran listrik, tingkat pendidikan krt, total pengeluaran, kepemilikan ac, ukuran rumah tangga serta variabel pendukung lainnya pada tahun 2025. Hasil analisis ini disajikan dalam bentuk tabel distribusi frekuensi dan grafik untuk mempermudah interpretasi data.

Analisis inferensia digunakan untuk membentuk klaster rumah tangga, menggambarkan perbedaan karakteristik antar klaster, dan mengevaluasi kekuatan pemisahan kelompok yang terbentuk. Pembentukan klaster dilakukan menggunakan metode *K-Means clustering* karena penelitian ini bertujuan mengelompokkan rumah tangga pada kondisi ketika label kelompok belum tersedia, dengan variabel pembentuk klaster berupa peubah kuantitatif kontinu yang telah distandarisasi menggunakan *Z-score* [24], [29], [30]. Variabel yang digunakan pada tahap klasterisasi meliputi pengeluaran listrik, total pengeluaran rumah tangga, ukuran rumah tangga, dan pendidikan KRT. Adapun kepemilikan AC tidak dimasukkan pada tahap pembentukan klaster, tetapi digunakan pada tahap *profiling* untuk membantu interpretasi karakter masing-masing kelompok. Jumlah klaster optimal ditentukan menggunakan Metode Elbow berdasarkan pola penurunan *Within-Cluster Sum of Squares* (WCSS). Selanjutnya, perbedaan antar klaster digambarkan secara univariat menggunakan ANOVA apabila asumsi parametrik terpenuhi, sedangkan ketika asumsi tidak terpenuhi digunakan uji Kruskal–Wallis. Evaluasi pemisahan kelompok secara multivariat dilakukan dengan analisis diskriminan menggunakan statistik Wilks' Lambda. Keputusan pengujian ditetapkan berdasarkan *p-value* dibandingkan dengan tingkat signifikansi $\alpha$.

Langkah-langkah yang dilakukan untuk mencapai tujuan penelitian ini secara sistematis disajikan pada Gambar 6 dan dirinci sebagai berikut:

**1. Tahap Pra-pengolahan Data (Data Pre-processing)**

  a. **Penggabungan data (merging)**
     Menggabungkan mikrodata VSEN25.K dan VSEN25.KP berdasarkan kode identitas rumah tangga.

  b. **Penyaringan (filtering)**
     Mengambil sampel rumah tangga Provinsi DKI Jakarta (kode wilayah 31).

  c. **Pembersihan data**

  > Menangani data hilang pada variabel utama dam deteksi pencilan pada variabel pengeluaran agar tidak menggeser centroid secara ekstrem menggunakan pemeriksaan boxplot/aturan IQR.

  d. **Penetapan variabel pembentuk klaster**
     Variabel pembentuk klaster (kontinu/kuantitatif):

  - $x_{1}$: Pengeluaran Listrik
  - $x_{2}$: Total pengeluaran
  - $x_{3}$: Ukuran rumah tangga
  - $x_{4}$: Pendidikan KRT

  > Variabel profiling (bukan pembentuk klaster):

  - Kepemilikan AC (biner 0/1)

  e. **Standarisasi Z-score untuk variabel pembentuk klaster**

$$Z_{ij} = \frac{x_{ij} - {\overset{ˉ}{x}}_{j}}{s_{j}},\ j = 1,2,3,4$$

**2. Penentuan Jumlah Klaster Optimal ($K$)**

> Jumlah klaster ditentukan menggunakan Metode Elbow dengan melihat pola penurunan Within-Cluster Sum of Squares (WCSS) terhadap beberapa kandidat $K$. Kandidat $K$ dipilih pada titik saat penurunan WCSS mulai melandai (titik "siku").

**3. Analisis Klaster Non-Hierarki (K-Means)**

  a. **Fungsi objektif (WCSS)**

$$WCSS = \sum_{k = 1}^{K}{\sum_{i \in C_{k}}^{}{\sum_{j = 1}^{4}\left( Z_{ij}-{\overset{ˉ}{Z}}_{kj} \right)^{2}}}$$

  b. **Alokasi objek (jarak Euclidean ke centroid)**

$$d\left( Z_{i},{\overset{ˉ}{Z}}_{k} \right) = \sqrt{\sum_{j = 1}^{4}\left( Z_{ij}-{\overset{ˉ}{Z}}_{kj} \right)^{2}}$$

  c. **Pengulangan sampai konvergen**
     Iterasi: alokasi → pembaruan centroid → alokasi ulang, sampai tidak ada perpindahan anggota (atau penurunan WCSS sangat kecil).

  d. **Stabilitas inisialisasi**
     Menjalankan K-Means beberapa kali dengan inisialisasi berbeda, lalu memilih solusi dengan WCSS terendah agar hasil tidak bergantung pada seed awal.

**4. Uji Perbedaan dan Validasi Klaster**

  a. **Uji beda univariat (ANOVA / Kruskal–Wallis)**

  > Setelah klaster terbentuk, evaluasi dilakukan untuk menggambarkan karakter perbedaan antar klaster pada variabel pembentuk klaster. Untuk satu variabel respons (univariat), uji yang digunakan adalah ANOVA satu arah apabila asumsi parametrik terpenuhi, sedangkan ketika asumsi tidak terpenuhi digunakan uji Kruskal–Wallis [28], [34]. Dalam penelitian ini, uji beda univariat digunakan untuk menunjukkan variabel mana yang paling membedakan karakter masing-masing klaster, bukan sebagai validasi eksternal yang sepenuhnya terpisah dari proses pembentukan klaster.
  >
  > Hipotesis:

$$H_{0}:\mu_{1j} = \mu_{2j} = \cdots = \mu_{Kj}$$

$H_{1}:$ minimal ada satu rata-rata yang berbeda

  > Statistik uji ANOVA:

$$F = \frac{MSB}{MSW}$$

  > Jika asumsi parametrik tidak layak, digunakan Kruskal–Wallis:

$$H = \frac{12}{N(N + 1)}\sum_{i = 1}^{K}\frac{R_{i}^{2}}{n_{i}} - 3(N + 1)$$

  > dengan $R_{i}$ jumlah peringkat pada klaster ke-$i$.

  b. **Uji homogenitas matriks varians–kovarians (Box's M)**

  > Untuk mendukung evaluasi pemisahan kelompok secara multivariat, homogenitas matriks varians–kovarians antar klaster diperiksa menggunakan uji Box's M [28], [31]. Hipotesis yang digunakan adalah
  >
  > $$H_{0}:\Sigma_{1} = \Sigma_{2} = \cdots = \Sigma_{K}$$
  >
  > $H_{1}:$ minimal ada satu yang berbeda

  Statistik Box's M dapat ditulis sebagai:

  > $$M = (N - g)\ln \mid S_{pooled} \mid - \sum_{i = 1}^{g}(n_{i} - 1)\ln \mid S_{i} \mid$$
  >
  > dengan $S_{pooled}$ adalah matriks kovarians gabungan, $S_{i}$ adalah matriks kovarians klaster ke-$i$, $n_{i}$ adalah ukuran klaster ke-$i$, $g$ adalah jumlah klaster, dan $N$ adalah total pengamatan [28], [31].

  c. **Analisis diskriminan dan Wilks' Lambda**

  > Selain secara univariat, evaluasi juga dilakukan secara multivariat menggunakan analisis diskriminan. Analisis ini digunakan untuk menilai kekuatan pemisahan kelompok yang telah terbentuk berdasarkan kombinasi variabel pembentuk klaster [28], [31]. Fungsi diskriminan linear dapat ditulis sebagai:
  >
  > $$D_{i} = w_{0} + w_{1}Z_{i1} + w_{2}Z_{i2} + w_{3}Z_{i3} + w_{4}Z_{i4}$$
  >
  > Salah satu statistik yang digunakan untuk menilai pemisahan kelompok adalah Wilks' Lambda, yang dirumuskan sebagai:

$$\Lambda = \frac{\mid W \mid}{\mid B + W \mid}$$

  > dengan $W$ adalah matriks *within-group* dan $B$ adalah matriks *between-group* [28]. Nilai $\Lambda$ yang semakin kecil menunjukkan pemisahan kelompok yang semakin kuat secara multivariat.
  >
  > Hipotesis:
  >
  > $H_{0}:\mu_{1} = \mu_{2} = \cdots = \mu_{K}$ (vektor mean multivariat sama)
  >
  > $H_{1}:$ minimal ada perbedaan vektor mean antar klaster
  >
  > Keputusan uji didasarkan pada p-value dibandingkan tingkat signifikansi $\alpha$.

**5. Profiling dan Interpretasi**

  a. Mendeskripsikan karakter dominan tiap klaster menggunakan statistik ringkas (mean/median variabel pembentuk klaster), termasuk visual ringkas (bar/radar/boxplot per klaster).

  b. Menghitung proporsi kepemilikan AC per klaster.

  c. Menyusun indikasi risiko cooling deficit secara hati-hati, misalnya: klaster dengan total pengeluaran rendah dan pengeluaran listrik rendah, sementara proporsi kepemilikan AC rendah → diinterpretasi sebagai kelompok yang berpotensi mengalami keterbatasan adaptasi pendinginan.

![Gambar 6 Diagram Alur Metode Analisis](assets/gambar-6-diagram-alur.png)

**Gambar 6. Diagram Alur Metode Analisis**

> **Deskripsi Gambar 6.** Diagram alur (*flowchart*) hitam-putih bergaya standar, dibaca secara *boustrophedon* (baris 1 kiri→kanan, baris 2 kanan→kiri, baris 3 kiri→kanan). Bentuk elips dipakai untuk terminal (Mulai/Selesai), persegi panjang untuk proses, dan satu bentuk catatan (persegi dengan sudut terlipat) untuk masukan tambahan. Urutan simpulnya:
>
> 1. **Mulai** (elips, pojok kiri atas)
> 2. **Input Data**
> 3. **Pra-pengolahan data**
> 4. **Penetapan Peubah Pembentuk klaster (X1, X2, X3, X4)** — akhir baris pertama, panah lalu turun ke baris kedua
> 5. **Standarisasi Z-score** (baris kedua, paling kanan)
> 6. **Penentuan Jumlah Klaster (K)** — panah mengarah ke kiri
> 7. **K-Means Clustering** (baris kedua, paling kiri), panah lalu turun ke baris ketiga
> 8. **Uji Beda & Validasi Klaster** (baris ketiga, paling kiri)
> 9. **Profiling & Interpretasi**
> 10. **Selesai** (elips, pojok kanan bawah)
>
> Selain rantai utama tersebut, terdapat satu **bentuk catatan bertuliskan "Kepemilikan AC"** di bagian bawah gambar, dengan panah mengarah **ke atas** menuju kotak "Profiling & Interpretasi". Ini menegaskan lagi bahwa kepemilikan AC masuk hanya pada tahap profiling, bukan pada tahap pembentukan klaster.

---

## Daftar Pustaka

1. Kementerian PPN/Bappenas, *Visi Indonesia 2045*, 2019.
2. Kementerian PPN/Bappenas, *Rencana Pembangunan Jangka Menengah Nasional (RPJMN) 2025–2029*, 2024.
3. Kementerian PPN/Bappenas dan BPS, *Laporan Emisi Gas Rumah Kaca Nasional 2023*, 2025.
4. Kementerian Lingkungan Hidup dan Kehutanan, *Laporan Inventarisasi GRK dan MPV Tahun 2024*, 2024.
5. Kementerian Energi dan Sumber Daya Mineral, *Capaian Rasio Elektrifikasi Nasional Tahun 2024*, 2025.
6. Y. Takata, T. Kubota, S. N. Pratiwi, and H. A. Sani, "Classification of daily lifestyle patterns and their relationships with household energy consumption in apartment buildings: A case study of Indonesia," *Journal of Asian Architecture and Building Engineering*, 2025.
7. A. B. Christono and D. D. Putri, "Pengaruh konsumsi dan investasi terhadap Produk Domestik Regional Bruto (PDRB) di Provinsi DKI Jakarta periode 2010–2019," *Journal of Economics and Business UBS*, 2021.
8. A. Prastika, "Hubungan antara tingkat konsumsi energi listrik dengan pertumbuhan ekonomi di Indonesia," *Jurnal Ilmu Ekonomi (JIE)*, 2023.
9. Badan Pusat Statistik, *Press Release: Kondisi Kelas Menengah di Indonesia*, 2024.
10. S. Siswanto et al., "Spatio-temporal characteristics of urban heat island of Jakarta metropolitan," *Remote Sensing Applications: Society and Environment*, vol. 32, p. 101062, 2023.
11. Dinas Lingkungan Hidup DKI Jakarta, *Laporan Inventarisasi Emisi Gas Rumah Kaca dan Monitoring, Pelaporan, Verifikasi*, 2025.
12. Pemerintah Provinsi DKI Jakarta, *Peraturan Gubernur Nomor 90 Tahun 2021 tentang Rencana Pembangunan Rendah Karbon Daerah yang Berketahanan Iklim*, 2021.
13. K. Handayani, Y. Krozer, and T. Filatova, "Trade-offs between electrification and climate change mitigation: An analysis of the Java-Bali power system in Indonesia," *Applied Energy*, vol. 236, 2019.
14. D. Novianto, W. Gao, and S. Kuroki, "Review on people's lifestyle and energy consumption of Asian communities," *Energy and Power Engineering*, vol. 7, no. 10, 2015.
15. BPS Provinsi DKI Jakarta, *Provinsi DKI Jakarta dalam Angka 2025*, 2025.
16. M. Nazer and H. Handra, "Analisis konsumsi energi rumah tangga perkotaan di Indonesia: Periode tahun 2008 dan 2011," *Jurnal Ekonomi dan Pembangunan Indonesia*, vol. 16, no. 2, pp. 141–153, 2016, doi: 10.21002/jepi.v16i2.588.
17. PT PLN (Persero), *Statistik PLN 2024*, 2025.
18. T. Kubota, U. Surahman, and O. Higashi, "A comparative analysis of household energy consumption in Jakarta and Bandung," in *Proceedings of the 30th International PLEA Conference*, 2014.
19. M. Kartika and N. A. Hidayati, "Electrical demand analysis on households and industry in Indonesia," *Jurnal Ilmu Ekonomi Terapan*, vol. 9, no. 1, pp. 79–90, 2024, doi: 10.20473/jiet.v9.v1.53553.
20. E. De Cian, G. Falchetta, F. Pavanello, Y. Romitti, and I. S. Wing, "The impact of air conditioning on residential electricity consumption across world countries," *Journal of Environmental Economics and Management*, vol. 131, p. 103122, 2025, doi: 10.1016/j.jeem.2025.103122.
21. A. A. Woldeamanuel, "Determinants of household energy consumption in urban areas of Ethiopia," presented at the *XXVIII IUSSP International Population Conference*, Cape Town, South Africa, 2017.
22. S. S. S. S. Ali, M. R. Razman, A. Awang, M. R. M. Asyraf, M. R. Ishak, R. A. Ilyas, and R. J. Lawrence, "Critical determinants of household electricity consumption in a rapidly growing city," *Sustainability*, vol. 13, no. 8, p. 4441, 2021, doi: 10.3390/su13084441.
23. F. Pavanello et al., "Air-conditioning and the adaptation cooling deficit in emerging economies," *Nature Communications*, vol. 12, p. 6460, 2021, doi: 10.1038/s41467-021-26592-2.
24. S. Landau and I. Chis Ster, "Cluster analysis: Overview," in *Encyclopedia of Behavioral Statistics*. Elsevier Ltd., 2010.
25. A. Oktasandira, *Analisis Klaster Pelanggan Listrik Berdasarkan Perilaku Konsumsi di Kota Sukabumi Menggunakan Metode K-Means Clustering*, 2025.
26. B. van der Kroon, R. Brouwer, and P. J. H. van Beukering, "The energy ladder: Theoretical myth or empirical truth? Results from a meta-analysis," *Renewable and Sustainable Energy Reviews*, vol. 20, pp. 504–513, 2013.
27. G. Leach, "The energy transition," *Energy Policy*, vol. 20, no. 2, pp. 116–123, 1992.
28. R. A. Johnson and D. W. Wichern, *Applied Multivariate Statistical Analysis*. Pearson Education Limited, 2014.
29. B. Everitt and T. Hothorn, *An Introduction to Applied Multivariate Analysis with R*. Springer, 2011.
30. J. F. Hair, W. C. Black, B. J. Babin, and R. E. Anderson, *Multivariate Data Analysis*, 7th ed. Prentice Hall, 2009.
31. A. C. Rencher and W. F. Christensen, *Methods of Multivariate Analysis*, 3rd ed. Wiley, 2012.
32. C. Li, Y. Song, and N. Kazaa, "Urban form and household electricity consumption: A multilevel study," *Energy and Buildings*, vol. 158, pp. 181–193, 2018, doi: 10.1016/j.enbuild.2017.10.007.
33. H. Thomson, N. Simcock, S. Bouzarovski, and S. Petrova, "Energy poverty and indoor cooling: An overlooked issue in Europe," *Energy and Buildings*, 2019.
34. W. J. Conover, *Practical Nonparametric Statistics*. Wiley, 1999.
35. BPS Provinsi DKI Jakarta, *Laju Pertumbuhan (Y-on-Y) PDRB Provinsi DKI Jakarta Atas Dasar Harga Konstan Menurut Lapangan Usaha (Persen), 2025*. Jakarta: BPS Provinsi DKI Jakarta, 2025.
