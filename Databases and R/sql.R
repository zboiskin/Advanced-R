# Executing SQL Queries from R
# Advanced R
# Week 5, Video 3

library(tidyverse)
library(dbplyr)
library(odbc)

connectionString <- 'Driver={SQL Server Native Client 11.0}; Server=mcobsql.business.nd.edu; Uid=BANstudent;Pwd=SQL%database!Mendoza;'
sqlserver <- dbConnect(odbc::odbc(), .connection_string=connectionString)

query <- "SELECT SalesOrderID, OrderDate, CustomerID, TotalDue FROM Sales.SalesOrderHeader WHERE DATEPART(year, OrderDate) = 2012"
soh_results <- dbGetQuery(sqlserver, query)
summary(soh_results)

query <- "SELECT p.FirstName, p.LastName, e.HireDate, d.Name as Department
FROM Person.Person p
INNER JOIN HumanResources.Employee e
ON p.BusinessEntityID = e.BusinessEntityID
INNER JOIN HumanResources.EmployeeDepartmentHistory edh
ON e.BusinessEntityID = edh.BusinessEntityID
INNER JOIN HumanResources.Department d
ON edh.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'"

sales_employees <- dbGetQuery(sqlserver, query)
summary(sales_employees)
