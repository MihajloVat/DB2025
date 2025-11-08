SELECT TO_TIMESTAMP(AVG(EXTRACT(EPOCH FROM dline))) AT TIME ZONE 'UTC' AS avg_deadline 
--в таблицях й інсертах не вказано часовий пояс, тож з AT TIME ZONE 'UTC' повернеться дата як в таблиці
FROM Tasks
GROUP BY prio;

SELECT a.user_id,t.task_id,t.stat
FROM Assignment a
INNER JOIN Tasks t
ON a.task_id = t.task_id

