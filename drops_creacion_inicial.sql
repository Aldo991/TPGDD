
-- DROP Tabla Si Existe
IF OBJECT_ID('STARSHIP.Cupon_Reclamo', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Cupon_Reclamo;
GO

IF OBJECT_ID('STARSHIP.Cupon_Pedido', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Cupon_Pedido;
GO

IF OBJECT_ID('STARSHIP.Reclamo', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Reclamo;
GO

IF OBJECT_ID('STARSHIP.Paquete', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Paquete;
GO

IF OBJECT_ID('STARSHIP.Envio_Mensajeria', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Envio_Mensajeria;
GO

IF OBJECT_ID('STARSHIP.Producto_Pedido', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Producto_Pedido;
GO

IF OBJECT_ID('STARSHIP.Negocio_Dia', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Negocio_Dia;
GO

IF OBJECT_ID('STARSHIP.Pedido', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Pedido;
GO

IF OBJECT_ID('STARSHIP.Producto_Negocio', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Producto_Negocio;
GO

IF OBJECT_ID('STARSHIP.Envio', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Envio;
GO

IF OBJECT_ID('STARSHIP.Medio_Pago', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Medio_Pago;
GO

IF OBJECT_ID('STARSHIP.Tipo_Medio_Pago', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Tipo_Medio_Pago;
GO

IF OBJECT_ID('STARSHIP.Operador', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Operador;
GO

IF OBJECT_ID('STARSHIP.Negocio', 'U') IS NOT NULL
BEGIN
	ALTER TABLE STARSHIP.Negocio
	DROP CONSTRAINT 
		FK_Negocio_categ,
		FK_Negocio_direccion;
END
GO

IF OBJECT_ID('STARSHIP.Pedido_Estado', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Pedido_Estado;
GO


IF OBJECT_ID('STARSHIP.Categoria_Negocio', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Categoria_Negocio;
GO

IF OBJECT_ID('STARSHIP.Dia', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Dia;
GO

IF OBJECT_ID('STARSHIP.Tipo_Negocio', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Tipo_Negocio;
GO

IF OBJECT_ID('STARSHIP.Horario', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Horario;
GO

IF OBJECT_ID('STARSHIP.Tipo_Paquete', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Tipo_Paquete;
GO

IF OBJECT_ID('STARSHIP.Repartidor_Localidad', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Repartidor_Localidad;
GO

IF OBJECT_ID('STARSHIP.Mens_Estado', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Mens_Estado;
GO

IF OBJECT_ID('STARSHIP.Recl_Estado', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Recl_Estado;
GO

IF OBJECT_ID('STARSHIP.Cupon_Descuento', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Cupon_Descuento;
GO

IF OBJECT_ID('STARSHIP.Cupon_Tipo', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Cupon_Tipo;
GO

IF OBJECT_ID('STARSHIP.Producto', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Producto;
GO

IF OBJECT_ID('STARSHIP.Recl_Solucion', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Recl_Solucion;
GO

IF OBJECT_ID('STARSHIP.Tipo_Reclamo', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Tipo_Reclamo;
GO

IF OBJECT_ID('STARSHIP.Cliente_Direccion', 'U') IS NOT NULL
DROP TABLE STARSHIP.Cliente_Direccion;
GO

IF OBJECT_ID('STARSHIP.Cliente', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Cliente;
GO

IF OBJECT_ID('STARSHIP.Repartidor_Direccion', 'U') IS NOT NULL
DROP TABLE STARSHIP.Repartidor_Direccion;
GO

IF OBJECT_ID('STARSHIP.Repartidor', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Repartidor;
GO



IF OBJECT_ID('STARSHIP.Tipo_Movilidad', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Tipo_Movilidad;
GO

IF OBJECT_ID('STARSHIP.Direccion', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Direccion;
GO

IF OBJECT_ID('STARSHIP.Direccion_Tipo', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Direccion_Tipo;
GO

IF OBJECT_ID('STARSHIP.Tarjeta', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Tarjeta;
GO

IF OBJECT_ID('STARSHIP.Marca_Tarjeta', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Marca_Tarjeta;
GO

IF OBJECT_ID('STARSHIP.Negocio', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Negocio;
GO

IF OBJECT_ID('STARSHIP.Localidad', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Localidad;
GO

IF OBJECT_ID('STARSHIP.Provincia', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Provincia;
GO

IF OBJECT_ID('STARSHIP.Cupon_Reclamo', 'U') IS NOT NULL
    DROP TABLE STARSHIP.Cupon_Reclamo;
GO

-- DROP Procedimiento Si Existe
IF OBJECT_ID('STARSHIP.GD1C2023.migrar_cupon_tipo', 'P') IS NOT NULL
	DROP PROCEDURE dbo.migrar_cupon_tipo
GO

IF OBJECT_ID('STARSHIP.migrar_provincias', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_provincias
GO

IF OBJECT_ID('STARSHIP.migrar_producto', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_producto
GO

IF OBJECT_ID('STARSHIP.migrar_localidad', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_localidad
GO

IF OBJECT_ID('STARSHIP.migrar_tipo_negocio', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_tipo_negocio
GO

IF OBJECT_ID('STARSHIP.migrar_direccion', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_direccion
GO

IF OBJECT_ID('STARSHIP.migrar_negocio', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_negocio
GO

IF OBJECT_ID('STARSHIP.migrar_tipo_reclamo', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_tipo_reclamo
GO

IF OBJECT_ID('STARSHIP.migrar_tipo_movilidad', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_tipo_movilidad
GO

IF OBJECT_ID('STARSHIP.migrar_reclamo_solucion', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_reclamo_solucion
GO

IF OBJECT_ID('STARSHIP.migrar_reclamo_estado', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_reclamo_estado
GO

IF OBJECT_ID('STARSHIP.migrar_tipo_medio_pago', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_tipo_medio_pago
GO

IF OBJECT_ID('STARSHIP.migrar_horario', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_horario
GO

IF OBJECT_ID('STARSHIP.insertar_dia', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.insertar_dia
GO

IF OBJECT_ID('STARSHIP.migrar_dia', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_dia
GO

IF OBJECT_ID('STARSHIP.migrar_negocio_dia', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_negocio_dia
GO

IF OBJECT_ID('STARSHIP.migrar_cliente', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_cliente
GO

IF OBJECT_ID('STARSHIP.migrar_cliente_direccion', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_cliente_direccion
GO

IF OBJECT_ID('STARSHIP.migrar_repartidor', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_repartidor
GO

IF OBJECT_ID('STARSHIP.migrar_repartidor_direccion', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_repartidor_direccion
GO

IF OBJECT_ID('STARSHIP.migrar_envio', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_envio
GO

IF OBJECT_ID('STARSHIP.migrar_marca_tarjeta', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_marca_tarjeta
GO

IF OBJECT_ID('STARSHIP.migrar_medio_pago', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_medio_pago
GO

IF OBJECT_ID('STARSHIP.migrar_tarjeta', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_tarjeta
GO

IF OBJECT_ID('STARSHIP.migrar_pedido_estado', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_pedido_estado
GO

IF OBJECT_ID('STARSHIP.migrar_tipo_paquete', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_tipo_paquete
GO

IF OBJECT_ID('STARSHIP.migrar_pedido', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_pedido
GO

IF OBJECT_ID('STARSHIP.migrar_cupon_tipo', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_cupon_tipo
GO

IF OBJECT_ID('STARSHIP.migrar_cupon_descuento', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_cupon_descuento
GO

IF OBJECT_ID('STARSHIP.migrar_cupon_pedido', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_cupon_pedido
GO

IF OBJECT_ID('STARSHIP.migrar_envio_mensajeria', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_envio_mensajeria
GO

IF OBJECT_ID('STARSHIP.migrar_mensajeria_estado', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_mensajeria_estado
GO

IF OBJECT_ID('STARSHIP.migrar_operador', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_operador
GO

IF OBJECT_ID('STARSHIP.migrar_paquete', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_paquete
GO

IF OBJECT_ID('STARSHIP.migrar_producto_negocio', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_producto_negocio
GO

IF OBJECT_ID('STARSHIP.migrar_producto_pedido', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_producto_pedido
GO

IF OBJECT_ID('STARSHIP.migrar_reclamo', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_reclamo
GO

IF OBJECT_ID('STARSHIP.migrar_repartidor_localidad', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_repartidor_localidad
GO

IF OBJECT_ID('STARSHIP.insertar_direccion_tipo', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.insertar_direccion_tipo
GO

IF OBJECT_ID('STARSHIP.migrar_cupon_reclamo', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.migrar_cupon_reclamo
GO

IF OBJECT_ID('STARSHIP.insertar_categoria_negocio', 'P') IS NOT NULL
	DROP PROCEDURE STARSHIP.insertar_categoria_negocio
GO

---
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'STARSHIP')
BEGIN
    DROP SCHEMA STARSHIP
END
GO