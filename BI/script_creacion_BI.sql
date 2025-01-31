--- Esquema
CREATE SCHEMA STARSHIP_BI
GO

---// Creacion de Dimensiones //----------------------------------------------------------------------------

/* CREATE TABLE STARSHIP_BI.DIMENSION_ (

);


ALTER TABLE STARSHIP_BI.DIMENSION_
ADD CONSTRAINT PK_ PRIMARY KEY (_ID); */

/* TODO VER PKS Y TIPOS */

CREATE TABLE STARSHIP_BI.DIMENSION_CALIFICACION (
    CALIFICACION_ID DECIMAL(19,0)
);

CREATE TABLE STARSHIP_BI.DIMENSION_TIEMPO (
    TIEMPO_ID DECIMAL(19,0) IDENTITY(1,1), --- PK
    TIEMPO_ANIO DECIMAL(19,0),
	TIEMPO_MES DECIMAL(19,0),
);

ALTER TABLE STARSHIP_BI.DIMENSION_TIEMPO
ADD CONSTRAINT PK_DIMENSION_TIEMPO PRIMARY KEY (TIEMPO_ID); 

CREATE TABLE STARSHIP_BI.DIMENSION_DIA (
    DIA_ID DECIMAL(19,0), --- PK --- DB
    DIA_DETALLE NVARCHAR(50)
);

ALTER TABLE STARSHIP_BI.DIMENSION_DIA
ADD CONSTRAINT PK_DIA PRIMARY KEY (DIA_ID);

CREATE TABLE STARSHIP_BI.DIMENSION_RANGO_HORARIO (
    RANGO_HORARIO_ID DECIMAL(19,0) IDENTITY(1,1),
    RANGO_HORARIO_INI DECIMAL(19,0),
    RANGO_HORARIO_FIN DECIMAL(19,0)
);

ALTER TABLE STARSHIP_BI.DIMENSION_RANGO_HORARIO
ADD CONSTRAINT PK_RANGO_HORARIO PRIMARY KEY (RANGO_HORARIO_ID);

CREATE TABLE STARSHIP_BI.DIMENSION_LUGAR (
	LUGAR_ID DECIMAL(19,0)  IDENTITY(1,1), --- PK
	LUGAR_LOCALIDAD_NOMBRE NVARCHAR(255),
    LUGAR_PROVINCIA_NOMBRE NVARCHAR(255)
);

ALTER TABLE STARSHIP_BI.DIMENSION_LUGAR
ADD CONSTRAINT PK_LUGAR PRIMARY KEY (LUGAR_ID);

CREATE TABLE STARSHIP_BI.DIMENSION_RANGO_ETARIO (
    RANGO_ETARIO_ID DECIMAL(19,0) IDENTITY(1,1), --- PK
    RANGO_ETARIO_INI DECIMAL(19,0),
    RANGO_ETARIO_FIN DECIMAL(19,0),
);

ALTER TABLE STARSHIP_BI.DIMENSION_RANGO_ETARIO
ADD CONSTRAINT PK_RANGO_ETARIO PRIMARY KEY (RANGO_ETARIO_ID);

CREATE TABLE STARSHIP_BI.DIMENSION_TIPO_MEDIO_PAGO (
	MEDIO_PAGO_ID DECIMAL(19, 0), --- PK --- DB
	MEDIO_PAGO_TIPO NVARCHAR(255),
    MEDIO_PAGO_MARCA NVARCHAR(255)
);

ALTER TABLE STARSHIP_BI.DIMENSION_TIPO_MEDIO_PAGO
ADD CONSTRAINT PK_TIPO_MEDIO_PAGO PRIMARY KEY (TIPO_MEDIO_PAGO_ID);

CREATE TABLE STARSHIP_BI.DIMENSION_NEGOCIO (
    NEGOCIO_ID DECIMAL(19,0), --- PK --- DB
	NEGOCIO_DESCRIPCION NVARCHAR(50)
);

ALTER TABLE STARSHIP_BI.DIMENSION_NEGOCIO
ADD CONSTRAINT PK_NEGOCIO PRIMARY KEY (NEGOCIO_ID);

CREATE TABLE STARSHIP_BI.DIMENSION_CLASIFICACION_NEGOCIO (
    CLASIFICACION_NEGOCIO_ID DECIMAL(19,0), --- PK
    CLASIFICACION_NEGOCIO_CATEGORIA NVARCHAR(50),
    CLASIFICACION_NEGOCIO_TIPO NVARCHAR(50)
);

ALTER TABLE STARSHIP_BI.DIMENSION_CLASIFICACION_NEGOCIO
ADD CONSTRAINT PK_CLASIFICACION_NEGOCIO PRIMARY KEY (CLASIFICACION_NEGOCIO_ID);

CREATE TABLE STARSHIP_BI.DIMENSION_TIPO_MOVILIDAD (
    TIPO_MOVILIDAD_ID DECIMAL(19,0), --- PK --- DB
	TIPO_MOVILIDAD_DESCRIPCION NVARCHAR(50)
);

ALTER TABLE STARSHIP_BI.DIMENSION_TIPO_MOVILIDAD
ADD CONSTRAINT PK_TIPO_MOVILIDAD PRIMARY KEY (TIPO_MOVILIDAD_ID);

CREATE TABLE STARSHIP_BI.DIMENSION_TIPO_PAQUETE (
    TIPO_PAQUETE_ID DECIMAL(19,0), --- PK --- DB
	TIPO_PAQUETE_DESCRIPCION NVARCHAR(50)
);

ALTER TABLE STARSHIP_BI.DIMENSION_TIPO_PAQUETE
ADD CONSTRAINT PK_TIPO_PAQUETE PRIMARY KEY (TIPO_PAQUETE_ID);

CREATE TABLE STARSHIP_BI.DIMENSION_ESTADO_PEDIDO (
    ESTADO_PEDIDO_ID DECIMAL(19,0), --- PK --- DB
	ESTADO_PEDIDO_DESCRIPCION NVARCHAR(50)
);

ALTER TABLE STARSHIP_BI.DIMENSION_ESTADO_PEDIDO
ADD CONSTRAINT PK_ESTADO_PEDIDO PRIMARY KEY (ESTADO_PEDIDO_ID);

CREATE TABLE STARSHIP_BI.DIMENSION_ESTADO_ENVIO_MENSAJERIA (
    ENVIO_MENSAJERIA_ID DECIMAL(19,0), --- PK --- DB
	ENVIO_MENSAJERIA_DESCRIPCION NVARCHAR(50)
);

ALTER TABLE STARSHIP_BI.DIMENSION_ESTADO_ENVIO_MENSAJERIA
ADD CONSTRAINT PK_ESTADO_ENVIO_MENSAJERIA PRIMARY KEY (ESTADO_ENVIO_MENSAJERIA_ID);

CREATE TABLE STARSHIP_BI.DIMENSION_ESTADO_RECLAMO (
    ESTADO_RECLAMO_ID DECIMAL(19,0), --- PK --- DB
	ESTADO_RECLAMO_DESCRIPCION NVARCHAR(50)
);

ALTER TABLE STARSHIP_BI.DIMENSION_ESTADO_RECLAMO
ADD CONSTRAINT PK_DIMENSION_ESTADO_RECLAMO PRIMARY KEY (ESTADO_RECLAMO_ID);

CREATE TABLE STARSHIP_BI.DIMENSION_TIPO_RECLAMO (
    TIPO_RECLAMO_ID DECIMAL(19,0), --- PK --- DB
	TIPO_RECLAMO_DESCRIPCION NVARCHAR(50)
);

ALTER TABLE STARSHIP_BI.DIMENSION_TIPO_RECLAMO
ADD CONSTRAINT PK_DIMENSION_TIPO_RECLAMO PRIMARY KEY (TIPO_RECLAMO_ID);

---// Creacion de Tablas de Hechos //-----------------------------------------------------------------------

CREATE TABLE STARSHIP_BI.HECHOS_COMPRA (
    HC_DIA DECIMAL(19,0),
    HC_RANGO_HORARIO DECIMAL(19,0), --- SE HACEN PEDIDOS
    HC_LUGAR DECIMAL(19,0),
    HC_TIEMPO DECIMAL(19,0),
    HC_ESTADO_PEDIDO DECIMAL(19, 0),---- TODO ENVIO MSJ CAPAZ TMB
    HC_CLASIFICACION_NEGOCIO DECIMAL(19, 0),
    HC_CALIFICACION_NEGOCIO_TOTAL DECIMAL(19,0),
    HC_CANTIDAD_PEDIDOS DECIMAL(19, 0), --- NO PK
    HC_MONTO_TOTAL_PEDIDOS DECIMAL(18, 2) --- NO PK
);

ALTER TABLE STARSHIP_BI.HECHOS_COMPRA
ADD CONSTRAINT PK_HECHOS_COMPRA PRIMARY KEY (
    HC_DIA,
    HC_RANGO_HORARIO,
    HC_LUGAR,
    HC_TIEMPO,
    HC_ESTADO_PEDIDO,
    HC_CLASIFICACION_NEGOCIO,
    HC_CALIFICACION_NEGOCIO_TOTAL
);

CREATE TABLE STARSHIP_BI.HECHOS_RECLAMO (
    HR_RANGO_HORARIO DECIMAL(19, 0),
    HR_TIEMPO DECIMAL(19, 0),
    HR_RANGO_ETARIO DECIMAL(19, 0), --- OPERADORES
    HR_NEGOCIO DECIMAL(19, 0),
    HR_DIA DECIMAL(19, 0),
    HR_TIPO_RECLAMO DECIMAL(19, 0),
    ---------------------------------------------
    HR_CANTIDAD_RECLAMOS DECIMAL(19, 0), --- NO PK
    HR_TIEMPO_SOLUCION_TOTAL DECIMAL(18, 2), --- NO PK
    HR_MONTO_CUPONES DECIMAL(18, 2) --- NO PK
);

ALTER TABLE STARSHIP_BI.HECHOS_RECLAMO
ADD CONSTRAINT PK_HECHOS_RECLAMO PRIMARY KEY (
    HR_RANGO_HORARIO,
    HR_TIEMPO,
    HR_RANGO_ETARIO, --- OPERADOR
    HR_NEGOCIO_ID,
    HR_TIPO_RECLAMO
);

CREATE TABLE STARSHIP_BI.HECHOS_ENTREGA (
    HE_TIPO_MOVILIDAD DECIMAL(19, 0),
    HE_RANGO_ETARIO DECIMAL(19, 0), --- REPARTIDOR,
    HE_RANGO_HORARIO DECIMAL(19, 0),
    HE_DIA DECIMAL(19, 0),
    HE_LUGAR DECIMAL(19, 0),
    HE_ESTADO_ENVIO_MENSAJERIA DECIMAL(19, 0),
    HE_ESTADO_PEDIDO DECIMAL(19, 0),
    HE_TIPO_PAQUETE DECIMAL(19, 0),
    HE_TIEMPO_ESTIMADO_TOTAL DECIMAL(18, 2), --- NO PK
    HE_TIEMPO_ENTREGA_TOTAL DECIMAL(18, 2), --- NO PK
    HE_VALOR_ASEGURADO_TOTAL DECIMAL(18, 2) --- NO PK
);

ALTER TABLE STARSHIP_BI.HECHOS_ENTREGA
ADD CONSTRAINT PK_HECHOS_ENTREGA PRIMARY KEY (
    HE_TIPO_MOVILIDAD,
    HE_RANGO_ETARIO, --- REPARTIDOR,
    HE_RANGO_HORARIO,
    HE_DIA,
    HE_LUGAR,
    HE_ESTADO_ENVIO_MENSAJERIA,
    HE_ESTADO_PEDIDO,
    HE_TIPO_PAQUETE
);

CREATE TABLE STARSHIP_BI.HECHOS_DESCUENTO (
    HD_RANGO_ETARIO DECIMAL(19, 0), --- USUARIOS
    HD_MONTO_CUPONES DECIMAL(18, 2),--- NO PK
    HD_TIEMPO DECIMAL(19, 0)
);

ALTER TABLE STARSHIP_BI.HECHOS_DESCUENTO
ADD CONSTRAINT PK_HECHOS_DESCUENTO PRIMARY KEY (
    HD_RANGO_ETARIO,
    HD_TIEMPO
);

---// Creacion de Foreign Keys //---------------------------------------------------------------------------

ALTER TABLE STARSHIP_BI.HECHOS_COMPRA
ADD CONSTRAINT FK_HECHOS_COMPRA

FOREIGN KEY (HC_DIA) REFERENCES STARSHIP_BI.DIMENSION_DIA(DIA_ID),

FOREIGN KEY (HC_RANGO_HORARIO)
    REFERENCES STARSHIP_BI.DIMENSION_RANGO_HORARIO(RANGO_HORARIO_ID),

FOREIGN KEY (HC_LUGAR)
    REFERENCES STARSHIP_BI.DIMENSION_LUGAR(LUGAR_ID),

FOREIGN KEY (HC_TIEMPO)
    REFERENCES STARSHIP_BI.DIMENSION_TIEMPO(TIEMPO_ID),

FOREIGN KEY (HC_ESTADO_PEDIDO)
    REFERENCES STARSHIP_BI.DIMENSION_ESTADO_PEDIDO(ESTADO_PEDIDO_ID),

FOREIGN KEY (HC_CLASIFICACION_NEGOCIO) REFERENCES
    STARSHIP_BI.DIMENSION_CLASIFICACION_NEGOCIO(CLASIFICACION_NEGOCIO_ID),
GO

ALTER TABLE STARSHIP_BI.HECHOS_RECLAMO
ADD CONSTRAINT FK_HECHOS_RECLAMO
FOREIGN KEY (RANGO_HORARIO)
    REFERENCES STARSHIP_BI.DIMENSION_RANGO_HORARIO(RANGO_HORARIO_ID),

FOREIGN KEY (TIEMPO)
    REFERENCES STARSHIP_BI.DIMENSION_TIEMPO(TIEMPO_ID),

FOREIGN KEY (RANGO_ETARIO)
    REFERENCES STARSHIP_BI.DIMENSION_RANGO_ETARIO(RANGO_ETARIO_ID),

FOREIGN KEY (NEGOCIO)
    REFERENCES STARSHIP_BI.DIMENSION_NEGOCIO(NEGOCIO_ID),

FOREIGN KEY (TIPO_RECLAMO)
        REFERENCES STARSHIP_BI.DIMENSION_TIPO_RECLAMO(TIPO_RECLAMO_ID);
GO
    

ALTER TABLE STARSHIP_BI.HECHOS_ENTREGA
ADD CONSTRAINT FK_HECHOS_ENTREGA
FOREIGN KEY () REFERENCES STARSHIP_BI.DIMENSION_(_ID),
FOREIGN KEY () REFERENCES STARSHIP_BI.DIMENSION_(_ID),
FOREIGN KEY () REFERENCES STARSHIP_BI.DIMENSION_(_ID),
FOREIGN KEY () REFERENCES STARSHIP_BI.DIMENSION_(_ID),
FOREIGN KEY () REFERENCES STARSHIP_BI.DIMENSION_(_ID),
FOREIGN KEY () REFERENCES STARSHIP_BI.DIMENSION_(_ID),
FOREIGN KEY () REFERENCES STARSHIP_BI.DIMENSION_(_ID);
GO

ALTER TABLE STARSHIP_BI.HECHOS_DESCUENTO
ADD CONSTRAINT FK_HECHOS_DESCUENTO

FOREIGN KEY (HD_RANGO_ETARIO)
    REFERENCES STARSHIP_BI.DIMENSION_RANGO_ETARIO(RANGO_ETARIO_ID),

FOREIGN KEY (HD_TIEMPO)
    REFERENCES STARSHIP_BI.DIMENSION_TIEMPO(TIEMPO_ID);
GO