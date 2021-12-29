# Begin by loading several packages.
# In addition to the tidyverse, you'll need dbplyr and ODBC
# If you haven't used these before, install them with install.packages() at the
# console before running this code.

library(tidyverse)
library(dbplyr)
library(odbc)

# Set up the database connection
connectionString = 'Driver={SQL Server Native Client 11.0};Server=mcobsql.business.nd.edu;Uid=BANstudent;Pwd=SQL%database!Mendoza;'

# Connect to the database
sqlserver <- dbConnect(odbc::odbc(),
                       .connection_string=connectionString)

# SELECT SalesOrderID, OrderDate, CustomerID, TotalDue 
# FROM Sales.SalesOrderHeader
# WHERE DATEPART(year, OrderDate) = 2012

salesorderheader <- tbl(sqlserver, in_schema('Sales', 'SalesOrderHeader'))

str(salesorderheader)

show_query(salesorderheader)

orders_from_2012 <- salesorderheader %>%
  select(SalesOrderID, OrderDate, CustomerID, TotalDue) %>%
  filter(year(OrderDate)==2012)

str(orders_from_2012)

summary(orders_from_2012)

print(orders_from_2012)

orders_tibble <- orders_from_2012 %>% collect()

str(orders_tibble)

# SELECT p.FirstName, p.LastName, e.HireDate, d.Name AS Department
# FROM Person.Person p
# INNER JOIN HumanResources.Employee e
# ON p.BusinessEntityID=e.BusinessEntityID
# INNER JOIN HumanResources.EmployeeDepartmentHistory edh
# ON e.BusinessEntityID=edh.BusinessEntityID
# INNER JOIN HumanResources.Department d
# ON edh.DepartmentID = d.DepartmentID
# WHERE d.Name = 'Sales'

person <- tbl(sqlserver, in_schema('Person', 'Person'))
employee <- tbl(sqlserver, in_schema('HumanResources', 'Employee'))
employeedepartmenthistory <- tbl(sqlserver, in_schema('HumanResources', 'EmployeeDepartmentHistory'))
department <- tbl(sqlserver, in_schema('HumanResources', 'Department'))

sales_employees <- person %>%
  inner_join(employee, by='BusinessEntityID') %>%
  inner_join(employeedepartmenthistory, by='BusinessEntityID') %>%
  inner_join(department, by='DepartmentID') %>%
  select(FirstName, LastName, HireDate, Name) %>%
  filter(Name=='Sales')

str(sales_employees)

print(sales_employees, n=20)

sales_tibble <- sales_employees %>% collect()