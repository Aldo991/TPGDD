--- MIGRACIÓN DE DATOS

CREATE PROCEDURE STARSHIP.insertar_categoria_negocio
AS
BEGIN
	INSERT INTO STARSHIP.Categoria_Negocio (categ_nego_detalle, categ_nego_tipo)
	SELECT 'Parrilla' ,tipo_nego_id FROM STARSHIP.Tipo_Negocio WHERE tipo_nego_detalle = 'Tipo Local Restaurante'
	INSERT INTO STARSHIP.Categoria_Negocio (categ_nego_detalle, categ_nego_tipo)
	SELECT 'Heladeria' ,tipo_nego_id FROM STARSHIP.Tipo_Negocio WHERE tipo_nego_detalle = 'Tipo Local Restaurante'
	INSERT INTO STARSHIP.Categoria_Negocio (categ_nego_detalle, categ_nego_tipo)
	SELECT 'Comidas Rapidas' ,tipo_nego_id FROM STARSHIP.Tipo_Negocio WHERE tipo_nego_detalle = 'Tipo Local Restaurante'
	INSERT INTO STARSHIP.Categoria_Negocio (categ_nego_detalle, categ_nego_tipo)
	SELECT 'OTROS' ,tipo_nego_id FROM STARSHIP.Tipo_Negocio WHERE tipo_nego_detalle = 'Tipo Local Restaurante'
	INSERT INTO STARSHIP.Categoria_Negocio (categ_nego_detalle, categ_nego_tipo)
	SELECT 'Minimercado' ,tipo_nego_id FROM STARSHIP.Tipo_Negocio WHERE tipo_nego_detalle = 'Tipo Local Mercado'
	INSERT INTO STARSHIP.Categoria_Negocio (categ_nego_detalle, categ_nego_tipo)
	SELECT 'Kiosco' ,tipo_nego_id FROM STARSHIP.Tipo_Negocio WHERE tipo_nego_detalle = 'Tipo Local Mercado'
	INSERT INTO STARSHIP.Categoria_Negocio (categ_nego_detalle, categ_nego_tipo)
	SELECT 'Supermercado' ,tipo_nego_id FROM STARSHIP.Tipo_Negocio WHERE tipo_nego_detalle = 'Tipo Local Mercado'
	INSERT INTO STARSHIP.Categoria_Negocio (categ_nego_detalle, categ_nego_tipo)
	SELECT 'OTROS' ,tipo_nego_id FROM STARSHIP.Tipo_Negocio WHERE tipo_nego_detalle = 'Tipo Local Mercado'
END
GO --select * from Categoria_Negocio


CREATE PROCEDURE STARSHIP.migrar_marca_tarjeta
AS
BEGIN
	INSERT INTO STARSHIP.Marca_Tarjeta (marca_tarjeta_detalle)
	SELECT
		MARCA_TARJETA
	FROM GD1C2023.gd_esquema.Maestra
	WHERE MARCA_TARJETA IS NOT NULL
	GROUP BY MARCA_TARJETA
END
GO --select * from Marca_Tarjeta

CREATE PROCEDURE STARSHIP.migrar_cupon_reclamo
AS
BEGIN
	INSERT INTO STARSHIP.Cupon_Reclamo (
		cupon_recl_cupon,
		cupon_recl_recl
	)
	SELECT
	CASE WHEN (CUPON_RECLAMO_NRO IS NOT NULL) --cupon_recl_cupon
	THEN 
		(SELECT
		cupon_id
		FROM STARSHIP.Cupon_Descuento
		JOIN STARSHIP.Cupon_Tipo ON tipo_cupon_codigo = cupon_tipo
		WHERE cupon_numero = CUPON_RECLAMO_NRO
		AND tipo_cupon_detalle = CUPON_RECLAMO_TIPO
		AND cupon_valor = CUPON_RECLAMO_MONTO
		AND cupon_fecha_venc = CUPON_RECLAMO_FECHA_VENCIMIENTO
		AND cupon_fecha_alta = CUPON_RECLAMO_FECHA_ALTA)
	ELSE NULL END,
	CASE WHEN (RECLAMO_NRO IS NOT NULL) --cupon_recl_recl
	THEN 
		(SELECT
			recl_numero
		FROM STARSHIP.Reclamo
		WHERE recl_numero = RECLAMO_NRO
		AND recl_detalle = RECLAMO_DESCRIPCION
		AND recl_calificacion = RECLAMO_CALIFICACION
		AND recl_fecha = RECLAMO_FECHA
		AND recl_fecha_sol = RECLAMO_FECHA_SOLUCION)
	ELSE NULL END
	FROM GD1C2023.gd_esquema.Maestra
	WHERE CUPON_RECLAMO_NRO IS NOT NULL AND RECLAMO_NRO IS NOT NULL
	GROUP BY
		CUPON_RECLAMO_NRO,
		CUPON_RECLAMO_TIPO,
		CUPON_RECLAMO_MONTO,
		CUPON_RECLAMO_FECHA_ALTA,
		CUPON_RECLAMO_FECHA_VENCIMIENTO,
		--
		RECLAMO_NRO,
		RECLAMO_DESCRIPCION,
		RECLAMO_CALIFICACION,
		RECLAMO_FECHA,
		RECLAMO_FECHA_SOLUCION
END
GO


CREATE PROCEDURE STARSHIP.migrar_tipo_paquete
AS
BEGIN
	INSERT INTO STARSHIP.TIPO_PAQUETE (
		tipo_paqu_detalle,
		tipo_paqu_alto,
		tipo_paqu_ancho,
		tipo_paqu_largo,
		tipo_paqu_peso,
    	tipo_paqu_precio
    )
	SELECT
		PAQUETE_TIPO,
		PAQUETE_ALTO_MAX,
		PAQUETE_ANCHO_MAX,
		PAQUETE_LARGO_MAX,
		PAQUETE_PESO_MAX,
		PAQUETE_TIPO_PRECIO
	FROM GD1C2023.gd_esquema.Maestra
	WHERE PAQUETE_TIPO IS NOT NULL
	GROUP BY
		PAQUETE_TIPO,
		PAQUETE_ALTO_MAX,
		PAQUETE_ANCHO_MAX,
		PAQUETE_LARGO_MAX,
		PAQUETE_PESO_MAX,
		PAQUETE_TIPO_PRECIO
END
GO --select * from Tipo_Paquete

CREATE PROCEDURE STARSHIP.migrar_tipo_movilidad
AS
BEGIN
	INSERT INTO STARSHIP.Tipo_Movilidad (
		tipo_movi_detalle
	)
	SELECT
		REPARTIDOR_TIPO_MOVILIDAD
	FROM GD1C2023.gd_esquema.Maestra
	WHERE REPARTIDOR_TIPO_MOVILIDAD IS NOT NULL
	GROUP BY REPARTIDOR_TIPO_MOVILIDAD
END
GO

CREATE PROCEDURE STARSHIP.migrar_tipo_negocio
AS
BEGIN
	INSERT INTO STARSHIP.TIPO_NEGOCIO (
		tipo_nego_detalle
	)
	SELECT
		LOCAL_TIPO
	FROM GD1C2023.gd_esquema.Maestra
	WHERE LOCAL_TIPO IS NOT NULL
	GROUP BY LOCAL_TIPO
END
GO  --select * from Tipo_Negocio

CREATE PROCEDURE STARSHIP.migrar_provincias 
AS
BEGIN
	INSERT INTO STARSHIP.PROVINCIA (
		prov_nombre
		)
	(SELECT
		ENVIO_MENSAJERIA_PROVINCIA
	FROM GD1C2023.gd_esquema.Maestra
	WHERE ENVIO_MENSAJERIA_PROVINCIA IS NOT NULL
	GROUP BY ENVIO_MENSAJERIA_PROVINCIA)
	UNION
	(SELECT
		ENVIO_MENSAJERIA_PROVINCIA
	FROM GD1C2023.gd_esquema.Maestra
	WHERE ENVIO_MENSAJERIA_PROVINCIA IS NOT NULL
	GROUP BY ENVIO_MENSAJERIA_PROVINCIA)
	UNION
	(SELECT
		LOCAL_PROVINCIA
	FROM GD1C2023.gd_esquema.Maestra
	WHERE LOCAL_PROVINCIA IS NOT NULL
	GROUP BY LOCAL_PROVINCIA)
END
GO

CREATE PROCEDURE STARSHIP.migrar_localidad
AS
BEGIN
	INSERT INTO STARSHIP.LOCALIDAD (
		locali_prov,
		locali_nombre
		)
	(SELECT
		CASE WHEN (ENVIO_MENSAJERIA_LOCALIDAD IS NOT NULL
		OR ENVIO_MENSAJERIA_PROVINCIA IS NOT NULL)
		THEN 
			(SELECT
				prov_codigo
			FROM STARSHIP.Provincia
			WHERE prov_nombre = ENVIO_MENSAJERIA_PROVINCIA)
		ELSE NULL END,
		ENVIO_MENSAJERIA_LOCALIDAD
	FROM GD1C2023.gd_esquema.Maestra
	WHERE ENVIO_MENSAJERIA_LOCALIDAD IS NOT NULL
	GROUP BY ENVIO_MENSAJERIA_PROVINCIA, ENVIO_MENSAJERIA_LOCALIDAD)
	UNION
	(SELECT
		CASE WHEN (DIRECCION_USUARIO_LOCALIDAD IS NOT NULL
		OR DIRECCION_USUARIO_PROVINCIA IS NOT NULL)
		THEN
			(SELECT
				prov_codigo
			FROM STARSHIP.Provincia
			WHERE prov_nombre = DIRECCION_USUARIO_PROVINCIA)
		ELSE NULL END,
		DIRECCION_USUARIO_LOCALIDAD
	FROM GD1C2023.gd_esquema.Maestra
	WHERE DIRECCION_USUARIO_LOCALIDAD IS NOT NULL
	GROUP BY DIRECCION_USUARIO_PROVINCIA, DIRECCION_USUARIO_LOCALIDAD)
	UNION
	(SELECT
		CASE WHEN (LOCAL_LOCALIDAD IS NOT NULL OR LOCAL_PROVINCIA IS NOT NULL)
		THEN
			(SELECT
				prov_codigo
			FROM STARSHIP.Provincia
			WHERE prov_nombre = LOCAL_PROVINCIA)
		ELSE NULL END,
		LOCAL_LOCALIDAD
	FROM GD1C2023.gd_esquema.Maestra
	WHERE LOCAL_LOCALIDAD IS NOT NULL
	GROUP BY LOCAL_PROVINCIA, LOCAL_LOCALIDAD)
END
GO

CREATE PROCEDURE STARSHIP.migrar_producto
AS
BEGIN
	INSERT INTO STARSHIP.Producto (
		prod_descripcion,
		prod_nombre,
		prod_codigo
	)
	SELECT
		PRODUCTO_LOCAL_DESCRIPCION,
		PRODUCTO_LOCAL_NOMBRE,
		PRODUCTO_LOCAL_CODIGO
	FROM GD1C2023.gd_esquema.Maestra
	WHERE PRODUCTO_LOCAL_CODIGO IS NOT NULL
	GROUP BY
	PRODUCTO_LOCAL_DESCRIPCION,
	PRODUCTO_LOCAL_NOMBRE,
	PRODUCTO_LOCAL_CODIGO
END
GO --select * from Producto


CREATE PROCEDURE STARSHIP.migrar_producto_negocio
AS
BEGIN
	INSERT INTO STARSHIP.Producto_Negocio (   
		prod_nego_prod,
		prod_nego_nego,
		prod_nego_prec_unitario
	)
	SELECT
		CASE WHEN (PRODUCTO_LOCAL_CODIGO IS NOT NULL)
			THEN
				(SELECT
					DISTINCT prod_codigo
				FROM STARSHIP.Producto
				WHERE prod_nombre = PRODUCTO_LOCAL_NOMBRE
				AND prod_descripcion = PRODUCTO_LOCAL_DESCRIPCION)
		ELSE NULL END,
   		CASE WHEN (LOCAL_NOMBRE IS NOT NULL)
			THEN
				(SELECT
					nego_codigo
				FROM STARSHIP.Negocio
				WHERE nego_nombre = LOCAL_NOMBRE
				AND LOCAL_DESCRIPCION = nego_detalle)
		ELSE NULL END,
		PRODUCTO_LOCAL_PRECIO
	FROM GD1C2023.gd_esquema.Maestra
	WHERE PRODUCTO_LOCAL_CODIGO IS NOT NULL
	GROUP BY
		PRODUCTO_LOCAL_CODIGO,
		PRODUCTO_LOCAL_NOMBRE,
		PRODUCTO_LOCAL_DESCRIPCION,
		PRODUCTO_LOCAL_PRECIO,
		LOCAL_NOMBRE,
		LOCAL_DESCRIPCION
END
GO

CREATE PROCEDURE STARSHIP.migrar_medio_pago
AS
BEGIN
	INSERT INTO STARSHIP.Medio_Pago (
		medi_tipo,
		medi_tarjeta,
		medi_clie_codigo
	)
	SELECT
		CASE WHEN (MEDIO_PAGO_TIPO IS NOT NULL)
		THEN 
			(SELECT
				tipo_medio_id
			FROM STARSHIP.Tipo_Medio_Pago
			WHERE tipo_medio_detalle = MEDIO_PAGO_TIPO)
		ELSE NULL END,
		CASE WHEN (MEDIO_PAGO_NRO_TARJETA IS NOT NULL)
		THEN 
			(SELECT
				tarj_codigo
			FROM STARSHIP.Tarjeta
			WHERE tarj_numero = MEDIO_PAGO_NRO_TARJETA)
		ELSE NULL END,
		CASE WHEN (USUARIO_DNI IS NOT NULL
		OR USUARIO_APELLIDO IS NOT NULL
		OR USUARIO_NOMBRE IS NOT NULL)
		THEN 
			(SELECT
				clie_codigo
			FROM STARSHIP.Cliente
			WHERE clie_dni = USUARIO_DNI
			AND clie_apellido = USUARIO_APELLIDO
			AND clie_nombre = USUARIO_NOMBRE)
		ELSE NULL END
	FROM GD1C2023.gd_esquema.Maestra
	WHERE MEDIO_PAGO_TIPO IS NOT NULL
	AND USUARIO_DNI IS NOT NULL
	GROUP BY 
		USUARIO_DNI,
		USUARIO_APELLIDO,
		USUARIO_NOMBRE,
		MEDIO_PAGO_TIPO,
		MEDIO_PAGO_NRO_TARJETA
END
GO --select * from Medio_Pago

CREATE PROCEDURE STARSHIP.migrar_cupon_pedido
AS
BEGIN
	INSERT INTO STARSHIP.Cupon_Pedido (
		cupon_ped_codigo,
		pedido_numero
	)
	SELECT 
		CASE WHEN (CUPON_NRO IS NOT NULL)
		THEN
			(SELECT
				cupon_id
			FROM STARSHIP.Cupon_Descuento
			WHERE cupon_numero = CUPON_NRO
				AND cupon_valor = CUPON_MONTO
				AND cupon_fecha_alta = CUPON_FECHA_ALTA
				AND cupon_fecha_venc = CUPON_FECHA_VENCIMIENTO)
		ELSE NULL END,
		PEDIDO_NRO
	FROM GD1C2023.gd_esquema.Maestra
	WHERE  CUPON_NRO IS NOT NULL
	GROUP BY 
		PEDIDO_NRO,
		CUPON_NRO,
		CUPON_MONTO,
		CUPON_FECHA_ALTA,
		CUPON_FECHA_VENCIMIENTO
END
GO --select * from Cupon_Pedido

CREATE PROCEDURE STARSHIP.migrar_producto_pedido
AS
BEGIN

	INSERT INTO STARSHIP.Producto_Pedido (
		pp_pedi_numero, -- FK
		pp_prod_codigo, -- FK
		pp_cantidad,
		pp_precio_unitario
	)
	SELECT
	CASE WHEN (PEDIDO_NRO IS NOT NULL)
	THEN 
		(SELECT
			pedi_numero
		FROM STARSHIP.Pedido
		WHERE pedi_numero = PEDIDO_NRO)
	ELSE NULL END,
	CASE WHEN (PRODUCTO_LOCAL_CODIGO IS NOT NULL)
	THEN 
		(SELECT
				prod_nego_codigo
		FROM STARSHIP.Producto_Negocio
		JOIN STARSHIP.Producto ON prod_nego_prod = prod_codigo
		JOIN STARSHIP.Negocio ON prod_nego_nego = nego_codigo
		JOIN STARSHIP.Pedido ON pedi_nego_codigo = nego_codigo
		WHERE prod_codigo = PRODUCTO_LOCAL_CODIGO
		AND prod_nombre = PRODUCTO_LOCAL_NOMBRE
		AND prod_descripcion = PRODUCTO_LOCAL_DESCRIPCION
		AND pedi_numero = PEDIDO_NRO
		)
	ELSE NULL END,
	PRODUCTO_CANTIDAD,
	PRODUCTO_LOCAL_PRECIO
FROM GD1C2023.gd_esquema.Maestra
WHERE 
	PEDIDO_NRO IS NOT NULL
	AND PRODUCTO_LOCAL_PRECIO IS NOT NULL
	AND PRODUCTO_CANTIDAD IS NOT NULL
	AND PRODUCTO_LOCAL_CODIGO IS NOT NULL
	AND PRODUCTO_LOCAL_NOMBRE IS NOT NULL
	AND PRODUCTO_LOCAL_DESCRIPCION IS NOT NULL
	AND LOCAL_NOMBRE IS NOT NULL
	AND LOCAL_DIRECCION IS NOT NULL
GROUP BY
	PEDIDO_NRO,
	--
	PRODUCTO_LOCAL_PRECIO,
	PRODUCTO_CANTIDAD,
	-- Producto
	PRODUCTO_LOCAL_CODIGO,
	PRODUCTO_LOCAL_NOMBRE,
	PRODUCTO_LOCAL_DESCRIPCION,
	-- NEGOCIO
	LOCAL_NOMBRE,
	LOCAL_DIRECCION
END
GO --select * from Producto_Pedido

CREATE PROCEDURE STARSHIP.migrar_tarjeta
AS
BEGIN
	INSERT INTO STARSHIP.Tarjeta (
		tarj_marca,
		tarj_numero
	)
	SELECT
		CASE WHEN (MEDIO_PAGO_NRO_TARJETA IS NOT NULL)
		THEN 
			(SELECT
				marca_tarjeta_cod 
			FROM STARSHIP.Marca_Tarjeta
			WHERE marca_tarjeta_detalle = MARCA_TARJETA)
		ELSE NULL END,
		MEDIO_PAGO_NRO_TARJETA
	FROM GD1C2023.gd_esquema.Maestra
	WHERE MEDIO_PAGO_NRO_TARJETA IS NOT NULL
	GROUP BY
		MEDIO_PAGO_NRO_TARJETA,
		MARCA_TARJETA
END
GO --select * from Tarjeta

CREATE PROCEDURE STARSHIP.migrar_tipo_medio_pago
AS
BEGIN
	INSERT INTO STARSHIP.Tipo_Medio_Pago (
		tipo_medio_detalle
	)
	SELECT
		MEDIO_PAGO_TIPO
	FROM GD1C2023.gd_esquema.Maestra
	WHERE MEDIO_PAGO_TIPO IS NOT NULL
	GROUP BY MEDIO_PAGO_TIPO
END
GO --select * from Tipo_Medio_Pago

CREATE PROCEDURE STARSHIP.migrar_cliente
AS 
BEGIN
	INSERT INTO STARSHIP.Cliente (
		clie_dni,
    	clie_nombre,
    	clie_apellido,
    	clie_telefono,
    	clie_nacimiento,
    	clie_fecha_registro,
    	clie_mail
	)
	SELECT
		USUARIO_DNI,
		USUARIO_NOMBRE,
		USUARIO_APELLIDO,
		USUARIO_TELEFONO,
		USUARIO_FECHA_NAC,
		USUARIO_FECHA_REGISTRO,
		USUARIO_MAIL
	FROM gd_esquema.Maestra
	WHERE USUARIO_DNI IS NOT NULL
	GROUP BY 
		USUARIO_DNI,
		USUARIO_NOMBRE,
		USUARIO_APELLIDO,
		USUARIO_TELEFONO,
		USUARIO_FECHA_NAC,
		USUARIO_FECHA_REGISTRO,
		USUARIO_MAIL
END
GO --select * from Cliente

CREATE PROCEDURE STARSHIP.migrar_cliente_direccion
AS
BEGIN
	INSERT INTO STARSHIP.Cliente_Direccion (
		clie_dir_detalle,
		clie_dir_clie_codigo,
		clie_dir_dir_codigo
	)
	SELECT
		DIRECCION_USUARIO_NOMBRE,
		CASE WHEN (USUARIO_DNI IS NOT NULL)
			THEN
				(SELECT
					clie_codigo
				FROM STARSHIP.Cliente
				WHERE clie_dni = USUARIO_DNI
				GROUP BY clie_codigo)
			ELSE NULL END,
		CASE WHEN (DIRECCION_USUARIO_DIRECCION IS NOT NULL
		OR DIRECCION_USUARIO_NOMBRE IS NOT NULL)
			THEN
				(SELECT
					dir_codigo
				FROM STARSHIP.Direccion
				JOIN STARSHIP.Localidad ON locali_codigo = dir_local_codigo 
				WHERE dir_calle_numero = DIRECCION_USUARIO_DIRECCION
				AND locali_nombre = DIRECCION_USUARIO_LOCALIDAD
				GROUP BY dir_codigo)
			ELSE NULL END
	FROM GD1C2023.gd_esquema.Maestra
	WHERE USUARIO_DNI IS NOT NULL AND DIRECCION_USUARIO_NOMBRE IS NOT NULL
	AND DIRECCION_USUARIO_DIRECCION IS NOT NULL AND DIRECCION_USUARIO_LOCALIDAD IS NOT NULL
	GROUP BY
		USUARIO_DNI,
		DIRECCION_USUARIO_DIRECCION,
		DIRECCION_USUARIO_NOMBRE,
		DIRECCION_USUARIO_LOCALIDAD
END
GO

CREATE PROCEDURE STARSHIP.migrar_pedido_estado
AS
BEGIN
	INSERT INTO STARSHIP.Pedido_Estado (
		pedi_estado_detalle
	)
	SELECT
		PEDIDO_ESTADO
	FROM GD1C2023.gd_esquema.Maestra
	WHERE PEDIDO_ESTADO IS NOT NULL
	GROUP BY PEDIDO_ESTADO
END
GO



CREATE PROCEDURE STARSHIP.migrar_pedido
AS
BEGIN
	INSERT INTO STARSHIP.Pedido (
		pedi_numero,
    	pedi_fecha_hora_pedi,
    	pedi_total_productos,
    	pedi_calificacion,
    	pedi_tarifa_serv,
    	pedi_observaciones,
    	pedi_tiempo_estimado,
    	pedi_fecha_hora_entr,
    	pedi_total_cupones,
    	pedi_total_servicio,
		pedi_usuario, -- FK
    	pedi_envio, -- FK
    	pedi_medio_pago, -- FK
   		pedi_estado, -- FK
    	pedi_nego_codigo -- FK
	)

	SELECT
		PEDIDO_NRO,
		PEDIDO_FECHA,
		PEDIDO_TOTAL_PRODUCTOS,
		PEDIDO_CALIFICACION,
		PEDIDO_TARIFA_SERVICIO,
		PEDIDO_OBSERV,
		PEDIDO_TIEMPO_ESTIMADO_ENTREGA,
		PEDIDO_FECHA_ENTREGA,
		PEDIDO_TOTAL_CUPONES,
		PEDIDO_TOTAL_SERVICIO,
		CASE WHEN (USUARIO_DNI IS NOT NULL) --pedi_usuario
		THEN
			(SELECT clie_codigo
			FROM STARSHIP.Cliente
			WHERE clie_dni = USUARIO_DNI AND clie_nombre = USUARIO_NOMBRE)
		ELSE NULL END,
		CASE WHEN (PEDIDO_PROPINA IS NOT NULL --pedi_envio
		OR PEDIDO_PRECIO_ENVIO IS NOT NULL)
		THEN
			(SELECT
				envi_numero
			FROM STARSHIP.Envio
			JOIN STARSHIP.Direccion ON dir_codigo = envi_dir_codigo
			JOIN STARSHIP.Cliente_Direccion ON clie_dir_dir_codigo = dir_codigo
			JOIN STARSHIP.Cliente ON clie_codigo = clie_dir_clie_codigo
			WHERE envi_precio = PEDIDO_PRECIO_ENVIO
			AND envi_propina = PEDIDO_PROPINA
			AND clie_dni = USUARIO_DNI)
		ELSE NULL END,
		CASE WHEN (MEDIO_PAGO_TIPO IS NOT NULL)
		THEN
			(SELECT
				medi_codigo
			FROM STARSHIP.Medio_Pago
			JOIN STARSHIP.Tipo_Medio_Pago ON tipo_medio_id = medi_tipo
			JOIN STARSHIP.Tarjeta ON medi_tarjeta = tarj_codigo
			JOIN STARSHIP.Marca_Tarjeta ON tarj_marca = marca_tarjeta_cod
			WHERE tipo_medio_detalle = MEDIO_PAGO_TIPO
			AND MARCA_TARJETA = marca_tarjeta_detalle
			AND MEDIO_PAGO_NRO_TARJETA = tarj_numero)
		ELSE NULL END, 
		CASE WHEN (PEDIDO_ESTADO IS NOT NULL) --pedi_estado
		THEN
			(SELECT
				pedi_estado_codigo
			FROM STARSHIP.Pedido_Estado
			WHERE pedi_estado_detalle = PEDIDO_ESTADO)
		ELSE NULL END, 
		CASE WHEN (LOCAL_NOMBRE IS NOT NULL)  --pedi_nego_codigo
		THEN
			(SELECT
				nego_codigo
			FROM STARSHIP.Negocio
			WHERE nego_nombre = LOCAL_NOMBRE)
		ELSE NULL END
	FROM GD1C2023.gd_esquema.Maestra
	WHERE PEDIDO_NRO IS NOT NULL
	GROUP BY
		PEDIDO_NRO,
		PEDIDO_FECHA,
		PEDIDO_TOTAL_PRODUCTOS,
		PEDIDO_CALIFICACION,
		PEDIDO_TARIFA_SERVICIO,
		PEDIDO_OBSERV,
		PEDIDO_TIEMPO_ESTIMADO_ENTREGA,
		PEDIDO_FECHA_ENTREGA,
		PEDIDO_TOTAL_CUPONES,
		PEDIDO_TOTAL_SERVICIO,
		--
		USUARIO_DNI,
		USUARIO_NOMBRE,
		--
		PEDIDO_PRECIO_ENVIO,
		PEDIDO_PROPINA,
		MARCA_TARJETA,
		MEDIO_PAGO_NRO_TARJETA,
		--
		PEDIDO_ESTADO,
		--
		LOCAL_NOMBRE,
		---
		MEDIO_PAGO_TIPO
END
GO

CREATE PROCEDURE STARSHIP.migrar_mensajeria_estado
AS
BEGIN
	INSERT INTO STARSHIP.Mens_Estado (mens_esta_detalle)
	SELECT
		ENVIO_MENSAJERIA_ESTADO 
	FROM GD1C2023.gd_esquema.Maestra
	WHERE ENVIO_MENSAJERIA_ESTADO IS NOT NULL
	GROUP BY ENVIO_MENSAJERIA_ESTADO
END
GO --select * from Mens_Estado

CREATE PROCEDURE STARSHIP.insertar_direccion_tipo
AS
BEGIN
	INSERT INTO STARSHIP.Direccion_Tipo (dir_tipo_detalle)
	VALUES
		('CLIENTE'),
		('OPERADOR'),
		('REPARTIDOR'),
		('NEGOCIO');
END
GO


CREATE PROCEDURE STARSHIP.migrar_direccion
AS
BEGIN
	INSERT INTO STARSHIP.Direccion (
		dir_calle_numero,
		dir_local_codigo,
		dir_direccion_tipo
	)
	(SELECT
		REPARTIDOR_DIRECION,
		NULL,
		(SELECT
			dir_tipo_codigo
		FROM STARSHIP.Direccion_Tipo
		WHERE dir_tipo_detalle = 'REPARTIDOR')
	FROM GD1C2023.gd_esquema.Maestra
	WHERE REPARTIDOR_DIRECION IS NOT NULL
	GROUP BY REPARTIDOR_DIRECION)
	UNION
	(SELECT
		DIRECCION_USUARIO_DIRECCION,
		CASE WHEN (DIRECCION_USUARIO_LOCALIDAD IS NOT NULL)
		THEN 
			(SELECT
				locali_codigo
			FROM STARSHIP.Localidad
			JOIN STARSHIP.Provincia ON prov_codigo = locali_prov
			WHERE DIRECCION_USUARIO_LOCALIDAD = locali_nombre
			AND prov_nombre = DIRECCION_USUARIO_PROVINCIA)
		ELSE NULL END,
		(SELECT
			dir_tipo_codigo
		FROM STARSHIP.Direccion_Tipo
		WHERE dir_tipo_detalle = 'CLIENTE')
	FROM GD1C2023.gd_esquema.Maestra
	WHERE DIRECCION_USUARIO_DIRECCION IS NOT NULL
	GROUP BY DIRECCION_USUARIO_DIRECCION, DIRECCION_USUARIO_LOCALIDAD,
	DIRECCION_USUARIO_PROVINCIA)
	UNION
	(SELECT
		LOCAL_DIRECCION,
		CASE WHEN (LOCAL_LOCALIDAD IS NOT NULL)
		THEN 
			(SELECT
				locali_codigo
			FROM STARSHIP.Localidad
			JOIN STARSHIP.PROVINCIA ON prov_codigo = locali_prov
			WHERE LOCAL_LOCALIDAD = locali_nombre
			AND prov_nombre = LOCAL_PROVINCIA)
		ELSE NULL END,
		(SELECT
			dir_tipo_codigo
		FROM STARSHIP.Direccion_Tipo
		WHERE dir_tipo_detalle = 'NEGOCIO')
	FROM GD1C2023.gd_esquema.Maestra
	WHERE LOCAL_DIRECCION IS NOT NULL
	GROUP BY LOCAL_LOCALIDAD, LOCAL_DIRECCION, LOCAL_PROVINCIA)
	UNION
	(SELECT
		OPERADOR_RECLAMO_DIRECCION,
		NULL,
		(SELECT
			dir_tipo_codigo
		FROM STARSHIP.Direccion_Tipo
		WHERE dir_tipo_detalle = 'OPERADOR')
	FROM GD1C2023.gd_esquema.Maestra
	WHERE OPERADOR_RECLAMO_DIRECCION IS NOT NULL
	GROUP BY OPERADOR_RECLAMO_DIRECCION)
END
GO

CREATE PROCEDURE STARSHIP.migrar_negocio
AS
BEGIN
	INSERT INTO STARSHIP.NEGOCIO (
 		nego_nombre,
    	nego_detalle,
		nego_direccion,
		nego_categ
	)
	SELECT
		LOCAL_NOMBRE,
		LOCAL_DESCRIPCION,
		CASE WHEN (LOCAL_DIRECCION IS NOT NULL) -- LOCAL_DIRECCION
		THEN
			(SELECT
				dir_codigo 
			FROM STARSHIP.Direccion
			JOIN STARSHIP.Localidad ON locali_codigo = dir_local_codigo
			JOIN STARSHIP.Provincia ON prov_codigo = locali_prov
			WHERE dir_calle_numero = LOCAL_DIRECCION
			AND locali_nombre = LOCAL_LOCALIDAD
			AND prov_nombre = LOCAL_PROVINCIA)
		ELSE NULL END,
		CASE 
		WHEN (LOCAL_TIPO IS NOT NULL AND LOCAL_TIPO LIKE '%Restaurante')
		THEN
			(SELECT categ_nego_id
			FROM STARSHIP.Categoria_Negocio
			JOIN Tipo_Negocio ON tipo_nego_id = categ_nego_tipo
			WHERE categ_nego_detalle = 'OTROS'
			AND tipo_nego_detalle LIKE '%Restaurante')
		WHEN (LOCAL_TIPO IS NOT NULL AND LOCAL_TIPO LIKE '%Mercado')
		THEN
			(SELECT categ_nego_id
			FROM STARSHIP.Categoria_Negocio
			JOIN Tipo_Negocio ON tipo_nego_id = categ_nego_tipo
			WHERE categ_nego_detalle = 'OTROS'
			AND tipo_nego_detalle LIKE '%Mercado')
		ELSE NULL END
		/*
		(SELECT
			categ_nego_id
		FROM Categoria_Negocio
		WHERE categ_nego_detalle = 'Migrada')
		*/
	FROM GD1C2023.gd_esquema.Maestra
	WHERE LOCAL_NOMBRE IS NOT NULL
		OR LOCAL_DESCRIPCION IS NOT NULL
		OR LOCAL_DIRECCION IS NOT NULL
	GROUP BY
		LOCAL_LOCALIDAD,
		LOCAL_PROVINCIA,
		--
		LOCAL_TIPO,
		--
		LOCAL_NOMBRE,
		LOCAL_DESCRIPCION,
		LOCAL_DIRECCION
END
GO --select * from Negocio

CREATE PROCEDURE STARSHIP.migrar_horario
AS
BEGIN
	INSERT INTO STARSHIP.Horario (
		hora_hora_apertura,
    	hora_hora_cierre
	)
	SELECT
		HORARIO_LOCAL_HORA_APERTURA,
		HORARIO_LOCAL_HORA_CIERRE
	FROM GD1C2023.gd_esquema.Maestra
	WHERE HORARIO_LOCAL_HORA_APERTURA IS NOT NULL
		OR HORARIO_LOCAL_HORA_CIERRE IS NOT NULL
	GROUP BY
		HORARIO_LOCAL_HORA_APERTURA,
    	HORARIO_LOCAL_HORA_CIERRE
	ORDER BY 1
END
GO --select * from Horario

CREATE PROCEDURE STARSHIP.insertar_dia
AS
BEGIN
	INSERT INTO STARSHIP.Dia (
		dia_codigo,
		dia_detalle
	)

	VALUES
  		(1, 'Domingo'),
  		(2, 'Lunes'),
  		(3, 'Martes'),
  		(4, 'Miercoles'),
  		(5, 'Jueves'),
  		(6, 'Viernes'),
  		(7, 'Sabado');
END
GO --select * from Dia

CREATE PROCEDURE STARSHIP.migrar_negocio_dia
AS
BEGIN
	INSERT INTO STARSHIP.Negocio_Dia (
		nego_dia_nego,
		nego_dia_dia,
		nego_dia_horario
	)
	SELECT
		CASE WHEN (LOCAL_NOMBRE IS NOT NULL
		OR LOCAL_DESCRIPCION IS NOT NULL)
		THEN
			(SELECT
				nego_codigo 
			FROM STARSHIP.Negocio
			WHERE nego_nombre = LOCAL_NOMBRE
			AND nego_detalle = LOCAL_DESCRIPCION)
		ELSE NULL END,
		CASE WHEN (HORARIO_LOCAL_DIA IS NOT NULL)
		THEN
			(SELECT
				dia_codigo
			FROM STARSHIP.Dia
			WHERE dia_detalle = HORARIO_LOCAL_DIA)
		ELSE NULL END,
		CASE WHEN (HORARIO_LOCAL_HORA_APERTURA IS NOT NULL
		OR HORARIO_LOCAL_HORA_CIERRE IS NOT NULL)
		THEN
			(SELECT
				hora_codigo
			FROM STARSHIP.Horario
			WHERE hora_hora_apertura = HORARIO_LOCAL_HORA_APERTURA
			AND hora_hora_cierre = HORARIO_LOCAL_HORA_CIERRE)
		ELSE NULL END
	FROM GD1C2023.gd_esquema.Maestra
	WHERE LOCAL_NOMBRE IS NOT NULL
	OR HORARIO_LOCAL_DIA IS NOT NULL
	OR HORARIO_LOCAL_HORA_APERTURA IS NOT NULL
	GROUP BY 
		HORARIO_LOCAL_DIA,
		--
		HORARIO_LOCAL_HORA_APERTURA,
		HORARIO_LOCAL_HORA_CIERRE,
		--
		LOCAL_NOMBRE,
		LOCAL_DESCRIPCION
END
GO --select * from Negocio_Dia

CREATE PROCEDURE STARSHIP.migrar_reclamo
AS
BEGIN
	INSERT INTO STARSHIP.Reclamo (
		recl_numero,
		recl_detalle,
		recl_fecha,
		recl_calificacion,
		recl_fecha_sol,
		recl_pedido, --<====== OK
		recl_tipo, --<======== OK
		recl_operador, --<==== OK
		recl_estado, --<====== OK
		recl_usuario, --<===== OK
		recl_solucion --<===== OK
	)
	SELECT
		RECLAMO_NRO,
		RECLAMO_DESCRIPCION,
		RECLAMO_FECHA,
		RECLAMO_CALIFICACION,
		RECLAMO_FECHA_SOLUCION,
		CASE WHEN (PEDIDO_NRO IS NOT NULL) --recl_pedido
		THEN 
			(SELECT pedi_numero
			FROM STARSHIP.Pedido
			WHERE pedi_numero = PEDIDO_NRO)
		ELSE NULL END,
		---------------------------
		CASE WHEN (RECLAMO_TIPO IS NOT NULL) --recl_tipo
		THEN 
			(SELECT
				tipo_rec_id
			FROM STARSHIP.Tipo_Reclamo
			WHERE tipo_rec_detalle = RECLAMO_TIPO)
		ELSE NULL END,
		---------------------------
		CASE WHEN (OPERADOR_RECLAMO_DNI IS NOT NULL OR
		OPERADOR_RECLAMO_APELLIDO IS NOT NULL
		OR OPERADOR_RECLAMO_NOMBRE IS NOT NULL) --recl_operador
		THEN 
			(SELECT
				oper_codigo
			FROM STARSHIP.Operador
			WHERE oper_dni = OPERADOR_RECLAMO_DNI
			AND oper_apellido = OPERADOR_RECLAMO_APELLIDO
			AND oper_nombre = OPERADOR_RECLAMO_NOMBRE)
		ELSE NULL END,
		---------------------------
		CASE WHEN (RECLAMO_ESTADO IS NOT NULL) --recl_estado
		THEN 
			(SELECT
				recl_estado_id
			FROM STARSHIP.Recl_Estado
			WHERE recl_estado_detalle = RECLAMO_ESTADO)
		ELSE NULL END,
		---------------------------
		CASE WHEN (USUARIO_DNI IS NOT NULL
		OR USUARIO_APELLIDO IS NOT NULL
		OR USUARIO_NOMBRE IS NOT NULL) --recl_usuario
		THEN 
			(SELECT
				clie_codigo
			FROM STARSHIP.Cliente
			WHERE clie_dni = USUARIO_DNI
			AND clie_apellido = USUARIO_APELLIDO
			AND clie_nombre = USUARIO_NOMBRE)
		ELSE NULL END,
		---------------------------
		CASE WHEN (RECLAMO_SOLUCION IS NOT NULL) --recl_solucion
		THEN 
			(SELECT
				recl_solucion_id
			FROM STARSHIP.Recl_Solucion
			WHERE recl_solucion_detalle = RECLAMO_SOLUCION)
		ELSE NULL END
	FROM GD1C2023.gd_esquema.Maestra
	WHERE RECLAMO_NRO IS NOT NULL
	GROUP BY
		RECLAMO_NRO,
		RECLAMO_DESCRIPCION,
		RECLAMO_FECHA,
		RECLAMO_CALIFICACION,
		RECLAMO_FECHA_SOLUCION,
		--
		RECLAMO_TIPO,
		--
		OPERADOR_RECLAMO_DNI,
		OPERADOR_RECLAMO_NOMBRE,
		OPERADOR_RECLAMO_APELLIDO,
		--
		RECLAMO_ESTADO,
		--
		USUARIO_DNI,
		USUARIO_APELLIDO,
		USUARIO_NOMBRE,
		--
		RECLAMO_SOLUCION,
		--
		PEDIDO_NRO
END
GO

CREATE PROCEDURE STARSHIP.migrar_tipo_reclamo
AS
BEGIN
	INSERT INTO STARSHIP.TIPO_RECLAMO (
		tipo_rec_detalle
	)
	SELECT
		RECLAMO_TIPO
	FROM GD1C2023.gd_esquema.Maestra
	WHERE RECLAMO_TIPO IS NOT NULL
	GROUP BY RECLAMO_TIPO
END
GO --select * from Tipo_Reclamo

CREATE PROCEDURE STARSHIP.migrar_reclamo_solucion
AS
BEGIN
	INSERT INTO STARSHIP.RECL_SOLUCION (
		recl_solucion_detalle
	)
	SELECT
		RECLAMO_SOLUCION
	FROM GD1C2023.gd_esquema.Maestra
	WHERE RECLAMO_SOLUCION IS NOT NULL
	GROUP BY RECLAMO_SOLUCION
END
GO --select * from Recl_Solucion

CREATE PROCEDURE STARSHIP.migrar_reclamo_estado
AS
BEGIN
	INSERT INTO STARSHIP.RECL_ESTADO (
		recl_estado_detalle
	)

	SELECT
		RECLAMO_ESTADO
	FROM GD1C2023.gd_esquema.Maestra
	WHERE RECLAMO_ESTADO IS NOT NULL
	GROUP BY RECLAMO_ESTADO

	INSERT INTO STARSHIP.RECL_ESTADO (
		recl_estado_detalle
	)
	VALUES
		('Iniciado'),
		('En Revision'),
		('Solucionado')
END
GO --select * from Recl_Estado



CREATE PROCEDURE STARSHIP.migrar_operador
AS
BEGIN
	INSERT INTO STARSHIP.OPERADOR (
		oper_dni,
		oper_nombre,
		oper_telefono,
		oper_apellido,
		oper_mail,
		oper_nacimiento,
		oper_domicilio
	)
	SELECT
		OPERADOR_RECLAMO_DNI,
		OPERADOR_RECLAMO_NOMBRE,
		OPERADOR_RECLAMO_TELEFONO,
		OPERADOR_RECLAMO_APELLIDO,
		OPERADOR_RECLAMO_MAIL,
		OPERADOR_RECLAMO_FECHA_NAC,
		CASE WHEN (OPERADOR_RECLAMO_DNI IS NOT NULL) --oper_domicilio
		THEN
			(SELECT
				dir_codigo
			FROM STARSHIP.Direccion
			JOIN STARSHIP.Direccion_Tipo ON dir_tipo_codigo = dir_direccion_tipo AND dir_tipo_detalle = 'OPERADOR'
			WHERE dir_calle_numero = OPERADOR_RECLAMO_DIRECCION
			AND dir_local_codigo IS NULL)
		ELSE NULL END
	FROM GD1C2023.gd_esquema.Maestra
	WHERE OPERADOR_RECLAMO_DNI IS NOT NULL
	GROUP BY
		OPERADOR_RECLAMO_DNI,
		OPERADOR_RECLAMO_NOMBRE,
		OPERADOR_RECLAMO_TELEFONO,
		OPERADOR_RECLAMO_APELLIDO,
		OPERADOR_RECLAMO_MAIL,
		OPERADOR_RECLAMO_FECHA_NAC,
		--
		OPERADOR_RECLAMO_DIRECCION
END
GO --select * from Operador

CREATE PROCEDURE STARSHIP.migrar_repartidor 
AS
BEGIN
	INSERT INTO STARSHIP.Repartidor (
		repa_dni,
		repa_nombre,
		repa_apellido,
		repa_telefono,
		repa_mail,
		repa_nacimiento,
		repa_tipo_mov
	)
	SELECT
		REPARTIDOR_DNI,
		REPARTIDOR_NOMBRE,
		REPARTIDOR_APELLIDO,
		REPARTIDOR_TELEFONO,
		REPARTIDOR_EMAIL,
		REPARTIDOR_FECHA_NAC,
		CASE WHEN (REPARTIDOR_TIPO_MOVILIDAD IS NOT NULL) -- rapa_tipo_mov
		THEN
			(SELECT
				tipo_movi_codigo 
			FROM STARSHIP.Tipo_Movilidad
			WHERE tipo_movi_detalle = REPARTIDOR_TIPO_MOVILIDAD)
		ELSE NULL END
	FROM GD1C2023.gd_esquema.Maestra
	WHERE REPARTIDOR_DNI IS NOT NULL
	GROUP BY
		REPARTIDOR_TIPO_MOVILIDAD,
		--
		REPARTIDOR_DNI,
		REPARTIDOR_NOMBRE,
		REPARTIDOR_APELLIDO,
		REPARTIDOR_TELEFONO,
		REPARTIDOR_EMAIL,
		REPARTIDOR_FECHA_NAC
END
GO --select * from Repartidor

CREATE PROCEDURE STARSHIP.migrar_repartidor_localidad
AS 
BEGIN
	INSERT INTO STARSHIP.Repartidor_Localidad (
		repa_loc_loc, 
		repa_loc_repa
	)
	SELECT
		CASE WHEN (LOCAL_LOCALIDAD IS NOT NULL)
		THEN
			(SELECT
				locali_codigo
			FROM STARSHIP.Direccion
			JOIN STARSHIP.NEGOCIO ON nego_direccion = dir_codigo
			JOIN STARSHIP.LOCALIDAD ON dir_local_codigo = locali_codigo
			JOIN STARSHIP.Provincia ON prov_codigo = locali_prov
			WHERE locali_nombre = LOCAL_LOCALIDAD AND prov_nombre = LOCAL_PROVINCIA
			GROUP BY locali_codigo)
		ELSE NULL END, 
		CASE WHEN (REPARTIDOR_DNI IS NOT NULL)
		THEN 
			(SELECT
				repa_codigo
			FROM STARSHIP.Repartidor
			WHERE repa_dni = REPARTIDOR_DNI
			AND repa_apellido = REPARTIDOR_APELLIDO
			AND repa_nombre = REPARTIDOR_NOMBRE)
		ELSE NULL END
	FROM GD1C2023.gd_esquema.Maestra
	WHERE REPARTIDOR_DNI IS NOT NULL
	AND LOCAL_LOCALIDAD IS NOT NULL
	GROUP BY 
		REPARTIDOR_DNI,
		REPARTIDOR_APELLIDO,
		REPARTIDOR_NOMBRE,
		LOCAL_LOCALIDAD,
		LOCAL_PROVINCIA
END
GO

CREATE PROCEDURE STARSHIP.migrar_repartidor_direccion
AS
BEGIN
	INSERT INTO STARSHIP.Repartidor_Direccion (
		repa_dir_repa_codigo,
		repa_dir_dir_codigo
	)
	SELECT
		CASE WHEN (REPARTIDOR_DNI IS NOT NULL
		OR REPARTIDOR_NOMBRE IS NOT NULL
		OR REPARTIDOR_APELLIDO IS NOT NULL)
		THEN
			(SELECT
				repa_codigo
			FROM STARSHIP.Repartidor
			WHERE REPARTIDOR_DNI = repa_dni
			AND REPARTIDOR_NOMBRE = repa_nombre
			AND REPARTIDOR_APELLIDO = repa_apellido)
		ELSE NULL END,
		CASE WHEN (REPARTIDOR_DIRECION IS NOT NULL)
		THEN
			(SELECT
				dir_codigo
			FROM STARSHIP.Direccion
			JOIN STARSHIP.Direccion_Tipo ON dir_tipo_codigo = dir_direccion_tipo
			AND dir_tipo_detalle = 'REPARTIDOR'
			WHERE dir_codigo IS NOT NULL
			AND dir_calle_numero = REPARTIDOR_DIRECION)
		ELSE NULL END
	FROM GD1C2023.gd_esquema.Maestra
	WHERE REPARTIDOR_DNI IS NOT NULL AND REPARTIDOR_NOMBRE IS NOT NULL
	AND REPARTIDOR_APELLIDO IS NOT NULL AND REPARTIDOR_DIRECION IS NOT NULL
	GROUP BY
		REPARTIDOR_DNI,
		REPARTIDOR_NOMBRE,
		REPARTIDOR_APELLIDO,
		--
		REPARTIDOR_DIRECION
END
GO --select * from Repartidor_Direccion


CREATE PROCEDURE STARSHIP.migrar_cupon_tipo
AS
BEGIN
	INSERT INTO STARSHIP.Cupon_Tipo (
		tipo_cupon_detalle
	)
	SELECT
		CUPON_TIPO
	FROM GD1C2023.gd_esquema.Maestra
	WHERE CUPON_TIPO IS NOT NULL
	GROUP BY CUPON_TIPO
END
GO

CREATE PROCEDURE STARSHIP.migrar_cupon_descuento
AS
BEGIN
	INSERT INTO STARSHIP.Cupon_Descuento (
		cupon_tipo,
		cupon_clie_codigo,
		cupon_numero,
		cupon_valor,
		cupon_fecha_alta,
		cupon_fecha_venc
	)
	SELECT --20279
		CASE WHEN (CUPON_NRO IS NOT NULL) --cupon_tipo
		THEN
			(SELECT
				tipo_cupon_codigo
			FROM STARSHIP.Cupon_Tipo
			WHERE tipo_cupon_detalle = CUPON_TIPO)
		ELSE NULL END,
		CASE WHEN (USUARIO_DNI IS NOT NULL OR USUARIO_APELLIDO IS NOT NULL OR USUARIO_NOMBRE IS NOT NULL) --cupon_clie_codigo
		THEN
			(SELECT
				clie_codigo
			FROM STARSHIP.Cliente
			WHERE clie_dni = USUARIO_DNI AND USUARIO_APELLIDO = clie_apellido AND USUARIO_NOMBRE = clie_nombre)
		ELSE NULL END,
		CUPON_NRO,
		CUPON_MONTO,
		CUPON_FECHA_ALTA,
		CUPON_FECHA_VENCIMIENTO
	FROM GD1C2023.gd_esquema.Maestra
	WHERE CUPON_NRO IS NOT NULL
	GROUP BY
		USUARIO_DNI,
		USUARIO_NOMBRE,
		USUARIO_APELLIDO,
		CUPON_NRO,
		CUPON_MONTO,
		CUPON_FECHA_ALTA,
		CUPON_FECHA_VENCIMIENTO,
		CUPON_TIPO

--------------------
	INSERT INTO STARSHIP.Cupon_Descuento (
		cupon_tipo,
		cupon_clie_codigo,
		cupon_numero,
		cupon_valor,
		cupon_fecha_alta,
		cupon_fecha_venc
	)
	SELECT
		CASE WHEN (CUPON_RECLAMO_NRO IS NOT NULL)
		THEN 
			(SELECT
				tipo_cupon_codigo
			FROM STARSHIP.Cupon_Tipo
			WHERE tipo_cupon_detalle = CUPON_RECLAMO_TIPO)
		ELSE NULL END,
		CASE WHEN (USUARIO_DNI IS NOT NULL 
			AND USUARIO_APELLIDO IS NOT NULL 
			AND USUARIO_NOMBRE IS NOT NULL)
		THEN 
			(SELECT
				clie_codigo
			FROM STARSHIP.Cliente
			WHERE clie_dni = USUARIO_DNI 
			AND USUARIO_APELLIDO = clie_apellido 
			AND USUARIO_NOMBRE = clie_nombre)
		ELSE NULL END,
		CUPON_RECLAMO_NRO,
		CUPON_RECLAMO_MONTO,
		CUPON_RECLAMO_FECHA_ALTA,
		CUPON_RECLAMO_FECHA_VENCIMIENTO
	FROM GD1C2023.gd_esquema.Maestra
	WHERE CUPON_RECLAMO_NRO IS NOT NULL
		AND CUPON_RECLAMO_NRO NOT IN 
			(select cupon_numero from Cupon_Descuento group by cupon_numero)
	GROUP BY 
		USUARIO_DNI,
		USUARIO_NOMBRE,
		USUARIO_APELLIDO,
		CUPON_RECLAMO_NRO,
		CUPON_RECLAMO_MONTO,
		CUPON_RECLAMO_FECHA_ALTA,
		CUPON_RECLAMO_FECHA_VENCIMIENTO,
		CUPON_RECLAMO_TIPO
END
GO --select * from Cupon_Descuento

CREATE PROCEDURE STARSHIP.migrar_envio_mensajeria
AS
BEGIN
	INSERT INTO STARSHIP.Envio_Mensajeria (
	mens_numero,
	mens_dir_origen,
    mens_dir_destino,
    mens_fecha_hora_pedi,
    mens_distancia,
    mens_detalle,
    mens_precio_total,
    mens_precio_seguro,
    mens_precio_envio,
    mens_propina,
    mens_fecha_hora_entr,
    mens_tiempo_estimado,
    mens_calificacion,
	mens_provincia,
	mens_repa_codigo,
    mens_localidad, 
    mens_estado_codigo,
    mens_medio_pago
	)
	SELECT
		ENVIO_MENSAJERIA_NRO,
		ENVIO_MENSAJERIA_DIR_ORIG,
		ENVIO_MENSAJERIA_DIR_DEST,
		ENVIO_MENSAJERIA_FECHA,
		ENVIO_MENSAJERIA_KM,
		ENVIO_MENSAJERIA_OBSERV,
		ENVIO_MENSAJERIA_TOTAL,
		ENVIO_MENSAJERIA_PRECIO_SEGURO,
		ENVIO_MENSAJERIA_PRECIO_ENVIO,
		ENVIO_MENSAJERIA_PROPINA,
		ENVIO_MENSAJERIA_FECHA_ENTREGA,
		ENVIO_MENSAJERIA_TIEMPO_ESTIMADO,
		ENVIO_MENSAJERIA_CALIFICACION,
		CASE WHEN (ENVIO_MENSAJERIA_PROVINCIA IS NOT NULL) --FK mens_provincia
	THEN
		(SELECT prov_codigo
		FROM STARSHIP.Provincia
		WHERE prov_nombre = ENVIO_MENSAJERIA_PROVINCIA)
	ELSE NULL END,
	---------------------------
    CASE WHEN (REPARTIDOR_DNI IS NOT NULL OR REPARTIDOR_NOMBRE IS NOT NULL OR REPARTIDOR_APELLIDO IS NOT NULL) --FK mens_repa_codigo
    THEN
		(SELECT repa_codigo
		FROM STARSHIP.Repartidor
		WHERE repa_dni = REPARTIDOR_DNI 
			AND repa_nombre = REPARTIDOR_NOMBRE
			AND repa_apellido = REPARTIDOR_APELLIDO)
	ELSE NULL END,
	------------------------------
	CASE WHEN (ENVIO_MENSAJERIA_LOCALIDAD IS NOT NULL) --FK mens_localidad
    THEN
		(SELECT
			locali_codigo 
		FROM STARSHIP.Localidad
		JOIN STARSHIP.Provincia ON prov_codigo = locali_prov
		WHERE locali_nombre = ENVIO_MENSAJERIA_LOCALIDAD
		AND prov_nombre = ENVIO_MENSAJERIA_PROVINCIA)
	ELSE NULL END, 
	-------------------------------
	CASE WHEN (ENVIO_MENSAJERIA_ESTADO IS NOT NULL) -- FK mens_estado_codigo
	THEN
		(SELECT
			mens_esta_codigo
		FROM STARSHIP.Mens_Estado
		WHERE mens_esta_detalle = ENVIO_MENSAJERIA_ESTADO)
	ELSE NULL END, 
	---------------------------------
    CASE WHEN (MEDIO_PAGO_TIPO IS NOT NULL AND MEDIO_PAGO_NRO_TARJETA IS NOT NULL) -- FK mens_medio_pago
	THEN
		(SELECT
			medi_codigo
		FROM STARSHIP.Medio_Pago
		LEFT JOIN STARSHIP.Tarjeta ON tarj_codigo = medi_tarjeta
		LEFT JOIN STARSHIP.Tipo_Medio_Pago ON tipo_medio_id = medi_tipo
		WHERE tipo_medio_detalle = MEDIO_PAGO_TIPO 
			AND tarj_numero = MEDIO_PAGO_NRO_TARJETA)
	ELSE NULL END
	FROM GD1C2023.gd_esquema.Maestra
	WHERE ENVIO_MENSAJERIA_NRO IS NOT NULL
	GROUP BY
		REPARTIDOR_DNI,
		REPARTIDOR_NOMBRE,
		REPARTIDOR_APELLIDO,
		--
		MEDIO_PAGO_TIPO,
		MEDIO_PAGO_NRO_TARJETA,
		--
		ENVIO_MENSAJERIA_ESTADO,
		--
		ENVIO_MENSAJERIA_LOCALIDAD,
		--
		ENVIO_MENSAJERIA_PROVINCIA,
		--
		ENVIO_MENSAJERIA_NRO,
		ENVIO_MENSAJERIA_DIR_ORIG,
		ENVIO_MENSAJERIA_DIR_DEST,
		ENVIO_MENSAJERIA_FECHA,
		ENVIO_MENSAJERIA_KM,
		ENVIO_MENSAJERIA_OBSERV,
		ENVIO_MENSAJERIA_TOTAL,
		ENVIO_MENSAJERIA_PRECIO_SEGURO,
		ENVIO_MENSAJERIA_PRECIO_ENVIO,
		ENVIO_MENSAJERIA_PROPINA,
		ENVIO_MENSAJERIA_FECHA_ENTREGA,
		ENVIO_MENSAJERIA_TIEMPO_ESTIMADO,
		ENVIO_MENSAJERIA_CALIFICACION
END
GO --select * from Envio_Mensajeria

CREATE PROCEDURE STARSHIP.migrar_paquete
AS
BEGIN
	INSERT INTO STARSHIP.PAQUETE (
		mens_valor_asegurado,
		paqu_tipo,
		paqu_clie,
		paqu_mens_numero
    )
	SELECT
		ENVIO_MENSAJERIA_VALOR_ASEGURADO,
		CASE WHEN (PAQUETE_TIPO IS NOT NULL) -- paqu_tipo
		THEN
			(SELECT tipo_paqu_codigo 
			FROM STARSHIP.Tipo_Paquete
			WHERE tipo_paqu_detalle = PAQUETE_TIPO)
		ELSE NULL END,
		CASE WHEN (USUARIO_DNI IS NOT NULL
		OR USUARIO_APELLIDO IS NOT NULL
		OR USUARIO_NOMBRE IS NOT NULL) -- paqu_clie
		THEN
			(SELECT clie_codigo 
			FROM STARSHIP.Cliente
			WHERE clie_dni = USUARIO_DNI
				AND clie_apellido = USUARIO_APELLIDO
				AND clie_nombre = USUARIO_NOMBRE)
		ELSE NULL END,
		CASE WHEN (ENVIO_MENSAJERIA_NRO IS NOT NULL) -- paqu_mens_numero
		THEN
			(SELECT mens_numero
			FROM STARSHIP.Envio_Mensajeria
			WHERE mens_numero = ENVIO_MENSAJERIA_NRO)
		ELSE NULL END
	FROM GD1C2023.gd_esquema.Maestra
	WHERE ENVIO_MENSAJERIA_NRO IS NOT NULL
		OR PAQUETE_TIPO IS NOT NULL
	GROUP BY
		PAQUETE_TIPO,
		--
		USUARIO_DNI,
		USUARIO_APELLIDO,
		USUARIO_NOMBRE,
		--
		ENVIO_MENSAJERIA_NRO,
		--
		ENVIO_MENSAJERIA_VALOR_ASEGURADO
END
GO --select * from Paquete


CREATE PROCEDURE STARSHIP.migrar_envio
AS
BEGIN
	INSERT INTO STARSHIP.Envio (
		envi_precio,
		envi_propina,
		envi_dir_codigo,
		envi_repartidor
	)
	SELECT
		PEDIDO_PRECIO_ENVIO,
		PEDIDO_PROPINA,
		CASE WHEN (DIRECCION_USUARIO_DIRECCION IS NOT NULL --envi_dir_codigo
		AND USUARIO_DNI IS NOT NULL
		AND USUARIO_NOMBRE IS NOT NULL
		AND USUARIO_APELLIDO IS NOT NULL) 
		THEN
			(SELECT
				dir_codigo
			FROM STARSHIP.Cliente_Direccion
			JOIN STARSHIP.Direccion ON dir_codigo = clie_dir_dir_codigo
			JOIN STARSHIP.Cliente ON clie_dir_clie_codigo = clie_codigo
			WHERE clie_nombre = USUARIO_NOMBRE
			AND clie_apellido = USUARIO_APELLIDO
			AND clie_dni = USUARIO_DNI)
		ELSE NULL END,
		CASE WHEN (REPARTIDOR_DNI IS NOT NULL
		AND REPARTIDOR_APELLIDO IS NOT NULL
		AND REPARTIDOR_NOMBRE IS NOT NULL) --envi_repartidor
		THEN 
			(SELECT
				repa_codigo
			FROM STARSHIP.Repartidor
			WHERE repa_dni = REPARTIDOR_DNI
			AND repa_apellido = REPARTIDOR_APELLIDO
			AND repa_nombre = REPARTIDOR_NOMBRE)
		ELSE NULL END
	FROM GD1C2023.gd_esquema.Maestra
	WHERE PEDIDO_PROPINA IS NOT NULL
	AND PEDIDO_PRECIO_ENVIO IS NOT NULL
	GROUP BY 
		DIRECCION_USUARIO_DIRECCION,
		USUARIO_DNI,
		USUARIO_NOMBRE,
		USUARIO_APELLIDO,
		--
		PEDIDO_NRO,
		PEDIDO_PRECIO_ENVIO,
		PEDIDO_PROPINA,
		--
		REPARTIDOR_DNI,
		REPARTIDOR_APELLIDO,
		REPARTIDOR_NOMBRE
END
GO --select * from Envio


------------------- EJECUCION DE PROCEDURES: MIGRACION -------------------

EXECUTE STARSHIP.migrar_tipo_negocio --
EXECUTE STARSHIP.insertar_categoria_negocio
EXECUTE STARSHIP.insertar_direccion_tipo
EXECUTE STARSHIP.migrar_mensajeria_estado
EXECUTE STARSHIP.migrar_tipo_paquete
EXECUTE STARSHIP.migrar_marca_tarjeta
EXECUTE STARSHIP.migrar_cupon_tipo
EXECUTE STARSHIP.migrar_provincias
EXECUTE STARSHIP.migrar_producto
EXECUTE STARSHIP.migrar_localidad
EXECUTE STARSHIP.migrar_direccion
EXECUTE STARSHIP.migrar_negocio
EXECUTE STARSHIP.migrar_producto_negocio
EXECUTE STARSHIP.migrar_tipo_reclamo
EXECUTE STARSHIP.migrar_tipo_movilidad
EXECUTE STARSHIP.migrar_reclamo_solucion
EXECUTE STARSHIP.migrar_reclamo_estado
EXECUTE STARSHIP.migrar_tipo_medio_pago
EXECUTE STARSHIP.migrar_horario
EXECUTE STARSHIP.insertar_dia
EXECUTE STARSHIP.migrar_negocio_dia
EXECUTE STARSHIP.migrar_cliente
EXECUTE STARSHIP.migrar_cliente_direccion
EXECUTE STARSHIP.migrar_repartidor
EXECUTE STARSHIP.migrar_repartidor_localidad
EXECUTE STARSHIP.migrar_repartidor_direccion
EXECUTE STARSHIP.migrar_envio
EXECUTE STARSHIP.migrar_tarjeta
EXECUTE STARSHIP.migrar_medio_pago
EXECUTE STARSHIP.migrar_pedido_estado
EXECUTE STARSHIP.migrar_cupon_descuento
EXECUTE STARSHIP.migrar_pedido
EXECUTE STARSHIP.migrar_producto_pedido
EXECUTE STARSHIP.migrar_cupon_pedido
EXECUTE STARSHIP.migrar_envio_mensajeria
EXECUTE STARSHIP.migrar_paquete
EXECUTE STARSHIP.migrar_operador
EXECUTE STARSHIP.migrar_reclamo
EXECUTE STARSHIP.migrar_cupon_reclamo
GO