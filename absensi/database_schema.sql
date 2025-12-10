-- Database Schema untuk Aplikasi Absensi GPS PT Alfaaz Radif
-- Database: absensi_gps

CREATE DATABASE IF NOT EXISTS absensi_gps CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE absensi_gps;

-- Table: shifts
CREATE TABLE IF NOT EXISTS shifts (
    id INT(11) NOT NULL AUTO_INCREMENT,
    nama_shift VARCHAR(100) NOT NULL,
    jam_masuk_mulai TIME NOT NULL DEFAULT '07:00:00',
    jam_masuk_akhir TIME NOT NULL DEFAULT '09:00:00',
    jam_pulang_mulai TIME NOT NULL DEFAULT '16:00:00',
    jam_pulang_akhir TIME NOT NULL DEFAULT '18:00:00',
    keterangan TEXT NULL,
    status ENUM('aktif', 'nonaktif') NOT NULL DEFAULT 'aktif',
    created_at DATETIME NULL,
    updated_at DATETIME NULL,
    PRIMARY KEY (id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: users
CREATE TABLE IF NOT EXISTS users (
    id INT(11) NOT NULL AUTO_INCREMENT,
    nama_lengkap VARCHAR(255) NOT NULL,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'karyawan') NOT NULL DEFAULT 'karyawan',
    nik VARCHAR(50) NULL,
    jabatan VARCHAR(100) NULL,
    divisi VARCHAR(100) NULL,
    shift_id INT(11) NULL,
    foto_profil VARCHAR(255) NULL,
    status ENUM('aktif', 'nonaktif') NOT NULL DEFAULT 'aktif',
    created_at DATETIME NULL,
    updated_at DATETIME NULL,
    PRIMARY KEY (id),
    INDEX idx_username (username),
    INDEX idx_role (role),
    INDEX idx_status (status),
    FOREIGN KEY (shift_id) REFERENCES shifts(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: absensi_settings
CREATE TABLE IF NOT EXISTS absensi_settings (
    id INT(11) NOT NULL AUTO_INCREMENT,
    kantor_latitude VARCHAR(50) NOT NULL,
    kantor_longitude VARCHAR(50) NOT NULL,
    radius_meter INT(11) NOT NULL DEFAULT 100,
    jam_masuk_mulai TIME NOT NULL DEFAULT '07:00:00',
    jam_masuk_akhir TIME NOT NULL DEFAULT '09:00:00',
    jam_pulang_mulai TIME NOT NULL DEFAULT '16:00:00',
    jam_pulang_akhir TIME NOT NULL DEFAULT '18:00:00',
    created_at DATETIME NULL,
    updated_at DATETIME NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: absensi
CREATE TABLE IF NOT EXISTS absensi (
    id INT(11) NOT NULL AUTO_INCREMENT,
    user_id INT(11) NOT NULL,
    tanggal DATE NOT NULL,
    jam_masuk TIME NULL,
    jam_pulang TIME NULL,
    foto_selfie_masuk VARCHAR(255) NULL,
    foto_selfie_pulang VARCHAR(255) NULL,
    latitude VARCHAR(50) NULL,
    longitude VARCHAR(50) NULL,
    status VARCHAR(50) NULL DEFAULT 'Tepat Waktu',
    created_at DATETIME NULL,
    updated_at DATETIME NULL,
    PRIMARY KEY (id),
    INDEX idx_user_id (user_id),
    INDEX idx_tanggal (tanggal),
    INDEX idx_user_tanggal (user_id, tanggal),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default admin user (password: admin123)
-- Password hash: password_hash('admin123', PASSWORD_DEFAULT)
-- Jika hash tidak bekerja, gunakan password_verify untuk generate hash baru
INSERT INTO users (nama_lengkap, username, password, role, status, created_at) VALUES
('Administrator', 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'aktif', NOW())
ON DUPLICATE KEY UPDATE nama_lengkap='Administrator';

-- Insert default settings (contoh koordinat Jakarta)
INSERT INTO absensi_settings (kantor_latitude, kantor_longitude, radius_meter, jam_masuk_mulai, jam_masuk_akhir, jam_pulang_mulai, jam_pulang_akhir, created_at) VALUES
('-6.2088', '106.8456', 100, '07:00:00', '09:00:00', '16:00:00', '18:00:00', NOW());

-- Insert default shifts
INSERT INTO shifts (nama_shift, jam_masuk_mulai, jam_masuk_akhir, jam_pulang_mulai, jam_pulang_akhir, keterangan, status, created_at) VALUES
('Shift Pagi', '07:00:00', '09:00:00', '16:00:00', '18:00:00', 'Shift kerja pagi standar (07:00 - 16:00)', 'aktif', NOW()),
('Shift Siang', '12:00:00', '14:00:00', '20:00:00', '22:00:00', 'Shift kerja siang (12:00 - 20:00)', 'aktif', NOW()),
('Shift Malam', '20:00:00', '22:00:00', '04:00:00', '06:00:00', 'Shift kerja malam (20:00 - 04:00)', 'aktif', NOW());

