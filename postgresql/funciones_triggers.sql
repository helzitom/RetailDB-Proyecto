-- Función para actualizar inventario
CREATE OR REPLACE FUNCTION actualizar_inventario()
RETURNS TRIGGER AS $$
BEGIN
    -- Descontar stock de la tienda correspondiente a la venta
    UPDATE inventario_tienda
    SET stock_actual = stock_actual - NEW.cantidad,
        ultima_actualizacion = NOW()
    WHERE id_producto = NEW.id_producto
      AND id_tienda = (SELECT id_tienda FROM ventas WHERE id_venta = NEW.id_venta);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger que llama la función al insertar un detalle de venta
CREATE TRIGGER trg_actualizar_inventario
AFTER INSERT ON detalle_venta
FOR EACH ROW
EXECUTE FUNCTION actualizar_inventario();

--Función: calcular rentabilidad de un producto
CREATE OR REPLACE FUNCTION calcular_rentabilidad(id_prod INT)
RETURNS NUMERIC AS $$
DECLARE
    ingresos NUMERIC;
    costos NUMERIC;
BEGIN
    SELECT 
        COALESCE(SUM(dv.cantidad * dv.precio_unitario), 0),
        COALESCE(SUM(dv.cantidad * p.precio_compra), 0)
    INTO ingresos, costos
    FROM detalle_venta dv
    JOIN productos p ON dv.id_producto = p.id_producto
    WHERE p.id_producto = id_prod;

    RETURN ingresos - costos;
END;
$$ LANGUAGE plpgsql;

/*USO*/
SELECT calcular_rentabilidad(10); -- ejemplo para producto id=10
