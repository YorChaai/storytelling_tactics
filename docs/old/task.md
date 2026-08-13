- `[/]` **Phase 1: Project Setup & Data Layer**
  - `[/]` Inisialisasi Vite + React project.
  - `[ ]` Konfigurasi Vanilla CSS (`index.css`) dengan desain estetik premium (glassmorphism, smooth gradients).
  - `[ ]` Buat `src/data/cards.json` berisi 54 mapping lengkap dengan `category`, `is_desert_island`, dan image path (mempertahankan typo `04. charater/`).
  - `[ ]` Buat `src/data/recipes.json` berisi definisi ke-7 Recipe.

- `[ ]` **Phase 2: Core Engine (State Management)**
  - `[ ]` Buat state `gameSession` menggunakan React Context atau custom hook.
  - `[ ]` Implementasi fitur: `drawRandom(n)`, `resetSession`, `getAvailableCards`, `getHistory`.
  - `[ ]` Pastikan logika *No Duplicate* berjalan sempurna.

- `[ ]` **Phase 3: UI Components**
  - `[ ]` Buat komponen `Card` yang memuat `.png` secara proporsional.
  - `[ ]` Tambahkan efek micro-interaction pada komponen `Card`.
  - `[ ]` Buat layout umum dan navigasi (Header, Sidebar/Menu).

- `[ ]` **Phase 4: Game Modes Integration**
  - `[ ]` Implementasi `Home` (Menu Utama).
  - `[ ]` Implementasi `Card Catalog` (Grid view per kategori).
  - `[ ]` Implementasi `Random Draw` mode.
  - `[ ]` Implementasi `Three Stories` mode (Generate 3 set independen atau sekuensial).
  - `[ ]` Implementasi `Recipe` mode.
  - `[ ]` Implementasi `Desert Island` mode (Subset 7 kartu).

- `[ ]` **Phase 5: Polish & Final Review**
  - `[ ]` Cek responsivitas di layar mobile dan desktop.
  - `[ ]` Pastikan semua 57 aset termuat dengan benar (termasuk non-gameplay jika dibutuhkan di cover/about).
  - `[ ]` Uji coba simulasi end-to-end.
