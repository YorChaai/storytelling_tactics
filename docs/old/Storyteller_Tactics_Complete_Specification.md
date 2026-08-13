# Storyteller Tactics — Complete Gameplay & Application Specification

Benar. Saya tadi terlalu membawa konsepnya ke **AI storytelling assistant**, padahal yang kamu inginkan berbeda:

> **Kamu ingin membuat aplikasi digital yang mengubah kartu fisik Storyteller Tactics menjadi sistem permainan otomatis.**
>
> **AI dipakai untuk membuat aplikasinya, bukan menjadi pemain/storytelling coach di dalam aplikasinya.**

Itu jauh lebih sederhana.

Dari halaman yang kamu kirim, mekanisme dasarnya memang ada: **ambil kartu secara acak → sesuaikan cerita dengan tactic kartu → ambil kartu lagi → ulangi → lakukan tiga kali → bandingkan cerita yang dihasilkan.** Ada juga mode **Desert Island Cards** dan **Recipe Cards**. Jadi kita bisa mendigitalisasi mekanisme itu.

## Jadi sebenarnya "mainnya" bagaimana?

Bayangkan kartu fisikmu dipindahkan menjadi aplikasi.

### Mode 1 — Random Card

User menekan:

**DRAW CARD**

Aplikasi mengambil satu kartu secara random.

Misalnya:

```
┌─────────────────────────────┐
│                             │
│       🎬 MOVIE TIME         │
│                             │
│       [gambar kartu]        │
│                             │
│       STYLE                 │
│                             │
│   [Buka Kartu]              │
└─────────────────────────────┘

```

User kemudian membaca kartu tersebut dan **mengikuti instruksi kartu secara manual**.

Lalu tekan:

**DRAW AGAIN**

Aplikasi mengambil kartu kedua.

Misalnya:

```
MOVIE TIME
      ↓
MAN IN A HOLE

```

Kemudian kartu ketiga:

```
MOVIE TIME
      ↓
MAN IN A HOLE
      ↓
HERO & GUIDE

```

Selesai.

Aplikasi tidak perlu menghasilkan cerita.

Aplikasi hanya mengatakan:

> **"Inilah tiga kartu yang kamu dapatkan. Sekarang gunakan ketiganya untuk membuat cerita."**

Itu sudah sesuai dengan konsep permainan fisiknya.

---

# Bahkan kamu bisa bikin 3 mode

## MODE A — Pick Any Card

Ini mode paling bebas.

```
          START
            │
            ▼
      [ DRAW CARD ]
            │
            ▼
       Random Card
            │
            ▼
       User melihat
            │
       ┌────┴────┐
       │         │
    DRAW      FINISH
       │
       ▼
 Random Card
       │
       ▼
    DRAW
       │
       ▼
 Random Card
       │
       ▼
      DONE

```

Kamu bahkan bisa kasih pilihan:

```
Number of cards:
[ 1 ] [ 2 ] [ 3 ] [ 4 ] [ 5 ]

             [ DRAW ]

```

Kalau user memilih 3:

```
CARD 1
Hero & Guide

CARD 2
Movie Time

CARD 3
Rags to Riches

```

---

# MODE B — Three Stories

Ini justru menarik karena aturan dari kartu yang kamu punya menyebut:

> lakukan proses tiga kali dan lihat cerita mana yang paling kamu sukai.

Jadi aplikasinya bisa membuat:

```
             START
               │
       ┌───────┼───────┐
       ▼       ▼       ▼
    STORY 1  STORY 2  STORY 3
       │       │       │
       ▼       ▼       ▼
    Random   Random   Random
    Cards    Cards    Cards

```

Misalnya:

### Story 1

```
Hero & Guide
+
Movie Time
+
Downfall

```

### Story 2

```
Order & Chaos
+
Story Hooks
+
Rags to Riches

```

### Story 3

```
Social Proof
+
Man in a Hole
+
Show & Tell

```

Kemudian layar:

```
Which story do you prefer?

┌────────────┐
│  STORY 1   │
│ ⭐         │
└────────────┘

┌────────────┐
│  STORY 2   │
│ ⭐         │
└────────────┘

┌────────────┐
│  STORY 3   │
│ ⭐         │
└────────────┘

```

**Tidak ada AI yang menentukan mana yang bagus.**

User sendiri yang memilih.

---

# MODE C — Recipe

Nah ini berbeda.

Kamu memilih:

```
RECIPE

○ Stories that Sell
○ Stories that Motivate
○ Stories that Convince
○ Stories that Connect
○ Stories that Explain
○ Stories that Lead
○ Stories that Impress

```

Misalnya user memilih:

**Stories that Sell**

Aplikasi tidak random dari seluruh 53 kartu.

Ia menggunakan **kartu-kartu tactic yang sudah ditentukan oleh Recipe tersebut**.

Jadi:

```
Stories that Sell
        │
        ├── Card A
        ├── Card B
        ├── Card C
        ├── Card D
        └── Card E

```

Kemudian aplikasi bisa memberikan:

```
[ DRAW TACTIC ]

        ↓

Social Proof

```

Lalu:

```
[ NEXT ]

        ↓

Simple Sales Stories

```

dan seterusnya.

Recipe memang dimaksudkan sebagai kombinasi beberapa storytelling tactics untuk problem tertentu.

---

# MODE D — Desert Island

Ini juga sebenarnya gampang.

Di kartu yang kamu punya sudah tertulis tujuh kartu pilihan:

```
The Dragon & The City
Story Listening
Trust Me, I'm an Expert
Pitch Perfect
Man in a Hole
Movie Time
Story Bank

```

Aplikasi:

```
DESERT ISLAND

Choose your 7 essential cards

```

Atau lebih bagus:

```
        DESERT ISLAND

        🎴 7 CORE CARDS

[ The Dragon & The City ]

[ Story Listening ]

[ Trust Me, I'm an Expert ]

[ Pitch Perfect ]

[ Man in a Hole ]

[ Movie Time ]

[ Story Bank ]

```

Lalu user hanya bermain dengan tujuh kartu tersebut.

---

# Jadi backend-mu ternyata sederhana

Kamu **tidak membutuhkan Claude API.**

Tidak membutuhkan:

- RAG
- Vector database
- AI recommendation
- LLM
- prompt engineering
- AI storyteller

Untuk MVP bahkan **tidak perlu backend yang berat**.

Karena sebenarnya yang kamu bangun adalah:

> **Card Engine**

---

# Arsitekturnya jadi seperti ini

```
                 APPLICATION
                      │
          ┌───────────┴───────────┐
          │                       │
       FRONTEND               CARD ENGINE
          │                       │
          │                ┌──────┴──────┐
          │                │             │
          │             Cards         Rules
          │                │             │
          │                ▼             ▼
          │            53 Cards      Randomizer
          │                              │
          └──────────────────────────────┘

```

Kalau mau ada backend:

```
Flutter
   │
   │ HTTP
   ▼
FastAPI
   │
   ├── Card Service
   │
   ├── Random Engine
   │
   ├── Recipe Engine
   │
   └── Game Session
           │
           ▼
       SQLite

```

Itu saja.

---

# Database-nya juga tidak rumit

Misalnya tabel:

```
cards

```

| idnamecategoryimage |               |           |               |
| ------------------- | ------------- | --------- | ------------- |
| 1                   | Hero & Guide  | Character | hero.png      |
| 2                   | Movie Time    | Style     | movie.png     |
| 3                   | Man in a Hole | Structure | man\_hole.png |

Kemudian:

```
recipes

```

| idname |                       |
| ------ | --------------------- |
| 1      | Stories that Sell     |
| 2      | Stories that Motivate |
| 3      | Stories that Convince |

Kemudian hubungan:

```
recipe_cards

```

| recipecard        |                      |
| ----------------- | -------------------- |
| Stories that Sell | Social Proof         |
| Stories that Sell | Simple Sales Stories |
| Stories that Sell | Rags to Riches       |

Dan:

```
game_sessions

```

| sessionmodecards |        |            |
| ---------------- | ------ | ---------- |
| 001              | random | 12, 38, 48 |

---

# Randomizer-nya sebenarnya sangat sederhana

Misalnya 53 kartu.

```
cards = [
    Hero & Guide,
    Movie Time,
    Man in a Hole,
    ...
]

```

Ketika:

**DRAW**

backend melakukan:

```
random card
      ↓
ambil satu kartu
      ↓
masukkan ke session
      ↓
kirim ke frontend

```

Yang perlu kamu putuskan hanya satu hal:

### Apakah kartu boleh keluar lagi?

Saya menyarankan **tidak boleh dalam satu sesi**.

Contoh:

```
53 kartu

DRAW 1
→ Movie Time

sisa:
52 kartu

DRAW 2
→ Hero & Guide

sisa:
51 kartu

DRAW 3
→ Downfall

sisa:
50 kartu

```

Ini lebih masuk akal daripada:

```
DRAW 1 → Movie Time
DRAW 2 → Movie Time

```

karena user sedang membangun kombinasi tactic.

Jadi backend punya:

```
available_cards
drawn_cards

```

---

# Dan sekarang saya paham maksud "AI bikin aplikasinya"

Kamu bisa memakai **Claude Code / coding AI** hanya sebagai developer assistant.

Misalnya kamu kasih spesifikasi:

```
Buat aplikasi Storyteller Tactics.

Aplikasi tidak menggunakan AI/LLM untuk gameplay.

Fitur:
1. 53 cards
2. 8 categories
3. Random card
4. No duplicate card in one session
5. 3-card story challenge
6. Three Stories mode
7. Recipe mode
8. Desert Island mode
9. Card history
10. Reset session

Frontend:
Flutter

Backend:
FastAPI

Database:
SQLite

```

Claude kemudian **menulis kode aplikasi tersebut**.

Ketika aplikasinya sudah jadi:

```
USER
 │
 ▼
Flutter App
 │
 ▼
FastAPI
 │
 ▼
Random Card Engine
 │
 ▼
SQLite

```

**Tidak ada AI di jalur gameplay.**

AI hanya digunakan **oleh kamu saat development** untuk membantu membuat kode.

Itu jauh lebih sesuai dengan apa yang kamu jelaskan.

---

## Jadi folder kamu sekarang sebenarnya sudah tepat

Kamu sudah punya:

```
card/
├── 01. Recipe
├── 02. Concept
├── 03. Explore
├── 04. Character
├── 05. Function
├── 06. Structure
├── 07. Style
├── 08. Organise
├── docs
├── coverintroduction.png
├── Pickacard...anycard.png
└── copyrightlegal.png

```

**Jangan tambah knowledge-base AI macam-macam dulu.**

Yang perlu kita lakukan sekarang adalah mengubah folder tersebut menjadi **data aplikasi**:

```
IMAGE
   ↓
CARD METADATA
   ↓
DATABASE
   ↓
RANDOM ENGINE
   ↓
GAME SESSION
   ↓
FRONTEND

```

Dan menurut saya, **sebelum coding**, kita perlu menentukan satu hal dulu: **aturan gameplay digitalnya**—khususnya bagaimana Random mode, Three Stories, Recipe, Desert Island, jumlah draw, duplicate, shuffle, reset, dan penyimpanan session bekerja. Itu baru kemudian bisa diterjemahkan menjadi backend API dan frontend.