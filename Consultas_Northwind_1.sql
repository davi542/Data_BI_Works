

/*1- Selecciona los 10 primeros Clientes que más hayan comprado en Francia*/ 
select top 10 CustomerID, round(sum(UnitPrice * Quantity),2) as Total_Venta, ShipCity
from Orders
inner join Order_Details
on Orders.OrderID = Order_Details.OrderID
where ShipCountry = 'France'
group by CustomerID, ShipCity
order by Total_Venta Desc

/*2- Selecciona el top 5 de empleados (nombre completo) y la cantidad vendida por cada uno de ellos*/
select top 5 CONCAT(employees.firstname,' ',employees.lastname) full_name, CONCAT('$',round(sum(UnitPrice * Quantity),2)) as Total_Venta
from employees
inner join orders 
on employees.EmployeeID = orders.EmployeeID 
inner join Order_Details
on Orders.OrderID = Order_Details.OrderID 
where ShipCountry = 'France'
group by firstname, lastname
order by full_name



/*3- Selecciona el creciminiento en venta semana contra semana del año 2017*/
set datefirst 1 -- (Monday)
select DATEPART(YEAR, OrderDate) as Año,
	DATEPART(WEEK, OrderDate) as Semana, 
	sum(UnitPrice * Quantity) as Venta,
	round(((sum(UnitPrice * Quantity)/(LAG(sum(UnitPrice * Quantity)) OVER(ORDER BY DATEPART(WEEK, OrderDate)))-1)*100),2) as Growth
from Orders
inner join Order_Details
on Orders.OrderID = Order_Details.OrderID
where YEAR(OrderDate) = '2017'
group by DATEPART(YEAR, OrderDate), DATEPART(WEEK, OrderDate)
order by Semana;

/*4- Selecciona el creciminiento en venta año contra semana del año */
set datefirst 1 -- (Monday)
select DATEPART(YEAR, OrderDate) as Año,
	sum(UnitPrice * Quantity) as Venta,
	round(((sum(UnitPrice * Quantity)/(LAG(sum(UnitPrice * Quantity)) OVER(ORDER BY DATEPART(YEAR, OrderDate)))-1)*100),2) as Growth
from Orders
inner join Order_Details
on Orders.OrderID = Order_Details.OrderID
group by DATEPART(YEAR, OrderDate)
order by Año;

/*5- Selecciona los articulos que su inventario esten por debajo del nivel de recompra y selecciona los datos del provedor que lo surte*/

select UnitsInStock,ProductName,CompanyName,ContactName,Address,City,Phone
from Products
inner join Suppliers
on Products.SupplierID = Suppliers.SupplierID
where UnitsInStock < ReorderLevel
order by UnitsInStock


/*6- Selecciona el top 10 de clientes(CustomerID) que más venta tienen, así como el empleado que le vende donde la region sea 1*/
select top 10 CustomerID, CONCAT(employees.firstname,' ',employees.lastname) full_name,
			round(sum(Order_Details.UnitPrice * Order_Details.Quantity),2) as Total_Venta,
			ShipCity
from Region
inner join Territories
on Region.RegionID = Territories.RegionID
inner join EmployeeTerritories
on Territories.TerritoryID = EmployeeTerritories.TerritoryID
inner join Employees
on EmployeeTerritories.EmployeeID = Employees.EmployeeID
inner join Orders
on Employees.EmployeeID = Orders.EmployeeID
inner join Order_Details
on Order_Details.OrderID = Orders.OrderID
where Region.RegionID = 1
group by Orders.CustomerID,ShipCity,Territories.RegionID,employees.firstname,employees.lastname
order by Total_Venta desc

