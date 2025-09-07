


-- Admin: control total
CREATE ROLE admin LOGIN PASSWORD 'admin123';
GRANT ALL PRIVILEGES ON DATABASE retaildb TO admin;

-- Vendedor: solo puede insertar ventas y ver productos/clientes
CREATE ROLE vendedor LOGIN PASSWORD 'vendedor123';
GRANT CONNECT ON DATABASE retaildb TO vendedor;

-- Permisos mínimos para vendedor
GRANT USAGE ON SCHEMA public TO vendedor;
GRANT SELECT ON clientes, productos TO vendedor;
GRANT INSERT ON ventas, detalle_venta TO vendedor;

-- Auditor: solo lectura de todo
CREATE ROLE auditor LOGIN PASSWORD 'auditor123';
GRANT CONNECT ON DATABASE retaildb TO auditor;

-- Permisos de solo lectura
GRANT USAGE ON SCHEMA public TO auditor;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO auditor;

--Mantener permisos futuros
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO auditor;

