/*CONSULTAS DE PRUEBA*/

/*Top 10 productos más vendidos por tienda*/
SELECT 
    t.nombre AS tienda,
    p.nombre AS producto,
    SUM(dv.cantidad) AS total_vendido
FROM detalle_venta dv
JOIN productos p ON dv.id_producto = p.id_producto
JOIN ventas v ON dv.id_venta = v.id_venta
JOIN tiendas t ON v.id_tienda = t.id_tienda
GROUP BY t.nombre, p.nombre
ORDER BY t.nombre, total_vendido DESC
LIMIT 10;

/*Reporte de ventas mensuales por empleado*/
SELECT 
    e.nombre || ' ' || e.apellidos AS empleado,
    DATE_TRUNC('month', v.fecha_venta) AS mes,
    COUNT(v.id_venta) AS num_ventas,
    SUM(v.total) AS total_vendido
FROM ventas v
JOIN empleados e ON v.empleado_id = e.id_empleado
GROUP BY empleado, mes
ORDER BY mes DESC, total_vendido DESC;

/*Productos con stock bajo el mínimo por tienda*/
SELECT 
    t.nombre AS tienda,
    p.nombre AS producto,
    it.stock_actual,
    p.stock_minimo
FROM inventario_tienda it
JOIN productos p ON it.id_producto = p.id_producto
JOIN tiendas t ON it.id_tienda = t.id_tienda
WHERE it.stock_actual < p.stock_minimo
ORDER BY t.nombre, p.nombre;

/*Análisis de rentabilidad por categoría de producto*/
SELECT 
    c.nombre AS categoria,
    SUM(dv.cantidad * dv.precio_unitario) AS ingresos,
    SUM(dv.cantidad * p.precio_compra) AS costos,
    SUM(dv.cantidad * dv.precio_unitario) - SUM(dv.cantidad * p.precio_compra) AS rentabilidad
FROM detalle_venta dv
JOIN productos p ON dv.id_producto = p.id_producto
JOIN categorias c ON p.id_categoria = c.id_categoria
GROUP BY c.nombre
ORDER BY rentabilidad DESC;

/*Historial de movimientos de un producto específico*/
SELECT 
    p.nombre AS producto,
    mi.tipo_movimiento,
    mi.cantidad,
    mi.fecha,
    e.nombre || ' ' || e.apellidos AS empleado
FROM movimientos_inventario mi
JOIN productos p ON mi.id_producto = p.id_producto
JOIN empleados e ON mi.id_empleado = e.id_empleado
WHERE p.id_producto = 10  -- 🔹 Cambiar por el producto específico
ORDER BY mi.fecha DESC;


/*Ranking de clientes por volumen de compras*/
SELECT 
    c.nombre || ' ' || c.apellidos AS cliente,
    COUNT(v.id_venta) AS num_compras,
    SUM(v.total) AS monto_total
FROM ventas v
JOIN clientes c ON v.cliente_id = c.id_cliente
GROUP BY cliente
ORDER BY monto_total DESC
LIMIT 10;

/*Proyección de restock basada en ventas históricas*/
SELECT 
    p.nombre AS producto,
    AVG(ventas_mensuales) AS promedio_mensual,
    MAX(it.stock_actual) AS stock_actual,
    CASE 
        WHEN MAX(it.stock_actual) < AVG(ventas_mensuales) THEN 'Necesita Restock'
        ELSE 'Stock Suficiente'
    END AS estado
FROM (
    SELECT 
        dv.id_producto,
        DATE_TRUNC('month', v.fecha_venta) AS mes,
        SUM(dv.cantidad) AS ventas_mensuales
    FROM detalle_venta dv
    JOIN ventas v ON dv.id_venta = v.id_venta
    GROUP BY dv.id_producto, mes
) sub
JOIN productos p ON sub.id_producto = p.id_producto
JOIN inventario_tienda it ON it.id_producto = p.id_producto
GROUP BY p.nombre;


/*Análisis de performance de empleados por tienda*/
SELECT 
    t.nombre AS tienda,
    e.nombre || ' ' || e.apellidos AS empleado,
    COUNT(v.id_venta) AS num_ventas,
    SUM(v.total) AS total_vendido
FROM ventas v
JOIN empleados e ON v.empleado_id = e.id_empleado
JOIN tiendas t ON v.id_tienda = t.id_tienda
GROUP BY t.nombre, empleado
ORDER BY t.nombre, total_vendido DESC;

/*Reporte de productos sin movimiento en últimos 90 días*/
SELECT 
    p.nombre AS producto,
    c.nombre AS categoria
FROM productos p
JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE p.id_producto NOT IN (
    SELECT DISTINCT dv.id_producto
    FROM detalle_venta dv
    JOIN ventas v ON dv.id_venta = v.id_venta
    WHERE v.fecha_venta > NOW() - interval '90 days'
)
ORDER BY categoria, producto;



