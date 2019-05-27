CREATE TABLE Grupo
(
  IDCurso text
    constraint Grupo_Curso_Codigo_fk
    references Curso (Codigo)
      on update cascade
      on delete cascade,
  Numero  int,
  IDProfe int
    constraint Grupo_Profesor_ID_fk
    references Profesor (ID)
      on update cascade
      on delete cascade,
  Dia1    text not null,
  Dia2    text not null,
  Codigo  text,
  constraint Grupo_IDCurso_Numero_pk
  primary key (IDCurso, Numero)
);

INSERT INTO "Grupo" ("IDCurso", "Numero", "IDProfe", "Dia1", "Dia2", "Codigo") VALUES ('IC3101', '1', '1', 'K-7:30-9:20', 'J-7:30-9:20', 'iVBORw0KGgoAAAANSUhEUgAAACMAAAAjCAYAAAAe2bNZAAAAAXNSR0IArs4c6QAA

ABxpRE9UAAAAAgAAAAAAAAASAAAAKAAAABIAAAARAAABcoDGSzsAAAE+SURBVFgJ

zJNZDgJBCAX7/pfWQCxSTcCoX3YyAm8BZvE8/uic2OWcs17w7BxaY5O38/ZO+upp

IyYiIjTUbgjn6Bytsch9qm+AVegJbbi11pD34b3edIlDEt+Z0UTkoCcGTk60tvPU

Ga9ieTJdEzUnBnIYPmGhAe+6wi2iKbFEWtIYOkf4CZu40IF/9W8q0+tp/FKHZ7py

Kd/BljM0Da9mzt2cHhMGt8V64Qx0dEPyqREec2D4HENHTZ6RYiLhiKHZ8s2Pnth7

XL7srh/Ek1my+c7aK7S+9zPHzPEDxjgZJg7ddZf6UOEn7+WZBGC1cbtjGhAZ1vXU

5sEcK0dILELfR3CBw32ixWMtPdwHLPXvxKtJi1nTF6BG48FwzM8a0AawS6gFzOPb

tCzgaK3z+oA9gNyDPmqmV2v9ljOHhZ4AAAD///sqRGAAAAFASURBVM2T0XKEMAwD

+f+fvlYmm25cc9fHeibItiQbBrhef4zrul45iSl3r4/Eh9f8wVlwEFqOxvzUgwdZ

mno6fUY9ajcj+jTMC6zF33nX7ATLg9HDbJr6Tx5rybv2XX1/BN8KbuBJDH88ib4h

fObTc5ib8v2aQiIwOvfg5N0z1dZ13lzluSS8lPxmfjjXDLbWPefv5qMrjYXTMvi+

FC3Y+almsTn8tcfFU455GuaedcyCpw723vaZRGSEDybgyKu5LgyFo56QOXDlwbjm

HYAQo0k495Kjhae2zr0jZwB4kOvXhXtCe6xJnoA33sx9TT+xf+0q1u+9SUStX86Y

F493QmvRB322pg9A5P4Wa8hTDz/InNQE+S9EjNBocXKONc7hQbjUROfoB/drQtTx

EK8bcq+GrGV46VEHCfKRQ/Qf8AuoPHM2X2m/4QAAAABJRU5ErkJggg=='),
('IC7602', '1', '1', 'K-9:30-11:20', 'J-9:30-11:20', 'iVBORw0KGgoAAAANSUhEUgAAACMAAAAjCAYAAAAe2bNZAAAAAXNSR0IArs4c6QAA

ABxpRE9UAAAAAgAAAAAAAAASAAAAKAAAABIAAAARAAABapOq020AAAE2SURBVFgJ

zNPBbsMwDANQ//9Pb1CAZ9CqnF16WICAEknRQt2sn3/0rNplrXV97VoeT6/N02H6

iuOb8NGZCvsjDJYuiDf7XqfHLC5R/v5lmG+BqQviFcbTkZ5o9vAeTVxX5/U9pPc3

Hx6Oc0Q4mtqSb97S8qk8j9oZ2ZfnuCZDkPkxXkJ5Yc6Yw0FeiN/LFDG9Ar+F0xnH

Mja8YQbkUm/1LeuN3xe6t2u/kAMnPYPpyZmFPIVZm9nXtIn4b+ASBQmjdX7q0zvW

ncxD1H+hDJiLmC1t4nGPLoA5e5zARDUPPMKHK5fPd+QQhelH83DXky+zUs+DnXN4

NYb0aVZnGD8ue7UsHjmw8x9fUwYwT4hLf68dip/6I4ehyHzfeAGQF3b+1hef2sen

LbCQOQfoND1/x/TJ6Rz+FwAA//+C1wBeAAABPUlEQVTF01FywkAMA1Duf+m2WniL

6tmE/tUziWxJ1oYAj6+qx+Oxp+5DnmZcY3rXDnvtn3yd/T69DpxLFvBmiA/q77T2

8C3MLdWGUyjPydf+1nvn5MHZWW9mD4dPlkBlObMdvblRzxNUrW0uDSHo2oYfTtEa

o2VuXMOLn16+087xzbRRmJA+CHflP+nN9d7iicGuNnYfj7n7cH3Jau/kpn+/mbnE

KADy0SE92B4z30T6wtw+lYD4HGSnNdz0nXZ4Wvv1ZgQ3OqCXOoj3ysd7h3u3TUjo

AfpA/QllXWlXufGvXQFQkBlayKya6z66nDuUA/fXNAPME4Xj50OET/HBJ/v+zfWe

/k8P0+F6uIPqr00LqukLH861ZmRwVgdE61nIHdd5/DgzXPnrVk9IhL38qZfVOHsZ

J/75M27HP/bfyC+jBvgXQAEAAAAASUVORK5CYII=');
