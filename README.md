# Aplikasi Agenda Kegiatan UKM Kampus (Universitas Pamulang)

Aplikasi mobile terintegrasi untuk manajemen Unit Kegiatan Mahasiswa (UKM) di lingkungan kampus. Proyek ini dibangun untuk memenuhi tugas mata kuliah, dengan tujuan memodernisasi dan mendigitalisasi proses pengelolaan kegiatan, pendaftaran anggota, dan pengajuan UKM baru.

Aplikasi ini memisahkan antara Front-End (Aplikasi Mobile) dan Back-End (API Server) untuk skalabilitas dan pemeliharaan yang lebih mudah.

## Fitur Utama

Aplikasi ini memiliki sistem otorisasi berbasis peran dengan 3 level akses:

#### 1. Mahasiswa (Pengguna Umum)
* Melihat daftar kegiatan terbaru dari semua UKM dengan fitur pencarian dan filter.
* Melihat daftar UKM yang resmi dan terdaftar.
* Melihat halaman detail dari setiap UKM dan kegiatan.
* **Mendaftar** ke UKM yang sedang membuka pendaftaran (dengan batasan maksimal 4 UKM).
* **Mengajukan proposal** untuk membuat UKM baru, lengkap dengan upload logo.
* Melihat dan mengedit profil pribadi.

#### 2. Admin UKM (Pengurus)
* Memiliki semua fitur Mahasiswa.
* **Mengelola UKM miliknya:** Membuka atau menutup pendaftaran untuk anggota baru.
* **Manajemen Anggota:** Melihat daftar pendaftar baru, lalu menyetujui (approve) atau menolak (reject) pendaftaran mereka.
* **Manajemen Kegiatan (CRUD):** Membuat, membaca, mengupdate, dan menghapus (CRUD) kegiatan atau acara untuk UKM yang dikelolanya.
* Melihat daftar anggota yang sudah diterima dan dapat mengeluarkannya.

#### 3. Super Admin (Kemahasiswaan/BEM)
* Memiliki semua fitur Admin UKM (untuk tujuan pengawasan).
* **Review Proposal UKM:** Melihat semua proposal UKM yang diajukan oleh mahasiswa.
* **Persetujuan UKM:** Menyetujui atau menolak proposal UKM. Jika disetujui, UKM menjadi resmi dan pengaju otomatis menjadi Admin UKM.
* **Menghapus UKM:** Dapat menghapus UKM yang sudah terdaftar dari sistem.

## Technology Stack Aplikasi ini

#### **Back-End (Folder: `/server`)**
* **Framework:** Laravel
* **Bahasa:** PHP
* **Database:** MySQL / MariaDB
* **Autentikasi:** JWT-Auth (JSON Web Token)
* **Lingkungan Lokal:** XAMPP 

#### **Front-End (Folder: `/client`)**
* **Framework:** Flutter
* **Bahasa:** Dart
* **State Management:** Provider
* **HTTP Client:** Dio (dengan Interceptors)
* **UI/UX:** Material 3, Google Fonts

## Struktur Folder

```
repo-root/
├── client/      # Folder proyek Flutter
└── server/      # Folder proyek Laravel
```

## Panduan Instalasi dan Konfigurasi

Untuk menjalankan proyek ini di mesin lokal, ikuti langkah-langkah di bawah ini.

### Persyaratan Untuk Bisa Menjalankan Aplikasi ini
* PHP (versi 8.1+)
* Composer
* Flutter SDK (versi 3+)
* Lingkungan server lokal seperti Laragon, XAMPP, atau Laravel Herd.
* Alat pengelola database seperti phpMyAdmin atau HeidiSQL.

### 1. Konfigurasi Back-End (Laravel)

Buka terminal di dalam folder `/server`.

```bash
# Pindah ke direktori server
cd server

# 1. Salin file environment
cp .env.example .env

# 2. Instal semua dependensi PHP (membuat folder vendor)
composer install

# 3. Generate kunci aplikasi
php artisan key:generate

# 4. Generate kunci rahasia untuk JWT
php artisan jwt:secret

# 5. Konfigurasi Database di file .env
#    Buka file .env dan sesuaikan bagian DB_DATABASE, DB_USERNAME, dan DB_PASSWORD
#    Contoh:
#    DB_DATABASE=db_ukm_unpam
#    DB_USERNAME=root
#    DB_PASSWORD=
#    
#    PENTING: Atur juga APP_URL agar sesuai dengan server lokal Anda
#    Contoh untuk php artisan serve: APP_URL=[http://127.0.0.1:8000](http://127.0.0.1:8000)

# 6. Buat tabel database dan isi dengan data contoh
php artisan migrate:fresh --seed

# 7. Buat symbolic link untuk folder storage
php artisan storage:link

# 8. Jalankan server
#    Jika menggunakan Laragon/Herd, server berjalan otomatis.
#    Jika tidak, jalankan perintah:
php artisan serve
```

### 2. Konfigurasi Front-End (Flutter)

Buka terminal baru di dalam folder `/client`.

```bash
# Pindah ke direktori client
cd client

# 1. Instal semua dependensi Flutter
flutter pub get

# 2. Buat file-file yang di-generate oleh json_serializable
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Konfigurasi Alamat API
#    Buka file lib/services/api_service.dart
#    Sesuaikan nilai 'baseUrl' agar menunjuk ke server Laravel Anda.
#    Contoh:
#    _dio.options.baseUrl = '[http://10.0.2.2:8000/api](http://10.0.2.2:8000/api)'; // Untuk Emulator Android & artisan serve

# 4. Jalankan aplikasi
flutter run
```

## Tim Pengembang

| NIM | NAMA |
| :--- | :--- |
| 221011402633 | ABU BAKAR BILL GATES |
| 221011400362 | AINUN JARIYAH |
| 221011400387 | ALDI HERMAWAN |
| 221011401860 | ELMA |
| 221011400458 | JOSHUA PUTRA GULTOM |
| 221011401742 | MUHAMAD SOBRAN |
| 221011400381 | MUHAMMAD FAHRY |

## Informasi User Tersedia

```bash

# Super Admin
email : superadmin@unpam.ac.id
password : password

# Admin UKM
email : admin.futsal@unpam.ac.id
password : password

# Mahasiswa
silahkan lakukan pembuatan akun baru di menu login dan klik 'Daftar di sini'

```

---
Copyright (c) 2025 - Kelompok 3, Teknik Informatika, Universitas Pamulang.
Semua Hak Dilindungi (All Rights Reserved).
