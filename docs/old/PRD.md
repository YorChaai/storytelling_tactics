# Product Requirements Document (PRD)
## Storyteller Tactics - Digital Card Engine MVP

### 1. Product Overview
Aplikasi ini adalah versi digital dari deck fisik "Storyteller Tactics". Aplikasi dirancang sebagai "Card Engine" yang memfasilitasi pengambilan kartu secara acak dan terstruktur sesuai dengan mode permainan aslinya. 

**PENTING**: Aplikasi ini BUKAN AI Storyteller. AI sama sekali tidak dilibatkan dalam gameplay MVP (tidak ada RAG, LLM, atau auto-generation cerita). Pengguna tetap merangkai cerita mereka sendiri berdasarkan kartu yang didapat.

### 2. Core Features (MVP)
1. **Card Catalog**: Menampilkan seluruh 54 framework kartu (53 tactic + 1 system) berdasarkan kategori.
2. **Random Draw Mode**: Mengambil 1 hingga sekian kartu secara acak ("Pick Any Card").
3. **Three Stories Mode**: Menghasilkan 3 kombinasi (masing-masing 3 kartu) untuk membandingkan 3 alur cerita.
4. **Recipe Mode**: Mode spesifik yang menampilkan kartu berdasarkan template "Recipe" tertentu (contoh: *Stories that Sell*).
5. **Desert Island Mode**: Bermain hanya dengan 7 kartu inti (pemula / quick play).
6. **Session & Rules**: 
   - Tidak ada kartu duplikat dalam satu sesi (kartu yang sudah di-draw tidak akan keluar lagi).
   - Menyimpan history kartu yang ditarik dalam sesi berjalan.
   - Fitur "Reset Session" untuk mengembalikan kartu ke deck utuh.
7. **Card Detail**: Menampilkan nama kartu, kategori, gambar PNG kartu, dan status khusus (misal: apakah bagian dari Desert Island).

### 3. Out of Scope (Non-MVP)
- AI Story generation atau AI recommendations.
- RAG / Vector Database.
- Sistem Akun / Cloud sync.
- Deck kustom oleh user.

### 4. Data Architecture
- **Cards**: 54 item (metadata: id, nama, kategori, image path, is_desert_island).
- **Categories**: 8 kategori taktik + 1 sistem.
- **Recipes**: 7 resep dengan daftar kartu taktik yang direkomendasikan.
- **Sessions**: State manager untuk melacak `available_cards` dan `drawn_cards`.

### 5. Tech Stack Proposal
- **Frontend**: Web App (Vite + React) untuk interaktivitas mulus.
- **Styling**: Vanilla CSS (seusai guideline sistem untuk fleksibilitas dan estetik).
- **Backend/Database**: Tidak perlu backend khusus untuk MVP. Semua metadata (JSON) dan logic (Session state di LocalStorage) bisa berjalan di sisi klien secara statis (Client-side only) agar cepat dan ringan.
