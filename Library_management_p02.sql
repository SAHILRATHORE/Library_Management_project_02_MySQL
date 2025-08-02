CREATE DATABASE Library;
USE library;

-- Create branch table
DROP TABLE IF EXISTS Branch;
CREATE TABLE Branch(
branch_id VARCHAR(10) PRIMARY KEY,
manager_id VARCHAR(10),
branch_address VARCHAR(50),
contact_no VARCHAR(10)
);

ALTER TABLE Branch
MODIFY COLUMN contact_no VARCHAR(20);

-- Create employees table
CREATE TABLE employees(
emp_id VARCHAR(10) PRIMARY KEY,
emp_name VARCHAR(30),
position VARCHAR(20),
salary INT,
branch_id VARCHAR(10)                -- FK
);

-- Create Books table
CREATE TABLE Books(
isbn VARCHAR(20) PRIMARY KEY,
book_title VARCHAR(75),
category VARCHAR(40),
rental_price FLOAT,
Status VARCHAR(4),
author VARCHAR(35),
publisher VARCHAR(55)
);

-- Create Member table
CREATE TABLE Member(
member_id VARCHAR(10) PRIMARY KEY,
member_name VARCHAR(20),
member_address VARCHAR(20),
reg_date DATE
);

-- Create Issue table
CREATE TABLE Issue(
issued_id VARCHAR(10) PRIMARY KEY,
issued_member_id VARCHAR(10),         -- FK
issued_book_name VARCHAR(75),
issued_date DATE,
issued_book_isbn VARCHAR(25),         -- FK
issued_emp_id VARCHAR(10)             -- FK
);

-- Create Return table
CREATE TABLE Return_Status(
return_id VARCHAR(10) PRIMARY KEY,
issued_id VARCHAR(10),               -- FK
return_book_name VARCHAR(75),
return_date DATE,
return_book_isbn VARCHAR(20)
);

-- FOREIGN KEY

ALTER TABLE Issue
ADD CONSTRAINT Fk_member
FOREIGN KEY (issued_member_id)
REFERENCES Member(member_id);

ALTER TABLE Issue
ADD CONSTRAINT Fk_Books
FOREIGN KEY (issued_book_isbn)
REFERENCES Books(isbn);

ALTER TABLE Issue
ADD CONSTRAINT Fk_Employee
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT Fk_Branch
FOREIGN KEY (branch_id)
REFERENCES Branch(branch_id);

ALTER TABLE Return_Status
ADD CONSTRAINT FK_Issue
FOREIGN KEY (issued_id)
REFERENCES Issue(issued_id)