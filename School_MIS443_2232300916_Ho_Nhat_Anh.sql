-- Create Schema
CREATE SCHEMA IF NOT EXISTS school;

-- 1. Create Students Table
Create table school.students(
student_id integer not null,
first_name varchar(50),
last_name varchar(50),
email varchar(100),
enrollment_date date,
graduation_year integer,
major varchar(100),
constraint students_pk Primary Key(student_id)
);

-- 2. Create Professors Table
Create table school.professors(
professor_id integer not null,
first_name varchar(50),
last_name varchar(50),
email varchar(100),
department varchar(100),
hire_date date,
constraint professors_pk Primary Key(professor_id)
);

-- 3. Create Courses Table
Create table school.courses(
course_id varchar(10) not null,
course_name varchar(50),
credits integer,
department varchar(100),
professor_id integer,
constraint courses_pk Primary Key(course_id),
constraint fk_courses_professor_id Foreign Key (professor_id) references school.professors(professor_id)
);

-- 4. Create Enrollments Table
Create table school.enrollments(
enrollment_id integer not null,
student_id integer,
course_id varchar(10),
semester varchar(20),
year integer,
grade varchar(2),
constraint enrollments_pk Primary Key(enrollment_id),
constraint fk_enrollments_student_id Foreign Key (student_id) references school.students(student_id),
constraint fk_enrollments_course_id Foreign Key (course_id) references school.courses(course_id)
);


---Question 1: Return the complete student roster from the students table.
select * from school.students;

---Question 2: Return students who are majoring in Computer Science.
select first_name, last_name, graduation_year from school.students
where major like 'Computer Science';

---Question 3: Return all courses ordered by credit hours from highest to lowest.
select course_name, credits from school.courses
order by credits DESC;

---Question 4: Return students who are expected to graduate in 2026.
select first_name, last_name, major from school.students
where graduation_year = '2026';