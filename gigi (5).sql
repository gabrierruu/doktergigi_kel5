-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 06, 2025 at 07:01 PM
-- Server version: 8.4.3
-- PHP Version: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gigi`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `antrian_harian` (IN `p_tanggal` DATE)   BEGIN
SELECT 
ap.id_appointment, p.id_pasien, p.nama, ap.jam, ap.hari
FROM appointment ap
INNER JOIN pasien p ON ap.id_pasien = p.id_pasien
WHERE ap.tanggal = p_tanggal
ORDER BY ap.jam ASC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cek_jadwal_kosong` (IN `p_tanggal` DATE)   BEGIN
    WITH jam_kerja AS (
        SELECT '08:00:00' AS jam
        UNION ALL SELECT '09:00:00'
        UNION ALL SELECT '10:00:00'
        UNION ALL SELECT '11:00:00'
    )
    SELECT 
        jk.jam,
        CASE 
            WHEN ap.id_appointment IS NULL THEN 'Kosong'
            ELSE 'Terisi'
        END AS status
    FROM jam_kerja jk
    LEFT JOIN appointment ap 
        ON TIME(ap.jam) = jk.jam 
       AND ap.tanggal = p_tanggal
    ORDER BY jk.jam;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `gaji` (IN `nilai` INT, OUT `status` CHAR(100))   BEGIN
IF (nilai>100) THEN
SET status='Kaya booo....';
ELSEIF (nilai>50) THEN
SET status='Uhmmm... lumayan';
ELSE
SET status='Walah...';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `my_sqrt` (`input_number` INT)   BEGIN
DECLARE i_sqrt FLOAT;
SET i_sqrt=SQRT(input_number);
SELECT i_sqrt;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `appointment`
--

CREATE TABLE `appointment` (
  `id_appointment` int NOT NULL,
  `jam` time NOT NULL,
  `tanggal` date NOT NULL,
  `hari` enum('Senin','Selasa','Rabu','Kamis','Jumat','Sabtu') COLLATE utf8mb4_general_ci NOT NULL,
  `id_pasien` int NOT NULL,
  `treatment` varchar(100) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointment`
--

INSERT INTO `appointment` (`id_appointment`, `jam`, `tanggal`, `hari`, `id_pasien`, `treatment`) VALUES
(7, '09:00:00', '2025-09-30', 'Selasa', 3, 'Orthodosi'),
(8, '10:00:00', '2025-10-02', 'Rabu', 4, 'Veneer'),
(14, '09:32:00', '2025-10-07', 'Selasa', 8, 'Esthetic Composite Filling');

--
-- Triggers `appointment`
--
DELIMITER $$
CREATE TRIGGER `cek_kuota` BEFORE INSERT ON `appointment` FOR EACH ROW BEGIN
    DECLARE v_sesi VARCHAR(10);
    DECLARE k INT;

    IF NEW.jam < '12:00:00' THEN
        SET v_sesi = 'pagi';
    ELSE
        SET v_sesi = 'sore';
    END IF;

    SELECT kuota INTO k
    FROM kuota
    WHERE tanggal = NEW.tanggal AND sesi = v_sesi
    LIMIT 1;
    
    IF k IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Kuota untuk tanggal ini belum dibuat';
    END IF;
    
    IF k <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Kuota untuk sesi hari ini sudah penuh';
    END IF;
    
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `hapus_appointment` AFTER DELETE ON `appointment` FOR EACH ROW BEGIN
    DECLARE s VARCHAR(10);

    IF OLD.jam < '12:00:00' THEN
        SET s = 'pagi';
    ELSE
        SET s = 'sore';
    END IF;

    UPDATE kuota
    SET kuota = kuota + 1
    WHERE tanggal = OLD.tanggal AND sesi = s;
    
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `kurang_kuota` AFTER INSERT ON `appointment` FOR EACH ROW BEGIN
    DECLARE v_sesi VARCHAR(10);

    IF NEW.jam < '12:00:00' THEN
        SET v_sesi = 'pagi';
    ELSE
        SET v_sesi = 'sore';
    END IF;

    UPDATE kuota
    SET kuota = kuota - 1
    WHERE tanggal = NEW.tanggal
      AND sesi = v_sesi;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `kuota`
--

CREATE TABLE `kuota` (
  `id_kuota` int NOT NULL,
  `tanggal` date NOT NULL,
  `sesi` enum('pagi','sore') NOT NULL,
  `kuota` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `kuota`
--

INSERT INTO `kuota` (`id_kuota`, `tanggal`, `sesi`, `kuota`) VALUES
(1, '2025-09-15', 'pagi', 0),
(2, '2025-09-15', 'sore', 4),
(3, '2025-09-16', 'pagi', 4),
(4, '2025-09-16', 'sore', 5),
(5, '2025-09-17', 'pagi', 5),
(6, '2025-09-17', 'sore', 5),
(7, '2025-10-01', 'pagi', 5),
(8, '2025-10-01', 'sore', 5),
(9, '2025-10-02', 'pagi', 4),
(10, '2025-10-02', 'sore', 5),
(11, '2025-10-03', 'pagi', 5),
(12, '2025-10-03', 'sore', 5),
(13, '2025-10-06', 'sore', 1),
(14, '2025-10-07', 'pagi', 2),
(15, '2025-10-07', 'sore', 3);

-- --------------------------------------------------------

--
-- Table structure for table `logingin`
--

CREATE TABLE `logingin` (
  `nama` varchar(20) NOT NULL,
  `username` varchar(200) NOT NULL,
  `password` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `logingin`
--

INSERT INTO `logingin` (`nama`, `username`, `password`) VALUES
('dr. Teguh', 'dokter', 'd79e31e7bd62b92a2167abae3671b4fe6dea6e53776a673ba6728442e9cdf08c03b9856a7c7f85c23424baf6d9f2117d8d798f4e5208182055d2fb408698a389'),
('Karyawan', 'karyawan', 'b7e2c10e927c1e23068e21aab0f3d13af4d332c8024c8b559ef90724ce6de63518a8e5ebb7bafe7ff1bf1d37125c22fd0eacf3473603638c5348ca94002761f8');

-- --------------------------------------------------------

--
-- Table structure for table `login_user`
--

CREATE TABLE `login_user` (
  `nama` varchar(50) NOT NULL,
  `telepon` varchar(20) NOT NULL,
  `password` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `login_user`
--

INSERT INTO `login_user` (`nama`, `telepon`, `password`) VALUES
('Rangga', '081228565494', 'e87110bb63f34b4cb8509afb5c56629b0d8548edb0453971e33c90ec14a0a8480301adb64449660845a3ec3872d0fb7ec25756f411abc3dc0020efa183b08d6b');

-- --------------------------------------------------------

--
-- Table structure for table `log_appointment`
--

CREATE TABLE `log_appointment` (
  `id_log` int NOT NULL,
  `id_appointment` int DEFAULT NULL,
  `id_pasien` int DEFAULT NULL,
  `tanggal` date DEFAULT NULL,
  `jam` time DEFAULT NULL,
  `hari` varchar(20) DEFAULT NULL,
  `treatment` varchar(100) DEFAULT NULL,
  `deleted_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `keterangan` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `log_appointment`
--

INSERT INTO `log_appointment` (`id_log`, `id_appointment`, `id_pasien`, `tanggal`, `jam`, `hari`, `treatment`, `deleted_at`, `keterangan`) VALUES
(1, 11, 8, '2025-10-02', '11:25:00', 'Kamis', 'Diamond', '2025-10-06 00:58:13', 'tidak jadi'),
(3, 10, 5, '2025-10-01', '04:01:00', 'Rabu', 'Myobrace', '2025-10-06 01:09:09', 'selesai'),
(4, 9, 1, '2025-10-02', '08:00:00', 'Rabu', 'Periksa', '2025-10-06 13:33:36', 'selesai'),
(7, 12, 1, '2025-10-06', '23:59:00', 'Senin', 'Sealant', '2025-10-07 00:07:28', 'selesai'),
(8, 13, 2, '2025-10-07', '08:33:00', 'Selasa', 'Veneer', '2025-10-07 00:35:01', 'selesai'),
(9, 6, 2, '2025-09-30', '11:00:00', 'Selasa', 'Bleaching', '2025-10-07 00:36:01', 'selesai');

-- --------------------------------------------------------

--
-- Table structure for table `pasien`
--

CREATE TABLE `pasien` (
  `id_pasien` int NOT NULL,
  `nama` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `tanggal` date NOT NULL,
  `gender` enum('Laki-Laki','Perempuan') COLLATE utf8mb4_general_ci NOT NULL,
  `no_hp` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `alamat` varchar(100) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pasien`
--

INSERT INTO `pasien` (`id_pasien`, `nama`, `tanggal`, `gender`, `no_hp`, `alamat`) VALUES
(1, 'Andi Pratama', '2015-03-12', 'Laki-Laki', '0812345678', 'Jl. Merpati No.1'),
(2, 'Citra Lestari', '2013-11-05', 'Perempuan', '0812345678', 'Jl. Melati No.3'),
(3, 'Fajar Nugroho', '2014-04-04', 'Laki-Laki', '0812345678', 'Jl. Mawar No.6'),
(4, 'Indah Rahmawati', '2014-08-30', 'Perempuan', '0812345678', 'Jl. Flamboyan No.9'),
(5, 'Syahroni', '2017-03-03', 'Laki-Laki', '0812345678', 'Jalan Rumah Rangga 01'),
(8, 'Gaby', '2010-10-07', 'Perempuan', '0812345678', 'Jalan Rumah Gaby01'),
(9, 'Dimas Bengbeng', '2016-07-05', 'Laki-Laki', '0876545678', 'Jalan Rumah Rangga 02'),
(10, 'Ravy Whienelda', '2010-09-09', 'Laki-Laki', '08765456789', 'Seberang Jalan'),
(11, 'Nathan', '2011-10-10', 'Perempuan', '08765456789', 'Sebelah Unika');

-- --------------------------------------------------------

--
-- Table structure for table `pembayaran`
--

CREATE TABLE `pembayaran` (
  `id_pembayaran` int NOT NULL,
  `id_appointment` int NOT NULL,
  `metode_pembayaran` varchar(100) NOT NULL,
  `total_pembayaran` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `pembayaran`
--

INSERT INTO `pembayaran` (`id_pembayaran`, `id_appointment`, `metode_pembayaran`, `total_pembayaran`) VALUES
(1, 6, 'QRIS', 100000),
(4, 9, 'QRIS', 100000),
(7, 12, 'Tunai / Cash', 50000),
(8, 13, 'Debit / Credit', 100000),
(9, 6, 'QRIS', 50000);

-- --------------------------------------------------------

--
-- Table structure for table `pencatatan`
--

CREATE TABLE `pencatatan` (
  `id_pencatatan` int NOT NULL,
  `keterangan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_pasien` int DEFAULT NULL,
  `tanggal` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pencatatan`
--

INSERT INTO `pencatatan` (`id_pencatatan`, `keterangan`, `id_pasien`, `tanggal`) VALUES
(1, 'Gigi nya sensitif', 1, '2025-10-07 00:40:54'),
(2, 'Gigi sangat sensitif', 2, '2025-10-07 00:40:54'),
(3, 'Gigi sudah membaik', 2, '2025-10-07 00:40:54'),
(4, 'Harus perbanyak sikat gigi', 1, '2025-10-06 17:51:59');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointment`
--
ALTER TABLE `appointment`
  ADD PRIMARY KEY (`id_appointment`),
  ADD KEY `pasien_appointment` (`id_pasien`);

--
-- Indexes for table `kuota`
--
ALTER TABLE `kuota`
  ADD PRIMARY KEY (`id_kuota`);

--
-- Indexes for table `log_appointment`
--
ALTER TABLE `log_appointment`
  ADD PRIMARY KEY (`id_log`);

--
-- Indexes for table `pasien`
--
ALTER TABLE `pasien`
  ADD PRIMARY KEY (`id_pasien`);

--
-- Indexes for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD PRIMARY KEY (`id_pembayaran`);

--
-- Indexes for table `pencatatan`
--
ALTER TABLE `pencatatan`
  ADD PRIMARY KEY (`id_pencatatan`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointment`
--
ALTER TABLE `appointment`
  MODIFY `id_appointment` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `kuota`
--
ALTER TABLE `kuota`
  MODIFY `id_kuota` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `log_appointment`
--
ALTER TABLE `log_appointment`
  MODIFY `id_log` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `pasien`
--
ALTER TABLE `pasien`
  MODIFY `id_pasien` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `pembayaran`
--
ALTER TABLE `pembayaran`
  MODIFY `id_pembayaran` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `pencatatan`
--
ALTER TABLE `pencatatan`
  MODIFY `id_pencatatan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointment`
--
ALTER TABLE `appointment`
  ADD CONSTRAINT `pasien_appointment` FOREIGN KEY (`id_pasien`) REFERENCES `pasien` (`id_pasien`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
