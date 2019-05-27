CREATE TABLE Estudiante
(
  Carne      int
    primary key,
  Nombre     text not null,
  Apellidos text not null,
  Correo     text not null,
  Contrasena text not null
);

INSERT INTO "Estudiante" ("Carne", "Nombre", "Apellidos", "Correo", "Contrasena") VALUES ('2015100516', 'joseph', 'salazar', 'jossalazar@ic-itcr.ac.cr', 'BI2MT9LBxtZD+2qCaP5KPvZKx5CSS0kV09i8JB4S9zzHm2VHiweQUPZd03ccuEWJWqXYNLKcdHCXcQPUUF/tHOA65n/hnN2s8v6kq09jZAo5Usx9dsf0G4aq');
