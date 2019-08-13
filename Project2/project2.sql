select * from customers;
select * from payments;
select * from orderdetails;
select * from orders;
select * from products;
select * from productlines;


-- 2.1 
select * from orders where status = 'Shipped' and shippeddate > requireddate;

-- 2.2
select 
substring(orderDate,1,7) as order_month,
sum(quantityordered) as sales,
sum(quantityOrdered*priceeach) as revenue
from 
orders as o
left join
orderdetails as od on o.orderNumber=od.orderNumber
where o.status='shipped'
group by 1
order by revenue desc;

-- 2.3
select substring(orderDate,1,7) as order_month, 
od.productcode, 
p.productname, 
sum(quantityordered) as sales, 
sum(quantityOrdered*priceeach) as revenue, 
sum(quantityOrdered * priceEach - quantityOrdered*buyPrice) as profit
from
orders as o
left join
orderdetails as od on o.orderNumber=od.orderNumber
left join
products as p on od.productCode = p.productCode
where o.status='shipped'
group by 1,2,3;

-- 2.4
create table sales_product as
select substring(orderDate,1,7) as order_month, 
od.productcode, 
p.productname, 
sum(quantityordered) as sales, 
sum(quantityOrdered*priceeach) as revenue, 
sum(quantityOrdered * priceEach - quantityOrdered*buyPrice) as profit
from
orders as o
left join
orderdetails as od on o.orderNumber=od.orderNumber
left join
products as p on od.productCode = p.productCode
where o.status='shipped'
group by 1,2,3;

-- 2.5 

select substring(orderDate,1,7) as order_month, 
pl.productline,
pl.textDescription,
sum(quantityordered) as sales, 
sum(quantityOrdered*priceeach) as revenue, 
sum(quantityOrdered * priceEach - quantityOrdered*buyPrice) as profit
from
orders as o
left join
orderdetails as od on o.orderNumber=od.orderNumber
left join
products as p on od.productCode = p.productCode
left join
productlines as pl on p.productLine=pl.productLine
where o.status='shipped'
group by 1,2,3
order by profit desc;

-- 2.6

create table workforce as
select base.*, reporto.num_of_reports from
(select off.city, emp.employeenumber, 
emp.lastname, emp.firstname, emp.jobtitle
from offices as off
left join
employees as emp
on off.officecode=emp.officecode) as base
left join
(select reportsto, count(*) as num_of_reports from employees
where reportsto is not null
group by 1) as reporto
on base. employeenumber = reporto.reportsto;

update workforce
set num_of_reports=0
where num_of_reports is null;