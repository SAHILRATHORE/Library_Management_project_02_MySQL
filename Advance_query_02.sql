SELECT * FROM Books;
SELECT * FROM Branch;
SELECT * FROM employees;
SELECT * FROM member;
SELECT * FROM return_status;
SELECT * FROM Issue;

-- Task 13: Identify Members with Overdue Books.
-- Write a query to identify members who have overdue books (assume a 30-day return period). 
-- Display the member's_id, member's name, book title, issue date, and days overdue.

SELECT 
I.issued_member_id,
M.member_name,
B.book_title,
I.issued_date,
-- Rs.return_date,
DATEDIFF(CURRENT_DATE(), I.issued_date) AS Over_dues_day
FROM
Issue As I
JOIN
Member As M
ON M.member_id = I.issued_member_id
JOIN
Books As B
ON B.isbn = I.issued_book_isbn
LEFT JOIN
return_status As Rs
ON Rs.issued_id = I.issued_id
WHERE return_date IS NULL
AND 
DATEDIFF(CURRENT_DATE(), I.issued_date) > 30
ORDER BY 1;


-- Task 14: Update Book Status on Return
-- Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).

-- Store Procedure
DROP PROCEDURE IF EXISTS add_return_status;
DELIMITER $$

CREATE PROCEDURE add_return_status(
	IN p_return_id VARCHAR(10),
	IN p_issued_id VARCHAR(10),
	IN p_book_quality VARCHAR(20)
)
BEGIN
	DECLARE v_isbn VARCHAR(50);
	DECLARE v_book_name VARCHAR(50);

	-- Insert return status
	INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
	VALUES (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

	-- Fetch the book info from Issue table
	SELECT 
		issued_book_isbn,
		issued_book_name
	INTO
		v_isbn,
		v_book_name
	FROM Issue
	WHERE issued_id = p_issued_id;

	-- Update Books table to mark book as returned
	UPDATE Books
	SET status = 'Yes'
	WHERE isbn = v_isbn;

	-- Output the success message
	SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS message;

END$$
DELIMITER ;

CALL add_return_status('RS140', 'IS134', 'Good');

-- Function checking
SELECT * FROM return_status
WHERE issued_id = 'RS140';

SELECT * FROM Issue
WHERE issued_book_isbn = '978-0-375-41398-8';

SELECT * FROM Books
WHERE isbn = '978-0-375-41398-8';

SELECT * FROM Books
Where status = 'no';
-- WHERE isbn = '978-0-307-58837-1';

DELETE FROM return_status
WHERE return_id = 'RS145';




-- Task 15: Branch Performance Report
-- Create a query that generates a performance report for each branch, showing the number of books issued,
-- the number of books returned, and the total revenue generated from book rentals.
CREATE TABLE Branch_performance 
AS
SELECT b.branch_id,
b.manager_id,
COUNT(i.issued_book_name) AS Total_book_issued,
COUNT(r.return_id) AS total_book_return,
SUM(rental_price) AS Revenue_generate
FROM 
Branch AS b
JOIN
employees AS e
ON e.branch_id = b.branch_id
JOIN
Issue AS i
ON i.issued_emp_id = e.emp_id
LEFT JOIN 
return_status as r
ON r.issued_id = i.issued_id 
JOIN
Books AS bk
ON bk.isbn = i.issued_book_isbn
GROUP BY 1,2;

SELECT * FROM Branch_performance;



-- Task 16: CTAS: Create a Table of Active Members, Use the CREATE TABLE AS (CTAS) statement.
-- to create a new table active_members containing members who have issued at least one book in the last 2 months.

CREATE TABLE Active_Members
AS
SELECT * FROM Member
WHERE member_id IN (SELECT 
						DISTINCT issued_member_id
						FROM issue
						WHERE 
							issued_date >= current_date() - INTERVAL 1 year
                        );
                        
SELECT * FROM Active_Members;

-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues.
-- Display the employee name, number of books processed, and their branch.

SELECT * FROM Issue;
SELECT * FROM employees;

SELECT e.emp_name,
b.*,
COUNT(i.issued_book_isbn) AS Total_book_issued
FROM
employees AS e
JOIN
Issue AS i
ON i.issued_emp_id = e.emp_id
JOIN 
Branch As b
ON e.branch_id = b.branch_id
GROUP BY 1,2;


-- Task 19: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system.
-- Description: Write a stored procedure that updates the status of a book in the library based on its issuance.
-- The procedure should function as follows: The stored procedure should take the book_id as an input parameter.
-- The procedure should first check if the book is available (status = 'yes').
-- If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
-- If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

DROP PROCEDURE IF EXISTS Manage_status;
DELIMITER $$
CREATE PROCEDURE Manage_status(
								IN p_issued_id VARCHAR(10),
                                IN p_issued_member_id VARCHAR(10),
                                IN p_issued_book_isbn VARCHAR(30),
                                IN p_issued_emp_id VARCHAR(10)
)

BEGIN

DECLARE v_status VARCHAR(10);

SELECT status 
	INTO
    v_status
FROM Books
WHERE isbn = p_issued_book_isbn;

IF v_status = 'yes' THEN 
    INSERT INTO Issue(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
    VALUES
    (p_issued_id, p_issued_member_id, current_date(), p_issued_book_isbn, p_issued_emp_id);
    
    UPDATE Books
    SET status = 'no'
    WHERE isbn = p_issued_book_isbn;
    
	SELECT CONCAT('Book records added successfully for book isbn : ', p_issued_book_isbn) AS message;
ELSE
	SELECT CONCAT('Sorry! The Requested Book is Unavailable : ', p_issued_book_isbn) AS message;
END IF;

END $$
DELIMITER ;

CALL Manage_status('IS178', 'C105', '978-0-06-112241-5', 'E110'); -- yes
CALL Manage_status('IS131', 'C106', '978-0-06-112008-4', 'E101'); -- no


SELECT * FROM Books
where isbn = '978-0-06-112241-5';
SELECT * FROM Books
where status = 'no';
SELECT * FROM Issue
where issued_book_isbn = '978-0-06-112241-5';

update books 
set status = 'no'
where isbn = '978-0-06-112008-4';

SELECT * FROM Books