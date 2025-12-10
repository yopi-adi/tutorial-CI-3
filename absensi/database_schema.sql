-- CONTOH

-- ====================================================
-- Table: users
-- ====================================================
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

-- Insert default admin user (password: admin123)
INSERT INTO users (nama_lengkap, username, password, role, status, created_at) VALUES
('Administrator', 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'aktif', NOW())
ON DUPLICATE KEY UPDATE nama_lengkap='Administrator';

