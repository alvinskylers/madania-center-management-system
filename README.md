# Madania Management

Sistem manajemen berbasis web untuk klinik terapi anak. Sistem ini mencakup seluruh alur pasien: pendaftaran keluarga, checkup diagnosa, paket terapi dan penjadwalan sesi, jurnal sesi, cuti terapis, permohonan reschedule, dan notifikasi. Setiap peran (admin, resepsionis, terapis, dan orang tua) memiliki ruang kerjanya masing-masing.

Antarmuka aplikasi menggunakan **bahasa Indonesia**.

> English version: [README.en.md](README.en.md)

## Daftar isi

- [Fitur](#fitur)
- [Aturan bisnis](#aturan-bisnis)
- [Teknologi](#teknologi)
- [Memulai](#memulai)
- [Akun bawaan](#akun-bawaan)
- [Konfigurasi](#konfigurasi)
- [Struktur proyek](#struktur-proyek)
- [Catatan penting](#catatan-penting)

## Fitur

Ada empat peran. Hak akses diatur berdasarkan awalan URL (`/admin/**`, `/receptionist/**`, `/therapist/**`, `/parent/**`).

| Peran | Yang dapat dilakukan |
|---|---|
| **Admin** | Mengelola pengguna, orang tua, pasien, terapis, dan resepsionis; menentukan jenis paket; membuat dan melihat paket terapi; memindahkan paket ke terapis lain; melihat seluruh jurnal dan checkup; menyetujui atau menolak permohonan cuti dan reschedule; menjadwalkan ulang sesi secara langsung; melihat utilisasi terapis. |
| **Resepsionis** | Mendaftarkan orang tua dan pasien; menjadwalkan checkup; membuat paket terapi; memindahkan paket ke terapis lain; meninjau permohonan cuti dan reschedule; menjadwalkan ulang sesi secara langsung dari kalender klinik. |
| **Terapis** | Melihat jadwal dan pasien sendiri; menuntaskan sesi dan menulis jurnal terapi; menjalankan checkup dan mencatat hasil diagnosa; mengajukan cuti; mengajukan reschedule. |
| **Orang tua** | Melihat jadwal dan perkembangan anak; membaca jurnal sesi dan memberi komentar; mengajukan reschedule untuk sesi yang akan datang. |

Sorotan fitur:

- **Checkup.** Terapis mendiagnosa pasien baru, keputusan orang tua (lanjut terapi atau tidak) dicatat, lalu paket terapi dapat dibuat dari checkup tersebut.
- **Paket terapi.** Jenis paket menentukan jumlah total sesi dan sesi per minggu (data awal: *Paket Ringan* 8/2, *Paket Reguler* 12/3, *Paket Intensif* 20/5). Saat paket dibuat, seluruh rangkaian sesi dibuat otomatis sesuai hari dan jam yang dipilih.
- **Jurnal terapi.** Setiap sesi yang tuntas memiliki jurnal (tujuan, catatan, perkembangan, suasana hati, rekomendasi) yang dapat dibaca dan dikomentari orang tua.
- **Cuti terapis.** Terapis mengajukan cuti; setelah admin atau resepsionis menyetujui, sesi yang terdampak dipindahkan ke waktu baru yang dipilih staf.
- **Pemindahan paket ke terapis lain.** Sisa sesi sebuah paket dipindahkan ke terapis lain, dengan pengecekan bentrok yang menampilkan semua benturan sebelum perubahan disimpan. Riwayat tetap tercatat pada terapis awal.
- **Permohonan reschedule.** Orang tua dan terapis mengajukan waktu baru; staf menyetujui atau menolaknya melalui antrean permohonan.
- **Reschedule langsung oleh staf.** Untuk keadaan darurat (misalnya kabar kecelakaan lewat telepon), admin dan resepsionis dapat mengklik sesi pada kalender jadwal dan langsung memindahkannya dengan alasan yang wajib diisi. Lihat [Aturan bisnis](#aturan-bisnis).
- **Notifikasi.** Notifikasi di dalam aplikasi untuk permohonan, persetujuan, penolakan, pemindahan terapis, dan komentar jurnal.
- **Utilisasi terapis.** Tampilan admin untuk melihat seberapa padat jadwal setiap terapis.
- **Kalender.** Tampilan FullCalendar dengan nama hari dan bulan dalam bahasa Indonesia.

## Aturan bisnis

**Penjadwalan (semua sesi)**
- Klinik buka pukul **08:00 – 17:00**; satu sesi berdurasi satu jam, sehingga waktu mulai paling lambat pukul 16:00.
- Terapis tidak boleh memiliki jadwal ganda; sesi `SCHEDULED` yang saling tumpang tindih ditolak.
- Seorang pasien tidak boleh memiliki paket aktif yang tumpang tindih.

**Permohonan reschedule (orang tua dan terapis)**
- Hanya sesi berstatus `SCHEDULED` yang dapat dijadwalkan ulang.
- Permohonan harus diajukan paling lambat **3 hari** sebelum tanggal sesi (dapat diatur, lihat di bawah). Setelah batas itu, keluarga diminta menghubungi klinik.
- Waktu baru harus berada pada tanggal yang berbeda dari jadwal saat ini dan tidak boleh di masa lalu.
- Hanya satu permohonan tertunda per sesi.

**Reschedule langsung (admin dan resepsionis)**
- Tidak terikat batas waktu pemberitahuan dan aturan tanggal berbeda, sehingga pemindahan pada hari yang sama diperbolehkan.
- Tetap diberlakukan: sesi berstatus `SCHEDULED` dan bukan dari hari sebelumnya, waktu baru tidak di masa lalu dan tidak sama dengan waktu saat ini, berada dalam jam operasional, serta tidak bentrok dengan sesi lain milik terapis.
- **Alasan wajib diisi** (maksimal 200 karakter).
- Pemindahan dicatat sebagai reschedule yang disetujui atas nama staf yang melakukannya, sehingga muncul di riwayat reschedule biasa. Permohonan tertunda untuk sesi tersebut ditutup sebagai digantikan.
- Orang tua dan terapis diberi notifikasi berisi waktu baru beserta alasannya.

## Teknologi

- **Java 21**, **Spring Boot 3.5** (Web, Data JPA, Security, Validation)
- **PostgreSQL 16**
- Templat sisi server **JTE** (dikompilasi lebih dulu pada build produksi)
- UI **Metronic**, Bootstrap 5, FullCalendar 5, flatpickr
- **Lombok**, **spring-dotenv** (memuat `.env`)
- **Docker / Docker Compose**, pgAdmin untuk memeriksa basis data

## Memulai

### Prasyarat

- JDK 21 dan PostgreSQL (menjalankan secara lokal), **atau** Docker dengan Docker Compose (menjalankan dalam kontainer)

### 1. Buat berkas `.env`

Di direktori utama proyek, buat berkas `.env` dengan kunci berikut (isi nilainya sesuai keinginan Anda):

```env
POSTGRES_DB=
POSTGRES_USER=
POSTGRES_PASSWORD=
PGADMIN_EMAIL=
PGADMIN_PASSWORD=
```

Jangan meng-commit berkas ini.

### 2a. Jalankan dengan Docker (aplikasi + basis data + pgAdmin)

```bash
docker compose up --build
```

| Layanan | URL / port |
|---|---|
| Aplikasi | http://localhost:8080 |
| PostgreSQL | `localhost:5432` |
| pgAdmin | http://localhost:5050 |

### 2b. Jalankan secara lokal

Jalankan PostgreSQL, buat basis data dengan nama yang sama seperti `POSTGRES_DB`, lalu:

```bash
./mvnw spring-boot:run
```

Di Windows gunakan `mvnw.cmd spring-boot:run`. Aplikasi terhubung ke `localhost:5432` memakai nilai di `.env`. Pada mode pengembangan lokal, JTE memuat ulang templat dari `src/main/jte` tanpa perlu memulai ulang aplikasi.

### Membuat berkas jar

```bash
./mvnw package -DskipTests
java -jar target/management-0.0.1-SNAPSHOT.jar
```

## Akun bawaan

Saat pertama kali dijalankan, seeder membuat admin, resepsionis, beberapa terapis, orang tua, pasien, paket, dan jurnal contoh agar aplikasi langsung dapat didemokan. Semua akun bawaan menggunakan kata sandi **`password`**.

| Peran | Email |
|---|---|
| Admin | `admin@madania.com` |
| Resepsionis | `receptionist@madania.com` |
| Terapis | `nadia.putri@madania.com`, `rizky.hidayat@madania.com`, `amelia.wijaya@madania.com` |
| Orang tua | `budi.santoso@gmail.com`, `siti.rahayu@gmail.com`, `ahmad.fauzi@gmail.com`, `dewi.lestari@gmail.com` |

Email dan kata sandi admin serta resepsionis dapat diganti melalui **variabel lingkungan proses** `ADMIN_EMAIL`, `ADMIN_PASSWORD`, `RECEPTIONIST_EMAIL`, dan `RECEPTIONIST_PASSWORD`. Variabel ini dibaca langsung dari lingkungan sistem, jadi menuliskannya hanya di `.env` tidak cukup. **Ganti semua kata sandi bawaan sebelum dipakai di luar keperluan demo.**

## Konfigurasi

Diatur di `src/main/resources/application.yaml`:

| Properti | Nilai awal | Keterangan |
|---|---|---|
| `app.timezone` | `Asia/Makassar` | Zona waktu klinik yang dipakai aturan penjadwalan. Jika kosong, memakai zona waktu server. |
| `app.reschedule.min-notice-days` | `3` | Batas minimal hari pemberitahuan untuk permohonan reschedule orang tua/terapis. |
| `gg.jte.development-mode` | `true` | Memuat ulang templat secara langsung. Docker mengubahnya menjadi `false` dan memakai templat yang sudah dikompilasi. |

Seeder berjalan berurutan: admin, jenis paket dan resepsionis, terapis, orang tua, pasien, paket terapi, jurnal.

## Struktur proyek

```
src/main/
├── java/com/madania/management/
│   ├── config/         Keamanan, aturan penjadwalan, atribut model, seeder
│   ├── controller/     admin/, receptionist/, therapist/, parent/ dan controller bersama
│   ├── service/        Logika bisnis (penjadwalan, reschedule, cuti, pemindahan paket, ...)
│   ├── entity/         Entitas JPA
│   ├── repository/     Repository Spring Data
│   ├── dto/            Objek formulir dan permintaan
│   └── enums/          Peran, status, jenis terapi, penilaian suasana hati
├── jte/
│   ├── layout/         Tata letak dasar
│   ├── components/     Bagian templat yang dipakai ulang (sidebar, navbar, modal, baris)
│   └── pages/          Templat dikelompokkan per peran
└── resources/
    ├── application*.yaml
    └── static/         CSS, JS (js/custom/ berisi skrip milik aplikasi), plugin, media
```

## Catatan penting

- **Profil dev membuat ulang basis data setiap kali aplikasi dijalankan.** `application-dev.yaml` menggunakan `ddl-auto: create`, yang menghapus dan membangun ulang tabel (lalu menjalankan seeder lagi) setiap aplikasi dimulai. Ini cocok untuk demo, tetapi jangan diarahkan ke data yang ingin dipertahankan. Docker Compose juga memakai profil `dev`. Untuk penggunaan sebenarnya, gunakan profil produksi terpisah dengan pengaturan yang tidak merusak data (`validate` atau `update`, atau alat migrasi).
- **Profil dev sengaja dibuat sangat rinci.** Profil ini menampilkan stack trace lengkap pada respons galat serta mencatat SQL dan log debug. Matikan semuanya di produksi.
- Kredensial bawaan bersifat publik; lihat [Akun bawaan](#akun-bawaan).
- Saat ini hanya ada uji dasar (`ManagementApplicationTests`). Aturan penjadwalan di `RescheduleNoticePolicy` tidak bergantung pada Spring maupun JPA sehingga mudah diuji unit dengan `Clock` tetap.