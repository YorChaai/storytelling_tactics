# Storyteller Tactics Docs

Dokumen ini adalah knowledge/spec layer untuk aplikasi digital Storyteller Tactics.

Tujuan tahap ini:

- Memahami struktur kartu dan aset yang tersedia.
- Menentukan aturan gameplay digital sebelum coding.
- Memisahkan pengetahuan kartu dari implementasi aplikasi.
- Menyimpan keputusan produk, PRD, workflow, dan task secara bertahap.

## Struktur Dokumen

```text
docs/
├── 00_README.md
├── 01_SYSTEM/
├── 02_CARDS/
├── 03_RELATIONSHIPS/
├── 04_WORKFLOWS/
├── 05_EXAMPLES/
└── 06_APP/
```

## Sumber Saat Ini

- Desain lama: `docs/olddesignrefernse.md`
- Spesifikasi gameplay/app: `docs/Storyteller_Tactics_Complete_Specification.md`
- Ringkasan isi kartu/folder: `docs/isikartufolder.md`
- Aset gambar kartu: `asset/card/`

## Prinsip Produk

Aplikasi ini dipahami sebagai digitalisasi deck fisik, bukan AI storyteller di dalam gameplay.

AI digunakan untuk membantu proses development dan perancangan. Gameplay inti tetap berupa card engine:

- draw card
- shuffle
- session
- recipe
- three stories
- desert island cards
- history/reset

## Catatan Penting

- Ada 53 tactic cards.
- Ada 1 Story Building System.
- Total framework fungsional: 54.
- Page copyright/legal bukan kartu gameplay.
- Folder aset bernama `asset`, bukan `assets`.
