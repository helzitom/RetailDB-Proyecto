
INSERT INTO clientes (nombre, apellidos, dni, email, telefono, fecha_registro)
SELECT
    (ARRAY['Juan','María','Carlos','Ana','Pedro','Lucía','José','Diana','Luis','Rosa'])[ceil(random()*10)],
    (ARRAY['García','Pérez','Torres','Rojas','Fernández','Ramírez','Salazar','Cruz','Flores','Gómez'])[ceil(random()*10)],
    LPAD((20400000 + g)::TEXT, 8, '0'),
    LOWER('cliento' || g || '@gmail.com'),
    '9' || LPAD((7000000 + g)::TEXT, 8, '0'),
    NOW() - (random() * interval '365 days')
FROM generate_series(1,1000) g;

INSERT INTO proveedores (nombre, contacto, telefono, email, direccion)
SELECT
    (ARRAY['Distribuidora Andina','Comercial San Juan','Importaciones Globales','TecnoParts','Alimentos Selectos','Muebles Hogar SAC','Deportes Perú','Moda Latina','Calzados Lima','Juguetería MundoKids'])[ceil(random()*10)],
    (ARRAY['Juan Pérez','María Torres','Luis Rojas','Ana Fernández','José Castillo','Lucía Vargas'])[ceil(random()*6)],
    '9' || LPAD((4000000 + g)::TEXT, 8, '0'),
    'contacto' || g || '@empresa.com',
    'Av. Principal ' || g || ', Lima'
FROM generate_series(1,50) g;

INSERT INTO categorias (nombre, descripcion, estado) VALUES
('Electrodomésticos', 'Línea blanca y electrodomésticos', TRUE),
('Tecnología', 'Computadoras, celulares, tablets', TRUE),
('Hogar', 'Muebles y decoración', TRUE),
('Deportes', 'Equipos deportivos y accesorios', TRUE),
('Ropa', 'Prendas de vestir', TRUE),
('Calzado', 'Zapatos y zapatillas', TRUE),
('Alimentos', 'Comestibles y bebidas', TRUE),
('Juguetes', 'Juguetes y entretenimiento', TRUE);


INSERT INTO productos (nombre, descripcion, id_categoria, id_proveedor, precio_compra, precio_venta, stock_minimo, estado)
SELECT
    (ARRAY['Laptop Lenovo','Celular Samsung','Refrigeradora LG','Sofá 3 Plazas','Bicicleta Montaña','Camiseta Deportiva','Zapatillas Nike','Leche Gloria','Lego City','Monitor LG'])[ceil(random()*10)] || ' ' || g,
    'Producto de la categoría asignada',
    (1 + (random()*7)::int),  -- categoría (1–8)
    (1 + (random()*49)::int), -- proveedor (1–50)
    (50 + random()*500)::NUMERIC(10,2),
    (100 + random()*900)::NUMERIC(10,2),
    (1 + random()*10)::int,
    TRUE
FROM generate_series(1,20000) g;

INSERT INTO tiendas (nombre, direccion, ciudad, telefono)
VALUES
('Tienda Lima Centro', 'Av. Abancay 123', 'Lima', '01-6001111'),
('Tienda Arequipa Plaza', 'Calle Mercaderes 456', 'Arequipa', '054-600222'),
('Tienda Cusco Colonial', 'Av. El Sol 789', 'Cusco', '084-600333'),
('Tienda Trujillo Norte', 'Av. España 321', 'Trujillo', '044-600444'),
('Tienda Chiclayo Sur', 'Av. Balta 654', 'Chiclayo', '074-600555'),
('Tienda Piura Centro', 'Av. Grau 987', 'Piura', '073-600666'),
('Tienda Iquitos Amazonas', 'Calle Próspero 159', 'Iquitos', '065-600777'),
('Tienda Huancayo Andes', 'Jr. Junín 753', 'Huancayo', '064-600888'),
('Tienda Tacna Sur', 'Av. Bolognesi 852', 'Tacna', '052-600999'),
('Tienda Juliaca Altiplano', 'Jr. San Román 147', 'Juliaca', '051-601000'),
('Tienda Pucallpa Ucayali', 'Av. Centenario 369', 'Pucallpa', '061-601111'),
('Tienda Tarapoto Selva', 'Jr. Lamas 258', 'Tarapoto', '042-601222'),
('Tienda Huaraz Sierra', 'Jr. Luzuriaga 741', 'Huaraz', '043-601333'),
('Tienda Ayacucho Libertad', 'Jr. 28 de Julio 963', 'Ayacucho', '066-601444'),
('Tienda Cajamarca Colonial', 'Jr. Cruz de Piedra 357', 'Cajamarca', '076-601555');

INSERT INTO empleados (nombre, apellidos, dni, cargo, id_tienda, fecha_ingreso)
SELECT
    'Empleado_' || g,
    'Apellido_' || g,
    LPAD((10000000 + g)::TEXT, 8, '0'),
    CASE WHEN g % 2 = 0 THEN 'Cajero' ELSE 'Vendedor' END,
    (1 + (random()*14)::int),  -- tienda entre 1 y 15
    NOW() - (random() * interval '1825 days')
FROM generate_series(1,10000) g;


INSERT INTO ventas (fecha_venta, cliente_id, empleado_id, id_tienda, total, estado)
SELECT
    NOW() - (random() * interval '180 days'),
    (2 + (random()*999)::int),  -- cliente
    (2 + (random()*99)::int),   -- empleado
    (1 + (random()*14)::int),   -- tienda
    (50 + random()*1000)::NUMERIC(12,2), -- total
    CASE WHEN random() > 0.95 THEN 'ANULADA' ELSE 'ACTIVA' END
FROM generate_series(1,10000) g;


INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario, subtotal)
SELECT
    (1 + (random()*1999)::int),   -- id_venta
    (1 + (random()*499)::int),    -- id_producto
    s.cantidad,
    s.precio,
    s.cantidad * s.precio
FROM (
    SELECT
        (1 + (random()*5)::int) AS cantidad,
        (10 + random()*300)::NUMERIC(10,2) AS precio,
        g
    FROM generate_series(1,2500) g
) s;

INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario, subtotal)
SELECT
    (1 + (random()*1999)::int),   -- id_venta
    (1 + (random()*499)::int),    -- id_producto
    s.cantidad,
    s.precio,
    s.cantidad * s.precio
FROM (
    SELECT
        (1 + (random()*5)::int) AS cantidad,
        (10 + random()*300)::NUMERIC(10,2) AS precio,
        g
    FROM generate_series(1,5000) g
) s;

INSERT INTO movimientos_inventario (tipo_movimiento, id_producto, cantidad, fecha, id_empleado)
SELECT
    CASE WHEN random() > 0.5 THEN 'ENTRADA' ELSE 'SALIDA' END,
    (1 + (random()*499)::int),
    (1 + (random()*50)::int),
    NOW() - (random() * interval '180 days'),
    (1 + (random()*99)::int)
FROM generate_series(1,1500) g;

INSERT INTO inventario_tienda (id_tienda, id_producto, stock_actual, stock_reservado, ultima_actualizacion)
SELECT
    (i % 10) + 1,           -- asigna a tiendas 1 a 10
    (i % 500) + 1,          -- asigna a productos 1 a 500
    (random() * 100)::int,  -- stock actual entre 0 y 100
    (random() * 50)::int,   -- stock reservado entre 0 y 50
    now() - (random() * 30)::int * interval '1 day' -- fecha aleatoria últimos 30 días
FROM generate_series(1, 1000) AS s(i);


INSERT INTO auditoria_precios (id_producto, precio_anterior, precio_nuevo, fecha_cambio, id_empleado)
SELECT
    (i % 500) + 1,              
    round((random() * 100 + 1)::numeric, 2),  -- precio anterior
    round((random() * 200 + 10)::numeric, 2), -- precio nuevo
    now() - (random() * 60)::int * interval '1 day', 
    (i % 100) + 1               
FROM generate_series(1, 1000) AS s(i);





