# MIS-443
# 🏫 School Database Management System (PostgreSQL)

> **Individual Database Project**  
> **Course:** MIS 443 - Business Data Management  
> **Institution:** Eastern International University (EIU)  
> **Lecturer:** Dang Thai Doan  
> **Quarter:** Q4 / 2025–2026  

---

## 👤 Student Information
* **Full Name:** Ho Nhat Anh
* **Student ID / IRN:** 2232300196
* **Major:** Business Analytics

---

## 📌 Project Overview
The **School Database Management System** is designed to centralize and streamline the management of academic data within a university environment. The primary goal of this relational database is to store, manage, and query information related to:
* **Professors** and their department affiliations.
* **Students** and their academic majors.
* **Courses** offered across various departments.
* **Enrollments**, tracking grades, semesters, and course-student mapping.

By replacing disjointed spreadsheet data with a normalized Relational Database Management System (RDBMS) using **PostgreSQL**, the system ensures data integrity, minimizes redundancy, and enables efficient querying for administrative reporting.

---

## 🗂️ Database Architecture & Schema

The database consists of **4 core tables** residing inside the `school` schema:

### 📋 Table Details
1. **`school.professors`**: Stores academic faculty member details.
   * `professor_id` (PK, INT), `first_name` (VARCHAR), `last_name` (VARCHAR), `email` (VARCHAR), `department` (VARCHAR), `hire_date` (DATE).
2. **`school.students`**: Stores undergraduate student demographic and enrollment details.
   * `student_id` (PK, INT), `first_name` (VARCHAR), `last_name` (VARCHAR), `email` (VARCHAR), `enrollment_date` (DATE), `graduation_year` (INT), `major` (VARCHAR).
3. **`school.courses`**: Contains details of all courses offered by the school.
   * `course_id` (PK, VARCHAR), `course_name` (VARCHAR), `credits` (INT), `department` (VARCHAR), `professor_id` (FK, INT).
4. **`school.enrollments`**: A junction table representing the many-to-many relationship between Students and Courses[cite: 1].
   * `enrollment_id` (PK, INT), `student_id` (FK, INT), `course_id` (FK, VARCHAR), `semester` (VARCHAR), `year` (INT), `grade` (VARCHAR)[cite: 1].

---

### 🔗 Relationships
* **`professors` ➔ `courses` (One-to-Many):** One professor can teach multiple courses[cite: 1].
  * **FK:** `courses.professor_id` $\rightarrow$ `professors.professor_id`[cite: 1].
* **`students` ↔ `courses` via `enrollments` (Many-to-Many):** A student can enroll in multiple courses, and a course can have many enrolled students[cite: 1].
  * **FK:** `enrollments.student_id` $\rightarrow$ `students.student_id`[cite: 1]
  * **FK:** `enrollments.course_id` $\rightarrow$ `courses.course_id`[cite: 1]

---

## 📐 Entity-Relationship Diagram (ERD)
<img width="376" height="338" alt="image" src="https://github.com/user-attachments/assets/881cc8c6-5aaf-46f1-83ff-3800f91f8041" />
Database Implementation (DDL Scripts)
-- Create Schema
CREATE SCHEMA IF NOT EXISTS school;

-- 1. Create Students Table
CREATE TABLE school.students (
    student_id INT NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    enrollment_date DATE,
    graduation_year INT,
    major VARCHAR(100),
    CONSTRAINT students_pk PRIMARY KEY (student_id)
);

-- 2. Create Professors Table
CREATE TABLE school.professors (
    professor_id INT NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    department VARCHAR(100),
    hire_date DATE,
    CONSTRAINT professors_pk PRIMARY KEY (professor_id)
);

-- 3. Create Courses Table
CREATE TABLE school.courses (
    course_id VARCHAR(10) NOT NULL,
    course_name VARCHAR(50),
    credits INT,
    department VARCHAR(100),
    professor_id INT,
    CONSTRAINT courses_pk PRIMARY KEY (course_id),
    CONSTRAINT fk_courses_professor_id FOREIGN KEY (professor_id) REFERENCES school.professors(professor_id)
);

-- 4. Create Enrollments Table
CREATE TABLE school.enrollments (
    enrollment_id INT NOT NULL,
    student_id INT,
    course_id VARCHAR(10),
    semester VARCHAR(20),
    year INT,
    grade VARCHAR(2),
    CONSTRAINT enrollments_pk PRIMARY KEY (enrollment_id),
    CONSTRAINT fk_enrollments_student_id FOREIGN KEY (student_id) REFERENCES school.students(student_id),
    CONSTRAINT fk_enrollments_course_id FOREIGN KEY (course_id) REFERENCES school.courses(course_id)
);

Data Import
Data from professor.csv, students.csv, course.csv, and enrollments.csv were imported using PostgreSQL's COPY statement / pgAdmin Import utility with specified delimiters[cite: 1].
Example:
COPY school.students (student_id, first_name, last_name, email, enrollment_date, graduation_year, major) 
FROM 'D:\students.csv' 
DELIMITER E'\t' ' CSV HEADER;

Summary of the Completed SQL Questions

Question 1: Return the complete student roster
SELECT * FROM school.students;
<img width="452" height="257" alt="image" src="https://github.com/user-attachments/assets/44135428-b209-4aeb-995a-60584ba10904" />
Question 2: Return students majoring in Computer Science
SELECT first_name, last_name, graduation_year 
FROM school.students
WHERE major LIKE 'Computer Science';
<img width="454" height="257" alt="image" src="https://github.com/user-attachments/assets/30b6bf13-daa7-415a-a745-c96ce2dc3178" />
Question 3: Return all courses ordered by credit hours from highe
SELECT course_name, credits 
FROM school.courses
ORDER BY credits DESC;
<img width="454" height="256" alt="image" src="https://github.com/user-attachments/assets/30042e9c-b37b-48d3-ac06-e6c610c9f109" />
Question 4: Return students who are expected to graduate in 2026
SELECT first_name, last_name, major 
FROM school.students
WHERE graduation_year = 2026;
<img width="453" height="258" alt="image" src="https://github.com/user-attachments/assets/e550b31c-47d8-4e52-88d3-245e5608c542" />

Challenges Encountered & Solutions
1. Data Type Mismatch Error
Issue: Received error invalid input syntax for type integer: "CS101" during data import[cite: 1].

Root Cause: course_id was initially defined as INTEGER, but CSV data contained string values like "CS101"[cite: 1].

Solution: Altered the column data type from INT to VARCHAR(10) across both courses and enrollments tables[cite: 1].

2. Foreign Key Constraint Violations
Issue: PostgreSQL blocked schema alterations on courses.course_id[cite: 1].

Root Cause: Active Foreign Key fk_enrollments_course_id in enrollments referenced courses(course_id)[cite: 1].

Solution: Temporarily dropped the FK constraint, modified data types in both tables, and re-added the FK constraint[cite: 1].

3. File Delimiter and Header Parsing Issues
Issue: File import failed or combined all columns into a single column[cite: 1].

Root Cause: Source files used Tab (\t) separators instead of standard commas[cite: 1].

Solution: Updated COPY command to use DELIMITER E'\t' and CSV HEADER[cite: 1].

🎯 Conclusion
The School Database Management System successfully establishes a structured, reliable, and scalable database using PostgreSQL[cite: 1]. By correctly mapping entity relationships and enforcing relational constraints, the system maintains data integrity and provides a robust baseline for school administration querying[cite: 1].
