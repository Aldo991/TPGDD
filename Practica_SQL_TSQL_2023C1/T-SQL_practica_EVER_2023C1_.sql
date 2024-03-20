/*
T-SQL
*/

/* Ejercicio 1 ==============================================================================
1. Hacer una función que dado un artículo y un deposito devuelva un string que
indique el estado del depósito según el artículo. Si la cantidad almacenada es
menor al límite retornar “OCUPACION DEL DEPOSITO XX %” siendo XX el
% de ocupación. Si la cantidad almacenada es mayor o igual al límite retornar
“DEPOSITO COMPLETO”.
*/

/* Hecho en clase */
CREATE FUNCTION t_sql_eje_01 (@articulo char(8), @deposito char(2))RETURNS VARCHAR(50)ASBEGIN	declare @cantidad_actual decimal(12,2)	declare @cant_max decimal(12,2)	DECLARE @mensaje varchar(50)	select @cantidad_actual = stoc_cantidad, @cant_max = stoc_stock_maximo	from stock	where stoc_producto = @articulo and stoc_deposito = @deposito	if @cantidad_actual >= @cant_max 		set @mensaje = 'DEPOSITO COMPLETO'	ELSE		set @mensaje = 'OCUPACION DEL DEPOSITO ' + str((@cantidad_actual/@cant_max)*100.00) + '%'	RETURN @mensajeEND
GO


/* Ejercicio 2 ==============================================================================
2. Realizar una función que dado un artículo y una fecha, retorne el stock que
existía a esa fecha
*/

CREATE FUNCTION t_sql_eje_02 (@producto char(8), @fecha smalldatetime)
RETURNS DECIMAL(10,2)
AS
BEGIN
	declare @stock_fecha decimal(10,2)

	select @stock_fecha = SUM(item_cantidad)
	from Item_Factura
	JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
	where item_producto = @producto
	AND fact_fecha > @fecha

	set @stock_fecha = @stock_fecha + (select SUM(stoc_cantidad) from STOCK where stoc_producto = @producto)

	RETURN @stock_fecha
END
GO


/* Ejercicio 3 ==============================================================================
3. Cree el/los objetos de base de datos necesarios para corregir la tabla empleado
en caso que sea necesario. Se sabe que debería existir un único gerente general
(debería ser el único empleado sin jefe). Si detecta que hay más de un empleado
sin jefe deberá elegir entre ellos el gerente general, el cual será seleccionado por
mayor salario. Si hay más de uno se seleccionara el de mayor antigüedad en la
empresa. Al finalizar la ejecución del objeto la tabla deberá cumplir con la regla
de un único empleado sin jefe (el gerente general) y deberá retornar la cantidad
de empleados que había sin jefe antes de la ejecución.
*/

CREATE PROCEDURE t_sql_eje_03
AS
BEGIN
	declare @empleado_gerente numeric(6)
	declare @empleados_sin_jefe numeric(6) = (select COUNT(*) from Empleado where empl_jefe is null)

	select top 1 @empleado_gerente = empl_codigo from Empleado
	where empl_jefe is null
	order by empl_salario DESC, empl_ingreso
	
	PRINT 'Cantidad de empleados sin jefe: '+RTRIM(@empleados_sin_jefe)

	UPDATE Empleado 
	SET empl_jefe = @empleado_gerente
	where empl_jefe is null
	AND empl_codigo <> @empleado_gerente
END
GO

--EXEC t_sql_eje_03


/* Ejercicio 4 ==============================================================================
4. Cree el/los objetos de base de datos necesarios para actualizar la columna de
empleado empl_comision con la sumatoria del total de lo vendido por ese
empleado a lo largo del último año. Se deberá retornar el código del vendedor
que más vendió (en monto) a lo largo del último año.
*/

--select * into t_Empleado from Empleado

CREATE PROCEDURE t_sql_eje_04 (@vendedor_mas_vendio numeric(6) OUTPUT)
AS
BEGIN
	SET @vendedor_mas_vendio = (select top 1 fact_vendedor from Factura
	where YEAR(fact_fecha) = (select TOP 1 YEAR(fact_fecha) from Factura 
								group by YEAR(fact_fecha)
								order by YEAR(fact_fecha) DESC)
	group by fact_vendedor
	order by SUM(fact_total) DESC)

	PRINT 'COD. VENDEDOR QUE MÁS VENDIÓ: ' + RTRIM(@vendedor_mas_vendio)

	UPDATE t_Empleado
	SET empl_comision = (select SUM(fact_total) from Factura 
						where fact_vendedor = empl_codigo 
						and YEAR(fact_fecha) = (select TOP 1 YEAR(fact_fecha) from Factura 
												group by YEAR(fact_fecha)
												order by YEAR(fact_fecha) DESC))
	--WHERE -- No va porq' lo tengo q' cambiar a todos.
END
GO

/*
declare @variable_empleador numeric(6)
EXEC dbo.t_sql_eje_04 @variable_empleador OUTPUT
PRINT '>>> ' + RTRIM(@variable_empleador)

select * from Empleado
select * from t_Empleado
*/


/* Ejercicio 5 ==============================================================================
Realizar un procedimiento que complete con los datos existentes en el modelo
provisto la tabla de hechos denominada Fact_table tiene las siguiente definición:

Create table Fact_table ( 
	anio char(4) not null,
	mes char(2) not null,
	familia char(3) not null,
	rubro char(4) not null,
	zona char(3) not null,
	cliente char(6) not null,
	producto char(8) not null,
	cantidad decimal(12,2),
	monto decimal(12,2)
)
Alter table Fact_table
Add constraint PK_1
primary key(anio,mes,familia,rubro,zona,cliente,producto)
*/

--select * from Fact_table

CREATE PROCEDURE t_sql_eje_05
AS
BEGIN
	INSERT INTO Fact_table (
		anio,
		mes,
		familia,
		rubro,
		zona,
		cliente,
		producto,
		cantidad,
		monto
	)
	SELECT
		--COUNT(*),
		YEAR(fact_fecha),
		MONTH(fact_fecha),
		fami_id,
		rubr_id,
		zona_codigo,
		fact_cliente,
		item_producto,
		SUM(item_cantidad),
		SUM(item_precio)
	FROM Item_Factura Item1
	JOIN Factura F1 ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
	JOIN Producto P1 ON prod_codigo = item_producto
	JOIN Rubro ON rubr_id = prod_rubro
	JOIN Familia ON fami_id = prod_familia
	JOIN Empleado ON empl_codigo = fact_vendedor
	JOIN Departamento ON depa_codigo = empl_departamento
	JOIN Zona ON zona_codigo = depa_zona
	group by 
		YEAR(fact_fecha),
		MONTH(fact_fecha),
		fami_id,
		rubr_id,
		zona_codigo,
		fact_cliente,
		item_producto
END
GO

/*
EXEC t_sql_eje_05
--drop procedure t_sql_eje_05
select * from Fact_table
--delete from Fact_table
*/

/* Ejercicio 6 ==============================================================================
Realizar un procedimiento que si en alguna factura se facturaron componentes
que conforman un combo determinado (o sea que juntos componen otro
producto de mayor nivel), en cuyo caso deberá reemplazar las filas
correspondientes a dichos productos por una sola fila con el producto que
componen con la cantidad de dicho producto que corresponda.
*/

--select * from Item_Factura --19484
--select * from Composicion --12

select * into Item_Factura_2 from Item_Factura
--select * from Item_Factura_2 --19484
--drop table Item_Factura_2

CREATE PROCEDURE t_sql_eje_06
AS
BEGIN
	/*
	select * 
	from Composicion C1
	join Composicion C2 ON C2.comp_producto = C1.comp_componente

	select * from Composicion COMP1 
	join Composicion COMP2 on COMP2.comp_producto = COMP1.comp_producto 
							and COMP1.comp_componente > COMP2.comp_componente
	*/
	DECLARE @fact_tipo char(1), @fact_sucursal char(4), @fact_numero char(8)
	DECLARE @prod_1_cod char(8), @prod_1_cant decimal(12,2), @prod_1_precio decimal(12,2)
	DECLARE @prod_2_cod char(8), @prod_2_cant decimal(12,2), @prod_2_precio decimal(12,2)

	DECLARE @ITEM_1_CANT DECIMAL(12,2), @ITEM_2_CANT DECIMAL(12,2)
	DECLARE @AUX_COUNT_1 DECIMAL(12,2), @AUX_COUNT_2 DECIMAL(12,2)
	DECLARE @AUX_PROD_1 char(8), @AUX_PROD_2 char(8)

	DECLARE Prod_Comp_cursor CURSOR
	FOR 
	(select
		item1.item_tipo,
		item1.item_sucursal,
		item1.item_numero,
		item1.item_producto,
		item1.item_cantidad,
		item1.item_precio,
		item2.item_producto,
		item2.item_cantidad,
		item2.item_precio
	from Item_Factura_2 item1
	join Item_Factura_2 item2 on item2.item_tipo+item2.item_sucursal+item2.item_numero = item1.item_tipo+item1.item_sucursal+item1.item_numero
	and item1.item_producto > item2.item_producto
	and item1.item_producto in (select comp_componente from Composicion) 
	and item2.item_producto in (select comp_componente from Composicion))

	OPEN Prod_Comp_cursor
	FETCH NEXT FROM Prod_Comp_cursor 
	INTO @fact_tipo, @fact_sucursal, @fact_numero, @prod_1_cod, @prod_1_cant, @prod_1_precio, @prod_2_cod, @prod_2_cant, @prod_2_precio

	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Preguntarme si P1 y P2 fomran parte del mismo super producto
		IF EXISTS (select COMP1.comp_producto from Composicion COMP1 
					join Composicion COMP2 on COMP2.comp_producto = COMP1.comp_producto 
											and COMP1.comp_componente > COMP2.comp_componente
					where COMP1.comp_componente = @prod_1_cod and COMP2.comp_componente = @prod_2_cod)
		BEGIN
			select @ITEM_1_CANT = COMP1.comp_cantidad, @ITEM_2_CANT = COMP2.comp_cantidad,
				@AUX_PROD_1 = COMP1.comp_producto, @AUX_PROD_2 = COMP2.comp_producto 
			from Composicion COMP1 
			join Composicion COMP2 on COMP2.comp_producto = COMP1.comp_producto 
									and COMP1.comp_componente > COMP2.comp_componente
			where COMP1.comp_componente = @prod_1_cod 
				and COMP2.comp_componente = @prod_2_cod
			
			--ENTRA SOLO SI LAS CANTIDADES SON SUFICIENTES
			IF (@prod_1_cant >= @ITEM_1_CANT AND @prod_2_cant >= @ITEM_2_CANT)
			BEGIN
				SET @AUX_COUNT_1 = 0
				SET @AUX_COUNT_2 = 0

				WHILE ((@prod_1_cant - @ITEM_1_CANT) >= 0 AND (@prod_2_cant - @ITEM_2_CANT) >= 0)
				BEGIN
					SET @prod_1_cant = @prod_1_cant - @ITEM_1_CANT
					SET @prod_2_cant = @prod_2_cant - @ITEM_2_CANT
					SET @AUX_COUNT_1 = @AUX_COUNT_1 + 1
					SET @AUX_COUNT_2 = @AUX_COUNT_2 + 1
				END

				IF(@prod_1_cant > 0)
				BEGIN
					UPDATE Item_Factura_2
					SET item_cantidad = @prod_1_cant
					WHERE item_tipo = @fact_tipo 
					and item_sucursal = @fact_sucursal 
					and item_numero = @fact_numero
					and item_producto = @prod_1_cod 
				END

				IF @prod_2_cant > 0
				BEGIN
					UPDATE Item_Factura_2
					SET item_cantidad = @prod_2_cant
					WHERE item_tipo = @fact_tipo 
					and item_sucursal = @fact_sucursal 
					and item_numero = @fact_numero
					and item_producto = @prod_2_cod  
				END

				IF(@prod_1_cant = 0)
				BEGIN
					DELETE FROM Item_Factura_2 
					WHERE item_tipo = @fact_tipo 
					and item_sucursal = @fact_sucursal 
					and item_numero = @fact_numero
					and item_producto = @prod_1_cod
				END

				IF @prod_2_cant = 0
				BEGIN
					DELETE FROM Item_Factura_2
					WHERE item_tipo = @fact_tipo 
					and item_sucursal = @fact_sucursal 
					and item_numero = @fact_numero
					and item_producto = @prod_2_cod
				END

				IF(@prod_1_cant < 0)
				BEGIN
					PRINT 'ERROR CON LA CANTIDAD DEL PROD_1: ' + RTRIM(@prod_1_cod)
				END
				IF(@prod_2_cant < 0)
				BEGIN
					PRINT 'ERROR CON LA CANTIDAD DEL PROD_2: ' + RTRIM(@prod_2_cod)
				END

				INSERT INTO Item_Factura_2 (item_tipo, item_sucursal, item_numero, item_producto, item_cantidad, item_precio)
									VALUES (@fact_tipo, @fact_sucursal, @fact_numero, @AUX_PROD_1, @AUX_COUNT_1, @ITEM_1_CANT*@prod_1_precio+@ITEM_2_CANT*@prod_2_precio)

				PRINT '' + RTRIM(@fact_tipo) + '  ' + RTRIM(@fact_sucursal) + '  ' + RTRIM(@fact_numero)
				PRINT '>>>> [' + RTRIM(@AUX_PROD_1) + ']: #' + RTRIM(@AUX_COUNT_1) + '  $' + RTRIM(@ITEM_1_CANT*@prod_1_precio+@ITEM_2_CANT*@prod_2_precio)
				PRINT '[' + RTRIM(@prod_1_cod) + ']: ' + '#' + RTRIM(@ITEM_1_CANT) + '  $' + RTRIM(@prod_1_precio)
				PRINT '[' + RTRIM(@prod_2_cod) + ']: ' + '#' + RTRIM(@ITEM_2_CANT) + '  $' + RTRIM(@prod_2_precio)
				PRINT '======================================================'

			END
			ELSE
			BEGIN
				PRINT 'No alcanzaron las CANTIDADES: [' + RTRIM(@prod_1_cod) + ']: ' + RTRIM(@prod_1_cant) + ' <> [' + RTRIM(@prod_2_cod) + ']: ' + RTRIM(@prod_2_cant)
			END
		END
		ELSE
		BEGIN
			PRINT 'Match ERROR (No pertenecen al mismo super producto): [' + RTRIM(@prod_1_cod) + '] [' + RTRIM(@prod_2_cod) + ']'
		END

		FETCH NEXT FROM Prod_Comp_cursor
		INTO @fact_tipo, @fact_sucursal, @fact_numero, @prod_1_cod, @prod_1_cant, @prod_1_precio, @prod_2_cod, @prod_2_cant, @prod_2_precio
	END

	CLOSE Prod_Comp_cursor
	DEALLOCATE Prod_Comp_cursor

END
GO

--EXEC t_sql_eje_06
/*
select * from Item_Factura --19484
select * from Item_Factura_2 -- 19479

select * from Item_Factura where item_producto = '00005703'
select * from Item_Factura where item_tipo='A' and item_sucursal='0003' and item_numero='00090676'

select * from Item_Factura where item_tipo='A' and item_sucursal='0003' and item_numero='00096572'
select * from Item_Factura_2 where item_tipo='A' and item_sucursal='0003' and item_numero='00096572'
*/



/* Ejercicio 7 ==============================================================================
7. Hacer un procedimiento que dadas dos fechas complete la tabla Ventas. Debe
insertar una línea por cada artículo con los movimientos de stock generados por
las ventas entre esas fechas. La tabla se encuentra creada y vacía.
*/

--select * from Factura --3000

CREATE TABLE #VENTAS (
	CODIGO  CHAR(8),
	DETALLE CHAR(50),
	CANT_MOV DECIMAL(12,2),
	AVG_PRECIO_VENTA DECIMAL(12,2),
	RENGLON int IDENTITY(1,1),
	GANANCIA DECIMAL(12,2)
)
--SELECT count(*) FROM #VENTAS
--select * from #VENTAS
--drop table #VENTAS

CREATE PROCEDURE t_sql_eje_07 (@FECHA_1 DATE, @FECHA_2 DATE)
AS
BEGIN
	IF (SELECT COUNT(*) FROM #VENTAS) > 0
	BEGIN
		DELETE FROM #VENTAS
	END

	INSERT INTO #VENTAS (
		CODIGO,
		DETALLE,
		CANT_MOV,
		AVG_PRECIO_VENTA,
		GANANCIA
	)
	SELECT 
		item_producto,
		prod_detalle,
		COUNT(*),
		AVG(item_precio*item_cantidad),
		SUM((prod_precio-item_precio)*item_cantidad)
	FROM Item_Factura 
	JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
	JOIN Producto ON prod_codigo = item_producto
	WHERE fact_fecha >= @FECHA_1 AND fact_fecha <= @FECHA_2
	GROUP BY item_producto, prod_detalle

END
GO

--EXEC t_sql_eje_07 '2010-05-01', '2012-05-30'
--select * from #VENTAS


/* Ejercicio 08 ==============================================================================
Realizar un procedimiento que complete la tabla Diferencias de precios, para los
productos facturados que tengan composición y en los cuales el precio de
facturación sea diferente al precio del cálculo de los precios unitarios por
cantidad de sus componentes, se aclara que un producto que compone a otro,
también puede estar compuesto por otros y así sucesivamente, la tabla se debe
crear y está formada por las siguientes columnas:
*/

CREATE TABLE DIFERENCIAS (
	CODIGO CHAR(8),
	DETALLE CHAR(50),
	CANTIDAD DECIMAL(12,2),
	PRECIO_GENERADO DECIMAL(12,2),
	PRECIO_FACTURADO DECIMAL(12,2)
)

CREATE FUNCTION FN_AUX_EJE_08_SUMA_COMPONENTES(@COD CHAR(8))
RETURNS DECIMAL(12,2)
AS
BEGIN
	DECLARE @SUMA_ACUM DECIMAL(12,2)

	IF NOT EXISTS (SELECT comp_producto FROM Composicion WHERE comp_producto = @COD)
		RETURN (SELECT prod_precio FROM Producto WHERE prod_codigo = @COD)
	ELSE

	DECLARE @COMP_COD CHAR(8), @COMP_CANT DECIMAL(12,2)
	DECLARE CURSOR_RECORRE CURSOR FOR (SELECT comp_componente, comp_cantidad FROM Composicion WHERE comp_producto = @COD)

	OPEN CURSOR_RECORRE
	FETCH NEXT FROM CURSOR_RECORRE INTO @COMP_COD, @COMP_CANT
	SET @SUMA_ACUM = 0
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SUMA_ACUM = @SUMA_ACUM + @COMP_CANT*DBO.FN_AUX_EJE_08_SUMA_COMPONENTES(@COMP_COD)

		FETCH NEXT FROM CURSOR_RECORRE INTO @COMP_COD, @COMP_CANT
	END
	CLOSE CURSOR_RECORRE
	DEALLOCATE CURSOR_RECORRE

	RETURN @SUMA_ACUM
END
GO


CREATE PROCEDURE t_sql_eje_08
AS
BEGIN
	INSERT INTO DIFERENCIAS (CODIGO,DETALLE,CANTIDAD,PRECIO_GENERADO,PRECIO_FACTURADO)
	SELECT 
		item_producto,
		prod_detalle,
		COUNT(DISTINCT comp_componente),
		DBO.FN_AUX_EJE_08_SUMA_COMPONENTES(item_producto),
		item_precio
	FROM Item_Factura
	JOIN Producto ON item_producto = prod_codigo
	JOIN Composicion ON item_producto = comp_producto
	WHERE item_precio <> DBO.FN_AUX_EJE_08_SUMA_COMPONENTES(item_producto)
	GROUP BY item_producto, prod_detalle, item_precio
END
GO

EXEC t_sql_eje_08
SELECT * FROM DIFERENCIAS


/* Ejercicio 09 ==============================================================================
9. Crear el/los objetos de base de datos que ante alguna modificación de un ítem de
factura de un artículo con composición realice el movimiento de sus
correspondientes componentes [(En STOCK)].
*/

CREATE TRIGGER TR_EJE_09_UPDATE ON Item_Factura
FOR UPDATE
AS
BEGIN
	DECLARE @PROD_COD CHAR(8), @PROD_CANT_I DECIMAL(12,2), @PROD_CANT_D DECIMAL(12,2)
	DECLARE UPDATE_CURSOR CURSOR 
	FOR (SELECT I.item_producto, I.item_cantidad, D.item_cantidad FROM inserted I 
		JOIN deleted D ON I.item_tipo+I.item_sucursal+I.item_numero = D.item_tipo+D.item_sucursal+D.item_numero 
		AND I.item_producto = D.item_producto)
	OPEN UPDATE_CURSOR
	FETCH NEXT FROM UPDATE_CURSOR INTO @PROD_COD, @PROD_CANT_I, @PROD_CANT_D
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS (SELECT * FROM Composicion WHERE comp_producto = @PROD_COD)
		/*
		BEGIN
			UPDATE STOCK 
			SET stoc_cantidad = stoc_cantidad + (@PROD_CANT_D - @PROD_CANT_I)
			WHERE stoc_producto = @PROD_COD
			AND stoc_deposito = (SELECT TOP 1 S2.stoc_deposito FROM STOCK S2
								WHERE S2.stoc_producto = @PROD_COD AND S2.stoc_cantidad > 0
								ORDER BY S2.stoc_cantidad)
		END
		ELSE
		*/
		BEGIN
			UPDATE STOCK
			SET stoc_cantidad = stoc_cantidad + (@PROD_CANT_D - @PROD_CANT_I)*comp_cantidad
			FROM STOCK
			JOIN Composicion C ON C.comp_producto = @PROD_COD 
								AND C.comp_componente = stoc_producto
			WHERE stoc_deposito = (SELECT TOP 1 S2.stoc_deposito FROM STOCK S2
									WHERE S2.stoc_producto = C.comp_componente AND S2.stoc_cantidad > 0
									ORDER BY S2.stoc_cantidad)
		END
		FETCH NEXT FROM UPDATE_CURSOR INTO @PROD_COD, @PROD_CANT_I, @PROD_CANT_D
	END
	CLOSE UPDATE_CURSOR
	DEALLOCATE UPDATE_CURSOR
END
GO


/* Ejercicio 10 ==============================================================================
10. Crear el/los objetos de base de datos que ante el intento de borrar un artículo
verifique que no exista stock y si es así lo borre en caso contrario que emita un
mensaje de error.
*/

CREATE TRIGGER TR_EJE_10_V1 ON Producto
FOR DELETE
AS
BEGIN
	IF EXISTS (SELECT prod_codigo FROM deleted JOIN STOCK ON stoc_producto = prod_codigo 
				GROUP BY prod_codigo HAVING SUM(stoc_cantidad) > 0)
	BEGIN
		PRINT 'No se puede ejecutar la transacción - Alguno de los productos aun tiene stock'
		ROLLBACK
	END
END
GO


CREATE TRIGGER TR_EJE_10_V2 ON Producto
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @PROD_COD CHAR(8)
	DECLARE CURSOR_DELETE CURSOR
	FOR (SELECT prod_codigo FROM deleted)
	OPEN CURSOR_DELETE
	FETCH NEXT FROM CURSOR_DELETE INTO @PROD_COD
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (SELECT SUM(stoc_cantidad) FROM STOCK WHERE stoc_producto = @PROD_COD GROUP BY stoc_producto) = 0
			DELETE FROM Producto WHERE prod_codigo = @PROD_COD
		ELSE
		BEGIN
			PRINT 'NO SE PUEDE ELIMIANR EL PROD: ' + @PROD_COD
		END
		FETCH NEXT FROM CURSOR_DELETE INTO @PROD_COD
	END
	CLOSE CURSOR_DELETE
	DEALLOCATE CURSOR_DELETE
END
GO



/* Ejercicio 11 ==============================================================================
11. Cree el/los objetos de base de datos necesarios para que dado un código de
empleado se retorne la cantidad de empleados que este tiene a su cargo (directa o
indirectamente). Solo contar aquellos empleados (directos o indirectos) que
tengan un código mayor que su jefe directo.
*/

CREATE FUNCTION FN_EJE_11 (@EMPL_COD NUMERIC(6))
RETURNS INT
AS
BEGIN
	DECLARE @CONTADOR_EMPL INT = 0
	--CASO BASE
	IF NOT EXISTS (SELECT empl_codigo FROM Empleado WHERE empl_jefe = @EMPL_COD AND empl_codigo > @EMPL_COD)
		RETURN @CONTADOR_EMPL
	--CASO RECURSIVO
	DECLARE @EMPL_EMPL NUMERIC(6)
	DECLARE CURSOR_GESTOR CURSOR
	FOR (SELECT empl_codigo FROM Empleado WHERE empl_jefe = @EMPL_COD AND empl_codigo > @EMPL_COD)
	OPEN CURSOR_GESTOR
	FETCH NEXT FROM CURSOR_GESTOR INTO @EMPL_EMPL
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF DBO.FN_EJE_11(@EMPL_EMPL) = 0
			SET @CONTADOR_EMPL = @CONTADOR_EMPL + 1
		ELSE
			SET @CONTADOR_EMPL = @CONTADOR_EMPL + DBO.FN_EJE_11(@EMPL_EMPL) + 1
		FETCH NEXT FROM CURSOR_GESTOR INTO @EMPL_EMPL
	END
	CLOSE CURSOR_GESTOR
	DEALLOCATE CURSOR_GESTOR
	RETURN @CONTADOR_EMPL
END
GO

/*
select dbo.FN_EJE_11(5) --0
SELECT DBO.FN_EJE_11(3) --5
SELECT DBO.FN_EJE_11(2) --1
SELECT DBO.FN_EJE_11(1) --8
*/
--SELECT empl_codigo, empl_jefe FROM Empleado


/* Ejercicio 12 ==============================================================================
12. Cree el/los objetos de base de datos necesarios para que nunca un producto
pueda ser compuesto por sí mismo. Se sabe que en la actualidad dicha regla se
cumple y que la base de datos es accedida por n aplicaciones de diferentes tipos
y tecnologías. No se conoce la cantidad de niveles de composición existentes.
*/

-- ESTO INSERTA TODO O NADA
CREATE TRIGGER TR_EJE_12_V1 ON Composicion
FOR INSERT
AS
BEGIN
	IF EXISTS (SELECT * FROM inserted WHERE comp_producto = comp_componente)
	BEGIN
		PRINT 'ERROR: UNO DE LOS PRODUCTOS A INSERTAR ESTA COMPUESTO POR SI MISMO'
		ROLLBACK
	END		
END
GO

-- DANDOLE MAS PROFUNDIDAD A LA COMPOSICION
CREATE TRIGGER TR_EJE_12_V2 ON Composicion
FOR INSERT, UPDATE
AS
BEGIN
	IF (SELECT COUNT(*) FROM deleted) > 0
	BEGIN
		--UPDATE
		/*??????????????????  PREGUNTAR POR MAIL MEJOR - NO ME QUEDA DEL TODO CLARO*/
	END
	ELSE
	BEGIN
		--INSERT
		IF EXISTS (SELECT * FROM inserted WHERE comp_producto = comp_componente)
		BEGIN
			PRINT 'ERROR: UNO DE LOS PRODUCTOS A INSERTAR ESTA COMPUESTO POR SI MISMO'
			ROLLBACK
		END
	END
END
GO


/* Ejercicio 13 ==============================================================================
13. Cree el/los objetos de base de datos necesarios para implantar la siguiente regla
“Ningún jefe puede tener un salario mayor al 20% de las suma de los salarios de
sus empleados totales (directos + indirectos)”. Se sabe que en la actualidad dicha
regla se cumple y que la base de datos es accedida por n aplicaciones de
diferentes tipos y tecnologías
*/

-- ESTE EJERCICIO FUE HECHO POR MATIAS. lO HIZO CON UN TRIGGER FOR UPDATE,INSERT Y LA FN MAS SIMPLIFICADA
-- REVISAR EL VIDEO GRABADO
/*
- SUM(empl)*0.2 > empl.salario
- 
*/


--CREO UNA FUNCION QUE RECIBA UN EMPLEADO Y ME RETORNA el sueldo sumado de todos los subordinados
CREATE FUNCTION FN_AUX_EJE_13_SUM_SUELDO_EMPL (@EMPL_COD NUMERIC(6))
RETURNS DECIMAL(12,2)
AS
BEGIN
	DECLARE @SUM_SUELDO DECIMAL(12,2) = 0
	--CASO BASE
	IF NOT EXISTS (SELECT * FROM Empleado WHERE empl_jefe = @EMPL_COD)
		RETURN 0
	--CASO RECURSIVO
	DECLARE @EMPL_EMPL_COD NUMERIC(6), @EMPL_EMPL_SALARIO DECIMAL(12,2)
	DECLARE CURSOR_SUELDO CURSOR
	FOR (SELECT empl_codigo, empl_salario FROM Empleado WHERE empl_jefe = @EMPL_COD)
	OPEN CURSOR_SUELDO
	FETCH NEXT FROM CURSOR_SUELDO INTO @EMPL_EMPL_COD, @EMPL_EMPL_SALARIO
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SUM_SUELDO = @SUM_SUELDO + @EMPL_EMPL_SALARIO + DBO.FN_AUX_EJE_13_SUM_SUELDO_EMPL(@EMPL_EMPL_COD)
		FETCH NEXT FROM CURSOR_SUELDO INTO @EMPL_EMPL_COD, @EMPL_EMPL_SALARIO
	END
	CLOSE CURSOR_SUELDO
	DEALLOCATE CURSOR_SUELDO

	RETURN @SUM_SUELDO
END
GO
/*
SELECT empl_jefe, empl_codigo, empl_salario FROM Empleado
SELECT DBO.FN_AUX_EJE_13_SUM_SUELDO_EMPL(1) --72200
SELECT DBO.FN_AUX_EJE_13_SUM_SUELDO_EMPL(2) --3500
SELECT DBO.FN_AUX_EJE_13_SUM_SUELDO_EMPL(3) --43700
SELECT DBO.FN_AUX_EJE_13_SUM_SUELDO_EMPL(6) --0
*/
--CREO UN TRIGGER QUE PERMITA HACER UN CONTROL EN EL UPDATE DEL SUELDO DEL EMPLEADO
CREATE TRIGGER TR_EJE_13_V2 ON Empleado
FOR UPDATE
AS
BEGIN
	IF (SELECT COUNT(*) FROM inserted WHERE empl_salario > 0.2*dbo.FN_AUX_EJE_13_SUM_SUELDO_EMPL(empl_codigo)) > 0
	BEGIN
		PRINT 'Un jefe no puede ganar mas del 20% de la suma de  los salarios de sus empleados totales.'
		ROLLBACK
	END
END
GO

--SELECT * FROM Empleado

/* Ejercicio 14 ==============================================================================
14. Agregar el/los objetos necesarios para que si un cliente compra un producto
compuesto a un precio menor que la suma de los precios de sus componentes
que imprima la fecha, que cliente, que productos y a qué precio se realizó la
compra. No se deberá permitir que dicho precio sea menor a la mitad de la suma
de los componentes.
*/

/*
ESTE EJERCICIO FUE CONSULTADO AL PROFE POR MAIL Y ESTOY A LA ESPERA DE LA CORRECCIÓN
*/
CREATE FUNCTION FN_AUX_EJE_14_SUM_COMP (@PROD CHAR(8))
RETURNS DECIMAL(12,2)
AS
BEGIN
	--CASO BASE
	IF NOT EXISTS (SELECT * FROM Composicion WHERE comp_producto = @PROD)
		RETURN (SELECT prod_precio FROM Producto WHERE prod_codigo = @PROD)
	--CASO RECURSIVO
	--RETURN (SELECT SUM(comp_cantidad*dbo.FN_AUX_EJE_14_SUM_COMP(comp_componente)) FROM Composicion WHERE comp_producto = @PROD)
	DECLARE CURSOR_COMP CURSOR
	FOR (SELECT comp_componente, comp_cantidad FROM Composicion WHERE comp_producto = @PROD)
	DECLARE @COMP_COMP CHAR(8), @COMP_CANT DECIMAL(12,2)
	DECLARE @RESULT DECIMAL(12,2) = 0
	OPEN CURSOR_COMP
	FETCH NEXT FROM CURSOR_COMP INTO @COMP_COMP, @COMP_CANT
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @RESULT = @RESULT + @COMP_CANT*DBO.FN_AUX_EJE_14_SUM_COMP(@COMP_COMP)
		FETCH NEXT FROM CURSOR_COMP INTO @COMP_COMP, @COMP_CANT
	END
	CLOSE CURSOR_COMP
	DEALLOCATE CURSOR_COMP
	RETURN @RESULT
END
GO

CREATE TRIGGER TR_EJE_14 ON Item_Factura
FOR INSERT
AS
BEGIN
	IF EXISTS (SELECT * FROM inserted JOIN Composicion ON comp_producto = item_producto WHERE item_precio < DBO.FN_AUX_EJE_14_SUM_COMP(item_producto))
	BEGIN
		IF EXISTS (SELECT * FROM inserted WHERE item_precio < 0.5*DBO.FN_AUX_EJE_14_SUM_COMP(item_producto))
		BEGIN
			ROLLBACK
			DELETE FROM Factura 
			WHERE fact_tipo+fact_sucursal+fact_numero = (SELECT item_tipo+item_sucursal+item_numero 
															FROM inserted GROUP BY item_tipo+item_sucursal+item_numero)
		END
		ELSE
		BEGIN
			DECLARE @FECHA SMALLDATETIME
			DECLARE @CLIENTE CHAR(6)

			SELECT @FECHA=fact_fecha, @CLIENTE=fact_cliente
			FROM Factura WHERE fact_tipo+fact_sucursal+fact_numero=
							(SELECT item_tipo+item_sucursal+item_numero 
								FROM inserted GROUP BY item_tipo+item_sucursal+item_numero)

			PRINT ('FECHA: ' + @FECHA)
			PRINT ('CLIENTE: ' + @CLIENTE)
			DECLARE CURSOR_REPORTE CURSOR 
			FOR (SELECT item_producto, item_precio FROM inserted WHERE item_producto IN (SELECT comp_producto FROM Composicion))
			DECLARE @PROD CHAR(8), @PRECIO DECIMAL(12,2)
			OPEN CURSOR_REPORTE
			FETCH NEXT FROM CURSOR_REPORTE INTO @PROD, @PRECIO
			WHILE @@FETCH_STATUS = 0
			BEGIN
				PRINT ('PROD: ' + @PROD + 'PRECIO: $' + STR(@PRECIO))
				FETCH NEXT FROM CURSOR_REPORTE INTO @PROD, @PRECIO
			END
			CLOSE CURSOR_REPORTE
			DEALLOCATE CURSOR_REPORTE
		END
	END
END
GO


/* Ejercicio 15 ==============================================================================
15. Cree el/los objetos de base de datos necesarios para que el objeto principal
reciba un producto como parametro y retorne el precio del mismo.
Se debe prever que el precio de los productos compuestos sera la sumatoria de
los componentes del mismo multiplicado por sus respectivas cantidades. No se
conocen los nivles de anidamiento posibles de los productos. Se asegura que
nunca un producto esta compuesto por si mismo a ningun nivel. El objeto
principal debe poder ser utilizado como filtro en el where de una sentencia
select.
*/

CREATE FUNCTION FN_EJE_15 (@PROD CHAR(8))
RETURNS DECIMAL(12,2)
AS
BEGIN
	DECLARE @RESULT DECIMAL(12,2) = 0
	IF NOT EXISTS (SELECT * FROM Composicion WHERE comp_producto = @PROD)
	BEGIN
		SET @RESULT = (SELECT prod_precio FROM Producto WHERE prod_codigo = @PROD)
		RETURN @RESULT
	END

	SET @RESULT = @RESULT + (SELECT SUM(comp_cantidad*DBO.FN_EJE_15(comp_componente))
							FROM Composicion 
							WHERE comp_producto = @PROD)

	RETURN @RESULT
END
GO

/* Ejercicio 16 ==============================================================================
16. Desarrolle el/los elementos de base de datos necesarios para que ante una venta
automaticamante se descuenten del stock los articulos vendidos. Se descontaran
del deposito que mas producto poseea y se supone que el stock se almacena
tanto de productos simples como compuestos (si se acaba el stock de los
compuestos no se arman combos)
En caso que no alcance el stock de un deposito se descontara del siguiente y asi
hasta agotar los depositos posibles. En ultima instancia se dejara stock negativo
en el ultimo deposito que se desconto.
*/
/*[OK] Consultado por mail*/

CREATE TRIGGER TR_EJE_16 ON Item_Factura
FOR INSERT
AS
BEGIN
	IF EXISTS (SELECT item_producto
		FROM inserted JOIN STOCK ON item_producto = stoc_producto
		GROUP BY item_producto
		HAVING SUM(item_cantidad) <= 0)
	BEGIN
		ROLLBACK
	END
	ELSE
	BEGIN
		DECLARE @PROD_COD CHAR(8), @PROD_CANT DECIMAL(12,2)
		DECLARE CURSOR_STOCK CURSOR
		FOR SELECT item_producto, item_cantidad FROM inserted
		OPEN CURSOR_STOCK
		FETCH NEXT FROM CURSOR_STOCK INTO @PROD_COD, @PROD_CANT
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @NRO_DEPOSITOS INT = (SELECT COUNT(*) FROM STOCK WHERE stoc_producto = @PROD_COD GROUP BY stoc_producto)
			DECLARE @DEPO_COD CHAR(2), @DEPO_CANT DECIMAL(12,2)
			DECLARE CURSOR_DEPOSITO CURSOR
			FOR SELECT stoc_deposito, stoc_cantidad FROM STOCK WHERE stoc_producto = @PROD_COD AND stoc_cantidad > 0 ORDER BY stoc_cantidad DESC
			OPEN CURSOR_DEPOSITO
			FETCH NEXT FROM CURSOR_DEPOSITO INTO @DEPO_COD, @DEPO_CANT
			WHILE @@FETCH_STATUS = 0 AND @PROD_CANT > 0
			BEGIN
				SET @NRO_DEPOSITOS = @NRO_DEPOSITOS - 1
				IF @NRO_DEPOSITOS = 0
				BEGIN
					UPDATE STOCK 
					SET stoc_cantidad = stoc_cantidad - @PROD_CANT
					WHERE stoc_deposito = @DEPO_COD
					AND stoc_producto = @PROD_COD
				END
				ELSE
				BEGIN
					IF @PROD_CANT > 0
					BEGIN
						IF @PROD_CANT >= @DEPO_CANT
						BEGIN
							UPDATE STOCK SET stoc_cantidad = 0 
							WHERE stoc_producto = @PROD_COD
							AND stoc_deposito = @DEPO_COD

							SET @PROD_CANT = @PROD_CANT - @DEPO_CANT
						END
						ELSE
						BEGIN
							UPDATE STOCK SET stoc_cantidad = stoc_cantidad - @PROD_CANT
							WHERE stoc_producto = @PROD_COD
							AND stoc_deposito = @DEPO_COD 

							SET @PROD_CANT = 0
						END
					END
				END

				FETCH NEXT FROM CURSOR_DEPOSITO INTO @DEPO_COD, @DEPO_CANT
			END
			CLOSE CURSOR_DEPOSITO
			DEALLOCATE CURSOR_DEPOSITO
			
			FETCH NEXT FROM CURSOR_STOCK INTO @PROD_COD, @PROD_CANT
		END
		CLOSE CURSOR_STOCK
		DEALLOCATE CURSOR_STOCK
	END
END
GO



/* Ejercicio 17 ==============================================================================
17. Sabiendo que el punto de reposicion del stock es la menor cantidad de ese objeto
que se debe almacenar en el deposito y que el stock maximo es la maxima
cantidad de ese producto en ese deposito, cree el/los objetos de base de datos
necesarios para que dicha regla de negocio se cumpla automaticamente. No se
conoce la forma de acceso a los datos ni el procedimiento por el cual se
incrementa o descuenta stock
*/

--select * from STOCK

CREATE TRIGGER TR_EJE_17 ON STOCK
FOR UPDATE, INSERT
AS
BEGIN
	IF (SELECT COUNT(*) FROM deleted) > 0
	BEGIN
		IF (SELECT COUNT(*) FROM inserted WHERE stoc_cantidad > stoc_stock_maximo OR stoc_cantidad < stoc_punto_reposicion) > 0
		BEGIN
			PRINT 'NO SE PUEDE UPDETEAR LA INFORMACIÓN'
			ROLLBACK
		END
	END
	ELSE
	BEGIN
		IF (SELECT COUNT(*) FROM inserted WHERE stoc_cantidad > stoc_stock_maximo OR stoc_cantidad < stoc_punto_reposicion) > 0
		BEGIN
			PRINT 'NO SE PUEDE INSERTAR LA INFORMACIÓN'
			ROLLBACK
		END
	END
END
GO

--drop trigger TR_EJE_17


/* Ejercicio 18 ==============================================================================
18. Sabiendo que el limite de credito de un cliente es el monto maximo que se le
puede facturar mensualmente, cree el/los objetos de base de datos necesarios
para que dicha regla de negocio se cumpla automaticamente. No se conoce la
forma de acceso a los datos ni el procedimiento por el cual se emiten las facturas
*/
--select * from Cliente

CREATE TRIGGER TR_EJE_18_V1 ON Factura
FOR INSERT
AS
BEGIN
	IF EXISTS 
	(SELECT I.fact_cliente, YEAR(I.fact_fecha), MONTH(I.fact_fecha), SUM(I.fact_total) 
	FROM inserted I 
	JOIN Cliente ON clie_codigo = I.fact_cliente
	GROUP BY I.fact_cliente, YEAR(I.fact_fecha), MONTH(I.fact_fecha), clie_limite_credito
	HAVING SUM(I.fact_total) + 
			(SELECT SUM(F.fact_total) FROM Factura F WHERE F.fact_cliente = I.fact_cliente 
			AND YEAR(F.fact_fecha) = YEAR(I.fact_fecha)	AND MONTH(F.fact_fecha) = MONTH(I.fact_fecha)
			GROUP BY F.fact_cliente) 
			> clie_limite_credito
	)
	BEGIN
		--PRINT ('ERROR: SE EXCEDIÓ EL LÍMITE DE CRÉDITO DE UN CLIENTE')
		ROLLBACK
	END
END
GO

/*CASO ALTERNATIVO EXPLICADO EN CLASE*/
CREATE TRIGGER TR_EJE_18_V2 ON Factura
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO Factura
	SELECT * 
	FROM inserted WHERE fact_cliente IN 
		(SELECT I.fact_cliente
		FROM inserted I 
		JOIN Cliente ON clie_codigo = I.fact_cliente
		GROUP BY I.fact_cliente, YEAR(I.fact_fecha), MONTH(I.fact_fecha), clie_limite_credito
		HAVING SUM(I.fact_total) + 
				(SELECT SUM(F.fact_total) FROM Factura F WHERE F.fact_cliente = I.fact_cliente 
				AND YEAR(F.fact_fecha) = YEAR(I.fact_fecha)	AND MONTH(F.fact_fecha) = MONTH(I.fact_fecha)
				GROUP BY F.fact_cliente) 
				<= clie_limite_credito
		)
END
GO



/* Ejercicio 19 ==============================================================================
19. Cree el/los objetos de base de datos necesarios para que se cumpla la siguiente
regla de negocio automáticamente “Ningún jefe puede tener menos de 5 años de
antigüedad y tampoco puede tener más del 50% del personal a su cargo
(contando directos e indirectos) a excepción del gerente general”. Se sabe que en
la actualidad la regla se cumple y existe un único gerente general.
*/

--select * from Empleado

CREATE FUNCTION FN_AUX_EJE_19_CONT_EMPL_JEFE (@JEFE NUMERIC(6))
RETURNS DECIMAL(12,2)
AS
BEGIN
	--CASO BASE
	IF NOT EXISTS (SELECT * FROM Empleado WHERE empl_jefe = @JEFE)
		RETURN 0
	--CASO RECURSIVO
	DECLARE @CONT_EMPLEADOS DECIMAL(12,2) = 0
	DECLARE @EMPLEADO NUMERIC(6)
	DECLARE CURSOR_EMPL CURSOR
	FOR SELECT empl_codigo FROM Empleado WHERE empl_jefe = @JEFE
	OPEN CURSOR_EMPL
	FETCH NEXT FROM CURSOR_EMPL INTO @EMPLEADO
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @CONT_EMPLEADOS = @CONT_EMPLEADOS + DBO.FN_AUX_EJE_19_CONT_EMPL_JEFE(@EMPLEADO) + 1
		FETCH NEXT FROM CURSOR_EMPL INTO @EMPLEADO
	END
	CLOSE CURSOR_EMPL
	DEALLOCATE CURSOR_EMPL
	RETURN @CONT_EMPLEADOS
END
GO

CREATE TRIGGER TR_EJE_19 ON Empleado
FOR INSERT, UPDATE
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM deleted)
	BEGIN
		--INSERT
		--VERIFICAR SI EL EMPL_JEFE CUMPLE LA REGLA
		IF EXISTS (SELECT * FROM inserted I
					WHERE DBO.FN_AUX_EJE_19_CONT_EMPL_JEFE(I.empl_jefe)>0.5*((SELECT COUNT(*) FROM Empleado)-1)
					AND GETDATE() < DATEADD(YEAR,5,(SELECT E2.empl_ingreso FROM Empleado E2 WHERE E2.empl_codigo = I.empl_jefe))
				  )
		BEGIN
			ROLLBACK
		END
	END
	ELSE
	BEGIN
		--UPDATE
		--VERIFICAR QUE EL EMPL JEFE CUMPLA LA REGLA
		IF EXISTS (SELECT * FROM inserted I
					WHERE DBO.FN_AUX_EJE_19_CONT_EMPL_JEFE(I.empl_jefe)>0.5*((SELECT COUNT(*) FROM Empleado)-1)
					AND GETDATE() < DATEADD(YEAR,5,(SELECT E2.empl_ingreso FROM Empleado E2 WHERE E2.empl_codigo = I.empl_jefe))
				  )
		BEGIN
			ROLLBACK
		END
	END
END
GO


/* Ejercicio 20 ==============================================================================
20. Crear el/los objeto/s necesarios para mantener actualizadas las comisiones del
vendedor.
El cálculo de la comisión está dado por el 5% de la venta total efectuada por ese
vendedor en ese mes, más un 3% adicional en caso de que ese vendedor haya
vendido por lo menos 50 productos distintos en el mes.
*/

--select * from Empleado

--CONSULTADO AL PROFE
CREATE TRIGGER TR_EJE_20_V1 ON Factura
FOR INSERT, DELETE, UPDATE
AS
BEGIN
	IF EXISTS (SELECT * FROM inserted)
	BEGIN
		--AGREGANDO EL 5% DE LA FACTURACION MENSUAL
		DECLARE @EMPLEADO NUMERIC(6), @ANIO INT, @MES INT
		DECLARE CURSOR_VENDEDOR CURSOR
		FOR
		SELECT I.fact_vendedor, YEAR(I.fact_fecha), MONTH(I.fact_fecha)
		FROM inserted I
		GROUP BY I.fact_vendedor, YEAR(I.fact_fecha), MONTH(I.fact_fecha)
		OPEN CURSOR_VENDEDOR
		FETCH NEXT FROM CURSOR_VENDEDOR INTO @EMPLEADO, @ANIO, @MES
		CLOSE CURSOR_VENDEDOR
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @SUM_TEMPORAL DECIMAL(12,2) =  (SELECT SUM(fact_total) FROM Factura 
													WHERE 
														fact_vendedor = @EMPLEADO AND
														YEAR(fact_fecha) = @ANIO AND
														MONTH(fact_fecha) = @MES)
			UPDATE Empleado
			SET empl_comision = @SUM_TEMPORAL*0.05
							+
								(SELECT CASE
								WHEN (SELECT COUNT(DISTINCT item_producto) 
										FROM Factura
										JOIN Item_Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
										WHERE 
											fact_vendedor = @EMPLEADO AND
											YEAR(fact_fecha) = @ANIO AND
											MONTH(fact_fecha) = @MES) >= 50
								THEN @SUM_TEMPORAL*0.03
								ELSE 0 END)
			WHERE empl_codigo = @EMPLEADO
			FETCH NEXT FROM CURSOR_VENDEDOR INTO @EMPLEADO, @ANIO, @MES
		END
		DEALLOCATE CURSOR_VENDEDOR
	END
	ELSE
	BEGIN
		--ESTA PARTE ES DEL DELETE
		DECLARE @EMPLEADO_D NUMERIC(6), @ANIO_D INT, @MES_D INT
		DECLARE CURSOR_DELETE CURSOR
		FOR
		SELECT D.fact_vendedor, YEAR(D.fact_fecha), MONTH(D.fact_fecha) FROM deleted D
		GROUP BY D.fact_vendedor, YEAR(D.fact_fecha), MONTH(D.fact_fecha)
		OPEN CURSOR_DELETE
		FETCH NEXT FROM CURSOR_DELETE INTO @EMPLEADO_D, @ANIO_D, @MES_D
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @SUM_TEMPORAL_D DECIMAL(12,2) =  (SELECT SUM(fact_total) FROM Factura 
													WHERE 
														fact_vendedor = @EMPLEADO_D AND
														YEAR(fact_fecha) = @ANIO_D AND
														MONTH(fact_fecha) = @MES_D)
			UPDATE Empleado
			SET empl_comision = @SUM_TEMPORAL_D*0.05
							+
								(SELECT CASE
								WHEN (SELECT COUNT(DISTINCT item_producto) 
										FROM Factura
										JOIN Item_Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
										WHERE 
											fact_vendedor = @EMPLEADO_D AND
											YEAR(fact_fecha) = @ANIO_D AND
											MONTH(fact_fecha) = @MES_D) >= 50
								THEN @SUM_TEMPORAL_D*0.03
								ELSE 0 END)
			WHERE empl_codigo = @EMPLEADO_D

			FETCH NEXT FROM CURSOR_DELETE INTO @EMPLEADO_D, @ANIO_D, @MES_D
		END
		CLOSE CURSOR_DELETE
		DEALLOCATE CURSOR_DELETE
	END
END
GO


/* Ejercicio 21 ==============================================================================
21. Desarrolle el/los elementos de base de datos necesarios para que se cumpla
automaticamente la regla de que en una factura no puede contener productos de
diferentes familias. En caso de que esto ocurra no debe grabarse esa factura y
debe emitirse un error en pantalla.
*/
-- El profe lo mostró resuelto como ejemplo de uso de cursores

--SELECT * FROM Familia
CREATE TRIGGER TR_EJE_21_V1 ON Factura
FOR INSERT
AS
BEGIN
	IF EXISTS
	(SELECT I.fact_tipo+I.fact_sucursal+I.fact_numero
	FROM inserted I
	JOIN Item_Factura ITEM1 ON ITEM1.item_tipo+ITEM1.item_sucursal+ITEM1.item_numero=I.fact_tipo+I.fact_sucursal+I.fact_numero
	JOIN Item_Factura ITEM2 ON ITEM2.item_tipo+ITEM2.item_sucursal+ITEM2.item_numero = ITEM1.item_tipo+ITEM1.item_sucursal+ITEM1.item_numero
	JOIN Producto P1 ON P1.prod_codigo = ITEM1.item_producto
	JOIN Producto P2 ON P2.prod_codigo = ITEM2.item_producto
	JOIN Familia FAM1 ON FAM1.fami_id = P1.prod_familia
	JOIN Familia FAM2 ON FAM2.fami_id = P2.prod_familia
	WHERE 
		ITEM2.item_producto > ITEM1.item_producto AND
		FAM2.fami_id > FAM1.fami_id
	GROUP BY 
		I.fact_tipo+I.fact_sucursal+I.fact_numero
	)
	BEGIN
		DELETE  ITEM_D
		FROM Item_Factura AS ITEM_D
		JOIN inserted I ON I.fact_tipo+I.fact_sucursal+I.fact_numero = ITEM_D.item_tipo+ITEM_D.item_sucursal+ITEM_D.item_numero

		ROLLBACK
		PRINT ('ERROR: UNA FACTURA NO PUEDE CONTENER PRODUCTOS DE DIFERENTES FAMILIAS')
	END
END
GO


/*OTRO UNIVERSO ================ DUDA !!!!*/

CREATE TRIGGER TR_EJE_21_V2 ON Item_Factura
FOR INSERT
AS
BEGIN
	IF EXISTS (SELECT I.item_tipo+I.item_sucursal+I.item_numero FROM inserted I 
				JOIN Producto ON prod_codigo = item_producto
				GROUP BY I.item_tipo+I.item_sucursal+I.item_numero
				HAVING COUNT(DISTINCT prod_familia) > 1)
	BEGIN
		DECLARE @FACT_ID CHAR(50)
		DECLARE CURSRO_DELETE CURSOR FOR
		SELECT I.item_tipo+I.item_sucursal+I.item_numero FROM inserted I GROUP BY I.item_tipo+I.item_sucursal+I.item_numero
		OPEN CURSRO_DELETE
		FETCH NEXT FROM CURSRO_DELETE INTO @FACT_ID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DELETE FROM Item_Factura
			WHERE item_tipo+item_sucursal+item_numero = @FACT_ID

			DELETE FROM Factura
			WHERE fact_tipo+fact_sucursal+fact_numero = @FACT_ID

			FETCH NEXT FROM CURSRO_DELETE INTO @FACT_ID
		END
		CLOSE CURSRO_DELETE
		DEALLOCATE CURSRO_DELETE

		ROLLBACK
		PRINT('ERROR: UNA FACTURA NO PUEDE CONTENER PRODUCTOS DE DIFERENTES FAMILIAS')
	END
END
GO


/* Ejercicio 22 ==============================================================================
Se requiere recategorizar los rubros de productos, de forma tal que 
nigun rubro tenga más de 20 productos asignados, 
	si un rubro tiene más de 20 productos asignados se deberan distribuir en otros rubros que no tengan mas de 20 productos 
	y si no entran se debra crear un nuevo rubro en la misma familia con la descirpción “RUBRO REASIGNADO”, 

cree el/los objetos de base de datos necesarios para que dicha regla de negocio quede implementada.
*/

CREATE PROCEDURE PR_EJE_22_V1
AS
BEGIN
	DECLARE @PROD_CODE CHAR(8), @PROD_RUBRO CHAR(4)
	-----
	DECLARE CURSOR_PROD CURSOR FOR 
	SELECT prod_codigo, prod_rubro FROM Producto
		WHERE prod_rubro IN 
		(SELECT P2.prod_rubro FROM Producto P2 GROUP BY P2.prod_rubro HAVING COUNT(P2.prod_codigo) > 20)
	OPEN CURSOR_PROD
	FETCH NEXT FROM CURSOR_PROD INTO @PROD_CODE, @PROD_RUBRO
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Verifico que existan rubros disponibles para asignar
		IF EXISTS (SELECT rubr_id FROM Rubro LEFT JOIN Producto ON prod_rubro = rubr_id 
					GROUP BY rubr_id, rubr_detalle 
					HAVING COUNT(prod_codigo) < 20 AND rubr_detalle <> 'RUBRO REASIGNADO')
		BEGIN
			UPDATE Producto
			SET prod_rubro = (SELECT TOP 1 rubr_id FROM Rubro LEFT JOIN Producto ON prod_rubro = rubr_id 
								GROUP BY rubr_id, rubr_detalle HAVING COUNT(prod_codigo) < 20 AND rubr_detalle <> 'RUBRO REASIGNADO' 
								ORDER BY COUNT(prod_codigo) DESC)
			WHERE prod_codigo = @PROD_CODE
		END
		ELSE
		--En caso de que no haya rubros disponibles para asignar, reasigno al 'RUBRO REASIGNADO'
		BEGIN
			IF NOT EXISTS (SELECT * FROM Rubro WHERE rubr_detalle = 'RUBRO REASIGNADO')
			BEGIN
				INSERT INTO Rubro (rubr_id, rubr_detalle)
				VALUES ('R999','RUBRO REASIGNADO')

				UPDATE Producto
				SET prod_rubro = (SELECT rubr_id FROM Rubro WHERE rubr_detalle = 'RUBRO REASIGNADO')
				WHERE prod_codigo = @PROD_CODE
			END
			ELSE
			BEGIN
				UPDATE Producto
				SET prod_rubro = (SELECT rubr_id FROM Rubro WHERE rubr_detalle = 'RUBRO REASIGNADO')
				WHERE prod_codigo = @PROD_CODE
			END
		END
		FETCH NEXT FROM CURSOR_PROD INTO @PROD_CODE, @PROD_RUBRO
	END
	CLOSE CURSOR_PROD
	DEALLOCATE CURSOR_PROD
END
GO




/* Ejercicio 23 ==============================================================================
Desarrolle el/los elementos de base de datos necesarios para que ante una venta
automaticamante se controle que en una misma factura no puedan venderse más
de dos productos con composición. Si esto ocurre debera rechazarse la factura.
*/

CREATE TRIGGER TR_EJE_23_V1 ON Item_Factura
FOR INSERT
AS
BEGIN
	DECLARE @FACTURA_KEY CHAR(15)
	DECLARE CURSOR_23 CURSOR
	FOR 
	SELECT I.item_tipo+I.item_sucursal+I.item_numero
	FROM inserted I
	GROUP BY I.item_tipo+I.item_sucursal+I.item_numero

	OPEN CURSOR_23
	FETCH NEXT FROM CURSOR_23 INTO @FACTURA_KEY
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF
		(SELECT COUNT(*)
		FROM Item_Factura ITEM2
		WHERE 
			ITEM2.item_tipo+ITEM2.item_sucursal+ITEM2.item_numero = @FACTURA_KEY AND
			ITEM2.item_producto IN (SELECT comp_producto FROM Composicion)
		GROUP BY ITEM2.item_tipo+ITEM2.item_sucursal+ITEM2.item_numero
		) > 2
		BEGIN
			DELETE FACT
			FROM Factura FACT
			WHERE fact_tipo+fact_sucursal+fact_numero = @FACTURA_KEY

			ROLLBACK
		END

		FETCH NEXT FROM CURSOR_23 INTO @FACTURA_KEY
	END
	CLOSE CURSOR_23
	DEALLOCATE CURSOR_23
END
GO



/* Ejercicio 24 ==============================================================================
Se requiere recategorizar los encargados asignados a los depositos. Para ello
cree el o los objetos de bases de datos necesarios que lo resuelva, teniendo en cuenta que 
	un deposito NO puede tener como encargado un empleado que pertenezca a un departamento que no sea de la misma zona que el deposito, 
	si esto ocurre a dicho deposito debera asignársele el empleado con menos depositos asignados que pertenezca a un departamento de esa zona.
*/
/*[OK] Consultado por mail*/

CREATE FUNCTION FN_AUX_EJE_24_ENCARGADO_C_MENOS_DEPO_ASIG_POR_ZONA (@ZONA_CODE CHAR(3))
RETURNS NUMERIC(6)
AS
BEGIN
	RETURN (SELECT TOP 1 depo_encargado
	FROM DEPOSITO
	JOIN Empleado ON empl_codigo = depo_encargado
	JOIN Departamento ON depa_codigo = empl_departamento
	JOIN Zona ON zona_codigo = depa_zona
	WHERE
		depo_zona = zona_codigo AND
		zona_codigo = @ZONA_CODE
	GROUP BY depo_encargado
	ORDER BY COUNT(depo_codigo) ASC)
END
GO


CREATE PROCEDURE PR_EJE_24_V1
AS
BEGIN
	DECLARE @DEPO_COD CHAR(2), @DEPO_ZONA CHAR(3), @EMPL_COD NUMERIC(6)
	DECLARE @EMPL_DEPA NUMERIC(6), @EMPL_ZONA CHAR(3)
	-----
	DECLARE CURSOR_DEPOSITO CURSOR FOR
	SELECT depo_codigo, depo_zona, depo_encargado, depa_codigo, zona_codigo
	FROM DEPOSITO
	JOIN Empleado ON empl_codigo = depo_encargado
	JOIN Departamento ON depa_codigo = empl_departamento
	JOIN Zona ON zona_codigo = depa_zona
	------
	OPEN CURSOR_DEPOSITO
	FETCH NEXT FROM CURSOR_DEPOSITO INTO @DEPO_COD, @DEPO_ZONA, @EMPL_COD, @EMPL_DEPA, @EMPL_ZONA
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF(@DEPO_ZONA <> @EMPL_ZONA)
		BEGIN
			UPDATE DEPOSITO
			SET depo_encargado = DBO.FN_AUX_EJE_24_ENCARGADO_C_MENOS_DEPO_ASIG_POR_ZONA(@DEPO_ZONA)
			WHERE depo_codigo = @DEPO_COD
		END

		FETCH NEXT FROM CURSOR_DEPOSITO INTO @DEPO_COD, @DEPO_ZONA, @EMPL_COD, @EMPL_DEPA, @EMPL_ZONA
	END
	CLOSE CURSOR_DEPOSITO
	DEALLOCATE CURSOR_DEPOSITO
END
GO

/*---------------------------------------------------
Esta parte flasheo para tratar de hacerlo SIN CURSOR
Esta parte no esta revisada por el profe*/
CREATE PROCEDURE PR_EJE_24_V2
AS
BEGIN
	UPDATE DEPO
	SET depo_encargado = DBO.FN_AUX_EJE_24_ENCARGADO_C_MENOS_DEPO_ASIG_POR_ZONA(DEPO.depo_zona)
	FROM DEPOSITO DEPO
	JOIN Empleado ON empl_codigo = depo_encargado
	JOIN Departamento ON depa_codigo = empl_departamento
	JOIN Zona ON zona_codigo = depa_zona
	WHERE DEPO.depo_zona <> zona_codigo
END
GO --Creo que no cumple su fuincion adecuadamente xq no estaría actualizando en tiempo real los depositos asignados por encargado




/* Ejercicio 25 ==============================================================================
Desarrolle el/los elementos de base de datos necesarios para que no se permita
que la composición de los productos sea recursiva, o sea, que si el producto A
compone al producto B, dicho producto B no pueda ser compuesto por el
producto A, hoy la regla se cumple.
*/
/*[OK] Consultado por mail*/

CREATE FUNCTION FN_AUX_EJE_25_EXPLORAR_CON_RESTRICCION_DE_COMPOSICION (@B_PADRE CHAR(8), @B_RESTRICCION CHAR(8))
RETURNS INT
AS
BEGIN
	DECLARE @RESULT INT = 0
	------
	--CASO BASE
	IF NOT EXISTS (SELECT * FROM Composicion WHERE comp_producto = @B_PADRE)
		SET @RESULT = 0
	--CASO RECURSIVO
	ELSE
	BEGIN
		DECLARE @COMP_A_EVALUAR CHAR(8)
		--
		DECLARE CURSRO_EXPLORER CURSOR FOR
		SELECT comp_componente FROM Composicion WHERE comp_producto = @B_PADRE
		--
		OPEN CURSRO_EXPLORER
		FETCH NEXT FROM CURSRO_EXPLORER INTO @COMP_A_EVALUAR
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @COMP_A_EVALUAR = @B_RESTRICCION
			BEGIN
				SET @RESULT = 1
				BREAK
			END
			ELSE
			BEGIN
				IF DBO.FN_AUX_EJE_25_EXPLORAR_CON_RESTRICCION_DE_COMPOSICION(@COMP_A_EVALUAR, @B_RESTRICCION) > 0
				BEGIN
					SET @RESULT = 1
					BREAK
				END
			END
			
			FETCH NEXT FROM CURSRO_EXPLORER INTO @COMP_A_EVALUAR
		END
		CLOSE CURSRO_EXPLORER
		DEALLOCATE CURSRO_EXPLORER
	END
	------
	RETURN @RESULT
END
GO

CREATE TRIGGER TR_EJE_25_V1 ON Composicion
FOR INSERT
AS
BEGIN
	IF EXISTS (SELECT * FROM inserted I WHERE DBO.FN_AUX_EJE_25_EXPLORAR_CON_RESTRICCION_DE_COMPOSICION(I.comp_componente, I.comp_producto) > 0)
	BEGIN
		ROLLBACK
	END
END
GO


/* Ejercicio 26 ==============================================================================
Desarrolle el/los elementos de base de datos necesarios para que se cumpla
automaticamente la regla de que una factura no puede contener productos que
sean componentes de otros productos. En caso de que esto ocurra no debe
grabarse esa factura y debe emitirse un error en pantalla.
*/

CREATE TRIGGER TR_EJE_26_V1 ON Item_Factura FOR INSERT
AS
BEGIN
	IF EXISTS (SELECT * FROM inserted I WHERE I.item_producto IN (SELECT comp_componente FROM Composicion))
	BEGIN
		DELETE ITEM
		FROM Item_Factura ITEM
		WHERE ITEM.item_tipo+ITEM.item_sucursal+ITEM.item_numero IN
			(SELECT I.item_tipo+I.item_sucursal+I.item_numero FROM inserted I GROUP BY I.item_tipo+I.item_sucursal+I.item_numero)
		-------
		DELETE FACT
		FROM Factura FACT
		WHERE FACT.fact_tipo+FACT.fact_sucursal+FACT.fact_numero IN 
			(SELECT I.item_tipo+I.item_sucursal+I.item_numero FROM inserted I GROUP BY I.item_tipo+I.item_sucursal+I.item_numero)
		-------
		ROLLBACK
	END
END
GO
--DROP TRIGGER TR_EJE_26_V1


/* Ejercicio 27 ==============================================================================
Se requiere reasignar los encargados de stock de los diferentes depósitos. Para
ello se solicita que realice el o los objetos de base de datos necesarios para
asignar a cada uno de los depósitos el encargado que le corresponda,
entendiendo que el encargado que le corresponde es cualquier empleado que no
es jefe y que no es vendedor, o sea, que no está asignado a ningun cliente,
 
se deberán ir asignando tratando de que un empleado solo tenga un deposito
asignado, en caso de no poder se irán aumentando la cantidad de depósitos
progresivamente para cada empleado.
*/

--select * from Empleado
CREATE PROCEDURE PR_EJE_27_V1
AS
BEGIN
	DECLARE @DEPO_COD CHAR(2), @DEPO_ENCARGADO NUMERIC(6)
	DECLARE CURSOR_DEPSITOS CURSOR FOR
	SELECT depo_codigo, depo_encargado FROM DEPOSITO
	--
	OPEN CURSOR_DEPSITOS
	FETCH NEXT FROM CURSOR_DEPSITOS INTO @DEPO_COD, @DEPO_ENCARGADO
	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE DEPOSITO
		SET depo_encargado = (SELECT TOP 1 empl_codigo 
								FROM Empleado LEFT JOIN DEPOSITO ON depo_encargado = empl_codigo 
								WHERE empl_tareas <> 'Vendedor' AND empl_tareas NOT LIKE '%Jefe%' 
								GROUP BY empl_codigo
								ORDER BY COUNT(depo_codigo))
		WHERE depo_codigo = @DEPO_COD

		FETCH NEXT FROM CURSOR_DEPSITOS INTO @DEPO_COD, @DEPO_ENCARGADO
	END
	CLOSE CURSOR_DEPSITOS
	DEALLOCATE CURSOR_DEPSITOS
END
GO

--select empl_tareas from DEPOSITO join Empleado on empl_codigo = depo_encargado group by empl_tareas

/* Ejercicio 28 ==============================================================================
Se requiere reasignar los vendedores a los clientes. Para ello se solicita que
realice el o los objetos de base de datos necesarios para asignar a cada uno de los
clientes el vendedor que le corresponda, entendiendo que el vendedor que le
corresponde es aquel que le vendió más facturas a ese cliente, si en particular un
cliente no tiene facturas compradas se le deberá asignar el vendedor con más
venta de la empresa, o sea, el que en monto haya vendido más.
*/

CREATE PROCEDURE PR_EJE_28_V1
AS
BEGIN
	UPDATE CLIE
	SET CLIE.clie_vendedor = (SELECT CASE
							WHEN EXISTS (SELECT * FROM Factura WHERE fact_cliente = CLIE.clie_codigo)
							THEN (SELECT TOP 1 fact_vendedor FROM Factura WHERE fact_cliente = CLIE.clie_codigo 
										GROUP BY fact_vendedor ORDER BY COUNT(DISTINCT fact_tipo+fact_sucursal+fact_numero) DESC)
							ELSE (SELECT TOP 1 fact_vendedor FROM Factura GROUP BY fact_vendedor ORDER BY SUM(fact_total) DESC) END)
	FROM Cliente CLIE
END
GO


/* Ejercicio 29 ==============================================================================
Desarrolle el/los elementos de base de datos necesarios para que se cumpla
automaticamente la regla de que una factura no puede contener productos que
sean componentes de diferentes productos. En caso de que esto ocurra no debe
grabarse esa factura y debe emitirse un error en pantalla.
*/

CREATE TRIGGER TR_EJE_29_V2 ON Item_Factura FOR INSERT
AS
BEGIN
	IF EXISTS (SELECT * FROM inserted I WHERE (SELECT SUM(1) FROM Composicion WHERE comp_componente = I.item_producto) > 1)
	BEGIN
		DELETE FROM Factura
		WHERE fact_tipo+fact_sucursal+fact_numero IN
		(SELECT I.item_tipo+I.item_sucursal+I.item_numero FROM inserted I GROUP BY I.item_tipo+I.item_sucursal+I.item_numero)

		DELETE FROM Item_Factura
		WHERE item_tipo+item_sucursal+item_numero IN
		(SELECT I.item_tipo+I.item_sucursal+I.item_numero FROM inserted I GROUP BY I.item_tipo+I.item_sucursal+I.item_numero)

		ROLLBACK
		PRINT ('ERROR: UNA FACTURA NO PUEDE CONTENER PRODUCTOS QUE SEAN COMPONENTES DE DIFERENTES PRODUCTOS')
	END
END
GO



---------------------------------------------------------------------------------------
--Cuenta lo cantidad de deiferentes productos que tienen como compenente a uno en especifico
CREATE FUNCTION FN_AUX_EJE_29_CANT_PROD_COMP_DIF_AL_Q_PERTENECE (@PROD_COMP CHAR(8))
RETURNS INT
AS
BEGIN
	DECLARE @CONTADOR INT = 0
	DECLARE @PROD_PADRE CHAR(8)
	DECLARE CURSOR_COMP CURSOR FOR
	SELECT comp_producto FROM Composicion WHERE comp_componente = @PROD_COMP GROUP BY comp_producto
	--
	OPEN CURSOR_COMP
	FETCH NEXT FROM CURSOR_COMP INTO @PROD_PADRE
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @CONTADOR = @CONTADOR + 1
		FETCH NEXT FROM CURSOR_COMP INTO @PROD_PADRE
	END
	CLOSE CURSOR_COMP
	DEALLOCATE CURSOR_COMP

	RETURN @CONTADOR
END
GO

CREATE TRIGGER TR_EJE_29_V1 ON Item_Factura FOR INSERT
AS
BEGIN
	IF EXISTS (SELECT * FROM inserted I WHERE DBO.FN_AUX_EJE_29_CANT_PROD_COMP_DIF_AL_Q_PERTENECE(I.item_producto) > 1)
	BEGIN
		DELETE FROM Factura 
		WHERE fact_tipo+fact_sucursal+fact_numero IN
			(SELECT I.item_tipo+I.item_sucursal+I.item_numero FROM inserted I GROUP BY I.item_tipo+I.item_sucursal+I.item_numero)

		DELETE FROM Item_Factura 
		WHERE item_tipo+item_sucursal+item_numero IN
			(SELECT I.item_tipo+I.item_sucursal+I.item_numero FROM inserted I GROUP BY I.item_tipo+I.item_sucursal+I.item_numero)

		ROLLBACK
		PRINT ('ERROR: UNA FACTURA NO PUEDE CONTENER PRODUCTOS QUE SEAN COMPONENTES DE DIFERENTES PRODUCTOS')
	END
END
GO

--DROP TRIGGER TR_EJE_29_V1


/* Ejercicio 30 ==============================================================================
30. Agregar el/los objetos necesarios para crear una regla por la cual un cliente no
pueda comprar más de 100 unidades en el mes de ningún producto, si esto
ocurre no se deberá ingresar la operación y se deberá emitir un mensaje “Se ha
superado el límite máximo de compra de un producto”. Se sabe que esta regla se
cumple y que las facturas no pueden ser modificadas.
*/

/* Contemplar cuando se hayan ingresado de una misma factura items correctamente y en otra transaccion futura de la misma factura,
debería borrar toda la factura, inluyendo los item guardados anteriormente de la misma factura */

CREATE TRIGGER TR_EJE_30 ON Item_Factura
FOR INSERT
AS
BEGIN
	IF EXISTS
	(SELECT I.item_producto, F.fact_cliente, YEAR(F.fact_fecha), MONTH(F.fact_fecha) 
	FROM inserted I
	JOIN Factura F ON F.fact_tipo+F.fact_sucursal+F.fact_numero = I.item_tipo+I.item_sucursal+I.item_numero
	GROUP BY I.item_producto, F.fact_cliente, YEAR(F.fact_fecha), MONTH(F.fact_fecha)
	HAVING SUM(I.item_cantidad) +
			(SELECT SUM(ITEM2.item_cantidad) FROM Factura F2 
				JOIN Item_Factura ITEM2 ON F2.fact_tipo+F2.fact_sucursal+F2.fact_numero = ITEM2.item_tipo+ITEM2.item_sucursal+ITEM2.item_numero
				WHERE ITEM2.item_producto = I.item_producto
				AND YEAR(F2.fact_fecha) = YEAR(F.fact_fecha)
				AND MONTH(F2.fact_fecha) = MONTH(F.fact_fecha)
				AND F2.fact_cliente = F.fact_cliente
				GROUP BY ITEM2.item_producto)
			> 100
	)
	BEGIN
		--BORRAR TODOS LOS ITEMS DE LA MISMA FACTURA Q SI SE HAYAN GUARDADO EN OTRA TRANSACCION ANTERIOR
		--BASICAMENTE EL PROFE ASUME QUE SE MANDAN A GRABAR LOS PRODUCTOS DE LA MISMA FACTURA POR SEPARADO (UNO X UNO)
		--BORRA INCLUSO SI ENTRAN ITEMS DE DIFERENTES FACTURAS
		DELETE FROM Item_Factura
		WHERE item_tipo+item_sucursal+item_numero IN 
		(SELECT I.item_tipo+I.item_sucursal+I.item_numero FROM inserted I)

		--BORRAR LA CABECERA LA FACTURA, PARA QUE NO QUEDE VACÍA
		DELETE FROM Factura
		WHERE fact_tipo+fact_sucursal+fact_numero IN
		(SELECT I.item_tipo+I.item_sucursal+I.item_numero FROM inserted I)

		ROLLBACK
	END
END
GO



/* Ejercicio 31 ==============================================================================
Desarrolle el o los objetos de base de datos necesarios, para que un jefe no pueda
tener más de 20 empleados a cargo, directa o indirectamente, si esto ocurre
debera asignarsele un jefe que cumpla esa condición, si no existe un jefe para
asignarle se le deberá colocar como jefe al gerente general que es aquel que no
tiene jefe.
*/
/*
select * from Empleado
select SUM(empl_comision+10) from Empleado
SELECT *,empl_comision+10 FROM Empleado
select SUM(1) from Empleado
GO
*/
CREATE FUNCTION FN_AUX_EJE_31_CANT_EMPLEADOS_A_CARGO (@JEFE NUMERIC(6))
RETURNS INT
AS
BEGIN
	RETURN (
		SELECT CASE
		--CASO BASE
		WHEN NOT EXISTS (SELECT * FROM Empleado GROUP BY empl_jefe HAVING empl_jefe = @JEFE)
		THEN (0)
		--CASO RECURSIVO
		ELSE (
			SELECT SUM(1+DBO.FN_AUX_EJE_31_CANT_EMPLEADOS_A_CARGO(empl_codigo)) FROM Empleado WHERE empl_jefe = @JEFE
		) END
	)
END
GO

CREATE TRIGGER TR_EJE_31 ON Empleado FOR INSERT, UPDATE
AS
BEGIN
	UPDATE EMPL
	SET EMPL.empl_jefe = (SELECT CASE
							WHEN EXISTS (SELECT EMPL2.empl_jefe FROM Empleado EMPL2 GROUP BY EMPL2.empl_jefe 
										HAVING DBO.FN_AUX_EJE_31_CANT_EMPLEADOS_A_CARGO(EMPL2.empl_jefe) < 20 AND 
											EMPL2.empl_jefe NOT IN (SELECT EMPL3.empl_codigo FROM Empleado EMPL3 WHERE EMPL3.empl_jefe IS NULL))
							THEN (SELECT TOP 1 EMPL2.empl_jefe FROM Empleado EMPL2 GROUP BY EMPL2.empl_jefe 
										HAVING DBO.FN_AUX_EJE_31_CANT_EMPLEADOS_A_CARGO(EMPL2.empl_jefe) < 20 AND 
											EMPL2.empl_jefe NOT IN (SELECT EMPL3.empl_codigo FROM Empleado EMPL3 WHERE EMPL3.empl_jefe IS NULL))
							ELSE (SELECT TOP 1 EMPL4.empl_codigo FROM Empleado EMPL4 WHERE EMPL4.empl_jefe IS NULL) END
						)
	FROM Empleado EMPL
	JOIN inserted I ON I.empl_codigo = EMPL.empl_codigo
	WHERE 
		DBO.FN_AUX_EJE_31_CANT_EMPLEADOS_A_CARGO(I.empl_jefe) > 20 AND
		EMPL.empl_jefe IS NOT NULL
END
GO


