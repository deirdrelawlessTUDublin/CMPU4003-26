/* ============================================================
   CMPU4003 Advanced Databases
   Campus Events Database
   Week 1 Lab
   ============================================================ */

-- Create the schema used by the CampusEvents application.
CREATE SCHEMA IF NOT EXISTS campusevents;

-- Use the CampusEvents schema for all unqualified object names
-- in this script.
SET search_path TO campusevents;
-- ------------------------------------------------------------
-- Remove existing tables
-- Allows the script to be run again
-- ------------------------------------------------------------

DROP TABLE IF EXISTS registration;
DROP TABLE IF EXISTS event;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS venue;
DROP TABLE IF EXISTS student;


-- ============================================================
-- 1. CREATE TABLES
-- ============================================================

CREATE TABLE student (
    student_id     INTEGER PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    email          VARCHAR(150) NOT NULL UNIQUE,
    programme      VARCHAR(50) NOT NULL
);


CREATE TABLE venue (
    venue_id       INTEGER PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    building       VARCHAR(100) NOT NULL,
    capacity       INTEGER NOT NULL
                   CHECK (capacity > 0)
);


CREATE TABLE category (
    category_id    INTEGER PRIMARY KEY,
    category_name  VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE event (
    event_id       INTEGER PRIMARY KEY,
    title          VARCHAR(150) NOT NULL,
    event_date     TIMESTAMP NOT NULL,
    venue_id       INTEGER NOT NULL,
    category_id    INTEGER NOT NULL,
    capacity       INTEGER NOT NULL
                   CHECK (capacity > 0),

    CONSTRAINT fk_event_venue
        FOREIGN KEY (venue_id)
        REFERENCES venue(venue_id),

    CONSTRAINT fk_event_category
        FOREIGN KEY (category_id)
        REFERENCES category(category_id)
);


CREATE TABLE registration (
    registration_id INTEGER PRIMARY KEY,
    student_id      INTEGER NOT NULL,
    event_id        INTEGER NOT NULL,
    registered_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status           VARCHAR(20) NOT NULL DEFAULT 'REGISTERED',
    attended         BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_registration_student
        FOREIGN KEY (student_id)
        REFERENCES student(student_id),

    CONSTRAINT fk_registration_event
        FOREIGN KEY (event_id)
        REFERENCES event(event_id),

    CONSTRAINT chk_registration_status
        CHECK (status IN ('REGISTERED', 'CANCELLED', 'WAITLISTED')),

    CONSTRAINT uq_student_event
        UNIQUE (student_id, event_id)
);


-- ============================================================
-- 2. POPULATE LOOKUP TABLES
-- ============================================================

INSERT INTO category (category_id, category_name) VALUES
(1, 'Careers'),
(2, 'Technology'),
(3, 'Academic'),
(4, 'Social'),
(5, 'Wellbeing'),
(6, 'Sport');


INSERT INTO venue (venue_id, name, building, capacity) VALUES
(1, 'CQ-108', 'Central Quad', 120),
(2, 'CQ-201', 'Central Quad', 80),
(3, 'East Quad Auditorium', 'East Quad', 200),
(4, 'Library Seminar Room', 'Park House', 40),
(5, 'Sports Hall', 'Grangegorman', 300),
(6, 'Computer Lab 3', 'Central Quad', 35);


-- ============================================================
-- 3. POPULATE STUDENTS
-- ============================================================

INSERT INTO student (student_id, name, email, programme) VALUES
(1001, 'Aoife Murphy', 'aoife.murphy@student.tudublin.ie', 'TU422'),
(1002, 'Cian Kelly', 'cian.kelly@student.tudublin.ie', 'TU422'),
(1003, 'Emma Byrne', 'emma.byrne@student.tudublin.ie', 'TU856'),
(1004, 'Jack Doyle', 'jack.doyle@student.tudublin.ie', 'TU856'),
(1005, 'Sophie Ryan', 'sophie.ryan@student.tudublin.ie', 'TU422'),
(1006, 'Daniel Walsh', 'daniel.walsh@student.tudublin.ie', 'TU858'),
(1007, 'Niamh O''Connor', 'niamh.oconnor@student.tudublin.ie', 'TU422'),
(1008, 'Sean Brennan', 'sean.brennan@student.tudublin.ie', 'TU856'),
(1009, 'Ella McCarthy', 'ella.mccarthy@student.tudublin.ie', 'TU858'),
(1010, 'Luke Nolan', 'luke.nolan@student.tudublin.ie', 'TU422'),
(1011, 'Grace Flynn', 'grace.flynn@student.tudublin.ie', 'TU856'),
(1012, 'Adam Quinn', 'adam.quinn@student.tudublin.ie', 'TU858'),
(1013, 'Sarah Connolly', 'sarah.connolly@student.tudublin.ie', 'TU422'),
(1014, 'Conor Hayes', 'conor.hayes@student.tudublin.ie', 'TU856'),
(1015, 'Kate Murray', 'kate.murray@student.tudublin.ie', 'TU422');


-- ============================================================
-- 4. POPULATE EVENTS
-- ============================================================

INSERT INTO event
(event_id, title, event_date, venue_id, category_id, capacity)
VALUES

(1, 'AI Careers Evening',
 '2026-09-24 18:00:00', 1, 1, 100),

(2, 'Introduction to PostgreSQL',
 '2026-09-28 14:00:00', 6, 2, 30),

(3, 'Data Analytics Industry Panel',
 '2026-10-02 17:00:00', 3, 1, 180),

(4, 'Cybersecurity Workshop',
 '2026-10-07 10:00:00', 2, 2, 70),

(5, 'Research Skills Seminar',
 '2026-10-12 13:00:00', 4, 3, 35),

(6, 'Student Society Fair',
 '2026-10-15 12:00:00', 3, 4, 200),

(7, 'Managing Exam Stress',
 '2026-10-20 11:00:00', 4, 5, 35),

(8, 'Five-a-Side Football',
 '2026-10-23 16:00:00', 5, 6, 60),

(9, 'Redis for Fast Data',
 '2026-11-03 14:00:00', 6, 2, 30),

(10, 'Graduate Recruitment Fair',
 '2026-11-10 11:00:00', 3, 1, 180),

(11, 'Advanced SQL Clinic',
 '2026-11-17 15:00:00', 6, 3, 30),

(12, 'End of Semester Social',
 '2026-12-04 18:30:00', 1, 4, 110);


-- ============================================================
-- 5. POPULATE REGISTRATIONS
-- ============================================================

-- Event 1 - AI Careers Evening
-- 10 registrations

INSERT INTO registration VALUES
(1, 1001, 1, '2026-09-10 09:15:00', 'REGISTERED', FALSE),
(2, 1002, 1, '2026-09-10 09:20:00', 'REGISTERED', FALSE),
(3, 1003, 1, '2026-09-10 10:05:00', 'REGISTERED', FALSE),
(4, 1004, 1, '2026-09-10 10:15:00', 'REGISTERED', FALSE),
(5, 1005, 1, '2026-09-10 11:00:00', 'REGISTERED', FALSE),
(6, 1006, 1, '2026-09-10 11:20:00', 'REGISTERED', FALSE),
(7, 1007, 1, '2026-09-11 08:30:00', 'REGISTERED', FALSE),
(8, 1008, 1, '2026-09-11 08:45:00', 'REGISTERED', FALSE),
(9, 1009, 1, '2026-09-11 09:00:00', 'REGISTERED', FALSE),
(10, 1010, 1, '2026-09-11 09:10:00', 'REGISTERED', FALSE);


-- Event 2 - Introduction to PostgreSQL
-- 8 registrations

INSERT INTO registration VALUES
(11, 1001, 2, '2026-09-12 09:00:00', 'REGISTERED', FALSE),
(12, 1003, 2, '2026-09-12 09:10:00', 'REGISTERED', FALSE),
(13, 1005, 2, '2026-09-12 09:20:00', 'REGISTERED', FALSE),
(14, 1007, 2, '2026-09-12 09:30:00', 'REGISTERED', FALSE),
(15, 1009, 2, '2026-09-12 09:40:00', 'REGISTERED', FALSE),
(16, 1011, 2, '2026-09-12 09:50:00', 'REGISTERED', FALSE),
(17, 1013, 2, '2026-09-12 10:00:00', 'REGISTERED', FALSE),
(18, 1015, 2, '2026-09-12 10:10:00', 'REGISTERED', FALSE);


-- Event 3 - Industry Panel
-- 6 registrations

INSERT INTO registration VALUES
(19, 1002, 3, '2026-09-15 12:00:00', 'REGISTERED', FALSE),
(20, 1004, 3, '2026-09-15 12:05:00', 'REGISTERED', FALSE),
(21, 1006, 3, '2026-09-15 12:10:00', 'REGISTERED', FALSE),
(22, 1008, 3, '2026-09-15 12:15:00', 'REGISTERED', FALSE),
(23, 1010, 3, '2026-09-15 12:20:00', 'REGISTERED', FALSE),
(24, 1012, 3, '2026-09-15 12:25:00', 'REGISTERED', FALSE);


-- Event 4 - Cybersecurity Workshop
-- 4 registrations

INSERT INTO registration VALUES
(25, 1001, 4, '2026-09-18 13:00:00', 'REGISTERED', FALSE),
(26, 1004, 4, '2026-09-18 13:05:00', 'REGISTERED', FALSE),
(27, 1008, 4, '2026-09-18 13:10:00', 'REGISTERED', FALSE),
(28, 1014, 4, '2026-09-18 13:15:00', 'REGISTERED', FALSE);


-- Event 5 - Research Skills
-- 7 registrations

INSERT INTO registration VALUES
(29, 1003, 5, '2026-09-20 09:00:00', 'REGISTERED', FALSE),
(30, 1005, 5, '2026-09-20 09:05:00', 'REGISTERED', FALSE),
(31, 1007, 5, '2026-09-20 09:10:00', 'REGISTERED', FALSE),
(32, 1009, 5, '2026-09-20 09:15:00', 'REGISTERED', FALSE),
(33, 1011, 5, '2026-09-20 09:20:00', 'REGISTERED', FALSE),
(34, 1013, 5, '2026-09-20 09:25:00', 'REGISTERED', FALSE),
(35, 1015, 5, '2026-09-20 09:30:00', 'REGISTERED', FALSE);


-- Event 6 - Student Society Fair
-- 3 registrations

INSERT INTO registration VALUES
(36, 1002, 6, '2026-09-22 10:00:00', 'REGISTERED', FALSE),
(37, 1006, 6, '2026-09-22 10:05:00', 'REGISTERED', FALSE),
(38, 1010, 6, '2026-09-22 10:10:00', 'REGISTERED', FALSE);


-- Event 7 - Managing Exam Stress
-- 6 registrations

INSERT INTO registration VALUES
(39, 1001, 7, '2026-09-25 14:00:00', 'REGISTERED', FALSE),
(40, 1005, 7, '2026-09-25 14:05:00', 'REGISTERED', FALSE),
(41, 1007, 7, '2026-09-25 14:10:00', 'REGISTERED', FALSE),
(42, 1009, 7, '2026-09-25 14:15:00', 'REGISTERED', FALSE),
(43, 1013, 7, '2026-09-25 14:20:00', 'REGISTERED', FALSE),
(44, 1015, 7, '2026-09-25 14:25:00', 'REGISTERED', FALSE);


-- Event 8 - Football
-- 5 registrations

INSERT INTO registration VALUES
(45, 1002, 8, '2026-09-27 11:00:00', 'REGISTERED', FALSE),
(46, 1004, 8, '2026-09-27 11:05:00', 'REGISTERED', FALSE),
(47, 1006, 8, '2026-09-27 11:10:00', 'REGISTERED', FALSE),
(48, 1008, 8, '2026-09-27 11:15:00', 'REGISTERED', FALSE),
(49, 1010, 8, '2026-09-27 11:20:00', 'REGISTERED', FALSE);


-- Event 9 - Redis
-- deliberately only 2 registrations

INSERT INTO registration VALUES
(50, 1001, 9, '2026-10-01 09:00:00', 'REGISTERED', FALSE),
(51, 1002, 9, '2026-10-01 09:05:00', 'REGISTERED', FALSE);


-- Event 10 - Graduate Recruitment Fair
-- 6 registrations

INSERT INTO registration VALUES
(52, 1003, 10, '2026-10-05 10:00:00', 'REGISTERED', FALSE),
(53, 1005, 10, '2026-10-05 10:05:00', 'REGISTERED', FALSE),
(54, 1007, 10, '2026-10-05 10:10:00', 'REGISTERED', FALSE),
(55, 1009, 10, '2026-10-05 10:15:00', 'REGISTERED', FALSE),
(56, 1011, 10, '2026-10-05 10:20:00', 'REGISTERED', FALSE),
(57, 1013, 10, '2026-10-05 10:25:00', 'REGISTERED', FALSE);


-- Event 11 deliberately has NO registrations.
-- This makes the OUTER JOIN question meaningful.

-- Event 12 - End of Semester Social
-- 4 registrations

INSERT INTO registration VALUES
(58, 1004, 12, '2026-10-10 12:00:00', 'REGISTERED', FALSE),
(59, 1008, 12, '2026-10-10 12:05:00', 'REGISTERED', FALSE),
(60, 1012, 12, '2026-10-10 12:10:00', 'REGISTERED', FALSE),
(61, 1014, 12, '2026-10-10 12:15:00', 'CANCELLED', FALSE);


-- ============================================================
-- 6. VERIFY THE DATABASE
-- ============================================================

SELECT COUNT(*) AS students FROM student;
SELECT COUNT(*) AS venues FROM venue;
SELECT COUNT(*) AS categories FROM category;
SELECT COUNT(*) AS events FROM event;
SELECT COUNT(*) AS registrations FROM registration;