
1
SELECT n_group, COUNT (n_group)
FROM student
GROUP BY n_group
2
SELECT n_group, AVG(score)
FROM student
GROUP BY n_group
3
SELECT surname, (COUNT (surname))
FROM student
GROUP BY surname

4

5
SELECT n_group/1000 as course, (AVG (score))
FROM student
GROUP BY n_group/1000
6
SELECT n_group, (AVG(score))
FROM student
WHERE n_group/1000 = 2
GROUP BY n_group
ORDER BY avg DESC LIMIT 1
7
SELECT n_group, avg
FROM ( SELECT n_group, AVG(score)
FROM student
GROUP BY n_group ) as stud
WHERE avg <= 3.5
ORDER BY avg DESC
8
SELECT n_group, COUNT(*),MAX(score),AVG(score),MIN(score)
FROM student
GROUP BY n_group;
9
SELECT name, surname, n_group FROM student
WHERE score = (Select max(score) FROM student WHERE n_group=2282)
10
