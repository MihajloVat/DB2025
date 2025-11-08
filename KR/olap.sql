SELECT TO_TIMESTAMP(AVG(EXTRACT(EPOCH FROM dline))) AT TIME ZONE 'UTC' AS avg_deadline 
--в таблицях й інсертах не вказано часовий пояс, тож з AT TIME ZONE 'UTC' повернеться дата як в таблиці
FROM Tasks
GROUP BY prio;

SELECT user_id, done_tasks
FROM(
  SELECT user_id, COUNT(task_id) as done_tasks, 
  RANK() OVER (ORDER BY COUNT(task_id) DESC) AS rank
  FROM (SELECT a.user_id,t.task_id,t.stat
      FROM Assignment a
      INNER JOIN Tasks t
      ON a.task_id = t.task_id
	  WHERE stat = 'done') 
   GROUP BY user_id)
WHERE rank = 1;

SELECT proj_id,(done_tasks*1.0/all_tasks) as fraction,
RANK() OVER (ORDER BY done_tasks*1.0/all_tasks DESC) as rank
FROM(
SELECT proj_id, 
SUM(CASE WHEN stat = 'done' THEN 1 ELSE 0 END) as done_tasks, 
COUNT(task_id) as all_tasks
FROM Tasks
GROUP BY proj_id
);













