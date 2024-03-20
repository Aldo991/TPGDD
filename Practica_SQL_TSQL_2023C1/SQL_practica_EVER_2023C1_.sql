/* Ejercicio 1 ==============================================================================
1. Mostrar el código, razón social de todos los clientes cuyo límite de crédito sea mayor o
igual a $ 1000 ordenado por código de cliente.
*/

select 
	clie_codigo,
	clie_razon_social
from Cliente
where clie_limite_credito >= 1000
order by 1

select * from Cliente


/*Ejercicio 2==============================================================================
2. Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por
cantidad vendida.
*/

select 
	item_producto CÓDIGO,
	(select prod_detalle from Producto where prod_codigo = item_producto) DETALLE,
	SUM(item_cantidad)
from Item_Factura
JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
where YEAR(fact_fecha) = 2012
group by item_producto
order by SUM(item_cantidad) DESC


/* Ejercicio 3 ==============================================================================
3. Realizar una consulta que muestre código de producto, nombre de producto y el stock
total, sin importar en que deposito se encuentre, los datos deben ser ordenados por
nombre del artículo de menor a mayor.
*/

select
	prod_codigo,
	prod_detalle,
	ISNULL((select
		SUM(stoc_cantidad)
		from STOCK
		where stoc_producto = prod_codigo
		group by stoc_producto),0) STOCK_TOTAL
from Producto
group by prod_codigo, prod_detalle
order by 2


/* Ejercicio 4 ==============================================================================
4. Realizar una consulta que muestre para todos los artículos código, detalle y cantidad de
artículos que lo componen. Mostrar solo aquellos artículos para los cuales el stock
promedio por depósito sea mayor a 100.
*/

select 
	prod_codigo,
	prod_detalle,
	ISNULL(COUNT(comp_componente),0) CANTIDAD_COMPOSICIÓN
from Producto
LEFT JOIN Composicion ON comp_producto = prod_codigo
where prod_codigo IN
	(select stoc_producto
	from STOCK
	group by stoc_producto
	having AVG(stoc_cantidad) > 100)
group by prod_codigo, prod_detalle
order by 3 DESC


/* Ejercicio 5 ==============================================================================
5. Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos de
stock que se realizaron para ese artículo en el año 2012 (egresan los productos que
fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011.
*/

select
	prod_codigo,
	prod_detalle,
	SUM(item_cantidad) CANT_EGRESOS_2012
from Producto JOIN Item_Factura ON item_producto = prod_codigo
JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
where YEAR(fact_fecha) = 2012
group by prod_codigo, prod_detalle
having SUM(item_cantidad) > 
	(select SUM(item_cantidad) from Item_Factura
	JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
	where item_producto = prod_codigo AND YEAR(fact_fecha) = 2011
	group by item_producto)


/* Ejercicio 6 ==============================================================================
6. Mostrar para todos los rubros de artículos código, detalle, cantidad de artículos de ese
rubro y stock total de ese rubro de artículos. Solo tener en cuenta aquellos artículos que
tengan un stock mayor al del artículo ‘00000000’ en el depósito ‘00’.
*/

select
	rubr_id CODIGO,
	rubr_detalle DETALLE,
	COUNT(distinct prod_codigo) ARTÍCULOS_X_RUBRO,
	SUM(stoc_cantidad) STOCK_TOTAL_RUBRO
from Rubro LEFT JOIN Producto ON prod_rubro = rubr_id
JOIN STOCK ON stoc_producto = prod_codigo
where 
	(select SUM(stoc_cantidad) from STOCK
	where stoc_producto = prod_codigo
	group by stoc_producto) 
	> 
	(select stoc_cantidad from STOCK 
	where stoc_producto = '00000000' AND stoc_deposito = '00')
group by rubr_id, rubr_detalle
order by 3 ASC

/* Eje 6 - Otra forma no muy óptima */
select
	rubr_id CÓDIGO,
	rubr_detalle DETALLE,
	ISNULL((
		select COUNT(distinct prod_codigo) from STOCK JOIN Producto as P1 ON prod_codigo = stoc_producto
		where prod_rubro = R1.rubr_id
		AND
		prod_codigo IN 
		(select stoc_producto from STOCK
		group by stoc_producto
		having SUM(stoc_cantidad) > 
				(select SUM(stoc_cantidad) from STOCK 
				where stoc_producto = '00000000' AND
				stoc_deposito = '00'))
	),0) ARTICULOS_X_RUBRO,
	ISNULL((
		select SUM(stoc_cantidad) from STOCK JOIN Producto ON prod_codigo = stoc_producto
		where prod_rubro = R1.rubr_id
		AND
		prod_codigo IN
		(select stoc_producto from STOCK
		group by stoc_producto 
		having SUM(stoc_cantidad) >
				(select SUM(stoc_cantidad) from STOCK
				where stoc_producto = '00000000' AND
				stoc_deposito = '00'))
	),0) STOCK_TOTAL_RUBRO
from Rubro as R1
order by 3 ASC


/* Ejercicio 7 ==============================================================================
7. Generar una consulta que muestre para cada artículo código, detalle, mayor precio
menor precio y % de la diferencia de precios (respecto del menor Ej.: menor precio =
10, mayor precio =12 => mostrar 20 %). 
Mostrar solo aquellos artículos que posean stock.
*/
 /* Considerando a todos lo productos*/
select
	prod_codigo,
	prod_detalle,
	MAX(ISNULL(item_precio, prod_precio)) MAYOR_PRECIO,
	MIN(ISNULL(item_precio, prod_precio)) MENOR_PRECIO,
	CAST((MAX(ISNULL(item_precio, prod_precio))-MIN(ISNULL(item_precio, prod_precio)))*
		100/MIN(ISNULL(item_precio, 1)) AS decimal(10,2)) "%_Diferencia Precio" 
from Producto LEFT JOIN Item_Factura ON item_producto = prod_codigo
group by prod_codigo, prod_detalle
having prod_codigo IN
	(select stoc_producto from STOCK
	group by stoc_producto
	having SUM(stoc_cantidad) > 0)
order by 5 DESC

/*Considerando solo a los productos que se vendieron*/

select
	item_producto,
	prod_detalle,
	MAX(item_precio) 'P. MAYOR',
	MIN(item_precio) 'P. MENOR',
	CAST((MAX(item_precio)-MIN(item_precio))*100/MIN(item_precio) as decimal(10,2)) AS '%',
	STR((MAX(item_precio)-MIN(item_precio))*100/MIN(item_precio), 10,2) + '%' AS '%'
from Item_Factura JOIN Producto ON prod_codigo = item_producto
group by item_producto, prod_detalle
having item_producto IN
	(select stoc_producto from STOCK
	group by stoc_producto
	having SUM(stoc_cantidad) > 0)
order by 5 DESC


/* Ejercicio 8 ==============================================================================
8. Mostrar para el o los artículos que tengan stock en todos los depósitos, nombre del
artículo, stock del depósito que más stock tiene.
*/

select
	prod_detalle as 'NOMBRE DEL ARTÍCULO',
	MAX(stoc_cantidad) as 'STOCK del depósito con mas STOCK'
from STOCK JOIN Producto ON prod_codigo = stoc_producto
group by stoc_producto, prod_detalle
having 
	SUM(stoc_cantidad) > 0
	AND 
	COUNT(stoc_deposito) = (select COUNT(*) from DEPOSITO) - 30


/* Ejercicio 9 ==============================================================================
9. Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del
mismo y la cantidad de depósitos que ambos tienen asignados.
*/

select
	empl_jefe,
	empl_codigo,
	rtrim(empl_nombre) +' '+ rtrim(empl_apellido) as 'Nombre y Apellido',
	COUNT(*) as 'N° Dep. Asignados por Ambos'
from Empleado JOIN DEPOSITO ON depo_encargado = empl_codigo OR depo_encargado = empl_jefe
group by empl_jefe, empl_codigo, rtrim(empl_nombre) +' '+ rtrim(empl_apellido)
order by 2

/* Esto es para comprobar */
select
	empl_jefe,
	empl_codigo,
	rtrim(empl_nombre) +' '+ rtrim(empl_apellido) as 'Nombre y Apellido',
	COUNT(depo_encargado) as 'N° Dep. Asignados'
from Empleado LEFT JOIN DEPOSITO ON depo_encargado = empl_codigo
group by empl_jefe, empl_codigo, rtrim(empl_nombre) +' '+ rtrim(empl_apellido)
order by 2


/* Ejercicio 10 ==============================================================================
10. Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos
vendidos en la historia. 
Además mostrar de esos productos, quien fue el cliente que mayor compra realizo.
*/

select
	prod_codigo as 'CODIGO',
	prod_detalle as 'DETALLE',
	SUM(item_cantidad) as 'TOTAL VENDIDOS',
	(select TOP 1 '['+RTRIM(fact_cliente)+']  '+RTRIM(clie_razon_social)
		from Item_Factura
		JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
		JOIN Cliente ON fact_cliente = clie_codigo
		where item_producto = prod_codigo
		group by '['+RTRIM(fact_cliente)+']  '+RTRIM(clie_razon_social)
		order by SUM(item_cantidad) DESC
	) as 'Cliente que mas compro'
from Item_Factura JOIN Producto ON prod_codigo = item_producto
where 
	item_producto IN 
	(select TOP 10 item_producto from Item_Factura 
	group by item_producto
	order by SUM(item_cantidad) DESC)
	OR
	item_producto IN
	(select TOP 10 item_producto from Item_Factura 
	group by item_producto
	order by SUM(item_cantidad) ASC)
group by prod_codigo, prod_detalle
order by SUM(item_cantidad) DESC


/* Ejercicio 11 ==============================================================================
11. Realizar una consulta que retorne el detalle de la familia, la cantidad diferentes de
productos vendidos y el monto de dichas ventas sin impuestos. Los datos se deberán
ordenar de mayor a menor, por la familia que más productos diferentes vendidos tenga,
solo se deberán mostrar las familias que tengan una venta superior a 20000 pesos para
el año 2012.
*/

select
	FA1.fami_detalle,
	COUNT(distinct item_producto) as 'Cant. Prod. Vendidos',
	CAST(SUM(item_precio*item_cantidad) as decimal(10,2)) as 'Monto Total'
from Familia FA1
JOIN Producto ON prod_familia = FA1.fami_id
JOIN Item_Factura ON item_producto = prod_codigo
group by FA1.fami_id, FA1.fami_detalle
having (
	select SUM(item_cantidad*item_precio) from Item_Factura
	JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
	JOIN Producto ON prod_codigo = item_producto
	where prod_familia = FA1.fami_id AND YEAR(fact_fecha) = 2012
	) > 20000
order by 2 DESC


/* Ejercicio 12 ==============================================================================
12. Mostrar nombre de producto, cantidad de clientes distintos que lo compraron importe
promedio pagado por el producto, cantidad de depósitos en los cuales hay stock del
producto y stock actual del producto en todos los depósitos. Se deberán mostrar
aquellos productos que hayan tenido operaciones en el año 2012 y los datos deberán
ordenarse de mayor a menor por monto vendido del producto.
*/

select
	PD1.prod_detalle,
	COUNT(distinct fact_cliente) as 'N° Cli. Compraron',
	CAST(AVG(item_precio) as decimal(10,2)) as 'AVG Pagado X Producto',
	(select COUNT(stoc_deposito)
		from STOCK 
		where stoc_producto = PD1.prod_codigo AND stoc_cantidad > 0
		group by stoc_producto
		) as 'N° Dep. con Stock',
	(select SUM(stoc_cantidad) 
		from STOCK
		where stoc_producto = PD1.prod_codigo
		group by stoc_producto
		) as 'STOCK TOTAL'
from Producto as PD1
JOIN Item_Factura ON item_producto = PD1.prod_codigo
JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
group by PD1.prod_codigo, PD1.prod_detalle
having PD1.prod_codigo IN
	(select item_producto from Item_Factura
		JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
		where YEAR(fact_fecha) = 2012
		group by item_producto
	)
order by SUM(item_cantidad*item_precio) DESC


/* Ejercicio 13 ==============================================================================
13. Realizar una consulta que retorne para cada producto que posea composición nombre
del producto, precio del producto, precio de la sumatoria de los precios por la cantidad
de los productos que lo componen. Solo se deberán mostrar los productos que estén
compuestos por más de 2 productos y deben ser ordenados de mayor a menor por
cantidad de productos que lo componen.
*/

select
	PP.prod_detalle,
	PP.prod_precio,
	SUM(comp_cantidad*PC.prod_precio)
from Composicion
JOIN Producto PP ON PP.prod_codigo = comp_producto
JOIN Producto PC ON PC.prod_codigo = comp_componente
group by PP.prod_codigo, PP.prod_detalle, PP.prod_precio
having SUM(comp_cantidad) > 2
order by SUM(comp_cantidad) DESC


/* Ejercicio 14 ==============================================================================
14. Escriba una consulta que retorne una estadística de ventas por cliente. Los campos que
debe retornar son:

Código del cliente
Cantidad de veces que compro en el último año
Promedio por compra en el último año
Cantidad de productos diferentes que compro en el último año
Monto de la mayor compra que realizo en el último año

Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en
el último año.
No se deberán visualizar NULLs en ninguna columna
*/

select
	clie_codigo,
	COUNT(fact_tipo+fact_sucursal+fact_numero) as 'N° Compras',
	ISNULL(AVG(fact_total), 0) as 'AVG x Compra',
	ISNULL((select COUNT(distinct item_producto) from Item_Factura
		JOIN Factura ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
		where fact_cliente = clie_codigo AND 
			YEAR(fact_fecha) = (select TOP 1 YEAR(fact_fecha) from Factura group by YEAR(fact_fecha) order by 1 DESC)
		group by fact_cliente
		), 0) as '# Prod. Dif.',
	ISNULL(MAX(fact_total), 0) as 'Compra Máxima'
from Cliente
LEFT JOIN Factura ON fact_cliente = clie_codigo AND
	YEAR(fact_fecha) =
	(select TOP 1 YEAR(fact_fecha) from Factura
	group by YEAR(fact_fecha)
	order by 1 DESC)
group by clie_codigo
order by 2 DESC


/* Ejercicio 15 ==============================================================================
15. Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos
(en la misma factura) más de 500 veces. El resultado debe mostrar el código y
descripción de cada uno de los productos y la cantidad de veces que fueron vendidos
juntos. El resultado debe estar ordenado por la cantidad de veces que se vendieron
juntos dichos productos. Los distintos pares no deben retornarse más de una vez.

Ejemplo de lo que retornaría la consulta:

PROD1  DETALLE1				PROD2	DETALLE2				VECES
1731   MARLBORO KS			1718	PHILIPS MORRIS KS		507
1718   PHILIPS MORRIS KS	1705	PHILIPS MORRIS BOX		10562
*/

select
	IF1.item_producto 'PROD1',
	P1.prod_detalle 'DETALLE1',
	IF2.item_producto 'PROD2',
	P2.prod_detalle 'DETALLE2',
	COUNT(distinct IF1.item_tipo+IF1.item_sucursal+IF1.item_numero) 'VECES'
from Item_Factura IF1
JOIN Item_Factura IF2 ON IF2.item_tipo+IF2.item_sucursal+IF2.item_numero=IF1.item_tipo+IF1.item_sucursal+IF1.item_numero
	AND IF2.item_producto <> IF1.item_producto 
	AND IF2.item_producto > IF1.item_producto
JOIN Producto P1 ON P1.prod_codigo = IF1.item_producto
JOIN Producto P2 ON P2.prod_codigo = IF2.item_producto
group by IF1.item_producto,P1.prod_detalle,IF2.item_producto,P2.prod_detalle
having COUNT(distinct IF1.item_tipo+IF1.item_sucursal+IF1.item_numero) > 500
order by 5


/* Ejercicio 16 ==============================================================================
16. Con el fin de lanzar una nueva campaña comercial para los clientes que menos compran
en la empresa, se pide una consulta SQL que retorne aquellos clientes cuyas ventas son
inferiores a 1/3 del promedio de ventas del producto que más se vendió en el 2012.

Además mostrar
1. Nombre del Cliente
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
3. Código de producto que mayor venta tuvo en el 2012 (en caso de existir más de 1,
mostrar solamente el de menor código) para ese cliente.

Aclaraciones:
La composición es de 2 niveles, es decir, un producto compuesto solo se compone de
productos no compuestos.
Los clientes deben ser ordenados por código de provincia ascendente.
*/

select 
	clie_razon_social 'CLIENTE',
	SUM(item_cantidad) 'T. U. VENDIDAS',
	(select TOP 1 item_producto from Item_Factura
		JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
		where YEAR(fact_fecha) = 2012
			AND fact_cliente = CL1.clie_codigo
		group by item_producto
		order by SUM(item_cantidad) DESC, 1 ASC
	) 'COD_PROD_MAYOR_VENTA_2012'
from Cliente CL1
JOIN Factura ON fact_cliente = clie_codigo
JOIN Item_Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
where YEAR(fact_fecha) = 2012
group by clie_codigo, clie_razon_social
having SUM(item_cantidad*item_precio) < 
	(1/3)*(select TOP 1 AVG(item_cantidad*item_precio) from Item_Factura
			JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
			where YEAR(fact_fecha) = 2012
			group by item_producto
			order by 1 DESC)


/* Ejercicio 17 ==============================================================================
17. Escriba una consulta que retorne una estadística de ventas por año y mes para cada
producto.
La consulta debe retornar:

PERIODO: Año y mes de la estadística con el formato YYYYMM
PROD: Código de producto
DETALLE: Detalle del producto
CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo
VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del periodo
pero del año anterior
CANT_FACTURAS= Cantidad de facturas en las que se vendió el producto en el
periodo

La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por periodo y código de producto.
*/

select 
	ISNULL(RTRIM(YEAR(fact_fecha))+RIGHT('0'+ RTRIM(MONTH(fact_fecha)),2), '------') 'PERIODO',
	prod_codigo 'PROD',
	prod_detalle 'DETALLE',
	ISNULL(SUM(item_cantidad), 0) 'CANTIDAD_VENDIDA',
	ISNULL((select SUM(item_cantidad)
		from Item_Factura
		JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
		where YEAR(fact_fecha) = YEAR(FF.fact_fecha) - 1
			AND MONTH(fact_fecha) = MONTH(FF.fact_fecha)
			AND item_producto = prod_codigo
		group by item_producto
	),0) 'VENTAS_AÑO_ANTERIOR',
	ISNULL(COUNT(fact_tipo+fact_sucursal+fact_numero), 0) 'CANT_FACTURAS'
from Item_Factura
JOIN Producto ON prod_codigo = item_producto 
JOIN Factura FF ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
group by prod_codigo, prod_detalle, YEAR(fact_fecha), MONTH(fact_fecha)
order by 1,2


/* Ejercicio 18 ==============================================================================
18. Escriba una consulta que retorne una estadística de ventas para todos los rubros.

La consulta debe retornar:
DETALLE_RUBRO: Detalle del rubro
VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
PROD1: Código del producto más vendido de dicho rubro
PROD2: Código del segundo producto más vendido de dicho rubro
CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30
días

La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por cantidad de productos diferentes vendidos del rubro.
*/

select
	rubr_detalle 'DETALLE_RUBRO',
	ISNULL(SUM(item_cantidad*item_precio), 0) 'VENTAS',
	ISNULL((select TOP 1 prod_codigo
		from Producto JOIN Item_Factura ON item_producto = prod_codigo
		where prod_rubro = rubr_id
		group by prod_codigo
		order by SUM(item_cantidad) DESC
	), '-') 'PROD1',
	ISNULL((select TOP 1 prod_codigo
		from Producto JOIN Item_Factura ON item_producto = prod_codigo
		where prod_rubro = rubr_id
		group by prod_codigo
		having SUM(item_cantidad) <
			(select TOP 1 SUM(item_cantidad)
			from Producto JOIN Item_Factura ON item_producto = prod_codigo
			where prod_rubro = rubr_id
			group by prod_codigo
			order by SUM(item_cantidad) DESC)
		order by SUM(item_cantidad) DESC
	), '-') 'PROD2',
	ISNULL((select TOP 1 fact_cliente
		from Producto
		JOIN Item_Factura ON item_producto = prod_codigo
		JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
		where prod_rubro = rubr_id 
			AND fact_fecha > (select DATEADD(DAY,-30,MAX(fact_fecha)) from Factura)
		group by fact_cliente
		order by SUM(item_cantidad) DESC
	), '-') 'CLIENTE'
from Rubro
LEFT JOIN Producto ON prod_rubro = rubr_id
LEFT JOIN Item_Factura ON item_producto = prod_codigo
group by rubr_id, rubr_detalle
order by COUNT(distinct item_producto)


/* Ejercicio 19 ==============================================================================
19. En virtud de una recategorizacion de productos referida a la familia de los mismos se
solicita que desarrolle una consulta sql que retorne para todos los productos:

* Codigo de producto
* Detalle del producto
* Codigo de la familia del producto
* Detalle de la familia actual del producto
* Codigo de la familia sugerido para el producto
* Detalla de la familia sugerido para el producto

La familia sugerida para un producto es la que poseen la mayoria de los productos cuyo
detalle coinciden en los primeros 5 caracteres.

En caso que 2 o mas familias pudieran ser sugeridas se debera seleccionar la de menor
codigo. Solo se deben mostrar los productos para los cuales la familia actual sea
diferente a la sugerida

Los resultados deben ser ordenados por detalle de producto de manera ascendente
*/

select
	prod_codigo 'COD_PRODUCTO',
	prod_detalle 'DETALLE_PRODUCTO',
	FAM1.fami_id 'COD_F',
	FAM1.fami_detalle 'DETALLE_F',
	FAM2.fami_id 'COD_F_SUGERIDA',
	FAM2.fami_detalle 'DETALLE_F_SUGERIDA'
from Producto PD1
JOIN Familia FAM1 ON FAM1.fami_id = prod_familia
JOIN Familia FAM2 ON FAM2.fami_id = 
	(select TOP 1 fami_id from Familia
	where LEFT(PD1.prod_detalle, 5) = LEFT(fami_detalle, 5)
	order by 1 ASC)
	AND FAM1.fami_id <> 
	(select TOP 1 fami_id from Familia
	where LEFT(PD1.prod_detalle, 5) = LEFT(fami_detalle, 5)
	order by 1 ASC)
order by 2 ASC


/* Ejercicio 20 ==============================================================================
20. Escriba una consulta sql que retorne un ranking de los mejores 3 empleados del 2012

Se debera retornar:
legajo, nombre y apellido, anio de ingreso, puntaje 2011, puntaje 2012. 

El puntaje de cada empleado se calculara de la siguiente manera: 
* para los que hayan vendido al menos 50 facturas el puntaje se calculara como la cantidad de facturas
que superen los 100 pesos que haya vendido en el año, 
* para los que tengan menos de 50 facturas en el año el calculo del puntaje sera el 50% de cantidad 
de facturas realizadas por sus subordinados directos en dicho año.
*/

select TOP 3
	empl_codigo 'LEGAJO',
	RTRIM(empl_nombre)+' '+RTRIM(empl_apellido) 'NOMBRE_Y_APELLIDO',
	YEAR(empl_ingreso) 'AÑO_INGRESO',
	(select 
		CASE
			when COUNT(fact_tipo+fact_sucursal+fact_numero) >= 50
				then (select COUNT(fact_tipo+fact_sucursal+fact_numero)
					from Factura
					where fact_vendedor = EMP2011.empl_codigo
						AND YEAR(fact_fecha) = 2011
						AND fact_total > 100)
			else (select COUNT(fact_tipo+fact_sucursal+fact_numero)/2
				from Factura
				JOIN Empleado ON fact_vendedor = empl_codigo
				where empl_jefe = EMP2011.empl_codigo
					AND YEAR(fact_fecha) = 2011)
		END 
		from Empleado EMP2011
		JOIN Factura ON fact_vendedor = empl_codigo
		where EMP2011.empl_codigo = EMP1.empl_codigo
			AND YEAR(fact_fecha) = 2011
		group by EMP2011.empl_codigo
	) '2011',
	CASE
		when COUNT(fact_tipo+fact_sucursal+fact_numero) >= 50
			THEN (select COUNT(fact_tipo+fact_sucursal+fact_numero) 
				from Factura
				where fact_vendedor = EMP1.empl_codigo
				AND YEAR(fact_fecha) = 2012
				AND fact_total > 100)
		else (select COUNT(*)/2
			from Empleado 
			JOIN Factura ON fact_vendedor = empl_codigo
			where empl_jefe = EMP1.empl_codigo
				AND YEAR(fact_fecha) = 2012)
	END '2012'
from Empleado EMP1
JOIN Factura ON fact_vendedor = empl_codigo
where YEAR(fact_fecha) = 2012
group by empl_codigo, empl_apellido, empl_nombre, empl_ingreso
order by 5 DESC


/* Ejercicio 21 ==============================================================================
21. Escriba una consulta sql que retorne para todos los años, en los cuales se haya hecho al
menos una factura, la cantidad de clientes a los que se les facturo de manera incorrecta
al menos una factura y que cantidad de facturas se realizaron de manera incorrecta. Se
considera que una factura es incorrecta cuando la diferencia entre el total de la factura
menos el total de impuesto tiene una diferencia mayor a $ 1 respecto a la sumatoria de
los costos de cada uno de los items de dicha factura. Las columnas que se deben mostrar
son:
* Año
* Clientes a los que se les facturo mal en ese año
* Facturas mal realizadas en ese año
*/

select
	YEAR(fact_fecha) 'YEAR',
	COUNT(distinct fact_cliente) 'N°_CLI_MAL_FACTURADOS',
	COUNT(fact_cliente) 'N°_FACTURAS_MAL_HECHAS'
from Factura FC1
where 
	fact_total - fact_total_impuestos - 
	(select SUM(item_cantidad*item_precio) from Item_Factura
	where item_tipo+item_sucursal+item_numero = FC1.fact_tipo+FC1.fact_sucursal+FC1.fact_numero)
	> 1
group by YEAR(fact_fecha)
order by 1 


/* Ejercicio 22 ==============================================================================
22. Escriba una consulta sql que retorne una estadistica de venta para todos los rubros por
trimestre contabilizando todos los años. Se mostraran como maximo 4 filas por rubro (1
por cada trimestre).

Se deben mostrar 4 columnas:

* Detalle del rubro
* Numero de trimestre del año (1 a 4)
* Cantidad de facturas emitidas en el trimestre en las que se haya vendido al menos un producto del rubro
* Cantidad de productos diferentes del rubro vendidos en el trimestre

El resultado debe ser ordenado alfabeticamente por el detalle del rubro y dentro de cada
rubro primero el trimestre en el que mas facturas se emitieron.

No se deberan mostrar aquellos rubros y trimestres para los cuales las facturas emitiadas
no superen las 100.

En ningun momento se tendran en cuenta los productos compuestos para esta
estadistica.
*/

select 
	rubr_detalle 'RUBRO',
	DATEPART(QUARTER,fact_fecha) 'TRIMESTRE',
	COUNT(item_tipo+item_sucursal+item_numero) '#_FACT_EMITIDAS',
	COUNT(distinct prod_codigo) '#_PROD_VENDIDOS'
from Rubro R1
JOIN Producto ON prod_rubro = rubr_id
JOIN Item_Factura ON item_producto = prod_codigo
JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
group by rubr_id, rubr_detalle, DATEPART(QUARTER,fact_fecha)
having COUNT(item_tipo+item_sucursal+item_numero) >= 100
order by 1 ASC, 3 DESC


/* Ejercicio 23 ==============================================================================
23. Realizar una consulta SQL que para cada año muestre :

* Año
* El producto con composición más vendido para ese año.
* Cantidad de productos que componen directamente al producto más vendido
* La cantidad de facturas en las cuales aparece ese producto.
* El código de cliente que más compro ese producto.
* El porcentaje que representa la venta de ese producto respecto al total de venta del año.

El resultado deberá ser ordenado por el total vendido por año en forma descendente.
*/

select
	YEAR(fact_fecha) 'AÑO',
	item_producto 'PRODUCTO MAS VENDIDO',
	(select COUNT(*) from Composicion where comp_producto = item_producto) '#_PROD_COMPONEN',
	COUNT(distinct item_tipo+item_sucursal+item_numero) '#_FC_PROD_MAS_VENDIDO',
	(select TOP 1 fact_cliente from Factura 
		JOIN Item_Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
		where YEAR(fact_fecha) = YEAR(FC1.fact_fecha)
		AND item_producto = IFC1.item_producto
		group by fact_cliente
		order by COUNT(distinct fact_tipo+fact_sucursal+fact_numero) DESC
	) 'CLIENTE_MAS_COMPRÓ',
	RTRIM( COUNT(distinct item_tipo+item_sucursal+item_numero)*100/
		(select COUNT(distinct fact_tipo+fact_sucursal+fact_numero) from Item_Factura
			JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
			where YEAR(fact_fecha) = YEAR(FC1.fact_fecha)
	)) + '%' '%_TOTAL_VENTAS_ANUALES'
from Factura FC1
JOIN Item_Factura IFC1 ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
JOIN Composicion ON item_producto = comp_producto
group by YEAR(FC1.fact_fecha),item_producto
having item_producto IN 
	(select TOP 1 comp_producto from Composicion
	JOIN Item_Factura ON item_producto = comp_producto
	JOIN Factura FC1 ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
	where YEAR(fact_fecha) = YEAR(FC1.fact_fecha)
	group by comp_producto
	order by COUNT(distinct item_tipo+item_sucursal+item_numero) DESC
	)


/* Ejercicio 24 ==============================================================================
24. Escriba una consulta que considerando solamente las facturas correspondientes a los
dos vendedores con mayores comisiones, retorne los productos con composición
facturados al menos en cinco facturas,

La consulta debe retornar las siguientes columnas:

* Código de Producto
* Nombre del Producto
* Unidades facturadas

El resultado deberá ser ordenado por las unidades facturadas descendente.
*/

select
	prod_codigo 'CODIGO',
	prod_detalle 'DETALLE',
	COUNT(distinct fact_tipo+fact_sucursal+fact_numero) 'U_FACTURADAS'
from Factura
JOIN Empleado ON empl_codigo = fact_vendedor
JOIN Item_Factura ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
JOIN Composicion ON comp_producto = item_producto
JOIN Producto ON prod_codigo = comp_producto
where fact_vendedor IN
	(select TOP 2 empl_codigo from Empleado order by empl_comision DESC)
group by prod_codigo, prod_detalle
having COUNT(distinct fact_tipo+fact_sucursal+fact_numero) >= 5
order by 3 DESC


/* Ejercicio 25 ==============================================================================
25. Realizar una consulta SQL que para cada año y familia muestre :

a. Año
b. El código de la familia más vendida en ese año.
c. Cantidad de Rubros que componen esa familia.
d. Cantidad de productos que componen directamente al producto más vendido de
esa familia.
e. La cantidad de facturas en las cuales aparecen productos pertenecientes a esa
familia.
f. El código de cliente que más compro productos de esa familia.
g. El porcentaje que representa la venta de esa familia respecto al total de venta
del año.

El resultado deberá ser ordenado por el total vendido por año y familia en forma
descendente.
*/

select
	YEAR(FC1.fact_fecha) 'AÑO',
	P1.prod_familia 'FAMILIA_MAS_VENDIDA',
	(select COUNT(distinct rubr_id) from Producto
		JOIN Familia ON fami_id = prod_familia
		JOIN Rubro ON rubr_id = prod_rubro
		where fami_id = P1.prod_familia
	) '#_RUBROS',
	(select COUNT(*) from Composicion
		where comp_producto = 
			(select TOP 1 prod_codigo from Producto
			JOIN Item_Factura ON item_producto = prod_codigo
			JOIN Factura ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
			where prod_familia = P1.prod_familia
				AND YEAR(fact_fecha) = YEAR(FC1.fact_fecha)
			group by prod_codigo
			order by COUNT(distinct fact_tipo+fact_sucursal+fact_numero) DESC)
	) '#_COMP_DEL_PROD_MAS_VENDIDO',
	COUNT(distinct fact_tipo+fact_sucursal+fact_numero) '#_FACTURAS',
	(select TOP 1 fact_cliente from Item_Factura
		JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
		JOIN Producto ON prod_codigo = item_producto
		where prod_familia = P1.prod_familia
			AND YEAR(fact_fecha) = YEAR(FC1.fact_fecha)
		group by fact_cliente
		order by COUNT(distinct fact_tipo+fact_sucursal+fact_numero) DESC
	) 'CLIENTE_MAS_COMPRÓ',
	RTRIM( COUNT(distinct fact_tipo+fact_sucursal+fact_numero)*100/
		(select COUNT(distinct fact_tipo+fact_sucursal+fact_numero) from Item_Factura
			JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
			JOIN Producto ON prod_codigo = item_producto
		where YEAR(fact_fecha) = YEAR(FC1.fact_fecha))
	) + '%' '[%_VENTAS_TOTALES]'
from Factura FC1
JOIN Item_Factura ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
JOIN Producto P1 ON prod_codigo = item_producto
group by YEAR(FC1.fact_fecha), prod_familia
having prod_familia IN
	(select TOP 1 prod_familia from Item_Factura
	JOIN Factura ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
	JOIN Producto ON prod_codigo = item_producto
	where YEAR(fact_fecha) = YEAR(FC1.fact_fecha)
	group by prod_familia 
	order by COUNT(distinct fact_tipo+fact_sucursal+fact_numero) DESC)
order by 1 DESC, 5 DESC
 

/* Ejercicio 26 ==============================================================================
26. Escriba una consulta sql que retorne un ranking de empleados devolviendo las
siguientes columnas:

* Empleado
* Depósitos que tiene a cargo
* Monto total facturado en el año corriente
* Codigo de Cliente al que mas le vendió
* Producto más vendido
* Porcentaje de la venta de ese empleado sobre el total vendido ese año.

Los datos deberan ser ordenados por venta del empleado de mayor a menor.
*/

select
	empl_codigo 'EMPLEADO',
	(select COUNT(*) from DEPOSITO where depo_encargado = empl_codigo) 'DEPOSITOS',
	ISNULL(SUM(fact_total), 0) 'TOTAL FAC.',
	ISNULL((select TOP 1 fact_cliente from Factura
		where fact_vendedor = empl_codigo
		group by fact_cliente
		order by COUNT(distinct fact_tipo+fact_sucursal+fact_numero) DESC
	), '-') 'CLI. MAS VENDIDO',
	ISNULL((select TOP 1 item_producto from Item_Factura
		JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
		where fact_vendedor = empl_codigo
		group by item_producto
		order by SUM(item_cantidad) DESC
	), '-') 'PROD. MAS VENDIDO',
	RTRIM(ISNULL(CAST(SUM(fact_total)*100/(select SUM(fact_total) from Factura where YEAR(fact_fecha)=2012)
	as decimal(8,2)), 0))+' %' '[%]'
from Empleado E1 LEFT JOIN Factura FC1 ON fact_vendedor = empl_codigo AND YEAR(fact_fecha)=2012
group by empl_codigo
order by SUM(fact_total) DESC



/* Ejercicio 27 ==============================================================================
27. Escriba una consulta sql que retorne una estadística basada en la facturacion por año y
envase devolviendo las siguientes columnas:

* Año
* Codigo de envase
* Detalle del envase
* Cantidad de productos que tienen ese envase
* Cantidad de productos facturados de ese envase
* Producto mas vendido de ese envase
* Monto total de venta de ese envase en ese año
* Porcentaje de la venta de ese envase respecto al total vendido de ese año

Los datos deberan ser ordenados por año y dentro del año por el envase con más
facturación de mayor a menor
*/

select
	YEAR(fact_fecha) 'AÑO',
	enva_codigo 'COD',
	enva_detalle 'DETALLE ENVASE',
	COUNT(distinct prod_codigo) '# PROD.',
	SUM(item_cantidad) '# PROD. FACT.',
	(select TOP 1 item_producto from Item_Factura 
		JOIN Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
		JOIN Producto ON prod_codigo = item_producto
		where YEAR(fact_fecha) = YEAR(FC1.fact_fecha) AND prod_envase = enva_codigo
		group by item_producto
		order by SUM(item_cantidad) DESC
	) 'PRD. MAS VENDIDO',
	SUM(item_cantidad * item_precio)'TOTAL VENTA',
	RTRIM(CAST(SUM(item_cantidad * item_precio)*100/
		(select SUM(fact_total-fact_total_impuestos) from Factura where YEAR(fact_fecha) = YEAR(FC1.fact_fecha)
	) as decimal(10,2)))+' %' '% VENTA'
from Factura FC1
JOIN Item_Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
JOIN Producto ON prod_codigo = item_producto
JOIN Envases ON enva_codigo = prod_envase
group by YEAR(fact_fecha), enva_codigo, enva_detalle
order by 1, COUNT(distinct item_tipo+item_sucursal+item_numero) DESC



/* Ejercicio 28 ==============================================================================
28. Escriba una consulta sql que retorne una estadística por Año y Vendedor que retorne las
siguientes columnas:

** Año.
** Codigo de Vendedor
** Detalle del Vendedor
** Cantidad de facturas que realizó en ese año
** Cantidad de clientes a los cuales les vendió en ese año.
** Cantidad de productos facturados con composición en ese año
** Cantidad de productos facturados sin composicion en ese año.
* Monto total vendido por ese vendedor en ese año

Los datos deberan ser ordenados por año y dentro del año por el vendedor que haya
vendido mas productos diferentes de mayor a menor.
*/

select * from Empleado

select
	YEAR(fact_fecha) 'AÑO',
	fact_vendedor 'COD',
	RTRIM(empl_nombre)+' '+RTRIM(empl_apellido) 'DETALLE',
	COUNT(distinct fact_tipo+fact_sucursal+fact_numero) '# FACT.',
	COUNT(distinct fact_cliente) '# CLIENTES',
	(select ISNULL(SUM(item_cantidad),0) from Factura
		JOIN Item_Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
		JOIN Composicion ON comp_producto = item_producto
		where YEAR(fact_fecha) = YEAR(FC1.fact_fecha) AND FC1.fact_vendedor = fact_vendedor
	) '# PROD. CON COMPOSICION',
	SUM(item_cantidad) - 
		(select ISNULL(SUM(item_cantidad), 0) from Factura
		JOIN Item_Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
		JOIN Composicion ON comp_producto = item_producto
		where YEAR(fact_fecha) = YEAR(FC1.fact_fecha) AND FC1.fact_vendedor = fact_vendedor
	) '# PROD. SIN COMPOSICION',


	--SUM(distinct fact_total) 'TOTAL VENDIDO V1',

	(select SUM(fact_total) from Factura 
		where YEAR(fact_fecha)=YEAR(FC1.fact_fecha) 
			AND fact_vendedor = FC1.fact_vendedor
	) 'TOTAL VENDIDO V2'


from Factura FC1
	JOIN Empleado ON empl_codigo = fact_vendedor
	JOIN Item_Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
group by YEAR(fact_fecha), fact_vendedor, empl_nombre, empl_apellido
order by 1 DESC, COUNT(distinct item_producto) DESC



/* Ejercicio 29 ==============================================================================
29. Se solicita que realice una estadística de venta por producto para el año 2011, solo para
los productos que pertenezcan a las familias que tengan más de 20 productos asignados
a ellas, la cual deberá devolver las siguientes columnas:

a. Código de producto
b. Descripción del producto
c. Cantidad vendida
d. Cantidad de facturas en la que esta ese producto
e. Monto total facturado de ese producto

Solo se deberá mostrar un producto por fila en función a los considerandos establecidos
antes. El resultado deberá ser ordenado por el la cantidad vendida de mayor a menor.
*/

select
	PD1.prod_codigo 'COD',
	PD1.prod_detalle 'DESCRIPCIÓN',
	SUM(item_cantidad) 'CANT. VENDIDA',
	COUNT(distinct fact_tipo+fact_sucursal+fact_numero) '# FACT.',
	SUM(item_cantidad*item_precio) 'TOTAL FACT.'
from Producto PD1
JOIN Item_Factura ON item_producto = prod_codigo
JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
where YEAR(fact_fecha) = 2011
	AND prod_familia IN (select prod_familia from Producto 
							group by prod_familia 
							having COUNT(*) > 20)
group by PD1.prod_codigo, PD1.prod_detalle
order by 3 DESC



/* Ejercicio 30 ==============================================================================
30. Se desea obtener una estadistica de ventas del año 2012, para los empleados que sean
jefes, o sea, que tengan empleados a su cargo, para ello se requiere que realice la
consulta que retorne las siguientes columnas:

* Nombre del Jefe
* Cantidad de empleados a cargo
* Monto total vendido de los empleados a cargo
* Cantidad de facturas realizadas por los empleados a cargo
* Nombre del empleado con mejor ventas de ese jefe

Debido a la perfomance requerida, solo se permite el uso de una subconsulta si fuese
necesario.

Los datos deberan ser ordenados por de mayor a menor por el Total vendido y solo se
deben mostrarse los jefes cuyos subordinados hayan realizado más de 10 facturas.
*/

select
	E2.empl_nombre 'NOMBRE',
	COUNT(distinct E1.empl_codigo) '# EMPL CARGO',
	SUM(fact_total) 'TOTAL VENTAS EMPLEADOS',
	COUNT(distinct fact_tipo+fact_sucursal+fact_numero) '# FACT EMPLEADOS',
	(select TOP 1 empl_nombre from Factura JOIN Empleado ON empl_codigo = fact_vendedor
		where YEAR(fact_fecha) = 2012
		AND empl_jefe = E2.empl_codigo
		group by fact_vendedor, empl_nombre
		order by SUM(fact_total) DESC
	) 'EMPL. MEJOR VENTA'
from Factura 
JOIN Empleado E1 ON E1.empl_codigo = fact_vendedor
JOIN Empleado E2 ON E2.empl_codigo = E1.empl_jefe
where YEAR(fact_fecha) = 2012
group by E2.empl_codigo, E2.empl_nombre
having COUNT(distinct fact_tipo+fact_sucursal+fact_numero) > 10
order by 3 DESC



/* Ejercicio 31 ==============================================================================
31. Escriba una consulta sql que retorne una estadística por Año y Vendedor que retorne las
siguientes columnas:

* Año.
* Codigo de Vendedor
* Detalle del Vendedor
* Cantidad de facturas que realizó en ese año
* Cantidad de clientes a los cuales les vendió en ese año.
* Cantidad de productos facturados con composición en ese año
* Cantidad de productos facturados sin composicion en ese año.
* Monto total vendido por ese vendedor en ese año

Los datos deberan ser ordenados por año y dentro del año por el vendedor que haya
vendido mas productos diferentes de mayor a menor.
*/

select 
	YEAR(fact_fecha) 'AÑO',
	empl_codigo 'COD',
	RTRIM(empl_apellido)+' '+RTRIM(empl_nombre) 'VENDEDOR DETALLE',
	COUNT(distinct fact_tipo+fact_sucursal+fact_numero) '# FACT',
	COUNT(distinct fact_cliente) '# CLIENTES', 
	ISNULL((select SUM(item_cantidad) from Factura
		JOIN Item_Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
		where YEAR(fact_fecha) = YEAR(FC1.fact_fecha) 
			AND fact_vendedor = E1.empl_codigo
			AND item_producto IN (select comp_producto from Composicion group by comp_producto)
	),0) '# PROD C/COMP',
	SUM(item_cantidad) - 
		ISNULL((select SUM(item_cantidad) from Factura
				JOIN Item_Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
				where YEAR(fact_fecha) = YEAR(FC1.fact_fecha) 
					AND fact_vendedor = E1.empl_codigo
					AND item_producto IN (select comp_producto from Composicion group by comp_producto)
	),0) '# PROD S/COMP',
	SUM(item_cantidad*item_precio) '$ TOTAL VENDIDO'
from Factura FC1
JOIN Empleado E1 ON empl_codigo = fact_vendedor
JOIN Item_Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
group by YEAR(fact_fecha), empl_codigo, empl_apellido, empl_nombre
order by 1, COUNT(distinct item_producto) DESC



/* Ejercicio 32 ==============================================================================
32. Se desea conocer las familias que sus productos se facturaron juntos en las mismas
facturas para ello se solicita que escriba una consulta sql que retorne los pares de
familias que tienen productos que se facturaron juntos. Para ellos deberá devolver las
siguientes columnas:

* Código de familia
* Detalle de familia
* Código de familia
* Detalle de familia
* Cantidad de facturas
* Total vendido

Los datos deberan ser ordenados por Total vendido y solo se deben mostrar las familias
que se vendieron juntas más de 10 veces.
*/

select
	P1.prod_familia 'COD1',
	FAM1.fami_detalle 'DETALLE1',
	P2.prod_familia 'COD2',
	FAM2.fami_detalle 'DETALLE2',
	COUNT(distinct IF1.item_tipo+IF1.item_sucursal+IF1.item_numero) '# FACTURAS',
	SUM(IF1.item_cantidad + IF2.item_cantidad) 'TOTAL VENDIDO'
from Item_Factura IF1
JOIN Item_Factura IF2 ON IF2.item_tipo+IF2.item_sucursal+IF2.item_numero=IF1.item_tipo+IF1.item_sucursal+IF1.item_numero
JOIN Producto P1 ON P1.prod_codigo = IF1.item_producto
JOIN Producto P2 ON P2.prod_codigo = IF2.item_producto
JOIN Familia FAM1 ON FAM1.fami_id = P1.prod_familia
JOIN Familia FAM2 ON FAM2.fami_id = P2.prod_familia
	where IF1.item_producto > IF2.item_producto
		AND P1.prod_familia > P2.prod_familia
group by P1.prod_familia, FAM1.fami_detalle, P2.prod_familia, FAM2.fami_detalle
having COUNT(distinct IF1.item_tipo+IF1.item_sucursal+IF1.item_numero) > 10
order by 6



/* Ejercicio 33 ==============================================================================
33. Se requiere obtener una estadística de venta de productos que sean componentes. Para
ello se solicita que realiza la siguiente consulta que retorne la venta de los
componentes del producto más vendido del año 2012. Se deberá mostrar:

a. Código de producto
b. Nombre del producto
c. Cantidad de unidades vendidas
d. Cantidad de facturas en la cual se facturo
e. Precio promedio facturado de ese producto.
f. Total facturado para ese producto

El resultado deberá ser ordenado por el total vendido por producto para el año 2012.
*/

select * from Composicion --12
select * from Item_Factura --19484
select * from Item_Factura where item_producto='00001475'

select
	item_producto 'COD',
	prod_detalle 'PROD NAME',
	SUM(item_cantidad) '#U VENDIDAS',
	COUNT(distinct item_tipo+item_sucursal+item_numero) '#FACT',
	AVG(item_cantidad*item_precio) 'AVG',
	SUM(item_cantidad*item_precio) 'TOTAL FACTURADO'
from Item_Factura
JOIN Producto ON prod_codigo = item_producto
where item_producto IN 
	(select comp_componente from Composicion where comp_producto = 
		(select TOP 1 item_producto from Item_Factura 
		JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
		where YEAR(fact_fecha) = 2012 group by item_producto order by SUM(item_cantidad) DESC)
	group by comp_componente)
group by item_producto, prod_detalle
order by 3


/* Ejercicio 34 ==============================================================================
34. Escriba una consulta sql que retorne para todos los rubros la cantidad de facturas mal
facturadas por cada mes del año 2011 Se considera que una factura es incorrecta cuando
en la misma factura se factutan productos de dos rubros diferentes. Si no hay facturas
mal hechas se debe retornar 0. Las columnas que se deben mostrar son:

1- Codigo de Rubro
2- Mes
3- Cantidad de facturas mal realizadas.
*/

select * from Rubro --31

select
	rubr_id 'COD RUBRO',
	ISNULL(RTRIM(MONTH(fact_fecha)),'---') 'MES',
	--MONTH(fact_fecha),
	COUNT(distinct fact_tipo+fact_sucursal+fact_numero) 'FACT MAL REALIZADAS'
from Rubro
LEFT JOIN Producto ON prod_rubro = rubr_id
LEFT JOIN Item_Factura ON item_producto = prod_codigo
AND item_tipo+item_sucursal+item_numero IN 
		(select item_tipo+item_sucursal+item_numero from Item_Factura
		JOIN Producto ON prod_codigo = item_producto
		JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
			AND YEAR(fact_fecha) = 2011
		group by item_tipo+item_sucursal+item_numero
		having COUNT(distinct prod_rubro) > 1)
LEFT JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
AND YEAR(fact_fecha) = 2011
group by rubr_id, MONTH(fact_fecha)
order by 1,2



/* Ejercicio 35 ==============================================================================
35. Se requiere realizar una estadística de ventas por año y producto, para ello se solicita
que escriba una consulta sql que retorne las siguientes columnas:

* Año
* Codigo de producto
* Detalle del producto
* Cantidad de facturas emitidas a ese producto ese año
<*> Cantidad de vendedores diferentes que compraron ese producto ese año.
* Cantidad de productos a los cuales compone ese producto, si no compone a ninguno se debera retornar 0.
* Porcentaje de la venta de ese producto respecto a la venta total de ese año.

Los datos deberan ser ordenados por año y por producto con mayor cantidad vendida.
*/

select * from Factura FC1
JOIN Factura FC2 ON FC1.fact_cliente = FC2.fact_vendedor
--JOIN Factura FC2 ON FC1.fact_vendedor = FC2.fact_cliente

select
	YEAR(FC1.fact_fecha) 'AÑO',
	P1.prod_codigo 'COD',
	P1.prod_detalle 'DETALLE',
	COUNT(distinct fact_tipo+fact_sucursal+fact_numero) '# FACT',
	(select COUNT(distinct F2.fact_cliente) from Item_Factura
		JOIN Factura F2 ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
		JOIN Factura F3 ON F3.fact_vendedor = F2.fact_cliente
		where YEAR(F2.fact_fecha) = YEAR(FC1.fact_fecha)
			AND item_producto = P1.prod_codigo
	) '# VENDED Q COMPRARON',
	(select COUNT(*) from Composicion
		where comp_componente = P1.prod_codigo
	) '# PROD COMPONEN',
	RTRIM(CAST(SUM(item_cantidad*item_precio)*100/
		(select SUM(item_cantidad*item_precio) from Item_Factura 
		JOIN Factura ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
		where YEAR(fact_fecha) = YEAR(FC1.fact_fecha))
	as decimal(10,3)))+' %' '[%]'
from Item_Factura
JOIN Producto P1 ON prod_codigo = item_producto
JOIN Factura FC1 ON fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
group by YEAR(fact_fecha), prod_codigo, prod_detalle
order by 1, SUM(item_cantidad) DESC


/*
==============================================================================
==============================================================================
==============================================================================
*/

/*
Eje de PARCIAL 
==============================================================================
Realizar una consulta SQL que retorne, para cada producto que no fue vendido en el 2012,
lasiguiente información:

1. Detalle del producto
2. Rubro del producto
3. Cantidad de producto que tiene el rubro
4. Precio máximo de venta en toda la historia, si no tiene venta en la historia, mostrar 0.

El resultado deberá mostrar primero aquellos productos que tienen composición.

NOTA: No se permite el uso de sub-select en el FROM ni funciones definidas por el usuario
para este punto.
*/

select
	prod_detalle 'PROD DETALLE',
	prod_rubro 'RUBRO',
	(select COUNT(*) from Producto
		where prod_rubro = P1.prod_rubro
	) '# PROD X RUBRO',
	ISNULL((select MAX(item_precio) from Item_Factura
		where item_producto = P1.prod_codigo
	), 0) '$ MAX HISTÓRICO'
from Producto P1
LEFT JOIN Composicion ON comp_producto = prod_codigo
where prod_codigo not IN 
	(select item_producto from Item_Factura
	JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
	where YEAR(fact_fecha) = 2012
	group by item_producto)
group by prod_codigo, prod_detalle, prod_rubro, comp_producto
order by comp_producto DESC



/*
Eje Recuperatorio
==============================================================================
Se solicita una estadística por Año y familia, para ello se deberá mostrar:

Año, Código de familia, Detalle de familia, cantidad de facturas, cantidad de productos con composición vendidos,
monto total vendido.

Solo deberán considerar las familias que tengan al menos un producto con composición y 
que se hayan vendido conjuntamente (en la misma factura) con otra familia distinta.

NOTA: No se puede usar select en el from.
*/

select
	YEAR(fact_fecha) 'AÑO',
	prod_familia 'COD FAM',
	fami_detalle 'DETALLE FAM',
	COUNT(distinct fact_tipo+fact_sucursal+fact_numero) '# FACT',
	(select COUNT(distinct prod_codigo) from Producto JOIN Composicion ON comp_producto=prod_codigo
		where prod_familia=PROD1.prod_familia
	) '# PROD_COMP',
	SUM(item_cantidad*item_precio) 'TOTAL VENDIDO'
from Factura
JOIN Item_Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
JOIN Producto PROD1 ON prod_codigo=item_producto
JOIN Familia ON fami_id=prod_familia
where prod_familia IN 
	(select prod_familia from Producto JOIN Composicion ON prod_codigo = comp_producto group by prod_familia)
	AND prod_familia IN 
	(select p1.prod_familia from Item_Factura if1 
		JOIN Item_Factura if2 ON if1.item_tipo+if1.item_sucursal+if1.item_numero=if2.item_tipo+if2.item_sucursal+if2.item_numero
		JOIN Producto p1 ON p1.prod_codigo=if1.item_producto
		JOIN Producto p2 ON p2.prod_codigo=if2.item_producto
	where if1.item_producto > if2.item_producto
		AND p1.prod_familia>p2.prod_familia
	group by p1.prod_familia)
group by YEAR(fact_fecha), prod_familia, fami_detalle
order by 1
