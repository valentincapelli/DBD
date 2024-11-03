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