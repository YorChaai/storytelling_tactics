# Implementation Plan

## Goal Description
Membangun MVP dari aplikasi Storyteller Tactics berupa Digital Card Engine berbasis Web. Aplikasi ini akan mengelola pengacakan kartu (tanpa duplikasi dalam satu sesi), menampilkan gambar kartu, dan menyediakan berbagai mode (Random, Three Stories, Recipe, Desert Island).

Aplikasi akan dibangun sepenuhnya di sisi klien (Client-Side) menggunakan **React + Vite** dengan styling **Vanilla CSS** sesuai instruksi sistem, dan state disimpan di `LocalStorage`. Pendekatan ini menghilangkan kompleksitas backend sambil tetap memenuhi semua requirement MVP.

## User Review Required
> [!IMPORTANT]
> **Tech Stack Decision**
> Karena di dalam spesifikasi lama ada penyebutan `Flutter + FastAPI + SQLite`, saya mengusulkan untuk **MVP ini dibuat sebagai Web App (React + Vanilla CSS)** dengan state lokal. Ini akan jauh lebih cepat dikembangkan dan langsung dapat digunakan di browser tanpa setup backend. Apakah Anda setuju dengan stack React/Web ini?

> [!WARNING]
> **Metadata Kartu (Data Layer)**
> Saya akan membuat file JSON lokal (misal: `data/cards.json`) yang mereferensikan aset PNG yang ada di folder `asset/card/...`. Folder typo `04. charater/` akan tetap dipertahankan di *path string* sesuai instruksi Anda.

## Proposed Changes

---

### 1. Foundation & Setup
Inisialisasi project dan manajemen aset.
#### [NEW] `package.json` & vite config (React + Vite template)
#### [NEW] `index.css` (Implementasi Vanilla CSS tokens untuk dark mode / premium look)
#### [NEW] `src/data/cards.json` (Memetakan 54 aset menjadi metadata terstruktur)
#### [NEW] `src/data/recipes.json` (Memetakan 7 Recipe ke list ID kartu taktik yang relevan)

---

### 2. Core Engine & State Management
Logika permainan tanpa AI.
#### [NEW] `src/hooks/useGameSession.js` 
Hook untuk mengelola `availableCards`, `drawnCards`, dan `history`. Termasuk fungsi `drawCard(n)` dan `resetSession()`. State akan di-persist ke `localStorage`.

---

### 3. UI Components
Komponen antarmuka yang modern dan dinamis.
#### [NEW] `src/components/Card.jsx` (Komponen untuk merender gambar PNG kartu dengan efek hover 3D / micro-animations)
#### [NEW] `src/components/Modal.jsx` (Modal untuk Card Detail)
#### [NEW] `src/components/Deck.jsx` (Visualisasi sisa kartu)

---

### 4. Pages / Modes
Halaman untuk tiap mode permainan.
#### [NEW] `src/pages/Home.jsx` (Menu navigasi ke berbagai mode)
#### [NEW] `src/pages/Catalog.jsx` (Menampilkan semua 54 kartu dikelompokkan per kategori)
#### [NEW] `src/pages/RandomDraw.jsx` (Mode Pick Any Card & History)
#### [NEW] `src/pages/ThreeStories.jsx` (Men-generate 3 set @ 3 kartu)
#### [NEW] `src/pages/RecipeMode.jsx` (Memilih dari 7 Recipe -> Menampilkan subset kartu)
#### [NEW] `src/pages/DesertIsland.jsx` (Bermain hanya dengan 7 kartu inti)

## Verification Plan

### Automated Tests
- Menjalankan linter untuk memastikan tidak ada error syntax di React.
- Memastikan build Vite berhasil.

### Manual Verification
- Menjalankan local dev server (`npm run dev`).
- Menguji alur `Random Draw`: Menarik kartu -> Cek apakah kartu hilang dari sisa deck -> Reset deck -> Cek apakah kartu kembali penuh.
- Menguji visualisasi 57 PNG aset, memastikan path typo `04. charater/` tetap berjalan tanpa *broken image*.
- Verifikasi estetik Vanilla CSS (hover effect, premium look, layout responsif).
