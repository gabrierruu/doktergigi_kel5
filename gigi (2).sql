-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 30, 2025 at 02:26 PM
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
(6, '11:00:00', '2025-09-30', 'Selasa', 2, 'Bleaching'),
(7, '09:00:00', '2025-09-30', 'Selasa', 3, 'Orthodosi'),
(8, '10:00:00', '2025-10-02', 'Rabu', 4, 'Veneer'),
(9, '08:00:00', '2025-10-02', 'Rabu', 1, 'Periksa');

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
(6, '2025-09-17', 'sore', 5);

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
-- Table structure for table `pasien`
--

CREATE TABLE `pasien` (
  `id_pasien` int NOT NULL,
  `nama` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `tanggal` date NOT NULL,
  `gender` enum('Laki-Laki','Perempuan') COLLATE utf8mb4_general_ci NOT NULL,
  `no_hp` int NOT NULL,
  `alamat` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `id_orangtua` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pasien`
--

INSERT INTO `pasien` (`id_pasien`, `nama`, `tanggal`, `gender`, `no_hp`, `alamat`, `id_orangtua`) VALUES
(1, 'Andi Pratama', '2015-03-12', 'Laki-Laki', 812345678, 'Jl. Merpati No.1', 1),
(2, 'Citra Lestari', '2013-11-05', 'Perempuan', 812345680, 'Jl. Melati No.3', 3),
(3, 'Fajar Nugroho', '2014-04-04', 'Laki-Laki', 812345683, 'Jl. Mawar No.6', 6),
(4, 'Indah Rahmawati', '2014-08-30', 'Perempuan', 812345686, 'Jl. Flamboyan No.9', 9);

-- --------------------------------------------------------

--
-- Table structure for table `pencatatan`
--

CREATE TABLE `pencatatan` (
  `id_pencatatan` int NOT NULL,
  `keterangan` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `diagnosa` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `treatment` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `id_appointment` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `treatment`
--

CREATE TABLE `treatment` (
  `id_treatment` int NOT NULL,
  `treatment` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `treatment`
--

INSERT INTO `treatment` (`id_treatment`, `treatment`) VALUES
(1, 'Veneer'),
(2, 'Bleaching'),
(3, 'Orthodonsi');

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
-- Indexes for table `pasien`
--
ALTER TABLE `pasien`
  ADD PRIMARY KEY (`id_pasien`);

--
-- Indexes for table `pencatatan`
--
ALTER TABLE `pencatatan`
  ADD PRIMARY KEY (`id_pencatatan`),
  ADD KEY `pencatatan_appointment` (`id_appointment`);

--
-- Indexes for table `treatment`
--
ALTER TABLE `treatment`
  ADD PRIMARY KEY (`id_treatment`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointment`
--
ALTER TABLE `appointment`
  MODIFY `id_appointment` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `kuota`
--
ALTER TABLE `kuota`
  MODIFY `id_kuota` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `pasien`
--
ALTER TABLE `pasien`
  MODIFY `id_pasien` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `pencatatan`
--
ALTER TABLE `pencatatan`
  MODIFY `id_pencatatan` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `treatment`
--
ALTER TABLE `treatment`
  MODIFY `id_treatment` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointment`
--
ALTER TABLE `appointment`
  ADD CONSTRAINT `pasien_appointment` FOREIGN KEY (`id_pasien`) REFERENCES `pasien` (`id_pasien`);

--
-- Constraints for table `pencatatan`
--
ALTER TABLE `pencatatan`
  ADD CONSTRAINT `pencatatan_appointment` FOREIGN KEY (`id_appointment`) REFERENCES `appointment` (`id_appointment`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
