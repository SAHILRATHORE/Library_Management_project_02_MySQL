# 📚 Library Management System using MySQL

💡 A complete Library Management System using MySQL with CRUD, advanced queries, and stored procedures for real-time data handling.

This project demonstrates the design and implementation of a **Library Management System** using **MySQL**. It includes complete database setup, CRUD operations, advanced SQL queries, stored procedures, and data analysis. The system efficiently manages books, members, employees, and transactions within a library environment.

---

## 🚀 Project Highlights

- Built using **MySQL** with a well-structured relational schema.
- Implements **stored procedures** for real-time issuing and returning of books.
- Includes **CTAS (Create Table As Select)** for reporting.
- Performs **data analysis** to gain insights into library performance.
- Demonstrates advanced querying techniques like joins, subqueries, and aggregations.

---

## 🧱 Database Overview

- **Database Name**: `library_db`
- **Entities**:
  - `branch`
  - `employees`
  - `members`
  - `books`
  - `issued_status`
  - `return_status`

Each table is interconnected through appropriate **foreign key constraints** to ensure data integrity and relational mapping.

---

## 🛠️ Key Functionalities

### 1. 🔄 CRUD Operations

- **Create**: Add new books, members, and employees.
- **Read**: Retrieve information about issued books, active members, and overdue returns.
- **Update**: Modify member details, book availability, etc.
- **Delete**: Remove outdated or invalid records.

Example:
```sql
INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
```

### 2. 🧾 Stored Procedures
- **issue_book**
    Issues a book to a member only if the book is available.

- **add_return_records**
   Updates the book's status upon return and logs return details with a thank-you message.

```sql
CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL add_return_records('RS138', 'IS135', 'Good');
```

### 3. 📊 Data Analysis
Includes queries for:

- Books not yet returned

- Overdue members with fine calculations

- Branch-wise performance (issued books, returns, revenue)

- Top-performing employees

- Members with high-risk (damaged) book handling
```sql
SELECT 
    ist.issued_member_id, m.member_name, bk.book_title, ist.issued_date,
    DATEDIFF(CURRENT_DATE, ist.issued_date) AS over_due_days
FROM issued_status AS ist
JOIN members AS m ON m.member_id = ist.issued_member_id
JOIN books AS bk ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status AS rs ON rs.issued_id = ist.issued_id
WHERE rs.return_date IS NULL AND DATEDIFF(CURRENT_DATE, ist.issued_date) > 30;
```

**📈 Reports & CTAS Usage**
**CTAS (Create Table As Select) is used to generate dynamic summary tables such as:**

- book_issued_cnt – Number of times each book was issued

- branch_reports – Branch-wise performance metrics

- active_members – Members active in the last 2 months

- expensive_books – Books with rental price > ₹7.00


## 👨‍💻 Author
# Sahil Rathore
### Passionate about databases, backend systems, and data analytics.
