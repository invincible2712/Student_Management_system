create DATABASE student_management_system;
use student_management_system;

-- Read all table data
select * from students;
select * from teachers;
select * from classes;
select * from subjects;
select * from attendance;
select * from grades;

-- Count no. of students and teachers
select Count(*) as Total_students from students;
select Count(*) as Total_teachers from teachers;

-- List all classes and their respective teachers
select classes.class_name , Concat(Teachers.first_name , ' ' , Teachers.Last_name) as teacher_name
from classes
JOIN Teachers ON Classes.teacher_id = Teachers.teacher_id;

-- Get the grades of a speciic student (ex,student_id = 1)
select subjects.subject_name , Grades.grade , Grades.exam_date 
from Grades
Join Subjects ON Grades.subject_id = Subjects.subject_id
where Grades.student_id = 1;

-- Retrieve Attendance Records for a specific student (EX Student_ID = 1)
Select attendance_date , Status
from Attendance
where student_id = 10;

-- List all students along with their class names
select students.student_id , Concat(Students.first_name , ' ' , Students.last_name) as Student_name , Classes.class_name
from students
JOIN Classes on students.class_id = Classes.class_id;

-- Count Attendance (Ex Present , Absent)
select status , Count(*) As count
from Attendance
group by status;

-- List students with their last Attendance Date
select students.student_id , Concat(Students.first_name , ' ' , Students.last_name) as student_name,
Max(Attendance.attendance_date) as Last_attendance_date
from Students
LEFT JOIN Attendance ON Students.student_id = Attendance.student_id
group by Students.student_id , students.first_name , students.last_name 
limit 0, 5000;

-- Student who failed i.e grade greater than c
select Distinct Concat(students.first_name , ' ' , Students.last_name) as Student_name ,
classes.class_name,
grades.grade
from students
JOIN Grades ON students.student_id = Grades.student_id
JOIN subjects on Grades.subject_id = Subjects.subject_id
JOIN Classes on Subjects.class_id = Classes.class_id
Where Grades.grade > 'C'
Order by Classes.class_name , student_name;

-- Students who scored A in each class
select s.student_id , s.first_name , s.last_name , c.class_name
from students s
JOIN grades g ON s.student_id = g.student_id
JOIN classes c ON s.class_id = c.class_id
where g.grade = 'A';

-- Average number of teaching subjects per teacher
select t.teacher_id , t.first_name , t.last_name,
count(Distinct s.subject_id) as teaching_subject_count
from teachers t
LEFT JOIN subjects s on t.subject_id = s.subject_id
Group by t.teacher_id , t.first_name , t.Last_name;

-- Count of students in each class
select c.class_name , Count(s.student_id) as student_count
from classes c
join students s on c.class_id = s.class_id
group by c.class_name;

-- student count above 400
select c.class_name , Count(s.student_id) as student_count
from classes c
join students s on c.class_id = s.class_id
group by c.class_name
having student_count > 400;

-- Most Common grades in each subject
select sub.subject_name , g.grade , COUNT(g.grade) as Grade_count
from grades g
JOIN subjects sub on g.subject_id = sub.subject_id
Group by sub.subject_name , g.grade
Order by sub.subject_name , grade_count DESC;

-- Changing grades to marks
SET SQL_SAFE_UPDATES = 0;
update grades
set grade = CASE
When grade = 'A' THEN 99
When grade = 'B' THEN 89
When grade = 'C' THEN 79
When grade = 'D' THEN 69
When grade = 'E' THEN 49
When grade = 'F' THEN 39
END
WHERE grade in ('A','B','C','D','E','F');

-- Maximum and Minimum marks per subject
select subject_id , MAX(Grade) as max_grade , MIN(Grade) as min_grade
from grades
Group by subject_id;

-- Average Marks per classes
select c.class_name , AVG(g.grade) as avg_grade
From grades g
JOIN students s ON g.student_id = s.student_id
JOIN classes c ON s.class_id = c.class_id
Group by c.class_name;

-- Monthly Attendance Count
Select Date_Format(attendance_date , '%Y-%m') as month , Count(*) as Attendance_count
from attendance
Group by month
order by month;
