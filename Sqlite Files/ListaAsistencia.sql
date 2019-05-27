CREATE TABLE ListaAsistencia
(
  ID      INTEGER
    primary key AUTOINCREMENT,
  IDCurso text,
  IDGrupo int,
  Horario text not null,
  Fecha text not null,
  constraint ListaAsistencia_Grupo_IDCurso_Numero__fk
  FOREIGN KEY (IDCurso, IDGrupo)
    references Grupo (IDCurso, Numero)
      on update cascade
      on delete cascade
);

INSERT INTO "ListaAsistencia" ("ID", "IDCurso", "IDGrupo", "Horario", "Fecha") VALUES ('1', 'IC7602', '1', 'K-9:30-11:20', '2019-04-30'),
('2', 'IC7602', '1', 'J-9:30-11:30', '2019-05-02'),
('3', 'IC7602', '1', 'K-9:30-11:20', '2019-05-07'),
('4', 'IC7602', '1', 'J-9:30-11:20', '2019-05-09');
