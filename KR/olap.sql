SELECT TO_TIMESTAMP(AVG(EXTRACT(EPOCH FROM dline))) AT TIME ZONE 'UTC' AS avg_deadline 
--в таблицях й інсертах не вказано часовий пояс, тож з AT TIME ZONE 'UTC' повернеться дата як в таблиці
FROM Tasks
GROUP BY prio;

SELECT user_id, done_tasks
FROM(
  SELECT user_id, COUNT(task_id) as done_tasks, RANK() OVER (ORDER BY COUNT(task_id) DESC) AS rank
  FROM (SELECT a.user_id,t.task_id,t.stat
      FROM Assignment a
      INNER JOIN Tasks t
      ON a.task_id = t.task_id
	  WHERE stat = 'done') 
   GROUP BY user_id
WHERE rank = 1;




