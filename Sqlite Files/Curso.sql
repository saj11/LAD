CREATE TABLE Curso
(
  Codigo  text 
    primary key,
  Nombre  text not null
);

INSERT INTO "Curso" ("Codigo", "Nombre") VALUES ('CA2125', 'Elementos De Computacion'),
('CA3125', 'Analisis Y Diseño De Algoritmos'),
('IC1400', 'Fundamentos De Organizacion De Computadoras'),
('IC1802', 'Introduccion A La Programacion'),
('IC1803', 'Taller De Programacion"IC1803'),
('IC2001', 'Estructuras De Datos'),
('IC2101', 'Programacion Orientada A Objetos'),
('IC3002', 'Analisis De Algoritmos'),
('IC3101', 'Arquitectura De Computadores'),
('IC4301', 'Bases De Datos I'),
('IC4302', 'Bases De Datos II'),
('IC4700', 'Lenguajes De Programacion'),
('IC4810', 'Administracion De Proyectos'),
('IC5701', 'Compiladores E Interpretes'),
('IC5821', 'Requerimientos De Software'),
('IC6200', 'Inteligencia Artificial'),
('IC6400', 'Investigacion De Operaciones'),
('IC6600', 'Principios De Sistemas Operativos'),
('IC6821', 'Diseño De Software'),
('IC6831', 'Aseguramiento De La Calidad Del Software'),
('IC7602', 'Redes'),
('IC7841', 'Proyecto De Ingenieria De Software'),
('IC7900', 'Computacion Y Sociedad'),
('IC8842', 'Practica Profesional');
