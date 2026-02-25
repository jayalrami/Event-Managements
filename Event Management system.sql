CREATE DATABASE EventManagement;

USE EventManagement;

CREATE TABLE Venues (
    venue_id INT PRIMARY KEY,
    venue_name VARCHAR(100),
    location VARCHAR(100),
    capacity INT
);

CREATE TABLE Organizers (
    organizer_id INT PRIMARY KEY,
    organizer_name VARCHAR(100),
    contact_email VARCHAR(100),
    phone_number VARCHAR(15)
);

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

CREATE TABLE Attendees (
    attendee_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(15)
);

CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY,
    event_id INT,
    attendee_id INT,
    booking_date DATE,
    status ENUM('Confirmed','Cancelled','Pending'),
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (attendee_id) REFERENCES Attendees(attendee_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    ticket_id INT,
    amount_paid DECIMAL(10,2),
    payment_status ENUM('Success','Failed','Pending'),
    payment_date DATE,
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);

INSERT INTO Venues VALUES
(1, 'Grand Hall', 'Ahmedabad', 500),
(2, 'City Center', 'Surat', 300),
(3, 'Royal Palace', 'Mumbai', 800),
(4, 'Open Arena', 'Delhi', 1000),
(5, 'Conference Hub', 'Pune', 400);

INSERT INTO Organizers VALUES
(1, 'ABC Events', 'abc@gmail.com', '9876543210'),
(2, 'Star Planners', 'star@gmail.com', '9876501234'),
(3, 'Elite Org', 'elite@gmail.com', '9988776655'),
(4, 'Prime Events', 'prime@gmail.com', '9123456789'),
(5, 'Mega Shows', 'mega@gmail.com', '9012345678');

INSERT INTO Events VALUES
(1, 'Music Night', '2026-03-10', 1, 1, 500.00, 500, 450),
(2, 'Tech Conference', '2026-04-15', 5, 2, 1500.00, 400, 380),
(3, 'Food Festival', '2026-05-20', 2, 3, 300.00, 300, 250),
(4, 'Business Summit', '2026-06-05', 3, 4, 2000.00, 800, 750),
(5, 'Comedy Show', '2026-07-18', 4, 5, 700.00, 1000, 900);

INSERT INTO Attendees VALUES
(1, 'Jay', 'jay@gmail.com', '9090909090'),
(2, 'Rahul', 'rahul@gmail.com', '8080808080'),
(3, 'Priya', 'priya@gmail.com', '7070707070'),
(4, 'Neha', 'neha@gmail.com', '6060606060'),
(5, 'Amit', 'amit@gmail.com', '5050505050');

INSERT INTO Tickets VALUES
(1, 1, 1, '2026-02-01', 'Confirmed'),
(2, 2, 2, '2026-02-02', 'Pending'),
(3, 3, 3, '2026-02-03', 'Confirmed'),
(4, 4, 4, '2026-02-04', 'Cancelled'),
(5, 5, 5, '2026-02-05', 'Confirmed');

INSERT INTO Payments VALUES
(1, 1, 500.00, 'Success', '2026-02-01'),
(2, 2, 1500.00, 'Pending', '2026-02-02'),
(3, 3, 300.00, 'Success', '2026-02-03'),
(4, 4, 2000.00, 'Failed', '2026-02-04'),
(5, 5, 700.00, 'Success', '2026-02-05');

UPDATE Events
SET ticket_price = 600.00
WHERE event_id = 1;

DELETE FROM Payments
WHERE payment_id = 4;

-- use SQL Clauses (where, having,limit)

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

SELECT DISTINCT a.*
FROM Attendees a
JOIN Tickets t ON a.attendee_id = t.attendee_id
WHERE t.booking_date >= CURDATE() - INTERVAL 7 DAY;

-- Apply SQL operators (AND,OR,Not)

SELECT *
FROM Events
WHERE MONTH(event_date) = 12
AND available_seats > (total_seats * 0.5);

SELECT DISTINCT a.*
FROM Attendees a
LEFT JOIN Tickets t ON a.attendee_id = t.attendee_id
LEFT JOIN Payments p ON t.ticket_id = p.ticket_id
WHERE t.ticket_id IS NOT NULL
OR p.payment_status = 'Pending';

select * from Events where available_seats > 0;

-- Sorting and Grouping data (Order by , group by)

SELECT *
FROM Events
ORDER BY event_date ASC;

SELECT e.event_name,
       COUNT(t.attendee_id) AS total_attendees
FROM Events e
LEFT JOIN Tickets t ON e.event_id = t.event_id
GROUP BY e.event_name;

SELECT e.event_name,
       SUM(p.amount_paid) AS total_revenue
FROM Events e
JOIN Tickets t ON e.event_id = t.event_id
JOIN Payments p ON t.ticket_id = p.ticket_id
WHERE p.payment_status = 'Success'
GROUP BY e.event_name;

-- Use Aggregate Function (sum,avg,max,min,count)

SELECT SUM(amount_paid) AS total_revenue
FROM Payments
WHERE payment_status = 'Success';

SELECT e.event_id, e.event_name,
       COUNT(t.ticket_id) AS total_attendees
FROM Events e
LEFT JOIN Tickets t ON e.event_id = t.event_id
GROUP BY e.event_id, e.event_name
ORDER BY total_attendees DESC
LIMIT 1;

SELECT AVG(ticket_price) AS average_ticket_price
FROM Events;

-- Establish primary key and foreign key

ALTER TABLE Tickets
ADD CONSTRAINT unique_booking
UNIQUE (event_id, attendee_id);

-- implements join 

SELECT e.event_id, e.event_name, e.event_date,
       v.venue_name, v.location, v.capacity
FROM Events e
INNER JOIN Venues v
ON e.venue_id = v.venue_id;

SELECT DISTINCT a.attendee_id, a.name, a.email
FROM Attendees a
LEFT JOIN Tickets t ON a.attendee_id = t.attendee_id
LEFT JOIN Payments p ON t.ticket_id = p.ticket_id
WHERE t.ticket_id IS NOT NULL
AND (p.payment_status IS NULL OR p.payment_status <> 'Success');

SELECT e.event_id, e.event_name
FROM Tickets t
RIGHT JOIN Events e
ON t.event_id = e.event_id
WHERE t.ticket_id IS NULL;

SELECT a.attendee_id, a.name
FROM Attendees a
LEFT JOIN Tickets t
ON a.attendee_id = t.attendee_id
WHERE t.ticket_id IS NULL;

-- Use subqueries

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
        
SELECT a.attendee_id, a.name,
       COUNT(DISTINCT t.event_id) AS total_events
FROM Attendees a
JOIN Tickets t ON a.attendee_id = t.attendee_id
GROUP BY a.attendee_id, a.name
HAVING COUNT(DISTINCT t.event_id) > 1;

SELECT o.organizer_id, o.organizer_name,
       COUNT(e.event_id) AS total_events_managed
FROM Organizers o
JOIN Events e ON o.organizer_id = e.organizer_id
GROUP BY o.organizer_id, o.organizer_name
HAVING COUNT(e.event_id) > 3;        

-- Implements data and time function 

SELECT event_id, event_name,
       MONTH(event_date) AS event_month
FROM Events;

SELECT event_id, event_name, event_date,
       DATEDIFF(event_date, CURDATE()) AS days_remaining
FROM Events
WHERE event_date >= CURDATE();

SELECT payment_id,
       DATE_FORMAT(payment_date, '%Y-%m-%d %H:%i:%s') AS formatted_payment_date
FROM Payments;

-- String manipulation function

SELECT organizer_id,
       UPPER(organizer_name) AS organizer_name_uppercase
FROM Organizers;

SELECT attendee_id,
       TRIM(name) AS cleaned_name
FROM Attendees;

SELECT attendee_id,
       name,
       COALESCE(email, 'Not Provided') AS email_status
FROM Attendees;

-- Implement Windows Function 

SELECT event_name,
       SUM(p.amount_paid) AS total_revenue,
       RANK() OVER (ORDER BY SUM(p.amount_paid) DESC) AS revenue_rank
FROM Events e
JOIN Tickets t ON e.event_id = t.event_id
JOIN Payments p ON t.ticket_id = p.ticket_id
WHERE p.payment_status = 'Success'
GROUP BY event_name;

SELECT e.event_name,
       SUM(p.amount_paid) AS total_sales,
       SUM(SUM(p.amount_paid)) OVER (ORDER BY e.event_date) AS cumulative_sales
FROM Events e
JOIN Tickets t ON e.event_id = t.event_id
JOIN Payments p ON t.ticket_id = p.ticket_id
WHERE p.payment_status = 'Success'
GROUP BY e.event_name, e.event_date;

SELECT e.event_name,
       t.booking_date,
       COUNT(t.ticket_id) OVER (
           PARTITION BY e.event_id
           ORDER BY t.booking_date
       ) AS running_total_attendees
FROM Events e
JOIN Tickets t ON e.event_id = t.event_id;

-- Apply SQL Case Expression

SELECT event_name,
       total_seats,
       available_seats,
       CASE
           WHEN available_seats < (0.2 * total_seats)
                THEN 'High Demand'
           WHEN available_seats BETWEEN (0.2 * total_seats)
                                   AND (0.5 * total_seats)
                THEN 'Moderate Demand'
           ELSE 'Low Demand'
       END AS demand_category
FROM Events;

SELECT payment_id,
       payment_status,
       CASE
           WHEN payment_status = 'Success' THEN 'Successful'
           WHEN payment_status = 'Failed' THEN 'Failed'
           ELSE 'Pending'
       END AS payment_result
FROM Payments;