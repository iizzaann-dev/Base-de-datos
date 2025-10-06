USE escuela;
SELECT * FROM profesores_alumnos
INNER JOIN profesores 
ON profesores_alumnos.id_profesor = profesores.id_profesor
INNER JOIN alumnos
ON profesores_alumnos.id_alumno = alumnos.id_alumno;