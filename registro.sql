-- phpMyAdmin SQL Dump
-- version 4.7.5
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 21-11-2017 a las 02:04:32
-- Versión del servidor: 10.1.28-MariaDB
-- Versión de PHP: 7.1.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `registro`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`andres`@`localhost` PROCEDURE `GET_IN_DOC` (IN `cod` VARCHAR(40), IN `nom` VARCHAR(40), IN `password` VARCHAR(50), IN `cur` VARCHAR(40))  BEGIN

    INSERT INTO docentes VALUES(cod , nom , cur);
    UPDATE cursos SET codDoc= cod WHERE codCur = cur ;
    INSERT INTO usuarios VALUES ( cod , null , nom , 2 , AES_ENCRYPT(password, 1999 ) )  ;

END$$

CREATE DEFINER=`andres`@`localhost` PROCEDURE `GET_IN_EST` (`cod` VARCHAR(40), `nom` VARCHAR(40), `password` VARCHAR(50))  BEGIN

	INSERT INTO estudiantes VALUES(cod , nom);
	INSERT INTO usuarios VALUES ( null , cod , nom , 3 , AES_ENCRYPT(password, 1999 ) )  ;

END$$

CREATE DEFINER=`andres`@`localhost` PROCEDURE `LOGIN` (IN `con` VARCHAR(50), IN `nom` VARCHAR(40))  BEGIN

	SELECT * FROM usuarios WHERE ( AES_DECRYPT(password, 1999 ) ) = con and BINARY nomUsu = nom;

END$$

CREATE DEFINER=`andres`@`localhost` PROCEDURE `validate` (IN `pass` VARCHAR(50))  BEGIN

IF ( SELECT COUNT(*) FROM `usuarios` WHERE (AES_DECRYPT(password , 1999)) = pass ) <> 0  THEN
SELECT "false" as value;
ELSE SELECT "true" as value;

END IF;


END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cursos`
--

CREATE TABLE `cursos` (
  `codCur` int(4) NOT NULL,
  `nomCur` varchar(40) NOT NULL,
  `codDoc` int(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `cursos`
--

INSERT INTO `cursos` (`codCur`, `nomCur`, `codDoc`) VALUES
(1, 'JAVA', 1),
(2, 'SISTEMAS', 2),
(3, 'INGLES', 3),
(4, 'ELECTRICIDAD', 4),
(5, 'MATEMATICAS', 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `docentes`
--

CREATE TABLE `docentes` (
  `codDoc` int(4) NOT NULL,
  `nomDoc` varchar(40) NOT NULL,
  `codCur` int(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `docentes`
--

INSERT INTO `docentes` (`codDoc`, `nomDoc`, `codCur`) VALUES
(1, 'JONATAN', 1),
(2, 'RAMIRO', 2),
(3, 'MAURICIO', 3),
(4, 'JORGE', 4),
(5, 'CAMILO', 5);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `docentes_pass`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `docentes_pass` (
`codDoc` int(4)
,`nomUsu` varchar(40)
,`DECRYPT` blob
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiantes`
--

CREATE TABLE `estudiantes` (
  `codEst` int(4) NOT NULL,
  `nomEst` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `estudiantes`
--

INSERT INTO `estudiantes` (`codEst`, `nomEst`) VALUES
(1, 'ANDRES'),
(2, 'SARA'),
(3, 'MONICA'),
(4, 'JAVIER'),
(5, 'LUIZ');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `estudiantes_pass`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `estudiantes_pass` (
`codEst` int(4)
,`nomUsu` varchar(40)
,`DECRYPT` blob
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `matricula`
--

CREATE TABLE `matricula` (
  `codEst` int(4) NOT NULL,
  `codCur` int(4) NOT NULL,
  `nota` double(2,1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `matricula`
--

INSERT INTO `matricula` (`codEst`, `codCur`, `nota`) VALUES
(1, 3, 4.5),
(1, 2, NULL),
(2, 4, NULL),
(2, 3, 5.0),
(2, 1, 4.0),
(3, 3, 2.5),
(3, 1, 3.0),
(5, 1, 3.2),
(5, 2, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `codRol` int(4) NOT NULL,
  `nomRol` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`codRol`, `nomRol`) VALUES
(1, 'ADMINISTRADOR'),
(2, 'DOCENTE'),
(3, 'ESTUDIANTE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `codDoc` int(4) DEFAULT NULL,
  `codEst` int(4) DEFAULT NULL,
  `nomUsu` varchar(40) NOT NULL,
  `codRol` int(4) NOT NULL,
  `password` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`codDoc`, `codEst`, `nomUsu`, `codRol`, `password`) VALUES
(NULL, NULL, 'ANDRES_MONTOYA', 1, 0xbeb3d7867be0beaef0d05316e69fd092),
(1, NULL, 'JONATAN', 2, 0x069faafad918453d4d99fde994742be8),
(2, NULL, 'RAMIRO', 2, 0xf9c5da6db0755d86091e4a2c1fc6dbcd),
(NULL, 1, 'ANDRES', 3, 0xdb68b6c9caf33c52efb6314bfb908589),
(NULL, 2, 'SARA', 3, 0xcf5fb60e74cd7c589597acdad92e0516),
(NULL, 3, 'MONICA', 3, 0x4b0de3017eb4a60fb9793cbcbcaca17d),
(NULL, 4, 'JAVIER', 3, 0x8743a4b8941bbaba17f96cc9ae77a75c),
(NULL, 5, 'LUIZ', 3, 0xcc58eb2cb451b015086546360f7d3079),
(3, NULL, 'MAURICIO', 2, 0x7aed84475ac9e296ccc42e4723823d4b),
(4, NULL, 'JORGE', 2, 0x62b714b83b0634f5f2fdf6189c3b7ff7),
(5, NULL, 'CAMILO', 2, 0x08862c3315fc4f6ba8c6ab0433f6b381);

-- --------------------------------------------------------

--
-- Estructura para la vista `docentes_pass`
--
DROP TABLE IF EXISTS `docentes_pass`;

CREATE ALGORITHM=UNDEFINED DEFINER=`andres`@`localhost` SQL SECURITY DEFINER VIEW `docentes_pass`  AS  select `usuarios`.`codDoc` AS `codDoc`,`usuarios`.`nomUsu` AS `nomUsu`,aes_decrypt(`usuarios`.`password`,1999) AS `DECRYPT` from `usuarios` where (`usuarios`.`codDoc` is not null) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `estudiantes_pass`
--
DROP TABLE IF EXISTS `estudiantes_pass`;

CREATE ALGORITHM=UNDEFINED DEFINER=`andres`@`localhost` SQL SECURITY DEFINER VIEW `estudiantes_pass`  AS  select `usuarios`.`codEst` AS `codEst`,`usuarios`.`nomUsu` AS `nomUsu`,aes_decrypt(`usuarios`.`password`,1999) AS `DECRYPT` from `usuarios` where (`usuarios`.`codEst` is not null) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cursos`
--
ALTER TABLE `cursos`
  ADD PRIMARY KEY (`codCur`),
  ADD UNIQUE KEY `nomCur` (`nomCur`),
  ADD UNIQUE KEY `codDoc` (`codDoc`);

--
-- Indices de la tabla `docentes`
--
ALTER TABLE `docentes`
  ADD PRIMARY KEY (`codDoc`),
  ADD UNIQUE KEY `codCur` (`codCur`) USING BTREE;

--
-- Indices de la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  ADD PRIMARY KEY (`codEst`);

--
-- Indices de la tabla `matricula`
--
ALTER TABLE `matricula`
  ADD KEY `codCur` (`codCur`) USING BTREE,
  ADD KEY `codEst` (`codEst`) USING BTREE;

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`codRol`),
  ADD UNIQUE KEY `nomRol` (`nomRol`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD UNIQUE KEY `codEst_2` (`codEst`),
  ADD UNIQUE KEY `codDoc` (`codDoc`),
  ADD KEY `codUsu` (`codDoc`),
  ADD KEY `codEst` (`codEst`),
  ADD KEY `codRol` (`codRol`) USING BTREE;

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `codRol` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cursos`
--
ALTER TABLE `cursos`
  ADD CONSTRAINT `cursos_ibfk_1` FOREIGN KEY (`codDoc`) REFERENCES `docentes` (`codDoc`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `docentes`
--
ALTER TABLE `docentes`
  ADD CONSTRAINT `docentes_ibfk_1` FOREIGN KEY (`codCur`) REFERENCES `cursos` (`codCur`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `matricula`
--
ALTER TABLE `matricula`
  ADD CONSTRAINT `matricula_ibfk_4` FOREIGN KEY (`codEst`) REFERENCES `estudiantes` (`codEst`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `matricula_ibfk_5` FOREIGN KEY (`codCur`) REFERENCES `cursos` (`codCur`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`codEst`) REFERENCES `estudiantes` (`codEst`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `usuarios_ibfk_2` FOREIGN KEY (`codDoc`) REFERENCES `docentes` (`codDoc`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `usuarios_ibfk_3` FOREIGN KEY (`codRol`) REFERENCES `roles` (`codRol`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
