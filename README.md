🎟️ Event Management System (SQL Project)
📌 Database Creation
CREATE DATABASE EventManagement;
USE EventManagement;
🏗️ Table Creation
1️⃣ Venues Table
CREATE TABLE Venues (
    venue_id INT PRIMARY KEY,
    venue_name VARCHAR(100),
    location VARCHAR(100),
    capacity INT
);
2️⃣ Organizers Table
CREATE TABLE Organizers (
    organizer_id INT PRIMARY KEY,
    organizer_name VARCHAR(100),
    contact_email VARCHAR(100),
    phone_number VARCHAR(15)
);
3️⃣ Events Table
CREATE TABLE Events (
    event_id INT PRIMARY KEY,
    event_name VARCHAR(100),
    event_date DATE,
    venue_id INT,
    organizer_id INT,
    ticket_price DECIMAL(10,2),
    total_seats INT,
    available_seats INT,
    FOREIGN KEY (venue_id) REFERENCES Venues(venue_id),
    FOREIGN KEY (organizer_id) REFERENCES Organizers(organizer_id)
);
4️⃣ Attendees Table
CREATE TABLE Attendees (
    attendee_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(15)
);
5️⃣ Tickets Table
CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY,
    event_id INT,
    attendee_id INT,
    booking_date DATE,
    status ENUM('Confirmed','Cancelled','Pending'),
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (attendee_id) REFERENCES Attendees(attendee_id)
);
6️⃣ Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    ticket_id INT,
    amount_paid DECIMAL(10,2),
    payment_status ENUM('Success','Failed','Pending'),
    payment_date DATE,
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);
📥 Insert Sample Data

(You can keep your full INSERT statements here exactly as written.)

🔄 Data Modification
UPDATE Events
SET ticket_price = 600.00
WHERE event_id = 1;

DELETE FROM Payments
WHERE payment_id = 4;
📊 SQL Operations Implemented
✅ 1. SQL Clauses (WHERE, HAVING, LIMIT)
SELECT e.*
FROM Events e
JOIN Venues v ON e.venue_id = v.venue_id
WHERE v.location = 'Ahmedabad'
AND e.event_date > CURDATE();
SELECT e.event_id, e.event_name,
       SUM(p.amount_paid) AS total_revenue
FROM Events e
JOIN Tickets t ON e.event_id = t.event_id
JOIN Payments p ON t.ticket_id = p.ticket_id
WHERE p.payment_status = 'Success'
GROUP BY e.event_id, e.event_name
ORDER BY total_revenue DESC
LIMIT 5;
✅ 2. SQL Operators (AND, OR, NOT)
SELECT *
FROM Events
WHERE MONTH(event_date) = 12
AND available_seats > (total_seats * 0.5);
✅ 3. Sorting & Grouping (ORDER BY, GROUP BY)
SELECT *
FROM Events
ORDER BY event_date ASC;
SELECT e.event_name,
       COUNT(t.attendee_id) AS total_attendees
FROM Events e
LEFT JOIN Tickets t ON e.event_id = t.event_id
GROUP BY e.event_name;
✅ 4. Aggregate Functions (SUM, AVG, COUNT)
SELECT SUM(amount_paid) AS total_revenue
FROM Payments
WHERE payment_status = 'Success';
SELECT AVG(ticket_price) AS average_ticket_price
FROM Events;
✅ 5. Constraints (Primary & Foreign Key)
ALTER TABLE Tickets
ADD CONSTRAINT unique_booking
UNIQUE (event_id, attendee_id);
✅ 6. Joins (INNER, LEFT, RIGHT)
🔹 INNER JOIN
SELECT e.event_id, e.event_name, e.event_date,
       v.venue_name, v.location, v.capacity
FROM Events e
INNER JOIN Venues v
ON e.venue_id = v.venue_id;
🔹 LEFT JOIN
SELECT a.attendee_id, a.name
FROM Attendees a
LEFT JOIN Tickets t
ON a.attendee_id = t.attendee_id
WHERE t.ticket_id IS NULL;
✅ 7. Subqueries
SELECT e.event_id, e.event_name,
       SUM(p.amount_paid) AS total_revenue
FROM Events e
JOIN Tickets t ON e.event_id = t.event_id
JOIN Payments p ON t.ticket_id = p.ticket_id
WHERE p.payment_status = 'Success'
GROUP BY e.event_id, e.event_name
HAVING total_revenue >
       (SELECT AVG(amount_paid)
        FROM Payments
        WHERE payment_status = 'Success');
✅ 8. Date & Time Functions
SELECT MONTH(event_date) AS event_month
FROM Events;
SELECT DATEDIFF(event_date, CURDATE()) AS days_remaining
FROM Events;
✅ 9. String Functions
SELECT UPPER(organizer_name) FROM Organizers;
SELECT TRIM(name) FROM Attendees;
✅ 10. Window Functions
SELECT event_name,
       SUM(p.amount_paid) AS total_revenue,
       RANK() OVER (ORDER BY SUM(p.amount_paid) DESC) AS revenue_rank
FROM Events e
JOIN Tickets t ON e.event_id = t.event_id
JOIN Payments p ON t.ticket_id = p.ticket_id
WHERE p.payment_status = 'Success'
GROUP BY event_name;
✅ 11. CASE Expressions
SELECT event_name,
       CASE
           WHEN available_seats < (0.2 * total_seats)
                THEN 'High Demand'
           WHEN available_seats BETWEEN (0.2 * total_seats)
                                   AND (0.5 * total_seats)
                THEN 'Moderate Demand'
           ELSE 'Low Demand'
       END AS demand_category
FROM Events;
🎯 Project Summary

This project demonstrates:

Database creation

Table relationships (Primary & Foreign Keys)

CRUD operations

SQL Clauses & Operators

Aggregate Functions

Joins

Subqueries

Date & Time Functions

String Functions

Window Functions

CASE Expressions
