# USULAN TOPIK TUGAS AKHIR

> *Sumber berkas:* `112313326_Rafli_Hibriansyah_Siregar_Proposal_Tugas_Akhir_Revisi_2.docx`

**Nama/NIM:** Rafli Hibriansyah Siregar / 112313326

**Program Studi/Program:** Statistika / Program Diploma III

---

## Proposal Alternatif 3:

### Klasifikasi Pola Konsumsi Listrik Rumah Tangga Berdasarkan Karakteristik Sosial Ekonomi di DKI Jakarta

---

## Latar Belakang Masalah

Pencapaian Visi Indonesia Emas 2045 melalui pembangunan SDM unggul dan lingkungan berkelanjutan merupakan prioritas dalam RPJMN 2025–2029. DKI Jakarta, sebagai pusat ekonomi nasional, memiliki intensitas konsumsi listrik rumah tangga yang sangat tinggi, mencapai rata-rata 3.285,09 kWh/pelanggan. Angka ini melampaui dua kali lipat rata-rata nasional yang hanya sebesar 1.540,66 kWh/pelanggan.

Fenomena ini dipicu oleh pertumbuhan kelas menengah dan dampak *Urban Heat Island* (UHI) yang mendorong penggunaan penyejuk udara (AC) secara masif sebagai strategi adaptasi termal. Namun, terdapat heterogenitas pola konsumsi yang lebar antar-rumah tangga. Kebijakan efisiensi energi yang bersifat umum (*one-size-fits-all*) tidak lagi efektif karena faktor penentu konsumsi bervariasi antara kelompok berdaya rendah dan tinggi. Oleh karena itu, diperlukan identifikasi profil konsumen menggunakan Analisis Klaster untuk memetakan tipologi gaya hidup energi rumah tangga di Jakarta guna merumuskan strategi manajemen sisi permintaan (*demand-side management*) yang tepat sasaran.

---

## Tujuan dan Metode Analisis

Tujuan dari penelitian ini adalah:

1. Menggambarkan profil konsumsi listrik dan kondisi sosial ekonomi rumah tangga di Provinsi DKI Jakarta.
2. Mengidentifikasi dan mengelompokkan (klasterisasi) rumah tangga di Provinsi DKI Jakarta ke dalam beberapa tipologi homogen berdasarkan pola konsumsi listrik dan karakteristik sosial ekonomi.
3. Menganalisis perbedaan karakteristik sosial ekonomi yang paling signifikan dalam membedakan antar-kelompok konsumsi guna menentukan faktor pembeda utama dari setiap klaster yang terbentuk.

Penelitian ini menggunakan pendekatan kuantitatif multivariat dengan tahapan sebagai berikut:

- **Pra-pemrosesan Data:** Pembersihan data, penanganan pencilan (*outlier*), dan standarisasi variabel menggunakan transformasi **Z-Score** untuk menyamakan skala pengukuran.
- **Analisis Klaster:** Menggunakan algoritme **K-Means**. Penentuan jumlah klaster optimal dilakukan melalui **Metode Elbow** dan divalidasi menggunakan **Silhouette Coefficient**.
- **Profiling & Validasi:** Melakukan interpretasi karakteristik tiap klaster dan menguji signifikansi perbedaan antar-kelompok menggunakan **Uji ANOVA** atau **Kruskal-Wallis**.
- **Perangkat Lunak:** Pengolahan data dilakukan menggunakan **Microsoft Excel** dan **R Studio**.

---

## Ketersediaan Data

Data yang digunakan merupakan data sekunder tingkat rumah tangga.

- **Sumber Data:** Data sekunder mikro **Susenas Maret 2025** (Modul Kependudukan, Perumahan, dan Konsumsi) dari Badan Pusat Statistik.
- **Wilayah:** Provinsi DKI Jakarta.
- **Unit Observasi:** Rumah Tangga.
- **Variabel:** Pengeluaran Listrik, Pengeluaran Per Kapita (Kekayaan), Jumlah ART, Pendidikan KRT, Luas Lantai, Daya Terpasang, dan Kepemilikan AC.

---

## Daftar Pustaka

1. Agung P.S, P., Hartono, D., & Awirya, A. A. (2017). Pengaruh urbanisasi terhadap konsumsi energi dan emisi CO2: Analisis provinsi di Indonesia. *Jurnal Ekonomi Kuantitatif Terapan*.
2. Ali, S., et al. (2021). *Critical determinants of REC in Malaysia*. Stepwise Regression Analysis.
3. Antoniucci, V., et al. (2021). Urban density and household-electricity (Italy). *Journal of Energy*.
4. De Cian, E., Falchetta, G., Pavanello, F., Romitti, Y., & Wing, I. S. (2025). The impact of air conditioning on residential electricity consumption across world countries. *Journal of Environmental Economics and Management*, 131, 103122. <https://doi.org/10.1016/j.jeem.2025.103122>
5. Hair, J. F., Black, W. C., Babin, B. J., & Anderson, R. E. (2018). *Multivariate Data Analysis* (8th ed.). Cengage Learning.
6. Indrawanto, D. (2025). Integration of sustainable architecture principles in vertical housing design in high-density urban areas. *The Journal of Academic Science*, 2(2), 461-469.
7. Johnson, R. A., & Wichern, D. W. (2014). *Applied Multivariate Statistical Analysis* (6th ed.). Pearson Education Limited.
8. Kubota, T., Surahman, U., & Higashi, O. (2014). A comparative analysis of household energy consumption in Jakarta and Bandung. *Proceedings of the 30th International PLEA Conference*, Ahmedabad, India.
9. Oktasandira, A., et al. (2025). *Cluster analysis of electricity customers in Sukabumi using K-Means clustering*.
10. Pasaribu, N. G., Wulandari, F. W., & Wulandari, S. P. (2024). Pengelompokan indikator kemiskinan di Kabupaten/Kota Aceh tahun 2021 menggunakan analisis klaster. *Bilangan: Jurnal Ilmiah Matematika, Kebumian dan Angkasa*, 2(6).
11. Pavanello, F., et al. (2021). Air-conditioning and the adaptation cooling deficit in emerging economies. *Nature Communications*, 12, 6460. <https://doi.org/10.1038/s41467-021-26592-2>
12. Siswanto, S., et al. (2023). Spatio-temporal characteristics of urban heat Island of Jakarta metropolitan. *Remote Sensing Applications: Society and Environment*, 32, 101062. <https://doi.org/10.1016/j.rsase.2023.101062>
13. Takata, Y., Kubota, T., Pratiwi, S. N., & Sani, H. A. (2025). Classification of daily lifestyle patterns and their relationships with household energy consumption in apartment buildings: A case study of Indonesia. *Journal of Asian Architecture and Building Engineering*.

---

## Penelitian yang Terkait/Relevan

1. **Takata dkk. (2025)** mengklasifikasikan gaya hidup harian di apartemen Indonesia menggunakan *Hierarchical Clustering*. Hasilnya menunjukkan pola aktivitas harian, khususnya durasi di rumah, adalah faktor kunci konsumsi energi.
2. **Oktasandira dkk. (2025)** melakukan analisis klaster pelanggan listrik di Sukabumi menggunakan metode *K-Means* (*Elbow* & *Silhouette*). Penelitian ini berhasil mengidentifikasi 3 klaster optimal untuk kebijakan efisiensi wilayah.
3. **Kubota dkk. (2014)** membandingkan konsumsi energi di Jakarta dan Bandung. Hasil menunjukkan konsumsi Jakarta secara signifikan lebih tinggi dengan kepemilikan AC sebagai determinan utama.
4. **De Cian dkk. (2025)** menganalisis dampak AC terhadap meteran listrik secara global. Ditemukan bahwa kepemilikan AC meningkatkan konsumsi listrik rata-rata 36-57%.
5. **Pasaribu dkk. (2024)** mengelompokkan indikator kemiskinan di Aceh menggunakan analisis klaster. Hasilnya membuktikan bahwa metode *K-Means* lebih tajam dalam membagi sub-kelompok pada data bersumber dari BPS dibandingkan metode hierarki.

---

**Dosen Pembimbing yang diusulkan: Dr. Fitri Kartiasih, S.S.T., S.E., M.Si.**

> Jakarta, 23 Oktober 2025
>
> ttd
>
> ![Tanda tangan Rafli Hibriansyah Siregar](assets/usulan-tanda-tangan.png)
>
> Rafli Hibriansyah Siregar

> **Deskripsi gambar tanda tangan.** Pindaian tanda tangan tulisan tangan berwarna abu-abu gelap kebiruan di atas latar transparan, berorientasi vertikal (lebih tinggi daripada lebar). Bentuknya berupa coretan cepat: sebuah lengkung tebal menyerupai kait di bagian atas, disusul rangkaian goresan zig-zag rapat di tengah, lalu satu goresan diagonal panjang yang memanjang ke arah kanan bawah sebagai ekor. Tidak ada teks yang terbaca di dalam gambar. Ukuran tampil di dokumen ± 1,99 cm × 5,05 cm.
