CREATE TABLE `garage` (
  `id` int(11) NOT NULL,
  `owner` varchar(60) DEFAULT NULL,
  `posOut` longtext NOT NULL,
  `type` int(2) NOT NULL,
  `date` date DEFAULT NULL,
  `label` varchar(30) NOT NULL,
  `garage` longtext NOT NULL DEFAULT '[]',
  `price` int(6) NOT NULL,
  `code` int(5) DEFAULT NULL,
  `item` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `garage`
ADD PRIMARY KEY (`id`);
ALTER TABLE `garage`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--- Xed#1188 | https://discord.gg/HvfAsbgVpM