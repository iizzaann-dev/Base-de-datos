USE escuela;
SELECT * FROM profesores_alumnos
INNER JOIN profesores ON profesores.id_profesor = profesores_alumnos.id_profesor
INNER JOIN alumnos on alumnos.id_alumno = profesores_alumnos.id_alumnos;
-- Borramos al profesor con id = 12 (por ahora no funciona) --
delete from profesores
where id_profesor=12;