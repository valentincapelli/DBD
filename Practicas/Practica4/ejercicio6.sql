Ejercicio 6
Técnico = (codTec, nombre, especialidad) // técnicos
Repuesto = (codRep, nombre, stock, precio) // repuestos
RepuestoReparacion = (nroReparac (fk), codRep (fk), cantidad, precio) // repuestos utilizados en
reparaciones.
Reparación (nroReparac, codTec (fk), precio_total, fecha) // reparaciones realizadas

1_ 
SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
ORDER BY r.precio

2_
SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
INNER JOIN RepuestoReparacion ON (r.codRep = rr.codRep)
INNER JOIN Reparacion repa ON (rr.nroReparac = repa.nroReparac)
INNER JOIN Tecnico t ON (repa.codTec = t.codTec)
WHERE (repa.fecha BETWEEN 2023/01/01 and 2023/12/31)
EXCEPT (
    SELECT r.nombre, r.stock, r.precio
    FROM Repuesto r
    INNER JOIN RepuestoReparacion ON (r.codRep = rr.codRep)
    INNER JOIN Reparacion repa ON (rr.nroReparac = repa.nroReparac)
    INNER JOIN Tecnico t ON (repa.codTec = t.codTec)
    WHERE (t.nombre = "Jose Gonzalez")
)

3_
-- Solucion 1
SELECT t.nombre, t.especialidad
FROM Tecnico t RIGHT JOIN Reparacion r ON (t.codTec = r.codTec)
WHERE (t.codTec IS NULL)
ORDER BY t.nombre

-- Solucion 2
SELECT t.nombre, t.especialidad
FROM Tecnico t
EXCEPT (
    SELECT t.nombre, t.especialidad
    FROM Tecnico t RIGHT JOIN Reparacion r ON (t.codTec = r.codTec)
)
ORDER BY t.nombre

4_ 
SELECT t.nombre, t.especialidad
FROM Tecnico
EXCEPT (
    SELECT t.nombre, t.especialidad
    FROM Tecnico t RIGHT JOIN Reparacion r ON (t.codTec = r.codTec)
    WHERE (r.fecha < '2022-01-01' OR r.fecha > '2022-12-31')
)

5_ 
-- Solucion incorrecta
SELECT r.nombre, r.stock, COUNT(*)
FROM Repuesto r 
INNER JOIN RepuestoReparacion rr ON (r.codRep = rr.codRep)
INNER JOIN Reparacion repa ON (rr.nroReparac = repa.nroReparac)
INNER JOIN Tecnico T on (repa.codTec = t.codTec)
GROUP BY r.codRep, r.nombre, r.stock

/* La consulta le falta lo siguiente

Contar técnicos distintos: En lugar de COUNT(*), se necesita contar 
solo los técnicos distintos que usaron cada repuesto. Esto se logra 
usando COUNT(DISTINCT t.codTec).

Incluir repuestos sin uso en reparaciones: Para listar todos los 
repuestos, incluidos aquellos que no fueron utilizados en ninguna 
reparación, usa un LEFT JOIN en lugar de un INNER JOIN. Esto asegura 
que los repuestos sin reparaciones también aparezcan en el resultado 
con un conteo de técnicos en cero. */

-- Solucion correcta
SELECT r.nombre, r.stock, COUNT(DISTINCT t.codTec)
FROM Repuesto r 
LEFT JOIN RepuestoReparacion rr ON (r.codRep = rr.codRep)
LEFT JOIN Reparacion repa ON (rr.nroReparac = repa.nroReparac)
LEFT JOIN Tecnico T on (repa.codTec = t.codTec)
GROUP BY r.codRep, r.nombre, r.stock

6_ --Consultar
SELECT t.nombre, t.especialidad
FROM Tecnico t INNER JOIN Reparacion r ON (t.codTec = r.codTec)
GROUP BY t.codTec, t.nombre, t.especialidad
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM Tecnico t INNER JOIN Reparacion r ON (t.codTec = r.codTec)
    GROUP BY t.codTec, t.nombre, t.especialidad
)
UNION
SELECT t.nombre, t.especialidad
FROM Tecnico t INNER JOIN Reparacion r ON (t.codTec = r.codTec)
GROUP BY t.codTec, t.nombre, t.especialidad
HAVING COUNT(*) <= ALL (
    SELECT COUNT(*)
    FROM Tecnico t INNER JOIN Reparacion r ON (t.codTec = r.codTec)
    GROUP BY t.codTec, t.nombre, t.especialidad
)

7_ 
SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
WHERE (r.stock > 0) AND r.codRep NOT IN (
    SELECT rr.codRep
    FROM RepuestoReparacion rr ON (r.codRep = rr.codRep)
    INNER JOIN Reparacion repa ON (rr.nroReparac = repa.nroReparac)
    WHERE repa.precio_total > 1000
)

8_ 
SELECT DISTINCT repa.nroReparac, repa.fecha, repa.precio_total
FROM Reparacion repa
INNER JOIN RepuestoReparacion rr ON (repa.nroReparac = rr.nroReparac)
INNER JOIN Repuesto r ON (rr.codRep = r.codRep)
WHERE (r.precio BETWEEN 10000 AND 15000)

9_ Consultar!
--Solucion 1
SELECT nombre, stock, precio
FROM Repuesto r
WHERE NOT EXISTS (
    SELECT *
    FROM Tecnico t
    WHERE NOT EXISTS (
        SELECT *
        FROM Reparacion r2 
        INNER JOIN  RepuestoReparacion rr ON (r2.nroReparac = rr.nroReparac)
        WHERE (t.codTec = r2.codTec AND r.codRep = rr.codRep)
    )
)
/*  Paso 1: reconocer tablas de los extremos (donde saco los datos y donde quiero llegar)
    Paso 2: seleccionar los datos de la tabla donde quiero sacar los datos
    Paso 3: WHERE NOT EXISTS con la tabla donde quiero llegar
    Paso 4: WHERE NOT EXISTS con la/s tabla/s intermedia/s.
    Paso 5: WHERE (conecto tabla intermedia con tabla donde quiero llegar) AND
            (conecto tabla intermedia con tabla donde selecciono datos)
    */
--Solucion explicada

-- Agarro la tabla que selecciono los datos
SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
-- Agarro la tabla a la que quiero llegar
WHERE NOT EXISTS (
    SELECT *
    FROM Tecnico t
    -- Agarro la/s tabla/s intermedio, la que las une
    WHERE NOT EXISTS (
        SELECT *
        FROM RepuestoReparacion rr
        INNER JOIN Reparacion repa ON (rr.nroReparac = repa.nroReparac)
        WHERE (t.codTec = repa.codTec) AND (r.codRep = rr.codRep)
    )
)

10_ 
SELECT repa.fecha, t.nombre, repa.precio_total
FROM RepuestoReparacion rr
INNER JOIN Reparacion repa ON (rr.nroReparac = repa.nroReparac)
INNER JOIN Tecnico T on (repa.codTec = t.codTec)
GROUP BY repa.nroReparac, repa.fecha, t.nombre, repa.precio_total
HAVING COUNT(DISTINCT rr.codRep) >= 10