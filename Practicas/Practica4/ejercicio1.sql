/* Practica 4 - SQL

Ejercicio 1
Cliente(idCliente,nombre,apellido,DNI,telefono,direccion)
Factura(nroTicket,total,fecha,hora,idCliente(fk))
Detalle(nroTicket(fk),idProducto(fk),cantidad,preciounitario)
Producto(idProducto,nombreP,descripcion,precio,stock) */

1_ 
SELECT nombre, apellido, dni, telefono, direccion
FROM cliente
WHERE (apellido LIKE "Pe%")
ORDER BY dni

2_ 
SELECT c.nombre, c.apellido, c.dni, c.telefono, c.direccion
FROM cliente c INNER JOIN factura f ON (c.idCliente = f.idCliente)
WHERE (f.fecha BETWEEN 01/01/2017 and 31/12/2017)
EXCEPT (
FROM cliente c INNER JOIN factura f ON (c.idCliente = f.idCliente)
WHERE (f.fecha < 01/01/2017 and f.fecha > 31/12/2017)
)

3_ 
SELECT p.nombreP, p.descripcion, p.precio, p.stock
FROM producto p 
INNER JOIN detalle d ON (p.idProducto = d.idProducto)
INNER JOIN factura f ON (d.nroTicket = f.nroTicket)
INNER JOIN cliente c ON (f.idCliente = c.idCliente)
WHERE (c.dni = 45789456)
EXCEPT (
FROM producto p 
INNER JOIN detalle d ON (p.idProducto = d.idProducto)
INNER JOIN factura f ON (d.nroTicket = f.nroTicket)
INNER JOIN cliente c ON (f.idCliente = c.idCliente)
WHERE (c.apellido <> "Garcia")
)

4_ 
SELECT p.nombre, p.descripcion, p.precio, p.stock
FROM producto p 
INNER JOIN detalle d ON (p.idProducto = d.idProducto)
INNER JOIN factura f ON (d.nroTicket = f.nroTicket)
INNER JOIN cliente c ON (f.idCliente = c.idCliente)
EXCEPT (
FROM producto p 
INNER JOIN detalle d ON (p.idProducto = d.idProducto)
INNER JOIN factura f ON (d.nroTicket = f.nroTicket)
INNER JOIN cliente c ON (f.idCliente = c.idCliente)
WHERE (c.telefono LIKE "221%")
)
ORDER BY p.nombre

5_  CONSULTAR!
SELECT p.nombre, p.descripcion, p.precio, SUM(d.cantidad)
FROM producto p LEFT JOIN detalle d ON (p.idProducto = d.idProducto)

6_ 
SELECT c.nombre, c.apellido, c.dni, c.telefono, c.direccion
FROM cliente c 
INNER JOIN factura f ON (c.idCliente = f.idCliente)
INNER JOIN detalle d ON (f.nroTicket = d.nroTicket)
INNER JOIN producto p On (d.idProducto = p.idProducto)
WHERE (p.nombreP = "prod1") AND (c.idCliente in (
SELECT c.idCliente
FROM cliente c 
INNER JOIN factura f ON (c.idCliente = f.idCliente)
INNER JOIN detalle d ON (f.nroTicket = d.nroTicket)
INNER JOIN producto p On (d.idProducto = p.idProducto)
WHERE (p.nombreP = "prod2"))
EXCEPT (
SELECT c.nombre, c.apellido, c.dni, c.telefono, c.direccion
FROM cliente c 
INNER JOIN factura f ON (c.idCliente = f.idCliente)
INNER JOIN detalle d ON (f.nroTicket = d.nroTicket)
INNER JOIN producto p On (d.idProducto = p.idProducto)
WHERE (p.nombreP = "prod3")
))

7_ SELECT f.nroTicket,  f.total, f.fecha, f.hora, c.dni
FROM cliente c 
INNER JOIN factura f ON (c.idCliente = f.idCliente)
INNER JOIN detalle d ON (f.nroTicket = d.nroTicket)
INNER JOIN producto p On (d.idProducto = p.idProducto)
WHERE (p.nombreP = "prod38" OR f.fecha BETWEEN 01/01/2019 and 31/12/2019)

8_ 
INSERT INTO cliente (idCliente, nombre, apellido, dni, telefono, direccion) VALUES
(500002, "Jorge Luis", "Castor", "40578999", "221-4400789", "11 entre 500 y 501 nro:2587")

9_ 
SELECT  f.nroTicket,  f.total, f.fecha, f.hora
FROM cliente c 
INNER JOIN factura f ON (c.idCliente = f.idCliente)
INNER JOIN detalle d ON (f.nroTicket = d.nroTicket)
INNER JOIN producto p On (d.idProducto = p.idProducto)
WHERE (c.nomnbre = "Jorge" AND c.apellido = "Perez")
EXCEPT (
    FROM cliente c 
    INNER JOIN factura f ON (c.idCliente = f.idCliente)
    INNER JOIN detalle d ON (f.nroTicket = d.nroTicket)
    INNER JOIN producto p On (d.idProducto = p.idProducto)
    WHERE (p.nombreP = "Z")
)

10_ CONSULTAR
SELECT c.dni, c.apellido, c.nombre
FROM cliente c INNER JOIN factura f (c.idCliente = f.idCliente)
WHERE (SUM(f.total) > 10000000)