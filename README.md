# Project-TA

Naskah kerja Karya Ilmiah Tugas Akhir **Rafli Hibriansyah Siregar** (NIM 112313326), Program Studi Statistika Program Diploma III, Politeknik Statistika STIS.

**Judul:** Klasifikasi Rumah Tangga Berdasarkan Pola Konsumsi Listrik dan Karakteristik Sosial Ekonomi di DKI Jakarta
**Pembimbing:** Dr. Fitri Kartiasih
**Data:** mikrodata Susenas Maret 2025, Provinsi DKI Jakarta

Naskah resmi tetap dokumen `.docx`. Repo ini hanya menyimpan naskah kerja versi Markdown dan skrip olah data.

## Peta repo

```
Project-TA/
├── README.md                         ← dokumen ini
├── Draft TA Pasca SE.md              ← naskah kerja utama (tetap di root: disinkronkan ke Project claude.ai)
├── Script R Pasca SE Bimbingan.R     ← skrip olah Susenas (tetap di root: disinkronkan ke Project claude.ai)
├── Script R Gambar Bab I.R           ← skrip Gambar 1, 3, 4 (data publikasi ditulis di dalam skrip)
├── gambar/
│   ├── 0-halaman-awal/   logo-stis.png
│   ├── bab-1/            Gambar 1–4
│   ├── bab-2/            Gambar 5 (+ sumber draw.io)
│   ├── bab-3/            Gambar 6 (+ sumber draw.io)
│   └── bab-4/            Gambar 7–16
├── sumber-rujukan/                   ← bukti sumber resmi (BPS, Perpres, Bappenas, tarif PLN); lihat README di dalamnya
└── arsip/                            ← dokumen lama yang tidak dipakai lagi
```

| Dokumen | Isi | Status |
|---|---|---|
| `Draft TA Pasca SE.md` | Naskah kerja utama (halaman awal, Bab I–V, Daftar Pustaka, Lampiran) | Aktif |
| `Script R Pasca SE Bimbingan.R` | Skrip R olah Susenas; menghasilkan Tabel 3–9, Lampiran 1, dan Gambar 7–16 (disimpan di folder data lokal Rafli, lalu disalin ke `gambar/bab-4/`). Sejak Sesi BB juga menghasilkan grafik *centroid* pendamping Tabel 5 (`gambar-11a-centroid-klaster.png`, nomor final ditetapkan saat masuk naskah) dan tabel komponen utama siap tempel untuk Tabel 6 (`53e`) | Aktif |
| `Script R Gambar Bab I.R` | Skrip R Gambar 1, 3, dan 4; keluaran langsung ke `gambar/bab-1/` | Aktif |
| `gambar/` | Seluruh gambar naskah, dipisah per bab; nomor gambar tetap berurutan lintas bab | Aktif |
| `sumber-rujukan/` | Salinan dokumen resmi yang dikutip (jurnal dan buku tidak diunggah karena hak cipta) | Aktif |
| `arsip/Script last.R` | Skrip R versi sebelum revisi pascabimbingan | Arsip |
| `arsip/01-makalah-seminar-proposal.md` | Makalah seminar proposal | Arsip |
| `arsip/02-notula-seminar-proposal.md` | Notula seminar proposal | Arsip |
| `arsip/03-usulan-topik-tugas-akhir.md` | Usulan topik tugas akhir | Arsip |
| `arsip/Arsip_Terpadu_TA_STIS.md` | Gabungan pedoman akademik, surat, dan dokumen TA | Arsip |

> **Jangan memindah atau mengganti nama** `Draft TA Pasca SE.md` dan `Script R Pasca SE Bimbingan.R`: Project claude.ai membaca keduanya dari alamat root ini.

## Konvensi penulisan naskah kerja

- Gambar, tabel, dan lampiran dinomori berurutan lintas bab (Gambar 1, 2, …; Tabel 1, 2, …).
- Di bawah subbab hanya dipakai judul tebal tanpa nomor.
- Istilah mengikuti kamus istilah Polstat STIS; istilah asing ditulis miring.
- Persamaan ditulis dalam LaTeX dengan nomor dua digit per bab, misalnya (2.5).
- Daftar pustaka mengikuti format APA dan diurutkan alfabetis.
- Gambar disimpan di `gambar/bab-N/` sesuai bab tempat gambar dimuat, dengan nama `gambar-NN-deskripsi.png` (NN = nomor gambar dua digit); gambar yang belum tersedia ditandai dengan kotak keterangan.
- Tabel ditulis sebagai tabel Markdown, bukan gambar.
