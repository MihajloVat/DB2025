INSERT INTO Projects(title,descr,s_date,dline) VALUES
('Контрольна з баз даних', NULL,'2025-11-08','2025-11-08 23:59:59'),
('Курсова з баз даних', 'Застосунок для менеджменту мережі кав''ярень','2025-11-08','2025-11-08 23:59:59')

UPDATE Projects
SET s_date = DEFAULT
WHERE title = 'Контрольна з баз даних';

UPDATE Projects
SET descr = 'Передумав, придумаю іншу тему'
WHERE title = 'Курсова з баз даних';\

Delete from Projects
WHERE title = 'Контрольна з баз даних';

Delete from Projects
WHERE descr = 'Застосунок для менеджменту мережі кав''ярень'; --не спрацює, був апдейт
