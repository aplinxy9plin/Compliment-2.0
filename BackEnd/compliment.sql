-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Янв 26 2018 г., 17:59
-- Версия сервера: 10.1.28-MariaDB
-- Версия PHP: 7.1.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `compliment`
--

-- --------------------------------------------------------

--
-- Структура таблицы `boys`
--

CREATE TABLE `boys` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `vk_id` int(255) NOT NULL,
  `access_token` varchar(255) NOT NULL,
  `quest1` varchar(255) NOT NULL,
  `quest2` varchar(255) NOT NULL,
  `quest3` varchar(255) NOT NULL,
  `quest4` varchar(255) NOT NULL,
  `quest5` varchar(255) NOT NULL,
  `girl_id` int(255) NOT NULL,
  `type` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `girl`
--

CREATE TABLE `girl` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `vk_id` int(255) NOT NULL,
  `quest1` varchar(255) NOT NULL,
  `quest2` varchar(255) NOT NULL,
  `quest3` varchar(255) NOT NULL,
  `quest4` varchar(255) NOT NULL,
  `quest5` varchar(255) NOT NULL,
  `boy_id` int(255) NOT NULL,
  `type` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `boys`
--
ALTER TABLE `boys`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `girl`
--
ALTER TABLE `girl`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `boys`
--
ALTER TABLE `boys`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `girl`
--
ALTER TABLE `girl`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
