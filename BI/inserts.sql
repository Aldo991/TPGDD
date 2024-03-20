------| DIMENSIONES |-----------------------------------------------------------

CREATE PROCEDURE STARSHIP_BI.migrar_dimension_tipo_reclamo
AS
BEGIN

    INSERT INTO STARSHIP_BI.DIMENSION_TIPO_RECLAMO (
        TIPO_RECLAMO_ID,
        TIPO_RECLAMO_DESCRIPCION
    )
    SELECT
        tipo_rec_id,
        tipo_rec_detalle
    FROM STARSHIP.Tipo_Reclamo
END
GO

CREATE PROCEDURE STARSHIP_BI.insertar_dimension_rango_horario
AS
BEGIN

	INSERT INTO STARSHIP_BI.DIMENSION_RANGO_HORARIO (
        RANGO_HORARIO_INI,
        RANGO_HORARIO_FIN
    )

	VALUES 
        (8, 10),
        (10, 12),
        (12, 14),
        (14, 16),
        (16, 18),
        (18, 20),
        (20, 22),
        (22, 24)
END
GO

CREATE PROCEDURE STARSHIP_BI.insertar_rango_hetario
AS
BEGIN

	INSERT INTO STARSHIP_BI.dimension_rango_etario (
        RANGO_ETARIO_INI,
        RANGO_ETARIO_FIN
    )

    VALUES
        (0, 24),
        (25, 35),
        (35, 55),
        (56, NULL)
END
GO

CREATE PROCEDURE STARSHIP_BI.migrar_dimension_dia
AS
BEGIN

	INSERT INTO STARSHIP_BI.DIMENSION_DIA (
        DIA_CODIGO,
        DIA_DETALLE
    )

	SELECT 
        dia_codigo,
        dia_detalle
    FROM STARSHIP.dia
END
GO

/*DIMENSION PROVINCIA/LOCALIDAD*/
CREATE PROCEDURE STARSHIP_BI.migrar_dimension_lugar
AS
BEGIN

	INSERT INTO STARSHIP_BI.DIMENSION_LUGAR (
        LUGAR_LOCALIDAD_NOMBRE,
        LUGAR_PROVINCIA_NOMBRE
    )

	SELECT
        locali_nombre
        prov_nombre
    FROM STARSHIP.Provincia
    JOIN STARSHIP.Localidad ON locali_prov = prov_codigo

END
GO

CREATE PROCEDURE STARSHIP_BI.migrar_dimension_tipo_medio_pago
AS
BEGIN

	INSERT INTO STARSHIP_BI.dimension_tipo_medio_pago (
        MEDIO_PAGO_TIPO,
        MEDIO_PAGO_MARCA
    )

	SELECT
        tipo_medio_detalle,
        marca_tarjeta_detalle

    FROM STARSHIP.Medio_Pago

    JOIN STARSHIP.Tipo_Medio_Pago on tipo_medio_id = medi_tipo
    JOIN STARSHIP.Tarjeta on tarj_codigo = medi_tarjeta
    JOIN STARSHIP.Marca_Tarjeta on marca_tarjeta_cod = tarj_marca
    GROUP BY tipo_medio_detalle, marca_tarjeta_detalle

END
GO

CREATE PROCEDURE STARSHIP_BI.migrar_dimension_negocio
AS
BEGIN

	INSERT INTO STARSHIP_BI.dimension_negocio (
        NEGOCIO_ID,
        NEGOCIO_DESCRIPCION
    )

	SELECT
        nego_codigo,
        nego_nombre
    FROM STARSHIP.Negocio
    GROUP BY nego_codigo, nego_nombre

END
GO

CREATE PROCEDURE STARSHIP_BI.migrar_dimension_calificacion
AS
BEGIN

    INSERT INTO STARSHIP_BI.DIMENSION_CALIFICACION (
        CALIFICACION
    )

    SELECT
        pedi_calificacion
    FROM STARSHIP.Pedido

    UNION

    SELECT
        recl_calificacion
    FROM STARSHIP.Reclamo

    UNION

    SELECT
        mens_calificacion
    FROM STARSHIP.Envio_Mensajeria

END
GO


CREATE PROCEDURE STARSHIP_BI.migrar_dimension_tipo_movilidad
AS
BEGIN

	INSERT INTO STARSHIP_BI.dimension_tipo_movilidad (
        TIPO_MOVILIDAD_ID,
	    TIPO_MOVILIDAD_DESCRIPCION
    )

	SELECT
        tipo_movi_codigo,
        tipo_movi_detalle
    FROM STARSHIP.Tipo_Movilidad
END
GO

CREATE PROCEDURE STARSHIP_BI.migrar_dimension_tipo_paquete
AS
BEGIN

	INSERT INTO STARSHIP_BI.dimension_tipo_paquete (
        TIPO_PAQUETE_ID,
	    TIPO_PAQUETE_DESCRIPCION
    )

	SELECT
        tipo_paqu_codigo,
        tipo_paqu_detalle
    FROM STARSHIP.Tipo_Paquete
END
GO

CREATE PROCEDURE STARSHIP_BI.migrar_dimension_estado_pedido
AS
BEGIN

	INSERT INTO STARSHIP_BI.dimension_estado_pedido (
        ESTADO_PEDIDO_ID,
	    ESTADO_PEDIDO_DESCRIPCION
    )

	SELECT
        pedi_estado_codigo,
        pedi_estado_detalle
    FROM STARSHIP.Pedido_Estado
END
GO

CREATE PROCEDURE STARSHIP_BI.migrar_dimension_estado_envio_mensajeria
AS
BEGIN

	INSERT INTO STARSHIP_BI.dimension_estado_envio_mensajeria (
        ENVIO_MENSAJERIA_ID,
	    ENVIO_MENSAJERIA_DESCRIPCION
    )

	SELECT
        mens_esta_codigo,
        mens_esta_detalle
    FROM STARSHIP.Mens_Estado
END
GO

CREATE PROCEDURE STARSHIP_BI.migrar_dimension_estado_reclamo
AS
BEGIN

	INSERT INTO STARSHIP_BI.dimension_estado_reclamo (
        ESTADO_RECLAMO_ID,
	    ESTADO_RECLAMO_DESCRIPCION
    )

	SELECT
        recl_solucion_id,
        recl_solucion_detalle
    FROM STARSHIP.Recl_Estado

END
GO

CREATE PROCEDURE STARSHIP_BI.migrar_dimension_tiempo --- DUDA
AS
BEGIN

	INSERT INTO STARSHIP_BI.dimension_tiempo (
        TIEMPO_MES,
        TIEMPO_ANIO
    )

    (
	SELECT
		MONTH(mens_fecha_hora_pedi),
        YEAR(mens_fecha_hora_pedi)
	FROM STARSHIP.Envio_Mensajeria
	GROUP BY MONTH(mens_fecha_hora_pedi), YEAR(mens_fecha_hora_pedi)
	
    UNION
	
    SELECT
		MONTH(mens_fecha_hora_entr),
        YEAR(mens_fecha_hora_entr)
	FROM STARSHIP.Envio_Mensajeria
	GROUP BY MONTH(mens_fecha_hora_entr), YEAR(mens_fecha_hora_entr)
	
    UNION

	SELECT
		MONTH(recl_fecha),
        YEAR(recl_fecha)
	FROM STARSHIP.Reclamo
	GROUP BY MONTH(recl_fecha), YEAR(recl_fecha)

	UNION

	SELECT
		MONTH(recl_fecha_sol),
        YEAR(recl_fecha_sol)
	FROM STARSHIP.Reclamo
	GROUP BY MONTH(recl_fecha_sol), YEAR(recl_fecha_sol)
	
    UNION

	SELECT
		MONTH(clie_fecha_registro),
        YEAR(clie_fecha_registro)
	FROM STARSHIP.Cliente
	GROUP BY MONTH(clie_fecha_registro), YEAR(clie_fecha_registro)
	
    UNION

	SELECT
		MONTH(cupon_fecha_alta),
        YEAR(cupon_fecha_alta)
	FROM STARSHIP.Cupon_Descuento
	GROUP BY MONTH(cupon_fecha_alta), YEAR(cupon_fecha_alta)

	UNION

	SELECT
		MONTH(cupon_fecha_venc),
        YEAR(cupon_fecha_venc)
	FROM STARSHIP.Cupon_Descuento
	GROUP BY MONTH(cupon_fecha_venc), YEAR(cupon_fecha_venc)

	UNION

	SELECT
		MONTH(pedi_fecha_hora_pedi),
        YEAR(pedi_fecha_hora_pedi)
	FROM STARSHIP.Pedido
	GROUP BY MONTH(pedi_fecha_hora_pedi), YEAR(pedi_fecha_hora_pedi)
	
    UNION

	SELECT
		MONTH(pedi_fecha_hora_entr),
        YEAR(pedi_fecha_hora_entr)
	FROM STARSHIP.Pedido
	GROUP BY MONTH(pedi_fecha_hora_entr),YEAR(pedi_fecha_hora_entr)
    )
    ORDER BY 2, 1
END
GO

/* TIPO NEGOCIO / CATEGORIA */
CREATE PROCEDURE STARSHIP_BI.migrar_dimension_clasificacion_negocio
AS
BEGIN

	INSERT INTO STARSHIP_BI.dimension_clasificacion_negocio (
        CLASIFICACION_NEGOCIO_ID,
        CLASIFICACION_NEGOCIO_CATEGORIA,
	    CLASIFICACION_NEGOCIO_TIPO
    )

	SELECT
        categ_nego_id,
        categ_nego_detalle,
        tipo_nego_detalle
    FROM STARSHIP.Categoria_Negocio
    JOIN STARSHIP.Tipo_Negocio ON categ_nego_tipo = tipo_nego_id
END
GO

EXECUTE STARSHIP_BI.migrar_dimension_tipo_reclamo
EXECUTE STARSHIP_BI.migrar_dimension_fecha
EXECUTE STARSHIP_BI.migrar_dimension_dia
EXECUTE STARSHIP_BI.insertar_dimension_rango_horario
EXECUTE STARSHIP_BI.insertar_rango_hetario
EXECUTE STARSHIP_BI.migrar_dimension_lugar
EXECUTE STARSHIP_BI.migrar_dimension_tipo_medio_pago
EXECUTE STARSHIP_BI.migrar_dimension_negocio
EXECUTE STARSHIP_BI.migrar_dimension_tipo_movilidad
EXECUTE STARSHIP_BI.migrar_dimension_tipo_paquete
EXECUTE STARSHIP_BI.migrar_dimension_estado_envio_mensajeria
EXECUTE STARSHIP_BI.migrar_dimension_estado_reclamo
EXECUTE STARSHIP_BI.migrar_dimension_estado_pedido
EXECUTE STARSHIP_BI.migrar_dimension_clasificacion_negocio
EXECUTE STARSHIP_BI.migrar_dimension_calificacion
GO

------| TABLAS DE HECHOS |------------------------------------------------------

----------------| TODO: VER DONDE INCLUIR A ENVIO MENSAJERIA |------------------

CREATE PROCEDURE STARSHIP_BI.insertar_tabla_de_hechos_compra
AS
BEGIN
	INSERT INTO STARSHIP_BI.HECHOS_COMPRA (
        HC_DIA,
        HC_RANGO_HORARIO,
        HC_LUGAR, --- PEDIDO
        HC_TIEMPO,
        HC_ESTADO_PEDIDO,
        HC_CLASIFICACION_NEGOCIO,
        ------------------------------
        HC_CALIFICACION_NEGOCIO_TOTAL,
        HC_MONTO_TOTAL_PEDIDOS, --- NO PK
        HC_CANTIDAD_PEDIDOS --- NO PK
        --- TENDRIAMOS QUE TENER UN CAMPO Q CUENTE LA CANTIDAD DE NEGOCIOS
    )

	SELECT
        DD.DIA_ID,
        DRH.RANGO_HORARIO_ID,
        DL.LUGAR_ID,
        DT.TIEMPO_ID,
        DEP.ESTADO_PEDIDO_ID,
        DCT.CLASIFICACION_NEGOCIO_ID,
        SUM(P.pedi_calificacion),
        SUM(P.pedi_total_servicio),
        COUNT(P.pedi_numero)

    FROM STARSHIP.Pedido AS P

    JOIN STARSHIP_BI.DIMENSION_DIA AS DD ON
        DD.DIA_ID = DATEPART(dw, P.pedi_fecha_hora_pedi)

    JOIN STARSHIP_BI.DIMENSION_RANGO_HORARIO AS DRH ON
        DATEPART(HOUR, P.pedi_fecha_hora_pedi)
        BETWEEN DRH.RANGO_HORARIO_INI AND DRH.RANGO_HORARIO_FIN
    
    JOIN STARSHIP_BI.DIMENSION_LUGAR AS DL ON L.locali_nombre = DL.LUGAR_LOCALIDAD_NOMBRE
        AND PR.prov_nombre = DL.LUGAR_PROVINCIA_NOMBRE

    JOIN STARSHIP_BI.DIMENSION_TIEMPO AS DT ON
        YEAR(P.pedi_fecha_hora_pedi) = DT.TIEMPO_ANIO
        AND MONTH(P.pedi_fecha_hora_pedi) = DT.TIEMPO_MES

    JOIN STARSHIP.Envio AS E ON E.envi_codigo = P.pedi_envio
    JOIN STARSHIP.Direccion AS D ON D.dir_codigo = E.envi_dir_codigo
    JOIN STARSHIP.Localidad AS L ON D.dir_local_codigo = L.locali_codigo
    JOIN STARSHIP.Provincia AS PR ON L.locali_prov = PR.prov_codigo

    JOIN STARSHIP_BI.DIMENSION_ESTADO_PEDIDO AS DEP ON DEP.ESTADO_PEDIDO_ID = P.pedi_estado

    JOIN STARSHIP.Negocio AS NEGO ON NEGO.nego_codigo = P.pedi_nego_codigo
    JOIN STARSHIP_BI.DIMENSION_CLASIFICACION_NEGOCIO AS DCT ON
        DCT.CLASIFICACION_NEGOCIO_ID = NEGO.nego_categ

    GROUP BY DD.DIA_ID, DRH.RANGO_HORARIO_ID, DL.LUGAR_ID, DT.TIEMPO_ID, DEP.ESTADO_PEDIDO_ID,
    DCT.CLASIFICACION_NEGOCIO_ID
END
GO

-------------------------------------------------------------------------------------------

CREATE PROCEDURE STARSHIP_BI.insertar_tabla_de_hechos_descuento
AS
BEGIN

	INSERT INTO STARSHIP_BI.HECHOS_DESCUENTO (
        HD_RANGO_ETARIO, --- USUARIOS
        HD_MONTO_CUPONES, --- NO PK
        HD_TIEMPO
    )

	SELECT
        DRE.RANGO_ETARIO_ID,
        SUM(P.pedi_total_cupones),
        DT.TIEMPO_ID

    FROM STARSHIP.Cupon_Pedido AS CP

    JOIN STARSHIP.Pedido AS P ON P.pedi_numero = CP.cupon_ped_codigo

    JOIN STARSHIP.Cliente AS C ON C.clie_codigo = P.pedi_usuario

    JOIN STARSHIP_BI.DIMENSION_TIEMPO AS DT ON YEAR(P.pedi_fecha_hora_pedi) = DT.ANIO
        AND MONTH(P.pedi_fecha_hora_pedi) = DT.MES

    JOIN STARSHIP_BI.DIMENSION_RANGO_ETARIO AS DRE 
        ON DRE.RANGO_ETARIO_INI <= DATEDIFF(YEAR, C.clie_nacimiento, GETDATE())
        AND ISNULL(DRE.RANGO_ETARIO_FIN, 999) >= DATEDIFF(YEAR, C.clie_nacimiento, GETDATE())

    GROUP BY MONTH(P.pedi_fecha_hora_pedi), YEAR(P.pedi_fecha_hora_pedi), C.clie_codigo, DT.TIEMPO_ID, DRE.RANGO_ETARIO_ID
END
GO

-------------------------------------------------------------------------------------------

CREATE PROCEDURE STARSHIP_BI.insertar_tabla_de_hechos_entrega
AS
BEGIN

    --- POSIBLEMENTE TABLA DE HECHOS PARA SEPARAR MENS DE ENVIO COMUN

	INSERT INTO STARSHIP_BI.HECHOS_ENTREGA ( --- TODO ENVIO MENSAJERIA
        HE_TIPO_MOVILIDAD,
        HE_RANGO_ETARIO, --- REPARTIDOR
        HE_RANGO_HORARIO,
        HE_DIA,
        HE_LUGAR,
        HE_ESTADO_ENVIO_MENSAJERIA,
        HE_ESTADO_PEDIDO,
        HE_TIPO_PAQUETE,
        -------------------------------------
        HE_TIEMPO_ESTIMADO_TOTAL, -- NO PK
        HE_TIEMPO_ENTREGA_TOTAL, --NO PK
        HE_VALOR_ASEGURADO_TOTAL --NO PK
        --- TENDRIA QUE HABER OTRO QUE CUENTE LOS ENVIOS ACA
    )

	SELECT
        DTM.TIPO_MOVILIDAD_ID,
        DRE.RANGO_ETARIO_ID,
        DRH.RANGO_HORARIO_ID,
        DD.DIA_ID,
        DL.LUGAR_ID, --- TODO
        ,
        DEP.ESTADO_PEDIDO_DESCRIPCION,
        ,
        SUM(),
        SUM(),
        SUM()
        

    FROM STARSHIP.Envio AS E

    JOIN STARSHIP.Pedido AS P ON P.pedi_envio = E.envi_codigo

    JOIN STARSHIP.Pedido_Estado AS PE ON PE.pedi_estado_codigo = P.pedi_estado

    JOIN STARSHIP_BI.DIMENSION_ESTADO_PEDIDO AS DEP ON
        DEP.ESTADO_PEDIDO_DESCRIPCION = PE.pedi_estado_detalle

    JOIN STARSHIP_BI.DIMENSION_DIA AS DD ON 
        DD.DIA_ID = DATEPART(dw, P.pedi_fecha_hora_entr)

    JOIN STARSHIP.Cliente AS C ON P.pedi_usuario = C.clie_codigo

    JOIN STARSHIP.Repartidor AS R ON E.envi_repartidor = repa_codigo

    JOIN STARSHIP_BI.DIMENSION_TIPO_MOVILIDAD AS DTM ON DTM.TIPO_MOVILIDAD_ID = R.repa_tipo_movi

    JOIN STARSHIP_BI.DIMENSION_RANGO_HORARIO AS DRH ON
        DATEPART(HOUR, p.pedi_fecha_hora_pedi)
        BETWEEN DRH.RANGO_HORARIO_INI AND DRH.RANGO_HORARIO_FIN

    JOIN STARSHIP_BI.DIMENSION_RANGO_ETARIO AS DRE ON 
        DRE.RANGO_ETARIO_INI <= DATEDIFF(YEAR, C.clie_nacimiento, GETDATE())
        AND ISNULL(DRE.RANGO_ETARIO_FIN, 999) >= DATEDIFF(YEAR, C.clie_nacimiento, GETDATE())

    GROUP BY 
    

    /*
    SELECT R.repa_codigo 
        , DATEDIFF(YEAR, R.repa_nacimiento, GETDATE())
        , TM.tipo_movi_detalle
        , SUM(EM.mens_tiempo_estimado)
        , SUM(ABS(DATEDIFF(MINUTE, EM.mens_fecha_hora_pedi, EM.mens_fecha_hora_entr)))
        , SUM(P.mens_valor_asegurado)
    FROM STARSHIP.Envio_Mensajeria AS EM
    JOIN STARSHIP.Repartidor AS R ON EM.mens_repa_codigo = R.repa_codigo
    JOIN STARSHIP.Paquete AS P ON EM.mens_numero = P.paqu_mens_numero
    JOIN STARSHIP.Tipo_Paquete AS TP ON TP.tipo_paqu_codigo = P.paqu_tipo
    JOIN STARSHIP.Tipo_Movilidad AS TM ON TM.tipo_movi_codigo = R.repa_tipo_mov
    GROUP BY R.repa_codigo, R.repa_nacimiento, TM.tipo_movi_detalle
    UNION ALL
    SELECT R.repa_codigo
        , DATEDIFF(YEAR, R.repa_nacimiento, GETDATE()) 
        , TM.tipo_movi_detalle
        , SUM(P.pedi_tiempo_estimado)
        , SUM(DATEDIFF(MINUTE, P.pedi_fecha_hora_pedi, P.pedi_fecha_hora_entr))
        , SUM(0) as mens_valor_asegurado
    FROM STARSHIP.Envio AS E
    JOIN STARSHIP.Pedido AS P ON P.pedi_envio = E.envi_numero
    JOIN STARSHIP.Repartidor AS R ON R.repa_codigo = envi_repartidor
    JOIN STARSHIP.Tipo_Movilidad AS TM ON TM.tipo_movi_codigo = R.repa_tipo_mov
    GROUP BY R.repa_codigo, R.repa_nacimiento, TM.tipo_movi_detalle*/

END
GO

-------------------------------------------------------------------------------------------

CREATE PROCEDURE STARSHIP_BI.insertar_tabla_de_hechos_reclamo
AS
BEGIN

	INSERT INTO STARSHIP_BI.HECHOS_RECLAMO (
        HR_RANGO_HORARIO,
        HR_TIEMPO,
        HR_RANGO_ETARIO, --- OPERADOR
        HR_NEGOCIO,
        HR_DIA,
        HR_TIPO_RECLAMO,
        HR_CANTIDAD_RECLAMOS,
        HR_TIEMPO_SOLUCION_TOTAL,
        HR_MONTO_CUPONES
    )

	SELECT
        DRH.RANGO_HORARIO_ID,
        DT.TIEMPO_ID,
        DRE.RANGO_ETARIO_ID, --- OPERADOR
        DN.NEGOCIO_ID,
        DD.DIA_ID,
        DTR.TIPO_RECLAMO_ID,
        COUNT(DISTINCT R.recl_numero),
        SUM(DATEDIFF(MINUTE, R.recl_fecha, R.recl_fecha_sol)),
        SUM(CD.cupon_valor)

    FROM STARSHIP.Reclamo AS R

    JOIN STARSHIP.Cupon_Reclamo AS CR ON CR.cupon_recl_recl = R.recl_numero

    JOIN STARSHIP.Cupon_Descuento AS CD ON CD.cupon_id = CR.cupon_recl_cupon

    JOIN STARSHIP_BI.DIMENSION_DIA AS DD ON
        DD.DIA_ID = DATEPART(dw, R.recl_fecha)

    JOIN STARSHIP_BI.DIMENSION_TIPO_RECLAMO AS DTR ON DTR.TIPO_RECLAMO_ID = TR.tipo_rec_id

    JOIN STARSHIP.Pedido AS P ON P.pedi_numero = R.recl_pedido

    JOIN STARSHIP_BI.DIMENSION_NEGOCIO AS DN ON P.pedi_nego_codigo = DN.NEGOCIO_ID

    JOIN STARSHIP_BI.DIMENSION_TIEMPO AS DT ON
        YEAR(R.recl_fecha) = DT.TIEMPO_ANIO AND MONTH(R.recl_fecha) = DT.TIEMPO_MES

    JOIN STARSHIP_BI.DIMENSION_RANGO_HORARIO AS DRH ON
        DATEPART(HOUR, recl_fecha)
        BETWEEN DRH.RANGO_HORARIO_INI AND DRH.RANGO_HORARIO_FIN

    JOIN STARSHIP.Operador AS O ON R.recl_operador = O.oper_codigo

    JOIN STARSHIP_BI.DIMENSION_RANGO_ETARIO AS DRE  
        ON DRE.RANGO_ETARIO_INI <= DATEDIFF(YEAR, C.clie_nacimiento, GETDATE())
        AND ISNULL(DRE.RANGO_ETARIO_FIN, 999) >= DATEDIFF(YEAR, C.clie_nacimiento, GETDATE())

    GROUP BY  DRH.RANGO_HORARIO_ID, DT.TIEMPO_ID, DRE.RANGO_ETARIO_ID, DN.NEGOCIO_ID, DD.DIA_ID, DTR.TIPO_RECLAMO_ID
END
GO

EXECUTE STARSHIP_BI.insertar_tabla_de_hechos_compra
EXECUTE STARSHIP_BI.insertar_tabla_de_hechos_venta
EXECUTE STARSHIP_BI.insertar_tabla_de_hechos_descuento
EXECUTE STARSHIP_BI.insertar_tabla_de_hechos_entrega
EXECUTE STARSHIP_BI.insertar_tabla_de_hechos_reclamo