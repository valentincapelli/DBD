/* Ejercicio 2
Localidad = (codigoPostal, nombreL, descripcion, #habitantes)
Arbol = (nroArbol, especie, años, calle, nro, codigoPostal(fk))
Podador = (DNI, nombre, apellido, telefono, fnac, codigoPostalVive(fk))
Poda = (codPoda, fecha, DNI(fk), nroArbol(fk)) */

1_
SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Podador p
INNER JOIN Poda po ON (p.DNI = po.DNI)
INNER JOIN Arbol a ON (po.nroArbol = a.nroArbol)
INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
WHERE (p.nombre = "Juan" AND p.nombre = "Jose") AND a.nroArbol IN (
    SELECT a.nroArbol
    FROM Podador p
    INNER JOIN Poda po ON (p.DNI = po.DNI)
    INNER JOIN Arbol a ON (po.nroArbol = a.nroArbol)
    WHERE (p.apellido = "Perez" AND p.apellido = "Garcia")
)

2_ 
SELECT p.DNI, p.nombre, p.apellido, p.fnac, l.Localidad
FROM Localidad l
INNER JOIN Podador p ON (l.codigoPostal = p.codigoPostalVive)
INNER JOIN Poda po ON (p.DNI = po.DNI)
WHERE (po.fecha BETWEEN 01/01/2023 and 31/12/2023)

3_
-- Solucion 1 
SELECT a.especie, a.años, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
WHERE NOT EXIST (
    SELECT *
    FROM Poda po
    WHERE (a.nroArbol = po.nroArbol)
)

-- Solucion 2
SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
WHERE a.nroArbol NOT IN (
    SELECT a.nroArbol
    FROM Arbol a INNER JOIN Poda po (a.nroArbol = po.nroArbol)
)

--Solucion 3
SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
    LEFT JOIN Poda po ON (a.nroArbol = po.nroArbol)
WHERE po.nroArbol IS NULL

4_
SELECT a.especie, a.años, a.nro, l.Localidad
FROM Localidad l
INNER JOIN Arbol a ON (l.codigoPostal = a.codigoPostal)
INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
WHERE po.fecha BETWEEN 01/01/2022 AND 31/12/2022 
EXCEPT (
    FROM Localidad l
    INNER JOIN Arbol a ON (l.codigoPostal = a.codigoPostal)
    INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
    WHERE po.fecha BETWEEN 01/01/2023 AND 31/12/2023 
)

5_
SELECT p.DNI, p.nombre, p.apellido, p.fnac, l.nombreL
FROM Podador p INNER JOIN Poda po ON (p.DNI = po.DNI)
WHERE (p.apellido LIKE "%ata" AND EXISTS (SELECT * WHERE 
po.fecha BETWEEN 01/01/2024 AND 31/12/2024))
ORDER BY p.apellido, p.nombre

6_ CONSULTAR
SELECT p.DNI, p.apellido, p.nombre, p.fnac, l.Localidad
FROM Podador p
INNER JOIN Poda po ON (p.DNI = po.DNI)
INNER JOIN Arbol a ON (p.nroArbol = a.nroArbol)
WHERE (a.especie = "Coniferas") AND (p.DNI NOT IN (
    SELECT p.DNI
    FROM Podador p
    INNER JOIN Poda po ON (p.DNI = po.DNI)
    INNER JOIN Arbol a ON (p.nroArbol = a.nroArbol)
))

7_ 
SELECT a.especie
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
WHERE (l.nombreL = "La Plata")
INTERSECT (
SELECT a.especie
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.codigoPostal)
WHERE (l.nombreL = "Salta"))

8_
DELETE FROM Podador WHERE DNI = "22234566"
DELETE FROM Poda WHERE DNI = "22234566"

9_ 
SELECT DISTINCT l.nombreL, l.descripcion, l.#habitantes
FROM Localidad l
INNER JOIN Arbol a ON (l.codigoPostal = a.codigoPostal)
GROUP BY l.codigoPostal, l.nombreL, l.descripcion, l.#habitantes
HAVING COUNT(a.nroArbol) < 100  

