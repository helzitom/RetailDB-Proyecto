CREATE DATABASE retaildb

CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    estado BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE proveedores (
    id_proveedor SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    contacto VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(120) UNIQUE,
    direccion TEXT
);

CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    id_categoria INT NOT NULL,
    id_proveedor INT NOT NULL,
    precio_compra NUMERIC(10,2) NOT NULL,
    precio_venta NUMERIC(10,2) NOT NULL,
    stock_minimo INT DEFAULT 0,
    estado BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
    CONSTRAINT fk_producto_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
);

CREATE TABLE tiendas (
    id_tienda SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    direccion TEXT,
    ciudad VARCHAR(100),
    telefono VARCHAR(20),
    id_empleado INT -- gerente
);

CREATE TABLE inventario_tienda (
    id_inventario SERIAL PRIMARY KEY,
    id_tienda INT NOT NULL,
    id_producto INT NOT NULL,
    stock_actual INT DEFAULT 0,
    stock_reservado INT DEFAULT 0,
    ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventario_tienda FOREIGN KEY (id_tienda) REFERENCES tiendas(id_tienda),
    CONSTRAINT fk_inventario_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);


CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(150) NOT NULL,
    dni VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(120) UNIQUE,
    telefono VARCHAR(20),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE empleados (
    id_empleado SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(150) NOT NULL,
    dni VARCHAR(20) UNIQUE NOT NULL,
    cargo VARCHAR(100),
    id_tienda INT,
    fecha_ingreso DATE,
    CONSTRAINT fk_empleado_tienda FOREIGN KEY (id_tienda) REFERENCES tiendas(id_tienda)
);

ALTER TABLE tiendas
    ADD CONSTRAINT fk_tienda_gerente FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado);

CREATE TABLE ventas (
    id_venta SERIAL PRIMARY KEY,
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cliente_id INT NOT NULL,
    empleado_id INT NOT NULL,
    id_tienda INT NOT NULL,
    total NUMERIC(12,2) NOT NULL,
    estado VARCHAR(20) DEFAULT 'ACTIVA',
    CONSTRAINT fk_venta_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_venta_empleado FOREIGN KEY (empleado_id) REFERENCES empleados(id_empleado),
    CONSTRAINT fk_venta_tienda FOREIGN KEY (id_tienda) REFERENCES tiendas(id_tienda)
);

CREATE TABLE detalle_venta (
    id_detalle SERIAL PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario NUMERIC(10,2) NOT NULL,
    subtotal NUMERIC(12,2) NOT NULL,
    CONSTRAINT fk_detalle_venta FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);


CREATE TABLE movimientos_inventario (
    id_movimiento SERIAL PRIMARY KEY,
    tipo_movimiento VARCHAR(50) NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_empleado INT,
    CONSTRAINT fk_movimiento_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT fk_movimiento_empleado FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

CREATE TABLE auditoria_precios (
    id_auditoria SERIAL PRIMARY KEY,
    id_producto INT NOT NULL,
    precio_anterior NUMERIC(10,2) NOT NULL,
    precio_nuevo NUMERIC(10,2) NOT NULL,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_empleado INT,
    CONSTRAINT fk_auditoria_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT fk_auditoria_empleado FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);
