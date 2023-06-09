---------------------1-------------------
SELECT stud.name, stud.surname, h.hobby_name FROM student stud
INNER JOIN student_hobby sh ON stud.n_z = sh.id
INNER JOIN hobby h ON h.id = sh.id

---------------------2-------------------
SELECT (NOW ()-sh.started_at) as doing, *
FROM student stud
INNER JOIN student_hobby sh ON stud.n_z  = sh.student_id
INNER JOIN hobby h ON h.id = sh.hobby_id
WHERE sh.finished_at IS NULL
ORDER BY sh.started_at
--------------------3--------------- 
SELECT stud.name, stud.surname, stud.n_z, stud.date_birth
FROM student stud LEFT JOIN (
SELECT student_id, SUM(risk) FROM student_hobby sh
JOIN hobby h on sh.hobby_id = h.id
GROUP BY student_id) as nt 
ON stud.id=nt.student_id
WHERE stud.score>= (select AVG(score) FROM student) and nt.sum>9
------------------------5------------------
SELECT stud.surname, stud.name, stud.n_z, stud.age
FROM student stud 
Inner JOIN (
SELECT student_id, (count(sh.started_at)-count(sh.finished_at)) as counter
FROM student_hobby sh
JOIN hobby h on sh.hobby_id = h.id
GROUP BY student_id) as nt 
ON stud.n_z=nt.student_id
WHERE stud.age>19 and nt.counter>1
-----------------6-------------
SELECT stud.n_group, AVG(stud.score)
FROM student stud
INNER JOIN student_hobby sh on stud.n_z=sh.student_id
WHERE sh.finished_at IS NULL and sh.started_at IS NOT NULL
GROUP BY stud.n_group
--------------------7-------------
SELECT h.hobby_name as hobby, h.risk, 12*extract( days from (NOW ()-sh.started_at)) as doing, stud.n_z
FROM student stud
INNER JOIN student_hobby sh ON stud.n_z = sh.student_id
INNER JOIN hobby h ON h.id = sh.hobby_id
WHERE sh.finished_at IS NULL and stud.n_z=1
ORDER BY sh.started_at
------------------8----------------
SELECT h.hobby_name as hobby
FROM hobby h
INNER JOIN  student_hobby sh on h.id=sh.hobby_id
INNER JOIN( SELECT stud.n_z FROM student stud
WHERE stud.score=(select MAX(score) from student)) as nt on nt.n_z = sh.student_id
WHERE sh.finished_at IS NULL
----------------9-------------
SELECT h.hobby_name as hobby
FROM hobby h
INNER JOIN
student_hobby sh on h.id = sh.hobby_id
INNER JOIN (SELECT stud.n_z
FROM student stud
WHERE stud.score=3 and n_group/1000=2)  stud on stud.n_z=sh.student_id
WHERE sh.finished_at IS NULL
-----------------------10----------------
SELECT course_act.course
FROM
(SELECT course, COUNT(DISTINCT sh.student_id )as zanim
FROM student_hobby sh
INNER JOIN (
SELECT DISTINCT n_group/1000 as course, st.n_z
FROM student st) as nt on nt.n_z = sh.student_id
WHERE finished_at IS NULL
GROUP BY course) as course_act
RIGHT JOIN
(SELECT n_group/1000 as course, COUNT(*) from student st GROUP BY n_group/1000) as course_all 
on course_act.course = course_all.course
WHERE course_act.zanim*1./course_all.count>0.5
-----------------------11-------------- 
SELECT n_group FROM student
GROUP BY n_group
HAVING COUNT(CASE
    WHEN score>=4 THEN 1
    ELSE NULL END)/COUNT(*)>=0.6
--------------12-------------
SELECT n_group/1000 as course, COUNT(DISTINCT h.hobby_name)
FROM student as stud
RIGHT JOIN student_hobby as sh on sh.student_id=stud.n_z
Left JOIN hobby as h on h.id=sh.hobby_id
GROUP BY n_group/1000
-----------------13---------------
SELECT stud.n_z, stud.surname, stud.name, stud.age, n_group/1000 as course
FROM student as stud
LEFT JOIN student_hobby as sh on sh.student_id=stud.n_z
Left JOIN hobby as h on h.id=sh.hobby_id
WHERE sh.hobby_id is NULL and score=5
ORDER BY course, stud.age DESC
--------------14--------------
CREATE OR REPLACE VIEW full_info AS
SELECT distinct stud.n_z, stud.name, stud.surname,stud.email,stud.score,stud.n_group,stud.age
FROM student stud 
RIGHT JOIN student_hobby sh on stud.n_z=sh.student_id
WHERE finished_at is null and  extract(year from (clock_timestamp ( )-sh.started_at))>5
-----------------------15--------------
SELECT h.hobby_name, COUNT((sh.student_id, sh.hobby_id)) as count 
FROM hobby h LEFT JOIN student_hobby sh on h.id=sh.hobby_id
WHERE sh.finished_at is null
GROUP BY h.hobby_name
--------------16------------------ 
SELECT id FROM(
SELECT h.id, COUNT((sh.student_id, sh.hobby_id))
FROM hobby h LEFT JOIN student_hobby sh on h.id=sh.hobby_id
WHERE sh.finished_at is null
GROUP BY h.id 
ORDER BY count desc limit 1) as popular_hobby
-----------17------------
SELECT * FROM student stud RIGHT JOIN (
Select student_id from student_hobby sh
RIGHT JOIN( SELECT h.id  FROM hobby h LEFT JOIN student_hobby sh on h.id=sh.hobby_id
WHERE sh.finished_at is null
GROUP BY h.id
ORDER BY COUNT(distinct (sh.student_id, sh.hobby_id)) desc limit 1) as besth on besth.id=sh.hobby_id
WHERE finished_at is null) as stid on stud.n_z = stid.student_id
--------------18--------------
SELECT id FROM hobby ORDER BY risk desc limit 3
---------------------19-------------------
SELECT distinct stud.n_z, stud.name, stud.surname,stud.n_group sh.started_at FROM
student stud RIGHT JOIN student_hobby sh on stud.n_z=sh.student_id
WHERE sh.finished_at is null
ORDER BY sh.started_at limit 5
-------------------20----------------
SELECT distinct n_group from
(SELECT distinct stud.n_z, stud.name, stud.surname,stud.n_group, sh.started_at FROM
student stud RIGHT JOIN student_hobby sh on stud.n_z=sh.student_id
WHERE sh.finished_at is null
ORDER BY sh.started_at limit 5 ) as groupsss
----------21-----------------
CREATE OR REPLACE VIEW not_full_info AS
SELECT n_z, name, surname
FROM student
ORDER BY score desc
------------------26---------------------
CREATE VIEW updatable as
SELECT * FROM hobby;
SELECT * FROM updatable;
----------28----------------
SELECT n_group/1000 as course, surname, max(score),min(score) 
from student
group by n_group/1000, surname
 
-------------29-------------
SELECT age, COUNT(distinct hobby_id)
FROM student stud RIGHT JOIN student_hobby sh on stud.n_z = sh.student_id
GROUP BY age
 
-----------------30--------------- 
SELECT left(stud_tabl.name,1), min(risk), max(risk)
FROM (student stud RIGHT JOIN student_hobby sh on stud.n_z = sh.student_id) as stud_tabl
LEFT JOIN hobby h on h.id=stud_tabl.student_id
GROUP BY left(stud_tabl.name,1)
 
---------------31---------------
ALTER TABLE student
ADD date_of_birth DATE;
ALTER TABLE student 
ALTER COLUMN date_of_birth 
SET NOT NULL;

SELECT extract(month from date_of_birth) as month, avg(score)
FROM (student stud right join student_hobby sh on sh.student_id=stud.n_z) as month_table left join hobby h on h.id=month_table.hobby_id
WHERE finished_at is null and h.hobby_name='dance' 
GROUP BY month

-------------32------------
SELECT distinct 'Имя: '||stud.name||', фамилия: '||stud.surname||', группа: '||stud.n_group  

FROM student stud RIGHT JOIN student_hobby sh on stud.n_z=sh.student_id
 
-------------------33-------------- 
SELECT case position('ов' in surname)::varchar
when '0' then 'не найдено'
else position('ов' in surname)::varchar end
FROM student
 
-------------------34----------------
SELECT case 
when (length(surname)>10) then surname
else rpad(surname,10,'#') end
FROM student
 
---------35----------------
SELECT rtrim(surname,'#')
FROM( SELECT case 
when (length(surname)>10) then surname
else rpad(surname,10,'#')
end as surname
from student) as norm_tabl
 
------------36------------
SELECT extract(days FROM date_trunc('month', '4-1-2018'::date) + interval '1 month - 1 day');
SELECT extract(days FROM date_trunc('month', '2-1-2020'::date) + interval '1 month - 1 day');
SELECT extract(days FROM date_trunc('month', '2-1-2018'::date) + interval '1 month - 1 day');
 
-----------37-----------
SELECT current_date + cast(abs(extract(dow FROM current_date) - 7) - 1 AS int);
SELECT current_date+7 - (( cast(extract(dow FROM current_date) AS int)+1) %8)
 
---------38--------------
Select
extract(century from current_date) as century,
extract(weeks from current_date) as weeknumber,
extract(days from current_date) as daynumber;  
---------39-------------
SELECT stud.name, stud.surname, h.hobby_name,
case
when (sh.finished_at is null) then 'Закончил'
else 'Занимается' end
FROM student stud RIGHT JOIN student_hobby sh on stud.n_z=sh.student_id LEFT JOIN hobby h on h.id = sh.hobby_id
 
---------------------40---------------
SELECT n_group,
count(case round(score) when 2 then 1 end) as "2",
count(case round(score) when 3 then 1 end) as "3",
count(case round(score) when 4 then 1 end) as "4",
count(case round(score) when 5 then 1 end) as "5"
from student
group by n_group

