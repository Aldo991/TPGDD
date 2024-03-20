---| TEMPLATES |-----------------------------------------------------------------------------------------------

/*
IF OBJECT_ID('STARSHIP_BI.migrar_dimension_') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_
GO

IF OBJECT_ID('STARSHIP_BI.dimension_') IS NOT NULL
	DROP TABLE STARSHIP_BI.dimension_
GO

IF OBJECT_ID('STARSHIP_BI.view_dimension_') IS NOT NULL
	DROP VIEW STARSHIP_BI.view_dimension_
GO
*/

---| DIMENSIONES |--------------------------------------------------------------------------------------------


IF OBJECT_ID('STARSHIP_BI.DIMENSION_CALIFICACION') IS NOT NULL
	DROP TABLE STARSHIP_BI.DIMENSION_CALIFICACION
GO

IF OBJECT_ID('STARSHIP_BI.DIMENSION_TIEMPO') IS NOT NULL
	DROP TABLE STARSHIP_BI.DIMENSION_TIEMPO
GO

IF OBJECT_ID('STARSHIP_BI.DIMENSION_DIA') IS NOT NULL
	DROP TABLE STARSHIP_BI.DIMENSION_DIA
GO

IF OBJECT_ID('STARSHIP_BI.DIMENSION_RANGO_HORARIO') IS NOT NULL
	DROP TABLE STARSHIP_BI.DIMENSION_RANGO_HORARIO
GO

IF OBJECT_ID('STARSHIP_BI.DIMENSION_LUGAR') IS NOT NULL
	DROP TABLE STARSHIP_BI.DIMENSION_LUGAR
GO

IF OBJECT_ID('STARSHIP_BI.DIMENSION_RANGO_ETARIO') IS NOT NULL
	DROP TABLE STARSHIP_BI.DIMENSION_RANGO_ETARIO
GO

IF OBJECT_ID('STARSHIP_BI.DIMENSION_TIPO_MEDIO_PAGO') IS NOT NULL
	DROP TABLE STARSHIP_BI.DIMENSION_TIPO_MEDIO_PAGO
GO

IF OBJECT_ID('STARSHIP_BI.DIMENSION_NEGOCIO') IS NOT NULL
	DROP TABLE STARSHIP_BI.DIMENSION_NEGOCIO
GO

IF OBJECT_ID('STARSHIP_BI.DIMENSION_CLASIFICACION_NEGOCIO') IS NOT NULL
	DROP TABLE STARSHIP_BI.DIMENSION_CLASIFICACION_NEGOCIO
GO

IF OBJECT_ID('STARSHIP_BI.DIMENSION_TIPO_MOVILIDAD') IS NOT NULL
	DROP TABLE STARSHIP_BI.DIMENSION_TIPO_MOVILIDAD
GO

IF OBJECT_ID('STARSHIP_BI.DIMENSION_TIPO_PAQUETE') IS NOT NULL
	DROP TABLE STARSHIP_BI.DIMENSION_TIPO_PAQUETE
GO

IF OBJECT_ID('STARSHIP_BI.DIMENSION_ESTADO_PEDIDO') IS NOT NULL
	DROP TABLE STARSHIP_BI.DIMENSION_ESTADO_PEDIDO
GO

IF OBJECT_ID('STARSHIP_BI.DIMENSION_ESTADO_ENVIO_MENSAJERIA') IS NOT NULL
	DROP TABLE STARSHIP_BI.DIMENSION_ESTADO_ENVIO_MENSAJERIA
GO

IF OBJECT_ID('STARSHIP_BI.DIMENSION_ESTADO_RECLAMO') IS NOT NULL
	DROP TABLE STARSHIP_BI.DIMENSION_ESTADO_RECLAMO
GO

IF OBJECT_ID('STARSHIP_BI.DIMENSION_TIPO_RECLAMO') IS NOT NULL
	DROP TABLE STARSHIP_BI.DIMENSION_TIPO_RECLAMO
GO

---| PROCECIMIENTOS |-----------------------------------------------------------------------------------------


IF OBJECT_ID('STARSHIP_BI.migrar_dimension_tipo_reclamo') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_tipo_reclamo
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_fecha') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_fecha
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_dia') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_dia
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_rango_horario') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_rango_horario
GO

IF OBJECT_ID('STARSHIP_BI.insertar_rango_hetario') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.insertar_rango_hetario
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_lugar') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_lugar
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_tipo_medio_pago') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_tipo_medio_pago
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_negocio') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_negocio
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_tipo_movilidad') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_tipo_movilidad
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_tipo_paquete') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_tipo_paquete
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_estado_pedido') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_estado_pedido
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_estado_envio_mensajeria') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_estado_envio_mensajeria
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_estado_reclamo') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_estado_reclamo
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_estado_pedido') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_estado_pedido
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_clasificacion_negocio') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_clasificacion_negocio
GO

IF OBJECT_ID('STARSHIP_BI.insertar_tabla_de_hechos_compra') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.insertar_tabla_de_hechos_compra
GO

IF OBJECT_ID('STARSHIP_BI.insertar_tabla_de_hechos_venta') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.insertar_tabla_de_hechos_venta
GO

IF OBJECT_ID('STARSHIP_BI.insertar_tabla_de_hechos_descuento') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.insertar_tabla_de_hechos_descuento
GO

IF OBJECT_ID('STARSHIP_BI.insertar_tabla_de_hechos_entrega') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.insertar_tabla_de_hechos_entrega
GO

IF OBJECT_ID('STARSHIP_BI.insertar_tabla_de_hechos_reclamo') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.insertar_tabla_de_hechos_reclamo
GO

---| VIEW |-----------------------------------------------------------------------------------------------------

IF OBJECT_ID('STARSHIP_BI.view_dia_hora_localidad_mas_pedidos') IS NOT NULL
	DROP VIEW STARSHIP_BI.view_dia_hora_localidad_mas_pedidos
GO

IF OBJECT_ID('STARSHIP_BI.view_total_no_cobrado') IS NOT NULL
	DROP VIEW STARSHIP_BI.view_total_no_cobrado
GO

IF OBJECT_ID('STARSHIP_BI.view_promedio_mensual_envio') IS NOT NULL
	DROP VIEW STARSHIP_BI.view_promedio_mensual_envio
GO

IF OBJECT_ID('STARSHIP_BI.view_desvio_tiempo_promedio') IS NOT NULL
	DROP VIEW STARSHIP_BI.view_desvio_tiempo_promedio
GO

IF OBJECT_ID('STARSHIP_BI.view_total_cupones_edad') IS NOT NULL
	DROP VIEW STARSHIP_BI.view_total_cupones_edad
GO

IF OBJECT_ID('STARSHIP_BI.view_calificacion_promedio_local') IS NOT NULL
	DROP VIEW STARSHIP_BI.view_calificacion_promedio_local
GO

IF OBJECT_ID('STARSHIP_BI.view_promedio_pedido_mensajeria') IS NOT NULL
	DROP VIEW STARSHIP_BI.view_promedio_pedido_mensajeria
GO

IF OBJECT_ID('STARSHIP_BI.view_promedio_mensual_asegurado') IS NOT NULL
	DROP VIEW STARSHIP_BI.view_promedio_mensual_asegurado
GO

IF OBJECT_ID('STARSHIP_BI.view_cantidad_reclamos') IS NOT NULL
	DROP VIEW STARSHIP_BI.view_cantidad_reclamos
GO

IF OBJECT_ID('STARSHIP_BI.view_tiempo_promedio_resolucion') IS NOT NULL
	DROP VIEW STARSHIP_BI.view_tiempo_promedio_resolucion
GO

IF OBJECT_ID('STARSHIP_BI.view_monto_mensual_cupones_reclamo') IS NOT NULL
	DROP VIEW STARSHIP_BI.view_monto_mensual_cupones_reclamo
GO

---| TABLAS DE HECHOS |---------------------------------------------------------------------------------------

IF OBJECT_ID('STARSHIP_BI.HECHOS_PEDIDO') IS NOT NULL
	DROP TABLE STARSHIP_BI.HECHOS_PEDIDO
GO

IF OBJECT_ID('STARSHIP_BI.HECHOS_RECLAMO') IS NOT NULL
	DROP TABLE STARSHIP_BI.HECHOS_RECLAMO
GO

IF OBJECT_ID('STARSHIP_BI.HECHOS_ENTREGA') IS NOT NULL
	DROP TABLE STARSHIP_BI.HECHOS_ENTREGA
GO

IF OBJECT_ID('STARSHIP_BI.HECHOS_DESCUENTO') IS NOT NULL
	DROP TABLE STARSHIP_BI.HECHOS_DESCUENTO
GO

----| ESQUEMA |-----------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'STARSHIP_BI')
BEGIN
    DROP SCHEMA STARSHIP_BI
END
