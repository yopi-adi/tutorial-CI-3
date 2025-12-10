# Tutorial: Membuat Aplikasi CodeIgniter 3 + Bootstrap 5 dari Awal

## Download Links (direct)
-   **XAMPP (Windows)** --- XAMPP Version **7.3.2**\
    https://sourceforge.net/projects/xampp/files/XAMPP%20Windows/7.3.2/
-   **CodeIgniter 3 (ZIP)**\
    https://www.codeigniter.com/download\
    GitHub:
    https://github.com/bcit-ci/CodeIgniter/archive/refs/tags/3.1.13.zip


## 1. Persiapan Lingkungan
- Install **XAMPP** dari link download di atas
- Buka **XAMPP Control Panel** (biasanya ada di Start Menu atau Desktop)
- Klik tombol **Start** pada **Apache** dan **MySQL** (akan berubah menjadi hijau jika berjalan)
- (Opsional) Install **VS Code** untuk editor code

## 2. Buat Direktori Proyek (manual)
- Buka **File Explorer**.
- Arahkan ke folder `C:\xampp\htdocs`.
- Klik kanan → **New → Folder**, beri nama `absensi-gps`.
- Buka folder tersebut (double‑click) untuk menjadi direktori kerja.

## 3. Unduh CodeIgniter 3
- Unduh file ZIP dari tautan di atas.
- Ekstrak isi ZIP ke dalam folder `C:\xampp\htdocs\absensi-gps` sehingga file `index.php` berada di root folder.

## 4. Buat Database MySQL

### 4.1. Buka phpMyAdmin
1. Pastikan **Apache** dan **MySQL** sudah running di XAMPP Control Panel
2. Buka browser (Chrome, Firefox, dll)
3. Ketik di address bar: `http://localhost/phpmyadmin`
4. Atau klik **Admin** di sebelah MySQL di XAMPP Control Panel
5. Login dengan:
   - Username: `root`
   - Password: (kosongkan, default XAMPP)

### 4.2. Buat Database
1. Di phpMyAdmin, klik tab **Databases** di menu atas
2. Di bagian **Create database**, ketik: `absensi_gps`
3. Pilih **Collation**: `utf8mb4_unicode_ci`
4. Klik tombol **Create**

**Atau** jalankan SQL langsung:
1. Klik tab **SQL** di phpMyAdmin
2. Copy-paste query berikut:
```sql
CREATE DATABASE absensi_gps CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```
3. Klik tombol **Go**

### 4.3. Import Database Schema
1. Di phpMyAdmin, pilih database `absensi_gps` di sidebar kiri
2. Klik tab **Import** di menu atas
3. Klik tombol **Choose File** atau **Browse**
4. Pilih file `database_schema.sql` dari folder `C:\xampp\htdocs\absensi-gps\`
5. Pastikan **Format** adalah **SQL**
6. Klik tombol **Go** di bagian bawah
7. Tunggu hingga muncul pesan sukses "Import has been successfully finished"

## 5. Konfigurasi CI3

### 5.1. Buat File .htaccess
Buat file `.htaccess` di root folder `absensi-gps` dengan isi:
```apache
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ index.php/$1 [L]
```
File ini berfungsi untuk menghilangkan `index.php` dari URL.

### 5.2. Konfigurasi Database
Edit file `application/config/database.php`:
```php
$db['default'] = array(
    'dsn'      => '',
    'hostname' => 'localhost',
    'username' => 'root',
    'password' => '',  // Kosongkan jika XAMPP default
    'database' => 'absensi_gps',
    'dbdriver' => 'mysqli',
    'dbprefix' => '',
    'pconnect' => FALSE,
    'db_debug' => (ENVIRONMENT !== 'production'),
    'cache_on' => FALSE,
    'cachedir' => '',
    'char_set' => 'utf8mb4',
    'dbcollat' => 'utf8mb4_unicode_ci',
    'swap_pre' => '',
    'encrypt'  => FALSE,
    'compress' => FALSE,
    'stricton' => FALSE,
    'failover' => array(),
    'save_queries' => TRUE
);
```

### 5.3. Konfigurasi Base URL
File `application/config/config.php` sudah dikonfigurasi untuk auto-detect base URL. Pastikan `index_page` kosong:
```php
$config['index_page'] = '';
```

### 5.4. Generate Encryption Key
Generate encryption key untuk session security menggunakan PHP lokal:
1. Buat file baru `generate_key.php` di root folder `absensi-gps`
2. Isi dengan kode berikut:
```php
<?php
echo bin2hex(random_bytes(32));
?>
```
3. Buka browser, akses: `http://localhost/absensi-gps/generate_key.php`
4. Copy hasil yang muncul (string panjang)
5. Edit file `application/config/config.php`, cari baris `$config['encryption_key']`
6. Paste hasil generate key tersebut:
```php
$config['encryption_key'] = 'hasil_generate_key_dari_browser';
```
7. **Hapus file** `generate_key.php` setelah selesai (untuk keamanan)

### 5.5. Konfigurasi Routes
Edit `application/config/routes.php` untuk mengatur default controller:
```php
$route['default_controller'] = 'auth/login';
```

### 5.6. Konfigurasi Autoload
Edit `application/config/autoload.php` untuk auto-load helper dan library:
```php
$autoload['libraries'] = array('session', 'database');
$autoload['helper'] = array('url', 'form', 'auth', 'distance');
```
## 6. Install Dependencies Lokal

### 6.1. Download Bootstrap 5
1. Buka browser, akses: https://getbootstrap.com/docs/5.3/getting-started/download/
2. Klik **Download** untuk mendapatkan file ZIP Bootstrap 5.3.0 (atau versi terbaru)
3. Ekstrak file ZIP yang sudah didownload
4. Di dalam folder hasil ekstrak, cari folder `dist/`
5. Copy folder `css` dan `js` dari `dist/` ke folder `C:\xampp\htdocs\absensi-gps\assets\bootstrap\`
6. Struktur folder akhir:
```
absensi-gps/
└─ assets/
   └─ bootstrap/
      ├─ css/
      │  └─ bootstrap.min.css
      └─ js/
         └─ bootstrap.bundle.min.js
```

### 6.2. Download jQuery
1. Buka browser, akses: https://jquery.com/download/
2. Download **jQuery 3.7.0** (atau versi terbaru) - pilih **compressed, production**
3. Simpan file `jquery-3.7.0.min.js` ke folder `C:\xampp\htdocs\absensi-gps\assets\jquery\`
4. Struktur folder:
```
absensi-gps/
└─ assets/
   └─ jquery/
      └─ jquery-3.7.0.min.js
```

### 6.3. Download Font Awesome
1. Buka browser, akses: https://fontawesome.com/download
2. Download **Font Awesome Free** (versi terbaru)
3. Ekstrak file ZIP
4. Copy folder `css` dan `webfonts` dari hasil ekstrak ke folder `C:\xampp\htdocs\absensi-gps\assets\fontawesome\`
5. Struktur folder:
```
absensi-gps/
└─ assets/
   └─ fontawesome/
      ├─ css/
      │  └─ all.min.css
      └─ webfonts/
         └─ (semua file font)
```

### 6.4. Download Google Fonts (Inter) - Opsional
Jika ingin menggunakan font Inter secara lokal:
1. Buka browser, akses: https://fonts.google.com/specimen/Inter
2. Klik **Download family** untuk download ZIP
3. Ekstrak dan copy font files ke folder `C:\xampp\htdocs\absensi-gps\assets\fonts\inter\`
4. Atau gunakan font system default (tidak perlu download)

### 6.5. Update File Layout
Edit file `application/views/layouts/header.php`, ganti semua link CDN dengan path lokal:

**Hapus semua baris yang menggunakan CDN**, ganti dengan:
```html
<!-- Bootstrap CSS -->
<link href="<?php echo base_url('assets/bootstrap/css/bootstrap.min.css'); ?>" rel="stylesheet">

<!-- Font Awesome -->
<link rel="stylesheet" href="<?php echo base_url('assets/fontawesome/css/all.min.css'); ?>">

<!-- HAPUS Google Fonts jika ingin 100% lokal, atau gunakan font system default -->
<!-- Jika tetap ingin pakai Google Fonts Inter, biarkan baris berikut: -->
<!--
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
-->
```

Edit file `application/views/layouts/footer.php`, ganti link CDN dengan path lokal:
```html
<!-- jQuery -->
<script src="<?php echo base_url('assets/jquery/jquery-3.7.0.min.js'); ?>"></script>

<!-- Bootstrap JS -->
<script src="<?php echo base_url('assets/bootstrap/js/bootstrap.bundle.min.js'); ?>"></script>
```

**Catatan Penting:**
- Untuk **100% lokal tanpa internet**, **hapus semua baris Google Fonts** dari header
- Update CSS di `header.php` untuk menggunakan font system default, contoh:
```css
font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica', 'Arial', sans-serif;
```
- Jika menggunakan font Inter lokal (sudah didownload), gunakan `@font-face` di CSS untuk load font dari folder `assets/fonts/inter/`

## 7. Struktur Folder (detail)

```
absensi-gps/
├─ application/
│  ├─ config/
│  ├─ controllers/
│  │   ├─ Admin/
│  │   │   ├─ Dashboard.php
│  │   │   ├─ Karyawan.php
│  │   │   ├─ Laporan.php
│  │   │   ├─ Pengaturan.php
│  │   │   └─ Shift.php
│  │   ├─ Karyawan/
│  │   │   ├─ Absensi.php
│  │   │   ├─ Dashboard.php
│  │   │   ├─ Profil.php
│  │   │   └─ Riwaret.php
│  │   ├─ Auth.php
│  │   └─ Welcome.php
│  ├─ models/
│  │   ├─ Absensi_model.php
│  │   ├─ Pengaturan_model.php
│  │   ├─ Shift_model.php
│  │   └─ User_model.php
│  ├─ views/
│  │   ├─ admin/
│  │   │   ├─ absensi_view.php
│  │   │   └─ karyawan_view.php
│  │   ├─ auth/
│  │   ├─ errors/
│  │   ├─ karyawan/
│  │   └─ layouts/
│  └─ helpers/
├─ assets/
│  ├─ bootstrap/
│  │  ├─ css/
│  │  │  └─ bootstrap.min.css
│  │  └─ js/
│  │     └─ bootstrap.bundle.min.js
│  ├─ jquery/
│  │  └─ jquery-3.7.0.min.js
│  ├─ fontawesome/
│  │  ├─ css/
│  │  │  └─ all.min.css
│  │  └─ webfonts/
│  └─ fonts/
│     └─ inter/ (opsional)
├─ uploads/selfie/
├─ database_schema.sql
└─ README.md
```

### Penjelasan Singkat File
- **application/controllers/Admin/**: Controller untuk fitur admin (dashboard, karyawan, laporan, pengaturan, shift).
- **application/controllers/Karyawan/**: Controller untuk fitur karyawan (absensi, dashboard, profil, riwayat).
- **application/controllers/Auth.php**: Controller untuk autentikasi (login, logout).
- **application/models/Absensi_model.php**: Model yang berinteraksi dengan tabel `absensi` di database.
- **application/models/User_model.php**: Model untuk mengelola data user/karyawan.
- **application/models/Shift_model.php**: Model untuk mengelola data shift kerja.
- **application/models/Pengaturan_model.php**: Model untuk pengaturan aplikasi.
- **application/helpers/auth_helper.php**: Helper untuk fungsi autentikasi (cek login, role, dll).
- **application/helpers/distance_helper.php**: Helper untuk menghitung jarak GPS (Haversine formula).

## 8. Setup Folder Uploads
Buat folder untuk menyimpan foto selfie absensi:
1. Buat folder `uploads/selfie/` di root folder.
2. Pastikan folder memiliki permission write (bukan Read-Only).
3. Buat file `.htaccess` di dalam `uploads/selfie/` untuk keamanan:
```apache
Deny from all
```
Atau untuk PHP 7+:
```apache
Require all denied
```

## 9. Jalankan Aplikasi

### 9.1. Akses Aplikasi via Browser
1. Pastikan **Apache** & **MySQL** aktif di XAMPP Control Panel (status hijau)
2. Buka browser (Chrome, Firefox, Edge, dll)
3. Ketik di address bar: `http://localhost/absensi-gps/`
4. Tekan **Enter**
5. Halaman akan otomatis redirect ke halaman login (`auth/login`)

### 9.2. Verifikasi Aplikasi Berjalan
- Jika muncul halaman login → aplikasi berjalan dengan baik ✅
- Jika muncul error 404 → cek Section 11 (Debugging) untuk troubleshooting
- Jika muncul database error → pastikan database sudah di-import dengan benar
### 9.3. Login ke Aplikasi
**Login dengan kredensial default:**
- Username: `admin`
- Password: `admin123`

**Atau** buat user baru melalui phpMyAdmin:
1. Buka `http://localhost/phpmyadmin`
2. Pilih database `absensi_gps`
3. Klik tab **SQL**
4. Buat file PHP sementara `create_user.php` di root folder untuk generate password hash:
```php
<?php
echo password_hash('admin123', PASSWORD_DEFAULT);
?>
```
5. Akses `http://localhost/absensi-gps/create_user.php` di browser
6. Copy hasil hash yang muncul
7. Jalankan query SQL di phpMyAdmin:
```sql
INSERT INTO users (nama_lengkap, username, password, role) 
VALUES ('Admin', 'admin', 'hasil_hash_dari_create_user.php', 'admin');
```
8. **Hapus file** `create_user.php` setelah selesai (untuk keamanan)

## 10. Fitur Aplikasi
### Admin
- Dashboard: Overview absensi dan statistik
- Karyawan: CRUD data karyawan
- Laporan: Lihat dan export data absensi (CSV)
- Pengaturan: Konfigurasi lokasi GPS kantor
- Shift: Kelola shift kerja

### Karyawan
- Dashboard: Overview absensi pribadi
- Absensi: Absensi masuk/pulang dengan GPS dan selfie
- Riwayat: Lihat riwayat absensi
- Profil: Edit profil pribadi

## 11. Debugging Umum

### Error 404 (Page Not Found)
- Pastikan file `.htaccess` sudah ada di root folder.
- Pastikan `mod_rewrite` aktif di Apache (XAMPP biasanya sudah aktif).
- Cek `application/config/config.php` → `index_page` harus kosong.
- Cek `application/config/routes.php` → `default_controller` sudah benar.

### Database Connection Error
- Periksa `application/config/database.php`:
  - `hostname`: `localhost`
  - `username`: `root` (default XAMPP)
  - `password`: kosong (default XAMPP) atau sesuai setting Anda
  - `database`: `absensi_gps`
- Pastikan database sudah dibuat dan di-import.
- Pastikan MySQL service aktif di XAMPP.

### Bootstrap/CSS/JS Tidak Muncul
- Pastikan folder `assets/` sudah dibuat dan file-file sudah di-copy dengan benar.
- Cek path di `header.php` dan `footer.php` menggunakan `base_url()`.
- Pastikan file CSS/JS ada di lokasi yang benar (cek via File Explorer).
- Buka browser console (F12) → tab Network, lihat apakah file CSS/JS gagal load (404).
- Pastikan folder `assets/` tidak Read-Only.

### Permission Folder Upload
- Pastikan folder `uploads/selfie/` tidak Read-Only.
- Klik kanan folder → Properties → uncheck "Read-only".
- Pastikan Apache memiliki permission write ke folder tersebut.

### Session Error
- Pastikan `encryption_key` sudah di-set di `config.php`.
- Pastikan folder `application/sessions/` writable (jika pakai file session).
- Cek `application/config/config.php` → `sess_driver` sesuai kebutuhan.

### Helper Not Found
- Pastikan helper file ada di `application/helpers/`.
- Pastikan helper sudah di-autoload di `application/config/autoload.php`.
- Nama file helper harus sesuai: `auth_helper.php`, `distance_helper.php`.

### GPS Location Error
- Pastikan browser mengizinkan akses lokasi.
- Pastikan aplikasi diakses via HTTPS atau localhost (browser requirement).
- Cek console browser untuk error JavaScript.

## 12. Catatan Penting

### Keamanan
- **Jangan** commit file `application/config/database.php` dan `config.php` ke repository public. 
- Selalu hash password menggunakan `password_hash()` sebelum menyimpan ke database.
- Pastikan folder `uploads/` tidak bisa diakses langsung (gunakan `.htaccess`).

### Development vs Production
- Di development: `ENVIRONMENT` di `index.php` set ke `'development'` (akan menampilkan error detail).
- Di production: `ENVIRONMENT` set ke `'production'` (error disembunyikan, log ke file).
- Pastikan `db_debug` di `database.php` set ke `FALSE` di production.

### Tips
- **Semua dependency (Bootstrap, jQuery, Font Awesome) sudah diinstall lokal**, tidak perlu koneksi internet untuk menjalankan aplikasi.
- Monitor log di `application/logs/` untuk debugging.
- Jika ada update Bootstrap/jQuery, cukup replace file di folder `assets/` dengan versi baru.

