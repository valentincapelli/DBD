-- Consultar AR y SQL

/*
Selección: σ
Proyección: π
Producto: x
Producto natural: |x|
División: %
Unión: ∪
Intersección: ∩
Renombre: ρ
Asignación: ⇐
Diferencia: -
Hacer algo con todos de una tabla: δ
And: ^ 
*/


-- AR

1_

todas <= π cuit, nomClte, codProd, nomProd, descrip (Cliente |x| Pedido |x| PedProd |x| Producto)
ultimos12meses <= π cuit, nomClte, codProd, nomProd, descrip ((σ fechaped >= '2023/11/12' )Cliente |x| Pedido |x| PedProd |x| Producto)
π cuit, nomClte, codProd, nomProd, descrip (todas - ultimos12meses)

2_
ultimos12meses <= π cuit, nomClte, email, codProd ((σ fechaped >= '2023/11/12' )Cliente |x| Pedido |x| PedProd |x| Producto)
π cuit, nomClte, email (ultimos12meses % π codProd(Producto))

3_ 
pedidosUlt30dias <= π nroPed, fechaPed(σ fechaPed >= '2024/10/12'(Pedido))
π nroPed, fechaPed, codProd, cantPed, nroRemito, fechaEnt, cantEnt(σ (cantEnt < cantPed) ^ (Entrega.nroRemito = EntProd.nroRemito) (Producto |x| PedProd |x| pedidosUlt30dias |x| Entrega x EntProd))

4_ 
pedidosUlt30dias <= π nroPed, fechaPed, nroClte, dirEntrega(σ fechaPed >= '2024/10/12'(Pedido))

todos <= π nroPed, fechaPed, cuit, nomClte, dirEntrega, codProd, cantPed (Cliente |x| pedidosUlt30dias |x| PedProd |x| Prod)

entregados <= π nroPed, fechaPed, cuit, nomClte, dirEntrega, codProd, cantPed (Cliente |x| pedidosUlt30dias |x| PedProd |x| Prod |x| Entrega)

π nroPed, fechaPed, cuit, nomClte, dirEntrega, codProd, cantPed (todos - entregados)

-- SQL

2_ 
SELECT c.cuit, c.nomClte, c.email
FROM Cliente c
WHERE NOT EXISTS (
    SELECT p.*
    FROM Producto p
    WHERE NOT EXISTS (
        SELECT ped.*
        FROM Pedido ped
        INNER JOIN PedProd pp ON (ped.nroPed =pp.nroPed)
        WHERE (fechaPed >= '2023/12/11') AND (c.nroClte = ped.nroClte) AND (pp.codProd = p.codProd)
    )
)

3_ 
SELECT ped.nroPed, ped.fechaPed, p.codProd, pp.cantPed, e.nroRemito, e.fechaEnt, ep.cantEnt
FROM Producto p INNER JOIN PedProd pp ON (p.codProd = pp.codProd)
INNER JOIN Pedido ped ON (pp.nroPed = ped.nroPed)
INNER JOIN Entrega e ON (ped.nroPed = e.nroPed)
INNER JOIN EntProd ep ON (e.nroRemito = ep.nroRemito)
WHERE (ped.fechaPed => '2024/10/12')
ORDER BY ped.nroPed, p.codProd, e.fechaEnt

4_ 
SELECT ped.nroPed, ped.fechaPed, c.cuit, c.nomClte, ped.dirEntrega, p.codProd, pp.cantPed
FROM Producto p
INNER JOIN PedProd pp ON (p.codProd = pp.codProd)
INNER JOIN Pedido ped ON (pp.nroPed = ped.nroPed)
INNER JOIN Cliente c ON (ped.nroClte = c.nroClte)
WHERE (ped.fechaPed >= '2024/10/12')
EXCEPT (
    SELECT ped.nroPed, ped.fechaPed, c.cuit, c.nomClte, ped.dirEntrega, p.codProd, pp.cantPed
    FROM Producto p
    INNER JOIN PedProd pp ON (p.codProd = pp.codProd)
    INNER JOIN Pedido ped ON (pp.nroPed = ped.nroPed)
    INNER JOIN Cliente c ON (ped.nroClte = c.nroClte)
    INNER JOIN Entrega e ON (ped.nroRemito = e.nroRemito)
    WHERE (ped.fechaPed >= '2024/10/12')
)
ORDER BY ped.nroPed

5_ 
SELECT ped.nroPed, ped.fechaPed, p.codProd, pp.cantPed, ep.cantEnt
FROM Producto p
LEFT JOIN PedProd pp ON (p.codProd = pp.codProd)
LEFT JOIN Pedido ped ON (pp.nroPed = ped.nroPed)
LEFT JOIN EntProd ep ON (p.codProd = ep.codProd)
WHERE (ped.fechaPed >= '2024/10/12')
ORDER BY ped.nroPed, p.codProd

6_ 
SELECT c.nroClte, ped.nroPed, ped.fechaPed, pp.cantPed, SUM(p.precio) as montoTotal
FROM Producto p
INNER JOIN PedProd pp ON (p.codProd = pp.codProd)
INNER JOIN Pedido ped ON (pp.nroPed = ped.nroPed)
INNER JOIN Cliente c ON (ped.nroClte = c.nroClte)
INNER JOIN Entrega e ON (ped.nroRemito = e.nroRemito)
WHERE (ped.fechaPed >= '2024/10/12')
GROUP BY c.nroClte, ped.nroPed, ped.fechaPed, pp.cantPed
ORDER BY montoTotal DESC