/*Ejercicio 4
PERSONA = (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero)
ALUMNO = (DNI (fk), Legajo, Año_Ingreso)
PROFESOR = (DNI (fk), Matricula, Nro_Expediente)
TITULO = (Cod_Titulo, Nombre, Descripción)
TITULO-PROFESOR = (Cod_Titulo (fk), DNI (fk), Fecha)
CURSO = (Cod_Curso, Nombre, Descripción, Fecha_Creacion, Duracion)
ALUMNO-CURSO = (DNI (fk), Cod_Curso (fk), Año, Desempeño, Calificación)
PROFESOR-CURSO = (DNI (fk), Cod_Curso (fk), Fecha_Desde, Fecha_Hasta) */

--Consultar natural join y asterisco cuando hacemos un count

/*1. Listar DNI, legajo y apellido y nombre de todos los alumnos que tengan año de ingreso inferior a
2014.*/

SELECT a.DNI, a.legajo, p.nombre, p.apellido 
FROM Persona p NATURAL JOIN Alumno a 
WHERE ( a.anio_ingreso < 1/1/2014)

/*2. Listar DNI, matrícula, apellido y nombre de los profesores que dictan cursos que tengan más de
100 horas de duración. Ordenar por DNI.*/

SELECT pro.DNI, pro.matricula, p.apellido, p.nombre 
FROM Persona p NATURAL JOIN Profesor pro NATURAL JOIN Profesor-curso pc NATURAL JOIN Curso c
WHERE (c.duracion > 100)
ORDER BY pro.DNI 
 
/*3. Listar el DNI, Apellido, Nombre, Género y Fecha de nacimiento de los alumnos inscriptos al
curso con nombre “Diseño de Bases de Datos” en 2023*/

SELECT p.DNI, p.apellido, p.nombre, p.genero, p.fecha_nacimiento
FROM Persona p NATURAL JOIN Alumno a NATURAL JOIN Alumno_curso ac INNER JOIN Curso c ON (ac.Cod_Curso = c.Cod_Curso)
WHERE (c.nombre = 'Diseño de Bases de Datos' AND ac.Anio = 2023)

/*Listar el DNI, Apellido, Nombre y Calificación de aquellos alumnos que obtuvieron una
calificación superior a 8 en algún curso que dicta el profesor “Juan Garcia”. Dicho listado deberá
estar ordenado por Apellido y nombre*/

SELECT p.DNI, p.Apellido, p.Nombre, ac.Calificacion
FROM  Persona p NATURAL JOIN ALUMNO_CURSO ac 
WHERE (ac.Calificacion > 8) AND (ac.Cod_Curso IN (
    SELECT pc.Cod_Curso 
    FROM PROFESOR_CURSO pc NATURAL JOIN Persona p1
    WHERE (p1.Nombre = 'Juan' AND p1.Apellido = 'Garcia'))) 
ORDER BY p.Apellido, p.Nombre 


/*5. Listar el DNI, Apellido, Nombre y Matrícula de aquellos profesores que posean más de 3 títulos.
Dicho listado deberá estar ordenado por Apellido y Nombre*/

SELECT p.DNI, p.Apellido, p.Nombre, pro.Matricula 
FROM PERSONA p NATURAL JOIN PROFESOR pro NATURAL JOIN TITULO_PROFESOR tp
GROUP BY p.DNI, p.Apellido, p.Nombre, pro.Matricula
HAVING COUNT (*) > 3
ORDER BY p.Apellido, p.Nombre  


/*6. Listar el DNI, Apellido, Nombre, Cantidad de horas y Promedio de horas que dicta cada profesor.
La cantidad de horas se calcula como la suma de la duración de todos los cursos que dicta*/

SELECT p.DNI, p.Apellido, p.Nombre, SUM (c.Duracion) AS cantHoras, AVG(c.Duracion) AS promedioHoras
FROM Persona p NATURAL JOIN PROFESOR_CURSO pc INNER JOIN CURSO c ON (pc.Cod_Curso = c.Cod_Curso)
GROUP BY p.DNI, p.Apellido, p.Nombre 

/*Ejercicio 4
PERSONA = (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero)
ALUMNO = (DNI (fk), Legajo, Año_Ingreso)
PROFESOR = (DNI (fk), Matricula, Nro_Expediente)
TITULO = (Cod_Titulo, Nombre, Descripción)
TITULO-PROFESOR = (Cod_Titulo (fk), DNI (fk), Fecha)
CURSO = (Cod_Curso, Nombre, Descripción, Fecha_Creacion, Duracion)
ALUMNO-CURSO = (DNI (fk), Cod_Curso (fk), Año, Desempeño, Calificación)
PROFESOR-CURSO = (DNI (fk), Cod_Curso (fk), Fecha_Desde, Fecha_Hasta) */

/*7. Listar Nombre y Descripción del curso que posea más alumnos inscriptos y del que posea
menos alumnos inscriptos durante 2024*/ 

SELECT c.Nombre, c.Descripcion 
FROM CURSO c NATURAL JOIN Alumno_Curso 
WHERE (Anio BETWEEN 1/1/2024 AND 31/12/2024)
GROUP BY c.Cod_Curso, c.Nombre, c.Descripcion
HAVING COUNT(*) >= (
    SELECT COUNT(*)
    FROM CURSO c NATURAL JOIN Alumno_Curso  
    WHERE (Anio BETWEEN 1/1/2024 AND 31/12/2024)
    GROUP BY c.Cod_Curso, c.Nombre, c.Descripcion
)
UNION
SELECT c.Nombre, c.Descripcion 
FROM CURSO c NATURAL JOIN Alumno_Curso 
WHERE (Anio BETWEEN 1/1/2024 AND 31/12/2024)
GROUP BY c.Cod_Curso, c.Nombre, c.Descripcion
HAVING COUNT(*) <= (
    SELECT COUNT(*)
    FROM CURSO c NATURAL JOIN Alumno_Curso  
    WHERE (Anio BETWEEN 1/1/2024 AND 31/12/2024)
    GROUP BY c.Cod_Curso, c.Nombre, c.Descripcion
)