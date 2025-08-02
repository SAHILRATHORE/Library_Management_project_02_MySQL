SELECT * FROM Books;
SELECT * FROM Branch;
SELECT * FROM employees;
SELECT * FROM Issue;
SELECT * FROM Member;
SELECT * FROM return_status;

-- Project tasks

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher) 
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- Task 2: Update an Existing Member's Address

UPDATE Member
SET member_address = 'hola hola'
WHERE member_id = 'C101';

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM Issue
WHERE issued_id = 'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM Issue
WHERE issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT issued_emp_id,
COUNT(issued_id) as total_book_issued
FROM Issue
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1;

-- CTAS
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE Book_issued_count
AS
SELECT
B.isbn,
B.book_title,
COUNT(Ist.issued_id) AS Total_Issued
FROM 
Books AS B
JOIN
Issue AS Ist
ON B.isbn = Ist.issued_book_isbn
GROUP BY 1,2;

SELECT * FROM Book_issued_count;


-- Data Analysis & Findings
-- Task 7. Retrieve All Books in a Specific Category:

SELECT * FROM Books
WHERE category = 'Classic';

-- Task 8: Find Total Rental Income by Category:

SELECT
B.category,
SUM(B.rental_price) AS Total_Rental_income,
COUNT(*)
FROM 
Books AS B
JOIN
Issue AS Ist
ON B.isbn = Ist.issued_book_isbn
GROUP BY 1;

-- Task 9: List Members Who Registered in the Last 4 Year:

SELECT *  FROM Member
WHERE reg_date >= CURDATE() - INTERVAL 4 Year;

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:

SELECT 
E.*,
E2.emp_name as Manager,
B.branch_address
FROM
employees AS E
JOIN
Branch AS B
ON B.branch_id = E.branch_id
JOIN
employees AS E2
ON B.manager_id = E2.emp_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:

CREATE TABLE Expensive_Books 
AS
SELECT * FROM books
WHERE rental_price > 7;

SELECT * FROM Expensive_Books;

-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT * FROM 
Issue AS I
LEFT JOIN
return_status AS Rs
ON I.issued_id = Rs.issued_id
WHERE Rs.return_id  IS NULL; 



