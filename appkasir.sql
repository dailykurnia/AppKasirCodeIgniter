-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 05, 2019 at 11:25 PM
-- Server version: 10.1.38-MariaDB
-- PHP Version: 7.3.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `appkasir`
--

-- --------------------------------------------------------

--
-- Table structure for table `logtransaksi`
--

CREATE TABLE `logtransaksi` (
  `idlog` int(11) NOT NULL,
  `kodepesanan` varchar(15) NOT NULL,
  `total` int(11) NOT NULL,
  `bayar` int(11) NOT NULL,
  `kembalian` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `logtransaksi`
--

INSERT INTO `logtransaksi` (`idlog`, `kodepesanan`, `total`, `bayar`, `kembalian`) VALUES
(1, '494348842', 180000, 200000, 20000);

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `idmenu` int(11) NOT NULL,
  `namamenu` varchar(50) NOT NULL,
  `hargamenu` int(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`idmenu`, `namamenu`, `hargamenu`) VALUES
(1, 'Mie Goreng', 10000),
(2, 'Nasi Uduk', 170000),
(3, 'ayam bakar', 15000),
(7, 'Teh Es Manis', 5000),
(8, 'Semur Ayam', 15000),
(9, 'semur jengkol', 20000),
(10, 'ayam balado', 6000),
(11, 'Nasi Lemak', 4000);

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `idpelanggan` int(11) NOT NULL,
  `namapelanggan` varchar(30) NOT NULL,
  `jeniskelamin` varchar(1) NOT NULL,
  `nohp` varchar(12) NOT NULL,
  `alamat` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`idpelanggan`, `namapelanggan`, `jeniskelamin`, `nohp`, `alamat`) VALUES
(1, 'TAUFIK', 'P', '082121212112', 'Jl. Kualu'),
(2, 'Andika', 'P', '081288118811', 'Jl. Tuanku Tambusai'),
(4, 'suharti', 'P', '012219091212', 'Jl. Riau'),
(5, 'kiki', 'P', '0823232357', 'Jl. Palas');

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `idpesanan` int(11) NOT NULL,
  `kodepesanan` varchar(15) NOT NULL,
  `jumlah` int(5) NOT NULL,
  `idmenu` int(11) NOT NULL,
  `idpelanggan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pesanan`
--

INSERT INTO `pesanan` (`idpesanan`, `kodepesanan`, `jumlah`, `idmenu`, `idpelanggan`) VALUES
(18, '494348842', 1, 1, 1),
(19, '494348842', 1, 2, 1);

--
-- Triggers `pesanan`
--
DELIMITER $$
CREATE TRIGGER `TAMBAH_TRANSAKSI` AFTER INSERT ON `pesanan` FOR EACH ROW INSERT INTO transaksi SET
kodePesanan = new.kodePesanan,

total = (
    SELECT new.jumlah * menu.hargaMenu
    FROM pesanan
    INNER JOIN menu ON pesanan.idMenu = menu.idMenu
    WHERE pesanan.idMenu = new.idMenu
)
        
 ON DUPLICATE KEY UPDATE
 total = total+(
    SELECT new.jumlah * menu.hargaMenu
    FROM pesanan
    INNER JOIN menu ON pesanan.idMenu = menu.idMenu
    WHERE pesanan.idMenu = new.idMenu
)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `kodepesanan` varchar(15) NOT NULL,
  `total` int(30) NOT NULL,
  `bayar` int(30) NOT NULL,
  `kembalian` int(11) NOT NULL,
  `status` int(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`kodepesanan`, `total`, `bayar`, `kembalian`, `status`) VALUES
('494348842', 180000, 200000, 20000, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `iduser` int(11) NOT NULL,
  `namauser` varchar(50) NOT NULL,
  `privilage` int(11) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`iduser`, `namauser`, `privilage`, `password`) VALUES
(1, 'admin', 1, '0192023a7bbd73250516f069df18b500'),
(2, 'waiter', 2, 'e82d611b52164e7474fd1f3b6d2c68db'),
(3, 'kasir', 3, 'de28f8f7998f23ab4194b51a6029416f'),
(4, 'owner', 4, '5be057accb25758101fa5eadbbd79503');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `logtransaksi`
--
ALTER TABLE `logtransaksi`
  ADD PRIMARY KEY (`idlog`);

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`idmenu`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`idpelanggan`);

--
-- Indexes for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`idpesanan`),
  ADD KEY `idmenu` (`idmenu`),
  ADD KEY `idpelanggan` (`idpelanggan`),
  ADD KEY `kodepesanan` (`kodepesanan`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`kodepesanan`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`iduser`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `logtransaksi`
--
ALTER TABLE `logtransaksi`
  MODIFY `idlog` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `idmenu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `idpelanggan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `idpesanan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `iduser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`idmenu`) REFERENCES `menu` (`idmenu`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pesanan_ibfk_2` FOREIGN KEY (`idpelanggan`) REFERENCES `pelanggan` (`idpelanggan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`kodepesanan`) REFERENCES `pesanan` (`kodepesanan`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
