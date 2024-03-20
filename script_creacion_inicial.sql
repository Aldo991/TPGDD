-- Esquema
CREATE SCHEMA STARSHIP
GO

---// CREACIÓN DE TABLAS //------------------------------------------------------------

-- CREAR TABLA PRODUCTO
CREATE TABLE STARSHIP.Producto (
    prod_descripcion nvarchar(255),
    prod_nombre nvarchar(50),
    prod_codigo char(50) NOT NULL -- PK - DB
);

 -- AGREGAR PK Producto
ALTER TABLE STARSHIP.Producto
ADD CONSTRAINT PK_prod_codigo PRIMARY KEY (prod_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Negocio (
    nego_codigo decimal(19,0) identity(1,1), --PK
    nego_nombre nvarchar(100),
    nego_direccion decimal(19,0), -- FK
    nego_detalle nvarchar(255),
    nego_categ decimal(19,0) --FK
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Negocio
ADD CONSTRAINT PK_nego_codigo PRIMARY KEY (nego_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Producto_Negocio (
    prod_nego_prod char(50) NOT NULL, -- FK - DB
    prod_nego_prec_unitario decimal(18, 2),
    prod_nego_nego decimal(19,0) NOT NULL, -- FK
    prod_nego_codigo decimal(19,0) identity(1,1) --PK
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Producto_Negocio
ADD CONSTRAINT PK_prod_nego_codigo PRIMARY KEY (prod_nego_codigo);

-- CREAR TABLA ENVIO
CREATE TABLE STARSHIP.Envio (
    envi_numero decimal(18, 0) identity(1,1), -- PK
    envi_dir_codigo decimal(19,0), -- FK
    envi_precio decimal(18, 2),
    envi_propina decimal(18, 2),
    envi_repartidor decimal(19,0) -- FK
);

 -- AGREGAR PK ENVIO
ALTER TABLE STARSHIP.Envio
ADD CONSTRAINT PK_envi_numero PRIMARY KEY (envi_numero);

-- CREAR TABLA REPARTIDOR
CREATE TABLE STARSHIP.Repartidor (
    repa_codigo decimal(19,0) identity(1,1), -- PK
    repa_dni decimal(18,0),
    repa_nombre nvarchar(255),
    repa_apellido nvarchar(255),
    repa_telefono decimal(18, 0),
    repa_tipo_mov decimal(19,0), --FK
    repa_mail nvarchar(255),
    repa_nacimiento date
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Repartidor
ADD CONSTRAINT PK_repa_codigo PRIMARY KEY (repa_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Repartidor_Direccion (
    repa_dir_repa_codigo decimal(19,0) NOT NULL, --PKFK
    repa_dir_dir_codigo decimal(19,0) NOT NULL --PKFK
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Repartidor_Direccion
ADD CONSTRAINT PK_Repartidor_Direccion PRIMARY KEY (repa_dir_repa_codigo, repa_dir_dir_codigo);

-- CREAR TABLA
CREATE TABLE STARSHIP.Cupon_Reclamo (
    cupon_recl_recl decimal(18,0) NOT NULL, --PKFK - DB
    cupon_recl_cupon decimal(19,0) NOT NULL --PKFK
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Cupon_Reclamo
ADD CONSTRAINT PK_cupon_recl_recl PRIMARY KEY (cupon_recl_recl, cupon_recl_cupon);


-- CREAR TABLA 
CREATE TABLE STARSHIP.Tipo_Movilidad (
    tipo_movi_codigo decimal(19,0) identity(1,1), -- PK
    tipo_movi_detalle nvarchar(50)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Tipo_Movilidad
ADD CONSTRAINT PK_tipo_movi_codigo PRIMARY KEY (tipo_movi_codigo);


-- CREAR TABLA 
CREATE TABLE STARSHIP.Repartidor_Localidad (
    repa_loc_loc decimal(19,0) NOT NULL, --PKFK
    repa_loc_repa decimal(19,0) NOT NULL --PKFK
);


--  AGREGAR PK
ALTER TABLE STARSHIP.Repartidor_Localidad
ADD CONSTRAINT PK_repartidor_localidad PRIMARY KEY (repa_loc_loc, repa_loc_repa);


-- CREAR TABLA 
CREATE TABLE STARSHIP.Localidad (
    locali_codigo decimal(19,0) identity(1,1), --PK
    locali_prov decimal(19,0), -- FK
    locali_nombre nvarchar(255)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Localidad
ADD CONSTRAINT PK_locali_codigo PRIMARY KEY (locali_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Envio_Mensajeria (
    mens_numero decimal(18, 0) NOT NULL, --PK - DB
    mens_provincia decimal(19,0), --FK
    mens_dir_origen nvarchar(255),
    mens_dir_destino nvarchar(255),
    mens_fecha_hora_pedi datetime2(3),
    mens_distancia decimal(18, 2),
    mens_detalle nvarchar(255),
    mens_precio_total decimal(18,2),
    mens_precio_seguro decimal(18,2),
    mens_repa_codigo decimal(19,0), --FK
    mens_localidad decimal(19,0), --FK
    mens_estado_codigo decimal(19,0), -- FK
    mens_precio_envio decimal(18,2),
    mens_propina decimal(18,2),
    mens_fecha_hora_entr datetime2(3),
    mens_tiempo_estimado decimal(18,2),
    mens_calificacion decimal(18,0),
    mens_medio_pago decimal(19,0) -- FK
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Envio_Mensajeria
ADD CONSTRAINT PK_mens_numero PRIMARY KEY (mens_numero);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Paquete (
    paqu_codigo decimal(19,0) identity(1,1), --PK
    mens_valor_asegurado decimal(18,2),
    paqu_tipo decimal(19,0), --FK
    paqu_clie decimal(19,0), --FK
    paqu_mens_numero decimal(18, 0) -- FK
);

--  AGREGAR PK
ALTER TABLE  STARSHIP.Paquete
ADD CONSTRAINT PK_paqu_codigo PRIMARY KEY (paqu_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Tipo_Paquete (
    tipo_paqu_codigo decimal(19,0) identity(1,1), --PK
    tipo_paqu_peso decimal(18,2),
    tipo_paqu_alto decimal(18,2),
    tipo_paqu_largo decimal(18,2),
    tipo_paqu_precio decimal(18,2),
    tipo_paqu_ancho decimal(18,2),
    tipo_paqu_detalle nvarchar(50)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Tipo_Paquete
ADD CONSTRAINT PK_tipo_paqu_codigo PRIMARY KEY (tipo_paqu_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Operador (
    oper_codigo decimal(19,0) identity(1,1), --PK
    oper_dni decimal(18,2),
    oper_nombre nvarchar(255),
    oper_telefono decimal(18,0),
    oper_apellido nvarchar(255),
    oper_domicilio decimal(19,0), --FK
    oper_mail nvarchar(255),
    oper_nacimiento date
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Operador
ADD CONSTRAINT PK_oper_codigo PRIMARY KEY (oper_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Reclamo (
    recl_numero decimal(18,0) NOT NULL, --PK - DB
    recl_pedido decimal(18,0), --FK
    recl_detalle nvarchar(255),
    recl_fecha datetime2(3),
    recl_tipo decimal(19,0), --FK
    recl_operador decimal(19,0), --FK
    recl_estado decimal(19,0), --FK
    recl_usuario decimal(19,0), --FK
    recl_solucion decimal(19,0), --FK
    recl_calificacion decimal(18,0),
    recl_fecha_sol datetime2(3)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Reclamo
ADD CONSTRAINT PK_recl_numero PRIMARY KEY (recl_numero);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Tipo_Reclamo (
    tipo_rec_id decimal(19,0) identity(1,1), --PK
    tipo_rec_detalle nvarchar(50)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Tipo_Reclamo
ADD CONSTRAINT PK_tipo_rec_id PRIMARY KEY (tipo_rec_id);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Recl_Estado (
    recl_estado_id decimal(19,0) identity(1,1), --PK
    recl_estado_detalle nvarchar(50)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Recl_Estado
ADD CONSTRAINT PK_recl_estado_id PRIMARY KEY (recl_estado_id);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Recl_Solucion (
    recl_solucion_id decimal(19,0) identity(1,1), --PK
    recl_solucion_detalle nvarchar(255)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Recl_Solucion
ADD CONSTRAINT PK_recl_solucion_id PRIMARY KEY (recl_solucion_id);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Tipo_Negocio (
    tipo_nego_id decimal(19,0) identity(1,1),  --PK
    tipo_nego_detalle nvarchar(50)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Tipo_Negocio
ADD CONSTRAINT PK_tipo_nego_id PRIMARY KEY (tipo_nego_id);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Horario (
    hora_codigo decimal(19,0) identity(1,1), --PK
    hora_hora_apertura decimal(18, 0),
    hora_hora_cierre decimal(18, 0)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Horario
ADD CONSTRAINT PK_hora_codigo PRIMARY KEY (hora_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Direccion (
    dir_codigo decimal(19,0) identity(1,1), --PK
    dir_calle_numero nvarchar(255),
    dir_local_codigo decimal(19,0), --FK
    dir_direccion_tipo decimal(19,0) -- FK
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Direccion
ADD CONSTRAINT PK_dir_codigo PRIMARY KEY (dir_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Direccion_Tipo (
    dir_tipo_codigo decimal(19,0) identity(1,1), -- PK
    dir_tipo_detalle nvarchar(50)
)

--  AGREGAR PK
ALTER TABLE STARSHIP.Direccion_Tipo
ADD CONSTRAINT PK_direccion_tipo_codigo PRIMARY KEY (dir_tipo_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Cliente (
    clie_codigo decimal(19,0) identity(1,1), --PK
    clie_dni decimal(18,0),
    clie_nombre nvarchar(255),
    clie_apellido nvarchar(255),
    clie_telefono decimal(18,0),
    clie_nacimiento date,
    clie_fecha_registro datetime2(3),
    clie_mail nvarchar(255)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Cliente
ADD CONSTRAINT PK_clie_codigo PRIMARY KEY (clie_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Cliente_Direccion (
    clie_dir_clie_codigo decimal(19,0) NOT NULL, --PKFK
    clie_dir_dir_codigo decimal(19,0) NOT NULL, --PKFK
    clie_dir_detalle nvarchar(255)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Cliente_Direccion
ADD CONSTRAINT PK_Cliente_Direccion PRIMARY KEY (clie_dir_clie_codigo, clie_dir_dir_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Producto_Pedido (
    pp_pedi_numero decimal(18,0) NOT NULL, -- FK
    pp_prod_codigo decimal(19,0) NOT NULL, -- FK
    pp_cantidad decimal(18,0),
    pp_precio_unitario decimal(18, 2),
    pp_id decimal(19,0) identity(1,1) -- PK
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Producto_Pedido
ADD CONSTRAINT PK_pp_id PRIMARY KEY (pp_id);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Tipo_Medio_Pago (
    tipo_medio_id decimal(19,0) identity(1,1), --PK
    tipo_medio_detalle nvarchar(50)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Tipo_Medio_Pago
ADD CONSTRAINT PK_tipo_medio_id PRIMARY KEY (tipo_medio_id);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Medio_Pago (
    medi_codigo decimal(19,0) identity(1,1), --PK
    medi_tipo decimal(19,0), --FK
    medi_clie_codigo decimal(19,0), --FK
    medi_tarjeta decimal(19,0) --FK
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Medio_Pago
ADD CONSTRAINT PK_medi_codigo PRIMARY KEY (medi_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Tarjeta (
    tarj_codigo decimal(19,0) identity(1,1), --PK
    tarj_marca decimal(19,0), -- FK
    tarj_numero nvarchar(50)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Tarjeta
ADD CONSTRAINT PK_tarj_codigo PRIMARY KEY (tarj_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Marca_Tarjeta (
    marca_tarjeta_cod decimal(19,0) identity(1,1), --PK
    marca_tarjeta_detalle nvarchar(100)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Marca_Tarjeta
ADD CONSTRAINT PK_marca_tarjeta_cod PRIMARY KEY (marca_tarjeta_cod);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Cupon_Descuento (
    cupon_id decimal(19,0) identity(1,1), --PK
    cupon_numero decimal(18,0),
    cupon_clie_codigo decimal(19,0), --FK
    cupon_tipo decimal(19,0), --FK
    cupon_valor decimal(18,2),
    cupon_fecha_alta datetime2(3),
    cupon_fecha_venc datetime2(3)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Cupon_Descuento
ADD CONSTRAINT PK_cupon_id PRIMARY KEY (cupon_id);


-- CREAR TABLA 
CREATE TABLE STARSHIP.Cupon_Pedido (
    cupon_ped_codigo decimal(19,0) NOT NULL, --PKFK
    pedido_numero decimal(18,0) NOT NULL --PKFK
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Cupon_Pedido
ADD CONSTRAINT PK_cupones_pedido PRIMARY KEY (cupon_ped_codigo, pedido_numero);


-- CREAR TABLA 
CREATE TABLE STARSHIP.Pedido (
    pedi_numero decimal(18,0) NOT NULL, --PK - DB
    pedi_fecha_hora_pedi datetime2(3),
    pedi_usuario decimal(19,0), -- FK
    pedi_total_productos decimal(18,2),
    pedi_calificacion decimal(18,0),
    pedi_envio decimal(18,0), -- FK
    pedi_tarifa_serv decimal(18,2),
    pedi_medio_pago decimal(19,0), -- FK
    pedi_observaciones nvarchar(255),
    pedi_estado decimal(19,0), -- FK
    pedi_tiempo_estimado decimal(18, 0),
    pedi_fecha_hora_entr datetime2(3),
    pedi_nego_codigo decimal(19,0), -- FK
    pedi_total_cupones decimal(18,2),
    pedi_total_servicio decimal(18,2)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Pedido
ADD CONSTRAINT PK_pedi_numero PRIMARY KEY (pedi_numero);


-- CREAR TABLA 
CREATE TABLE STARSHIP.Pedido_Estado (
    pedi_estado_codigo decimal(19,0) identity(1,1), --PK
    pedi_estado_detalle nvarchar(100)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Pedido_Estado
ADD CONSTRAINT PK_pedi_estado_codigo PRIMARY KEY (pedi_estado_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Provincia (
    prov_codigo decimal(19,0) identity(1,1), --PK
    prov_nombre nvarchar(255)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Provincia
ADD CONSTRAINT PK_prov_codigo PRIMARY KEY (prov_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Mens_Estado (
    mens_esta_codigo decimal(19,0) identity(1,1), --PK
    mens_esta_detalle nvarchar(50)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Mens_Estado
ADD CONSTRAINT PK_mens_esta_codigo PRIMARY KEY (mens_esta_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Categoria_Negocio (
    categ_nego_id decimal(19,0) identity(1,1), --PK
    categ_nego_detalle nvarchar(50),
	categ_nego_tipo decimal(19,0) --FK
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Categoria_Negocio
ADD CONSTRAINT PK_categ_nego_id PRIMARY KEY (categ_nego_id);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Negocio_Dia (
    nego_dia_nego decimal(19,0) NOT NULL, --PKFK
    nego_dia_dia decimal(19,0) NOT NULL, --PKFK
    nego_dia_horario decimal(19,0) NOT NULL --FK
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Negocio_Dia
ADD CONSTRAINT PK_negocio_dia PRIMARY KEY (nego_dia_nego, nego_dia_dia, nego_dia_horario);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Dia (
    dia_codigo decimal(19,0) NOT NULL, --PK
    dia_detalle nvarchar(50)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Dia
ADD CONSTRAINT PK_dia_codigo PRIMARY KEY (dia_codigo);

-- CREAR TABLA 
CREATE TABLE STARSHIP.Cupon_Tipo (
    tipo_cupon_codigo decimal(19,0) identity(1,1), --PK
    tipo_cupon_detalle nvarchar(50)
);

--  AGREGAR PK
ALTER TABLE STARSHIP.Cupon_Tipo
ADD CONSTRAINT PK_tipo_cupon_codigo PRIMARY KEY (tipo_cupon_codigo);

---// Foreign Keys //--------------------------------------------------------------------------

--  AGREGAR FK
ALTER TABLE STARSHIP.Producto_Pedido
ADD CONSTRAINT FK_Producto_Pedido
FOREIGN KEY (pp_prod_codigo) REFERENCES STARSHIP.Producto_Negocio(prod_nego_codigo),
FOREIGN KEY (pp_pedi_numero) REFERENCES STARSHIP.Pedido(pedi_numero);

--  AGREGAR FK
ALTER TABLE STARSHIP.Producto_Negocio
ADD CONSTRAINT FK_Producto_Negocio
FOREIGN KEY (prod_nego_nego) REFERENCES STARSHIP.Negocio(nego_codigo),
FOREIGN KEY (prod_nego_prod) REFERENCES STARSHIP.Producto(prod_codigo);

--  AGREGAR FK
ALTER TABLE STARSHIP.Pedido
ADD CONSTRAINT FK_Pedido
FOREIGN KEY (pedi_nego_codigo) REFERENCES STARSHIP.Negocio(nego_codigo),
FOREIGN KEY (pedi_estado) REFERENCES STARSHIP.Pedido_Estado(pedi_estado_codigo),
FOREIGN KEY (pedi_medio_pago) REFERENCES STARSHIP.Medio_Pago(medi_codigo),
FOREIGN KEY (pedi_usuario) REFERENCES STARSHIP.Cliente(clie_codigo),
FOREIGN KEY (pedi_envio) REFERENCES STARSHIP.Envio(envi_numero);

--  AGREGAR FK
ALTER TABLE STARSHIP.Envio_Mensajeria
ADD CONSTRAINT FK_EnvioMensajeria
FOREIGN KEY (mens_provincia) REFERENCES STARSHIP.Provincia(prov_codigo),
FOREIGN KEY (mens_repa_codigo) REFERENCES STARSHIP.Repartidor(repa_codigo),
FOREIGN KEY (mens_localidad) REFERENCES STARSHIP.Localidad(locali_codigo),
FOREIGN KEY (mens_estado_codigo) REFERENCES STARSHIP.Mens_Estado(mens_esta_codigo),
FOREIGN KEY (mens_medio_pago) REFERENCES STARSHIP.Medio_Pago(medi_codigo);

--  AGREGAR FK
ALTER TABLE STARSHIP.Cupon_Reclamo
ADD CONSTRAINT FK_Cupon_Reclamo
FOREIGN KEY (cupon_recl_recl) REFERENCES STARSHIP.Reclamo(recl_numero),
FOREIGN KEY (cupon_recl_cupon) REFERENCES STARSHIP.Cupon_Descuento(cupon_id);

--  AGREGAR FK
ALTER TABLE STARSHIP.Cliente_Direccion
ADD CONSTRAINT FK_Cliente_Direccion
FOREIGN KEY (clie_dir_clie_codigo) REFERENCES STARSHIP.Cliente(clie_codigo),
FOREIGN KEY (clie_dir_dir_codigo) REFERENCES STARSHIP.Direccion(dir_codigo);

--  AGREGAR FK
ALTER TABLE STARSHIP.Repartidor_Direccion
ADD CONSTRAINT FK_Repartidor_Direccion
FOREIGN KEY (repa_dir_repa_codigo) REFERENCES STARSHIP.Repartidor(repa_codigo),
FOREIGN KEY (repa_dir_dir_codigo) REFERENCES STARSHIP.Direccion(dir_codigo);

--  AGREGAR FK
ALTER TABLE STARSHIP.Repartidor
ADD CONSTRAINT FK_Repartidor
FOREIGN KEY (repa_tipo_mov) REFERENCES STARSHIP.Tipo_Movilidad(tipo_movi_codigo);

--  AGREGAR FK
ALTER TABLE STARSHIP.Envio
ADD CONSTRAINT FK_Envio
FOREIGN KEY (envi_dir_codigo) REFERENCES STARSHIP.Direccion(dir_codigo),
FOREIGN KEY (envi_repartidor) REFERENCES STARSHIP.Repartidor(repa_codigo);

--  AGREGAR FK
ALTER TABLE STARSHIP.Cupon_Descuento
ADD CONSTRAINT FK_Cupon_Descuento
FOREIGN KEY (cupon_clie_codigo) REFERENCES STARSHIP.Cliente(clie_codigo),
FOREIGN KEY (cupon_tipo) REFERENCES STARSHIP.Cupon_Tipo(tipo_cupon_codigo);

--  AGREGAR FK
ALTER TABLE STARSHIP.Cupon_Pedido
ADD CONSTRAINT FK_Cupones_Pedido
FOREIGN KEY (cupon_ped_codigo) REFERENCES STARSHIP.Cupon_Descuento(cupon_id),
FOREIGN KEY (pedido_numero) REFERENCES STARSHIP.Pedido(pedi_numero);

--  AGREGAR FK
ALTER TABLE STARSHIP.Medio_Pago
ADD CONSTRAINT FK_Medio_Pago
FOREIGN KEY (medi_tipo) REFERENCES STARSHIP.Tipo_Medio_Pago(tipo_medio_id),
FOREIGN KEY (medi_tarjeta) REFERENCES STARSHIP.Tarjeta(tarj_codigo),
FOREIGN KEY (medi_clie_codigo) REFERENCES STARSHIP.Cliente(clie_codigo);

--  AGREGAR FK
ALTER TABLE STARSHIP.Tarjeta
ADD CONSTRAINT FK_Tarjeta
FOREIGN KEY (tarj_marca) REFERENCES STARSHIP.Marca_Tarjeta(marca_tarjeta_cod);

--  AGREGAR FK
ALTER TABLE STARSHIP.Repartidor_Localidad
ADD CONSTRAINT FK_Repartidor_Localidad
FOREIGN KEY (repa_loc_loc) REFERENCES STARSHIP.Localidad(locali_codigo),
FOREIGN KEY (repa_loc_repa) REFERENCES STARSHIP.Repartidor(repa_codigo);

--  AGREGAR FK
ALTER TABLE STARSHIP.Direccion
ADD CONSTRAINT FK_Direccion
FOREIGN KEY (dir_local_codigo) REFERENCES STARSHIP.Localidad(locali_codigo),
FOREIGN KEY (dir_direccion_tipo) REFERENCES STARSHIP.Direccion_Tipo(dir_tipo_codigo);

--  AGREGAR FK
ALTER TABLE STARSHIP.Localidad
ADD CONSTRAINT FK_Localidad
FOREIGN KEY (locali_prov) REFERENCES STARSHIP.Provincia(prov_codigo);

--  AGREGAR FK
ALTER TABLE STARSHIP.Operador
ADD CONSTRAINT FK_Operador
FOREIGN KEY (oper_domicilio) REFERENCES STARSHIP.Direccion(dir_codigo);

--  AGREGAR FK
ALTER TABLE STARSHIP.Paquete
ADD CONSTRAINT FK_Paquete
FOREIGN KEY (paqu_tipo) REFERENCES STARSHIP.Tipo_Paquete(tipo_paqu_codigo),
FOREIGN KEY (paqu_clie) REFERENCES STARSHIP.Cliente(clie_codigo),
FOREIGN KEY (paqu_mens_numero) REFERENCES STARSHIP.Envio_Mensajeria(mens_numero);

--  AGREGAR FK
ALTER TABLE STARSHIP.Reclamo
ADD CONSTRAINT FK_Reclamo
FOREIGN KEY (recl_pedido) REFERENCES STARSHIP.Pedido(pedi_numero),
FOREIGN KEY (recl_tipo) REFERENCES STARSHIP.Tipo_Reclamo(tipo_rec_id),
FOREIGN KEY (recl_operador) REFERENCES STARSHIP.Operador(oper_codigo),
FOREIGN KEY (recl_estado) REFERENCES STARSHIP.Recl_Estado(recl_estado_id),
FOREIGN KEY (recl_usuario) REFERENCES STARSHIP.Cliente(clie_codigo),
FOREIGN KEY (recl_solucion) REFERENCES STARSHIP.Recl_Solucion(recl_solucion_id);


--AGREGAR FK
ALTER TABLE STARSHIP.Categoria_Negocio
ADD CONSTRAINT FK_Categoria_Nego_Tipo
FOREIGN KEY (categ_nego_tipo) REFERENCES STARSHIP.Tipo_Negocio(tipo_nego_id);


--  AGREGAR FK
ALTER TABLE STARSHIP.Negocio
ADD CONSTRAINT FK_Negocio_direccion
FOREIGN KEY (nego_direccion) REFERENCES STARSHIP.Direccion(dir_codigo);
/*
--  AGREGAR FK xxxxxxxxxxxx
ALTER TABLE STARSHIP.Negocio
ADD CONSTRAINT FK_Negocio_tipo
FOREIGN KEY (nego_tipo) REFERENCES STARSHIP.Tipo_Negocio(tipo_nego_id);
*/

--  AGREGAR FK
ALTER TABLE STARSHIP.Negocio
ADD CONSTRAINT FK_Negocio_categ
FOREIGN KEY (nego_categ) REFERENCES STARSHIP.Categoria_Negocio(categ_nego_id);

--  AGREGAR FK
ALTER TABLE STARSHIP.Negocio_Dia
ADD CONSTRAINT FK_Negocio_Dia
FOREIGN KEY (nego_dia_nego) REFERENCES STARSHIP.Negocio(nego_codigo),
FOREIGN KEY (nego_dia_dia) REFERENCES STARSHIP.Dia(dia_codigo),
FOREIGN KEY (nego_dia_horario) REFERENCES STARSHIP.Horario(hora_codigo);
GO

