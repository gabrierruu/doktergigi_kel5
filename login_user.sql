-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 09 Okt 2025 pada 14.51
-- Versi server: 10.4.22-MariaDB
-- Versi PHP: 7.3.33

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

-- --------------------------------------------------------

--
-- Struktur dari tabel `login_user`
--

CREATE TABLE `login_user` (
  `user_id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `telepon` varchar(20) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  `login_provider` varchar(50) NOT NULL DEFAULT 'manual',
  `google_id` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `login_user`
--

INSERT INTO `login_user` (`user_id`, `nama`, `email`, `telepon`, `password`, `login_provider`, `google_id`) VALUES
(1, 'rdw', 'rmikael345@gmail.com', NULL, NULL, 'google', '108110744142961358064'),
(2, 'rizky', NULL, '081228565494', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2', 'manual', NULL),
(3, 'Rangga Dwi', 'rmikael333@gmail.com', NULL, NULL, 'google', '109712920682438305367');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `login_user`
--
ALTER TABLE `login_user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `telepon` (`telepon`),
  ADD UNIQUE KEY `google_id` (`google_id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `login_user`
--
ALTER TABLE `login_user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
