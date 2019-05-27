-- Database Manager 4.2.5 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `AsistenciaPorEstudiante`;
CREATE TABLE `AsistenciaPorEstudiante` (
  `IDListaAsist` int(255) NOT NULL,
  `Carne` int(255) NOT NULL,
  `Estado` varchar(1) NOT NULL,
  PRIMARY KEY (`IDListaAsist`,`Carne`),
  KEY `Carne` (`Carne`),
  CONSTRAINT `AsistenciaPorEstudiante_ibfk_3` FOREIGN KEY (`Carne`) REFERENCES `Estudiante` (`Carne`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `AsistenciaPorEstudiante_ibfk_2` FOREIGN KEY (`IDListaAsist`) REFERENCES `ListaAsistencia` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `AsistenciaPorEstudiante` (`IDListaAsist`, `Carne`, `Estado`) VALUES
(1,	2015100516,	'P'),
(2,	2015100516,	'T'),
(3,	2015100516,	'P'),
(4,	2015100516,	'P');

DROP TABLE IF EXISTS `Curso`;
CREATE TABLE `Curso` (
  `Codigo` varchar(255) NOT NULL,
  `Nombre` varchar(255) NOT NULL,
  PRIMARY KEY (`Codigo`),
  KEY `Codigo` (`Codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Curso` (`Codigo`, `Nombre`) VALUES
('CA2125',	'Elementos De Computacion'),
('CA3125',	'Analisis Y Diseno De Algoritmos'),
('IC1400',	'Fundamentos De Organizacion De Computadoras'),
('IC1802',	'Introduccion A La Programacion'),
('IC1803',	'Taller De Programacion\"IC1803'),
('IC2001',	'Estructuras De Datos'),
('IC2101',	'Programacion Orientada A Objetos'),
('IC3002',	'Analisis De Algoritmos'),
('IC3101',	'Arquitectura De Computadores'),
('IC4301',	'Bases De Datos I'),
('IC4302',	'Bases De Datos II'),
('IC4700',	'Lenguajes De Programacion'),
('IC4810',	'Administracion De Proyectos'),
('IC5701',	'Compiladores E Interpretes'),
('IC5821',	'Requerimientos De Software'),
('IC6200',	'Inteligencia Artificial'),
('IC6400',	'Investigacion De Operaciones'),
('IC6600',	'Principios De Sistemas Operativos'),
('IC6821',	'Diseño De Software'),
('IC6831',	'Aseguramiento De La Calidad Del Software'),
('IC7602',	'Redes'),
('IC7841',	'Proyecto De Ingenieria De Software'),
('IC7900',	'Computacion Y Sociedad'),
('IC8842',	'Practica Profesional');

DROP TABLE IF EXISTS `Estudiante`;
CREATE TABLE `Estudiante` (
  `Carne` int(255) NOT NULL,
  `Nombre` varchar(255) NOT NULL,
  `Apellidos` varchar(255) NOT NULL,
  `Correo` varchar(255) NOT NULL,
  `Contrasena` varchar(500) NOT NULL,
  PRIMARY KEY (`Carne`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Estudiante` (`Carne`, `Nombre`, `Apellidos`, `Correo`, `Contrasena`) VALUES
(2015100516,	'joseph',	'salazar',	'jossalazar@ic-itcr.ac.cr',	'BI2MT9LBxtZD+2qCaP5KPvZKx5CSS0kV09i8JB4S9zzHm2VHiweQUPZd03ccuEWJWqXYNLKcdHCXcQPUUF/tHOA65n/hnN2s8v6kq09jZAo5Usx9dsf0G4aq');

DROP TABLE IF EXISTS `Grupo`;
CREATE TABLE `Grupo` (
  `IDCurso` varchar(255) NOT NULL,
  `Numero` int(255) NOT NULL,
  `IDProfe` int(255) NOT NULL,
  `Dia1` varchar(255) NOT NULL,
  `Dia2` varchar(255) NOT NULL,
  `Codigo` varchar(1000) NOT NULL,
  PRIMARY KEY (`IDCurso`,`Numero`),
  KEY `IDProfe` (`IDProfe`),
  KEY `IDCurso` (`IDCurso`),
  CONSTRAINT `Grupo_ibfk_2` FOREIGN KEY (`IDCurso`) REFERENCES `Curso` (`Codigo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Grupo_ibfk_1` FOREIGN KEY (`IDProfe`) REFERENCES `Profesor` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Grupo` (`IDCurso`, `Numero`, `IDProfe`, `Dia1`, `Dia2`, `Codigo`) VALUES
('IC3101',	1,	1,	'K-7:30-9:20',	'J-7:30-9:20',	'iVBORw0KGgoAAAANSUhEUgAAACMAAAAjCAYAAAAe2bNZAAAAAXNSR0IArs4c6QAA  ABxpRE9UAAAAAgAAAAAAAAASAAAAKAAAABIAAAARAAABcoDGSzsAAAE+SURBVFgJ  zJNZDgJBCAX7/pfWQCxSTcCoX3YyAm8BZvE8/uic2OWcs17w7BxaY5O38/ZO+upp  IyYiIjTUbgjn6Bytsch9qm+AVegJbbi11pD34b3edIlDEt+Z0UTkoCcGTk60tvPU  Ga9ieTJdEzUnBnIYPmGhAe+6wi2iKbFEWtIYOkf4CZu40IF/9W8q0+tp/FKHZ7py  Kd/BljM0Da9mzt2cHhMGt8V64Qx0dEPyqREec2D4HENHTZ6RYiLhiKHZ8s2Pnth7  XL7srh/Ek1my+c7aK7S+9zPHzPEDxjgZJg7ddZf6UOEn7+WZBGC1cbtjGhAZ1vXU  5sEcK0dILELfR3CBw32ixWMtPdwHLPXvxKtJi1nTF6BG48FwzM8a0AawS6gFzOPb  tCzgaK3z+oA9gNyDPmqmV2v9ljOHhZ4AAAD///sqRGAAAAFASURBVM2T0XKEMAwD  +f+fvlYmm25cc9fHeibItiQbBrhef4zrul45iSl3r4/Eh9f8wVlwEFqOxvzUgwdZ  mno6fUY9ajcj+jTMC6zF33nX7ATLg9HDbJr6Tx5rybv2XX1/BN8KbuBJDH88ib4h  fObTc5ib8v2aQiIwOvfg5N0z1dZ13lzluSS8lPxmfjjXDLbWPefv5qMrjYXTMvi+  FC3Y+almsTn8tcfFU455GuaedcyCpw723vaZRGSEDybgyKu5LgyFo56QOXDlwbjm  HYAQo0k495Kjhae2zr0jZwB4kOvXhXtCe6xJnoA33sx9TT+xf+0q1u+9SUStX86Y  F493QmvRB322pg9A5P4Wa8hTDz/InNQE+S9EjNBocXKONc7hQbjUROfoB/drQtTx  EK8bcq+GrG');

DROP TABLE IF EXISTS `ListaAsistencia`;
CREATE TABLE `ListaAsistencia` (
  `ID` int(255) NOT NULL AUTO_INCREMENT,
  `IDCurso` varchar(255) NOT NULL,
  `IDGrupo` int(255) NOT NULL,
  `Horario` varchar(255) NOT NULL,
  `Fecha` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `ListaAsistencia` (`ID`, `IDCurso`, `IDGrupo`, `Horario`, `Fecha`) VALUES
(1,	'IC7602',	1,	'K-9:30-11:20',	'2019-04-30'),
(2,	'IC7602',	1,	'J-9:30-11:30',	'2019-05-02'),
(3,	'IC7602',	1,	'K-9:30-11:20',	'2019-05-07'),
(4,	'IC7602',	1,	'J-9:30-11:20',	'2019-05-09');

DROP TABLE IF EXISTS `Profesor`;
CREATE TABLE `Profesor` (
  `ID` int(255) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(255) NOT NULL,
  `Apellidos` varchar(255) NOT NULL,
  `Correo` varchar(255) NOT NULL,
  `Contrasena` varchar(500) NOT NULL,
  `TiempoTardiaCodigo` int(255) NOT NULL,
  `TiempoVigenciaCodigo` int(255) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Correo` (`Correo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Profesor` (`ID`, `Nombre`, `Apellidos`, `Correo`, `Contrasena`, `TiempoTardiaCodigo`, `TiempoVigenciaCodigo`) VALUES
(1,	'Carlos',	'Benavides',	'cbenavides@itcr.ac.cr',	'BFfIfYGY+6TywTCQw5lFTc3u39KFoaV7VJIZunCakJTnwPy7Gxl4QwKRsxr/cGLrF/HlgEISUb2yiZAERKwrtn75L/fHnMQADXn7GoEdSRf7qUi46qsbhAk=',	15,	120),
(2,	'Ivannia',	'Cerdas',	'icerdas@itcr.ac.cr',	'123456789',	15,	120),
(3,	'Alicia	',	'Salazar Hernandez',	'asalazar@itcr.ac.cr',	'123456789',	15,	120),
(4,	'Juan Carlos',	'Ortega Brenes',	'jcortega@itcr.ac.cr',	'123456789',	15,	120),
(5,	'Laura',	'Coto Sarmiento',	'lcoto@itcr.ac.cr',	'123456789',	15,	120),
(6,	'Ivan',	'Campos Fernandez',	'icampos@itcr.ac.cr',	'123456789',	15,	120),
(7,	'William',	'Mata Rodriguez',	'wmata@itcr.ac.cr',	'123456789',	15,	120),
(8,	'Luis Roberto',	'Villalobos Arias',	'lrvillalobos@itcr.ac.cr',	'123456789',	15,	120),
(9,	'Gustavo',	'Villavicencio Gomez',	'gvillavicencio@itcr.ac.cr',	'123456789',	15,	120),
(10,	'Ignacio',	'Trejos Zelaya',	'itrejos@itcr.ac.cr',	'123456789',	15,	120),
(11,	'Victor',	'Garro Abarca',	'vgarro@itcr.ac.cr',	'123456789',	15,	120),
(12,	'Armando',	'Arce Orozco',	'aarce@itcr.ac.cr',	'123456789',	15,	120),
(13,	'Kirstein',	'Gatjens Soto',	'kgatjens@itcr.ac.cr',	'123456789',	15,	120),
(14,	'Jorge',	'Vargas Calvo',	'jvargas@itcr.ac.cr',	'123456789',	15,	120),
(15,	'Esteban',	'Arias Mendez ',	'earias@itcr.ac.cr',	'123456789',	15,	120),
(16,	'Luis Alexander',	'Calvo Valverde',	'lacalvo@itcr.ac.cr',	'123456789',	15,	120),
(17,	'Jose',	'Stradi Granados',	'jstradi@itcr.ac.cr',	'123456789',	15,	120),
(18,	'Diego',	'Mora Rojas',	'dmora@itcr.ac.cr',	'123456789',	15,	120),
(19,	'Juan',	'Gomez Pereira',	'jgomez@itcr.ac.cr',	'123456789',	15,	120),
(20,	'Luis Pablo',	'Soto Chaves',	'lpsoto@itcr.ac.cr',	'123456789',	15,	120),
(21,	'Jose Dolores',	'Navas Su',	'jdnavas@itcr.ac.cr',	'123456789',	15,	120),
(22,	'Rodrigo',	'Nuñez Nuñez',	'rnuñez@itcr.ac.cr',	'123456789',	15,	120),
(23,	'Jose Enrique',	'Araya Monge',	'jearaya@itcr.ac.cr',	'123456789',	15,	120),
(24,	'Andrei',	'Fuentes Leiva',	'afuentes@itcr.ac.cr',	'123456789',	15,	120),
(25,	'Mauricio',	'Arroyo Herrera',	'marroyo@itcr.ac.cr',	'123456789',	15,	120),
(26,	'Jaime',	'Solano Soto ',	'jsolano@itcr.ac.cr',	'123456789',	15,	120),
(27,	'Saul',	'Calderon Ramirez',	'scalderon@itcr.ac.cr',	'123456789',	15,	120),
(28,	'Jose Elias',	'Helo Guzman',	'jehelo@itcr.ac.cr',	'123456789',	15,	120),
(29,	'Erika',	'Marin Schumann',	'emarin@itcr.ac.cr',	'123456789',	15,	120),
(30,	'Ericka',	'Solano Fernandez',	'esolano@itcr.ac.cr',	'123456789',	15,	120),
(31,	'Rodrigo',	'Bogarin Navarro',	'rbogarin@itcr.ac.cr',	'123456789',	15,	120),
(32,	'Maria',	'Estrada Sanchez',	'mestrada@itcr.ac.cr',	'123456789',	15,	120),
(33,	'Prueba',	'Prueba',	'prueba@gmail.com',	'BFfIfYGY+6TywTCQw5lFTc3u39KFoaV7VJIZunCakJTnwPy7Gxl4QwKRsxr/cGLrF/HlgEISUb2yiZAERKwrtn75L/fHnMQADXn7GoEdSRf7qUi46qsbhAk=',	15,	120);

-- 2019-05-12 22:21:10