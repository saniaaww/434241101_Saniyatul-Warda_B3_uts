# 📱 E-Ticketing Helpdesk Mobile

Aplikasi **E-Ticketing Helpdesk Mobile** merupakan aplikasi mobile berbasis **Flutter** yang dikembangkan untuk mempermudah proses pelaporan, monitoring, dan penyelesaian tiket layanan IT maupun layanan lainnya. Aplikasi ini menerapkan konsep **Client-Server** dengan komunikasi data menggunakan **REST API Laravel** dan penyimpanan data pada **database MySQL**.

Project ini dibuat sebagai **Ujian Akhir Semester (UAS) Semester 4 Praktikum Mobile Application** Program Studi **DIV Teknik Informatika** Universitas Airlangga.

---

# 🚀 Teknologi yang Digunakan

## Frontend
- Flutter
- Dart
- Material Design
- HTTP Package

## Backend
- Laravel REST API
- PHP

## Database
- MySQL
- MySQL Workbench

---

# 🏗️ Arsitektur Sistem

```text
+-----------------------+
|   Flutter Mobile App  |
+-----------+-----------+
            |
            | HTTP Request
            |
+-----------v-----------+
|   Laravel REST API    |
+-----------+-----------+
            |
            |
+-----------v-----------+
|    MySQL Database     |
+-----------------------+
```

Flutter bertugas sebagai aplikasi client yang digunakan oleh pengguna, Helpdesk, dan Admin. Seluruh proses bisnis dijalankan pada backend Laravel melalui REST API, sedangkan seluruh data disimpan pada database MySQL.

---

# 📂 Repository

## 📱 Flutter Mobile

Repository ini berisi source code aplikasi mobile Flutter.

Repository:

> https://github.com/saniaaww/434241101_Saniyatul-Warda_B3_uts

---

## ⚙️ Laravel REST API

Backend aplikasi dikembangkan menggunakan Laravel sebagai REST API.

Repository:

> https://github.com/saniaaww/helpdesk_ticket_API

---

# 🗄️ Database

Database menggunakan **MySQL** dan dikelola menggunakan **MySQL Workbench**.

File database telah disediakan pada repository backend dengan nama:

```text
helpdesk_ticket.sql
```

Database tersebut dapat langsung di-import melalui MySQL Workbench maupun phpMyAdmin sebelum menjalankan aplikasi.

Seluruh data aplikasi seperti akun pengguna, tiket, komentar, histori tiket, dan notifikasi disimpan pada database tersebut.

---

# 📥 Download APK

Versi aplikasi Android dapat langsung diunduh melalui menu **GitHub Releases**.

Release:

https://github.com/saniaaww/434241101_Saniyatul-Warda_B3_uts/releases

File yang tersedia:

```
app-release.apk
```

Setelah mengunduh APK, aktifkan izin **Install Unknown Apps** pada perangkat Android apabila diperlukan, kemudian lakukan instalasi aplikasi.

---

# 👥 Role Pengguna

Aplikasi memiliki tiga jenis pengguna.

## 👤 User

User merupakan pelapor tiket.

Fitur:

- Login
- Dashboard
- Membuat Ticket
- Upload Lampiran
- Melihat Daftar Ticket
- Melihat Detail Ticket
- Melihat Tracking Ticket
- Memberikan Komentar
- Melihat Riwayat Ticket
- Menerima Notifikasi

---

## 🛠️ Helpdesk

Helpdesk bertugas menangani tiket yang diberikan oleh Admin.

Fitur:

- Login
- Dashboard
- Melihat Ticket yang di-assign
- Melihat Detail Ticket
- Update Status Ticket
- Memberikan Komentar
- Menutup Ticket
- Melihat Statistik Ticket

**Catatan:**

Helpdesk **hanya dapat melihat tiket yang telah di-assign kepada dirinya sendiri**, sehingga setiap Helpdesk tidak dapat melihat tiket milik Helpdesk lainnya.

---

## 👨‍💼 Admin

Admin memiliki hak akses penuh terhadap sistem.

Fitur:

- Login
- Dashboard
- Melihat Seluruh Ticket
- Membuat Ticket
- Assign Ticket ke Helpdesk
- Update Status Ticket
- Melihat Detail Ticket
- Melihat Riwayat Ticket
- Kelola User
- Tambah User
- Edit User
- Hapus User
- Melihat Statistik Sistem

---

# 📡 REST API

Komunikasi antara Flutter dan Laravel menggunakan REST API.

Endpoint utama yang digunakan antara lain:

| Method | Endpoint | Keterangan |
|---------|----------|------------|
| POST | `/api/login` | Login |
| GET | `/api/dashboard` | Dashboard |
| GET | `/api/tickets` | Daftar Ticket |
| POST | `/api/tickets` | Membuat Ticket |
| GET | `/api/tickets/{id}` | Detail Ticket |
| POST | `/api/tickets/{id}/assign` | Assign Helpdesk |
| POST | `/api/tickets/{id}/status` | Update Status Ticket |
| GET | `/api/helpdesk` | Daftar Helpdesk |
| GET | `/api/users` | Daftar User |
| POST | `/api/users` | Tambah User |
| PUT | `/api/users/{id}` | Edit User |
| DELETE | `/api/users/{id}` | Hapus User |
| GET | `/api/tickets/{id}/comments` | Daftar Komentar |
| POST | `/api/tickets/{id}/comments` | Tambah Komentar |
| GET | `/api/tickets/{id}/history` | Riwayat Ticket |
| GET | `/api/notifications/{user}` | Daftar Notifikasi |

---

# 📱 Tampilan Aplikasi

Halaman utama aplikasi meliputi:

- Splash Screen
- Login
- Register
- Forgot Password
- Dashboard
- List Ticket
- Detail Ticket
- Tracking Ticket
- Create Ticket
- Notification
- Profile
- Setting
- Dark Mode & Light Mode

---

# ▶️ Cara Menjalankan Project

## 1. Clone Repository

```bash
git clone https://github.com/saniaaww/434241101_Saniyatul-Warda_B3_uts.git
```

Masuk ke folder project.

```bash
cd 434241101_Saniyatul-Warda_B3_uts
```

Install dependency.

```bash
flutter pub get
```

Jalankan aplikasi.

```bash
flutter run
```

---

# ⚙️ Menjalankan Backend

Clone repository Laravel.

```bash
git clone https://github.com/saniaaww/helpdesk_ticket.git
```

Install dependency Laravel.

```bash
composer install
```

Copy file environment.

```bash
cp .env.example .env
```

Generate application key.

```bash
php artisan key:generate
```

Import database:

```
helpdesk_ticket.sql
```

Jalankan server Laravel.

```bash
php artisan serve
```

Pastikan Base URL API pada Flutter mengarah ke server Laravel yang sedang berjalan.

Contoh:

```dart
const String baseUrl = "http://127.0.0.1:8000/api";
```

atau menggunakan IP Address komputer apabila dijalankan melalui perangkat Android.

---

# 📁 Struktur Folder Flutter

```
lib/
│
├── models/
├── services/
├── screens/
│   ├── auth/
│   ├── dashboard/
│   ├── ticket/
│   ├── notification/
│   └── profile/
│
├── widgets/
├── utils/
└── main.dart
```

---

# 📌 Mata Kuliah

Praktikum Mobile Application

Program Studi DIV Teknik Informatika

Universitas Airlangga

---

# 👨‍💻 Developer

**Nama:** Saniyatul Warda

**NIM:** 434241101

**Kelas:** B3

**Program Studi:** DIV Teknik Informatika

**Universitas Airlangga**

---

# 📄 Lisensi

Project ini dibuat untuk keperluan pembelajaran dan memenuhi tugas **Ujian Akhir Semester (UAS) Semester 4 Praktikum Mobile Application** Program Studi DIV Teknik Informatika Universitas Airlangga.
