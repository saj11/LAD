CREATE TABLE AsistenciaPorEstudiante
(
  IDListaAsist int
    constraint AsistenciaPorEstudiante_ListaAsistencia_ID_fk
    references ListaAsistencia (ID)
      on update cascade
      on delete cascade,
  Carne        int
    constraint AsistenciaPorEstudiante_Estudiante_Carne_fk
    references Estudiante (Carne)
      on update cascade
      on delete cascade,
  Estado       boolean not null,
  constraint AsistenciaPorEstudiante_IDListaAsist_Carne_pk
  primary key (IDListaAsist, Carne)
);

INSERT INTO "AsistenciaPorEstudiante" ("IDListaAsist", "Carne", "Estado") VALUES ('1', '2015100516', 'P'),
('2', '2015100516', 'T'),
('3', '2015100516', 'P'),
('4', '2015100516', 'P');
