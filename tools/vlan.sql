-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Vert: localhost
-- Generert den: 07. Sep, 2014 19:47 PM
-- Tjenerversjon: 5.5.38-0ubuntu0.14.04.1
-- PHP-Versjon: 5.5.9-1ubuntu4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `vlan`
--

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `netlist`
--

CREATE TABLE IF NOT EXISTS `netlist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `network` varchar(45) NOT NULL,
  `subnet` varchar(45) NOT NULL,
  `dhcp` int(1) DEFAULT '0',
  `dhcp_reserved` varchar(45) DEFAULT '0',
  `desc` varchar(100) DEFAULT NULL,
  `de` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

--
-- Dataark for tabell `netlist`
--

INSERT INTO `netlist` (`id`, `name`, `network`, `subnet`, `dhcp`, `dhcp_reserved`, `desc`, `de`) VALUES
(1, 'CREW', '213.184.213.128', '25', 1, '20', NULL, 0),
(2, 'DE-1', '213.184.214.0', '25', 1, '0', '', 1),
(3, 'DE-2', '213.184.214.128', '25', 1, '0', '', 1),
(4, 'DE-3', '213.184.215.0', '25', 1, '0', '', 1),
(5, 'DE-4', '213.184.215.128', '25', 1, '0', '', 1),
(6, 'SERVER', '213.184.213.16', '28', 0, '0', NULL, 0),
(7, 'DIV', '213.184.213.32', '28', 1, '5', NULL, 0),
(8, 'ILO', '10.0.0.1', '24', 1, '100', '', 0);

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `salkart`
--

CREATE TABLE IF NOT EXISTS `salkart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `radnr` int(11) NOT NULL,
  `deltagere` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

--
-- Dataark for tabell `salkart`
--

INSERT INTO `salkart` (`id`, `radnr`, `deltagere`) VALUES
(1, 1, 40),
(2, 2, 40),
(3, 3, 34),
(4, 4, 34),
(5, 5, 26),
(6, 6, 20),
(7, 7, 20),
(8, 8, 32),
(9, 9, 40),
(10, 10, 40),
(11, 11, 40);

-- --------------------------------------------------------

--
-- Tabellstruktur for tabell `switches`
--

CREATE TABLE IF NOT EXISTS `switches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `core` varchar(45) DEFAULT NULL,
  `core_port` varchar(45) DEFAULT NULL,
  `model` varchar(45) NOT NULL,
  `net_id` int(11) DEFAULT NULL,
  `ip` varchar(45) DEFAULT NULL,
  `rad` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=160 ;

--
-- Dataark for tabell `switches`
--

INSERT INTO `switches` (`id`, `name`, `core`, `core_port`, `model`, `net_id`, `ip`, `rad`) VALUES
(134, 'E1.1', '1', 'Gi0/1', 'dlink_24p', 2, NULL, 1),
(135, 'E1.2', '1', 'Gi0/2', '16p', 2, NULL, 1),
(136, 'E1.3', '1', 'Gi0/3', '8p', 2, NULL, 1),
(137, 'E2.1', '1', 'Gi0/4', 'dlink_24p', 2, NULL, 2),
(138, 'E2.2', '1', 'Gi0/5', '16p', 2, NULL, 2),
(139, 'E2.3', '1', 'Gi0/6', '8p', 2, NULL, 2),
(140, 'E3.1', '1', 'Gi0/7', 'dlink_24p', 2, NULL, 3),
(141, 'E3.2', '1', 'Gi0/8', '16p', 2, NULL, 3),
(142, 'E4.1', '1', 'Gi0/9', 'dlink_24p', 3, NULL, 4),
(143, 'E4.2', '1', 'Gi0/10', '16p', 3, NULL, 4),
(144, 'E5.1', '1', 'Gi0/11', 'dlink_24p', 3, NULL, 5),
(145, 'E5.2', '1', 'Gi0/12', '8p', 3, NULL, 5),
(146, 'E6.1', '1', 'Gi0/13', '16p', 3, NULL, 6),
(147, 'E6.2', '1', 'Gi0/14', '16p', 3, NULL, 6),
(148, 'E7.1', '2', 'Gi0/1', '16p', 3, NULL, 7),
(149, 'E7.2', '2', 'Gi0/2', '16p', 3, NULL, 7),
(150, 'E8.1', '2', 'Gi0/3', 'dlink_24p', 4, NULL, 8),
(151, 'E8.2', '2', 'Gi0/4', '16p', 4, NULL, 8),
(152, 'E9.1', '2', 'Gi0/5', 'dlink_24p', 4, NULL, 9),
(153, 'E9.2', '2', 'Gi0/6', '16p', 4, NULL, 9),
(154, 'E9.3', '2', 'Gi0/7', '16p', 4, NULL, 9),
(155, 'E10.1', '2', 'Gi0/8', 'dlink_24p', 4, NULL, 10),
(156, 'E10.2', '2', 'Gi0/9', '16p', 4, NULL, 10),
(157, 'E10.3', '2', 'Gi0/10', '16p', 4, NULL, 10),
(158, 'E11.1', '2', 'Gi0/11', 'dlink_24p', 5, NULL, 11),
(159, 'E11.2', '2', 'Gi0/12', 'dlink_24p', 5, NULL, 11);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
