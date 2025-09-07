-- 1️⃣ Crear secuencias para simular SERIAL
CREATE SEQUENCE seq_categorias START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_proveedores START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_productos START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tiendas START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_inventario START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_clientes START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_empleados START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ventas START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_detalle_venta START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_movimientos START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_auditoria START WITH 1 INCREMENT BY 1;

-- 2️⃣ Crear tablas

CREATE TABLE categorias (
    id_categoria NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    descripcion CLOB,
    estado NUMBER(1) DEFAULT 1 NOT NULL
);

CREATE TABLE proveedores (
    id_proveedor NUMBER PRIMARY KEY,
    nombre VARCHAR2(150) NOT NULL,
    contacto VARCHAR2(100),
    telefono VARCHAR2(20),
    email VARCHAR2(120) UNIQUE,
    direccion CLOB
);

CREATE TABLE productos (
    id_producto NUMBER PRIMARY KEY,
    nombre VARCHAR2(150) NOT NULL,
    descripcion CLOB,
    id_categoria NUMBER NOT NULL,
    id_proveedor NUMBER NOT NULL,
    precio_compra NUMBER(10,2) NOT NULL,
    precio_venta NUMBER(10,2) NOT NULL,
    stock_minimo NUMBER DEFAULT 0,
    estado NUMBER(1) DEFAULT 1 NOT NULL,
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
    CONSTRAINT fk_producto_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
);

CREATE TABLE tiendas (
    id_tienda NUMBER PRIMARY KEY,
    nombre VARCHAR2(150) NOT NULL,
    direccion CLOB,
    ciudad VARCHAR2(100),
    telefono VARCHAR2(20),
    id_empleado NUMBER
);

CREATE TABLE inventario_tienda (
    id_inventario NUMBER PRIMARY KEY,
    id_tienda NUMBER NOT NULL,
    id_producto NUMBER NOT NULL,
    stock_actual NUMBER DEFAULT 0,
    stock_reservado NUMBER DEFAULT 0,
    ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventario_tienda FOREIGN KEY (id_tienda) REFERENCES tiendas(id_tienda),
    CONSTRAINT fk_inventario_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

CREATE TABLE clientes (
    id_cliente NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    apellidos VARCHAR2(150) NOT NULL,
    dni VARCHAR2(20) UNIQUE NOT NULL,
    email VARCHAR2(120) UNIQUE,
    telefono VARCHAR2(20),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE empleados (
    id_empleado NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    apellidos VARCHAR2(150) NOT NULL,
    dni VARCHAR2(20) UNIQUE NOT NULL,
    cargo VARCHAR2(100),
    id_tienda NUMBER,
    fecha_ingreso DATE,
    CONSTRAINT fk_empleado_tienda FOREIGN KEY (id_tienda) REFERENCES tiendas(id_tienda)
);

ALTER TABLE tiendas
    ADD CONSTRAINT fk_tienda_gerente FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado);

CREATE TABLE ventas (
    id_venta NUMBER PRIMARY KEY,
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cliente_id NUMBER NOT NULL,
    empleado_id NUMBER NOT NULL,
    id_tienda NUMBER NOT NULL,
    total NUMBER(12,2) NOT NULL,
    estado VARCHAR2(20) DEFAULT 'ACTIVA',
    CONSTRAINT fk_venta_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_venta_empleado FOREIGN KEY (empleado_id) REFERENCES empleados(id_empleado),
    CONSTRAINT fk_venta_tienda FOREIGN KEY (id_tienda) REFERENCES tiendas(id_tienda)
);

CREATE TABLE detalle_venta (
    id_detalle NUMBER PRIMARY KEY,
    id_venta NUMBER NOT NULL,
    id_producto NUMBER NOT NULL,
    cantidad NUMBER NOT NULL,
    precio_unitario NUMBER(10,2) NOT NULL,
    subtotal NUMBER(12,2) NOT NULL,
    CONSTRAINT fk_detalle_venta FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

CREATE TABLE movimientos_inventario (
    id_movimiento NUMBER PRIMARY KEY,
    tipo_movimiento VARCHAR2(50) NOT NULL,
    id_producto NUMBER NOT NULL,
    cantidad NUMBER NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_empleado NUMBER,
    CONSTRAINT fk_movimiento_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT fk_movimiento_empleado FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

CREATE TABLE auditoria_precios (
    id_auditoria NUMBER PRIMARY KEY,
    id_producto NUMBER NOT NULL,
    precio_anterior NUMBER(10,2) NOT NULL,
    precio_nuevo NUMBER(10,2) NOT NULL,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_empleado NUMBER,
    CONSTRAINT fk_auditoria_producto FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    CONSTRAINT fk_auditoria_empleado FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

-- 3️⃣ Triggers para simular SERIAL / AUTO_INCREMENT

CREATE OR REPLACE TRIGGER trg_categorias
BEFORE INSERT ON categorias
FOR EACH ROW
BEGIN
   :NEW.id_categoria := seq_categorias.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_proveedores
BEFORE INSERT ON proveedores
FOR EACH ROW
BEGIN
   :NEW.id_proveedor := seq_proveedores.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_productos
BEFORE INSERT ON productos
FOR EACH ROW
BEGIN
   :NEW.id_producto := seq_productos.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_tiendas
BEFORE INSERT ON tiendas
FOR EACH ROW
BEGIN
   :NEW.id_tienda := seq_tiendas.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_inventario_tienda
BEFORE INSERT ON inventario_tienda
FOR EACH ROW
BEGIN
   :NEW.id_inventario := seq_inventario.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_clientes
BEFORE INSERT ON clientes
FOR EACH ROW
BEGIN
   :NEW.id_cliente := seq_clientes.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_empleados
BEFORE INSERT ON empleados
FOR EACH ROW
BEGIN
   :NEW.id_empleado := seq_empleados.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_ventas
BEFORE INSERT ON ventas
FOR EACH ROW
BEGIN
   :NEW.id_venta := seq_ventas.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_detalle_venta
BEFORE INSERT ON detalle_venta
FOR EACH ROW
BEGIN
   :NEW.id_detalle := seq_detalle_venta.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_movimientos_inventario
BEFORE INSERT ON movimientos_inventario
FOR EACH ROW
BEGIN
   :NEW.id_movimiento := seq_movimientos.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_auditoria_precios
BEFORE INSERT ON auditoria_precios
FOR EACH ROW
BEGIN
   :NEW.id_auditoria := seq_auditoria.NEXTVAL;
END;
/
