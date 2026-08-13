# Card Taxonomy

Dokumen ini menjelaskan struktur metadata yang akan dipakai untuk memahami kartu sebelum masuk ke implementasi.

## Minimal Metadata

Setiap kartu sebaiknya punya data:

- `id`
- `name`
- `category`
- `asset_path`
- `purpose`
- `when_to_use`
- `when_not_to_use`
- `input`
- `process`
- `output`
- `questions`
- `related_cards`
- `recommended_next_cards`
- `example`

## Metadata Untuk MVP Card Engine

Untuk MVP tanpa AI gameplay, minimal cukup:

- `id`
- `name`
- `category`
- `asset_path`
- `is_desert_island`
- `recipe_membership`
- `sort_order`

## Metadata Untuk Fase Lanjut

Jika nanti aplikasi berkembang menjadi recommendation assistant, tambahkan:

- problem tags
- user goals
- compatible cards
- suggested sequence
- examples
- prompts/questions

## Keputusan Saat Ini

MVP difokuskan ke card engine, bukan RAG/vector database/LLM gameplay.
