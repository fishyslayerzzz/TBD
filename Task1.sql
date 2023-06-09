select n_group,
	count(*) as cnt,
	count(date_birth) as cnt_db,
	sum(score) as sum_score,
	min(score) as min_score,
	max(score) as max_score,
	avg(score)::real as avg_score
FROM student
GROUP BY n_group
HAVING avg(score)>4 and avg(score)<4.5;

SELECT surname, name, score
FROM student
group by surname, name, score
HAVING avg(score)>4 and avg(score)<4.5

SELECT *
FROM student
ORDER BY n_group DESC, name

SELECT surname, name, score
FROM student
group by surname, name, score
HAVING avg(score)>4
order by score DESC

select name, risk
from hobby
where name = 'Футбол' or name = 'Баскетбол'

select *
from student_hobby

SELECT surname, name, score
FROM student
group by surname, name, score
HAVING avg(score)>4.5

SELECT surname, name, score
FROM student
group by surname, name, score
ORDER BY score DESC
LIMIT 5

SELECT name, risk,
 CASE 
 WHEN risk>=8 THEN 'очень высокий'
 WHEN risk>=6 THEN 'высокий'
 WHEN risk>=4 THEN 'средний'
 WHEN risk>=2 THEN 'низкий'
 WHEN risk<2 THEN 'очень низкий'
END
from hobby
order by risk

SELECT name, risk,
 CASE 
 WHEN risk>=8 THEN 'очень высокий'
 WHEN risk>=6 THEN 'высокий'
 WHEN risk>=4 THEN 'средний'
 WHEN risk>=2 THEN 'низкий'
 WHEN risk<2 THEN 'очень низкий'
END
FROM hobby
group by name,risk
ORDER BY risk DESC
LIMIT 3
