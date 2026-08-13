# Card Selection Workflow

Dokumen ini menjelaskan cara aplikasi memilih kartu.

## Random Mode

1. User memilih jumlah kartu.
2. Aplikasi membuat session baru.
3. Aplikasi mengambil kartu secara acak dari deck aktif.
4. Kartu yang sudah keluar masuk ke `drawn cards`.
5. Kartu tidak boleh keluar lagi dalam session yang sama.
6. User bisa reset session untuk mengocok ulang.

## Recipe Mode

1. User memilih recipe.
2. Aplikasi membuat subset deck berdasarkan recipe tersebut.
3. User menekan draw/next.
4. Aplikasi menampilkan tactic dari subset recipe.

## Desert Island Mode

1. Aplikasi memakai preset 7 kartu inti.
2. User melakukan draw dari 7 kartu tersebut.
3. Tidak ada duplicate dalam satu session.

## Rule

Default MVP: no duplicate card in one session.
