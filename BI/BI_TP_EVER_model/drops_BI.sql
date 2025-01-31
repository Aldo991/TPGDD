/*
====| DROPS DE TABLAS DE HECHOS |==============================================================*/

IF OBJECT_ID('STARSHIP_BI.HECHOS_PEDIDO') IS NOT NULL
	DROP TABLE STARSHIP_BI.HECHOS_PEDIDO
GO

IF OBJECT_ID('STARSHIP_BI.HECHOS_ENVIO') IS NOT NULL
	DROP TABLE STARSHIP_BI.HECHOS_ENVIO
GO

IF OBJECT_ID('STARSHIP_BI.HECHOS_RECLAMO') IS NOT NULL
	DROP TABLE STARSHIP_BI.HECHOS_RECLAMO
GO

/*
====| DROPS DE DIMENSIONES |==============================================================*/
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

IF OBJECT_ID('STARSHIP_BI.DIMENSION_EVENTO') IS NOT NULL
	DROP TABLE STARSHIP_BI.DIMENSION_EVENTO
GO

/*
====| DROPS DE PROCEDURES |==============================================================*/
IF OBJECT_ID('STARSHIP_BI.migrar_dimension_tiempo') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_tiempo
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_dia') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_dia
GO

IF OBJECT_ID('STARSHIP_BI.insertar_dimension_rango_horario') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.insertar_dimension_rango_horario
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_lugar') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_lugar
GO

IF OBJECT_ID('STARSHIP_BI.insertar_rango_hetario') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.insertar_rango_hetario
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_tipo_medio_pago') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_tipo_medio_pago
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_negocio') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_negocio
GO

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_clasificacion_negocio') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_clasificacion_negocio
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

IF OBJECT_ID('STARSHIP_BI.migrar_dimension_tipo_reclamo') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_dimension_tipo_reclamo
GO

IF OBJECT_ID('STARSHIP_BI.insertar_dimension_evento') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.insertar_dimension_evento
GO

---------------------------------------------------------------------------------------

IF OBJECT_ID('STARSHIP_BI.migrar_hechos_pedido') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_hechos_pedido
GO

IF OBJECT_ID('STARSHIP_BI.migrar_hechos_envio') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_hechos_envio
GO

IF OBJECT_ID('STARSHIP_BI.migrar_hechos_reclamo') IS NOT NULL
	DROP PROCEDURE STARSHIP_BI.migrar_hechos_reclamo
GO

/*
====| DROPS DE VIEWS |==============================================================*/

IF OBJECT_ID('STARSHIP_BI.VIEW_01_MAYOR_CANTIDAD_DE_PEDIDOS') IS NOT NULL
	DROP VIEW STARSHIP_BI.VIEW_01_MAYOR_CANTIDAD_DE_PEDIDOS
GO

IF OBJECT_ID('STARSHIP_BI.VIEW_02_MONTO_TOTAL_NO_COBRADO') IS NOT NULL
	DROP VIEW STARSHIP_BI.VIEW_02_MONTO_TOTAL_NO_COBRADO
GO

IF OBJECT_ID('STARSHIP_BI.VIEW_03_PROMEDIO_MENSUAL_ENVIOS_PEDIDO') IS NOT NULL
	DROP VIEW STARSHIP_BI.VIEW_03_PROMEDIO_MENSUAL_ENVIOS_PEDIDO
GO

IF OBJECT_ID('STARSHIP_BI.VIEW_04_DESVIO_PROMEDIO_EN_TIEMPO_DE_ENTREGA') IS NOT NULL
	DROP VIEW STARSHIP_BI.VIEW_04_DESVIO_PROMEDIO_EN_TIEMPO_DE_ENTREGA
GO

IF OBJECT_ID('STARSHIP_BI.VIEW_05_TOTAL_CUPONES_POR_MES') IS NOT NULL
	DROP VIEW STARSHIP_BI.VIEW_05_TOTAL_CUPONES_POR_MES
GO

IF OBJECT_ID('STARSHIP_BI.VIEW_06_CALIFICACION_PROMEDIO_MENSUAL_POR_LOCAL') IS NOT NULL
	DROP VIEW STARSHIP_BI.VIEW_06_CALIFICACION_PROMEDIO_MENSUAL_POR_LOCAL
GO

IF OBJECT_ID('STARSHIP_BI.VIEW_07_PORCENTAJE_ENVIOS_ENTREGADOS_MENSUALES') IS NOT NULL
	DROP VIEW STARSHIP_BI.VIEW_07_PORCENTAJE_ENVIOS_ENTREGADOS_MENSUALES
GO

IF OBJECT_ID('STARSHIP_BI.VIEW_08_PROMEDIO_MENSUAL_DEL_VALOR_ASEGURADO') IS NOT NULL
	DROP VIEW STARSHIP_BI.VIEW_08_PROMEDIO_MENSUAL_DEL_VALOR_ASEGURADO
GO

IF OBJECT_ID('STARSHIP_BI.VIEW_09_CANTIDAD_RECLAMOS_MENSUALES') IS NOT NULL
	DROP VIEW STARSHIP_BI.VIEW_09_CANTIDAD_RECLAMOS_MENSUALES
GO

IF OBJECT_ID('STARSHIP_BI.VIEW_10_TIEMPO_PROMEDIO_MENSUAL_RESOL_RECLAMOS') IS NOT NULL
	DROP VIEW STARSHIP_BI.VIEW_10_TIEMPO_PROMEDIO_MENSUAL_RESOL_RECLAMOS
GO

IF OBJECT_ID('STARSHIP_BI.VIEW_11_MONTO_MENSUAL_EN_CUPONES_DE_RECLAMO') IS NOT NULL
	DROP VIEW STARSHIP_BI.VIEW_11_MONTO_MENSUAL_EN_CUPONES_DE_RECLAMO
GO

/*
====| DROPS SCHEMA |==============================================================*/

IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'STARSHIP_BI')
BEGIN
    DROP SCHEMA STARSHIP_BI
END
GO