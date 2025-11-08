INSERT INTO Projects (title, descr, s_date, dline)
VALUES 
('Website Redesign', 'Update the company website with new design', NULL , '2025-03-15'),
('Mobile App', 'Create an Android and iOS app for tracking habits', '2025-02-01', NULL),
('Marketing Campaign', NULL, '2025-03-01', '2025-04-10');

INSERT INTO Users (team_role, fullname, email)
VALUES
('Developer', 'Alice Johnson', 'alice@example.com'),
('Project Manager', 'Bob Smith', 'bob@example.com'),
('Designer', 'Charlie Brown', NULL);

INSERT INTO Tasks (proj_id, title, descr, prio, dline, stat)
VALUES
(1, 'Implement Frontend', 'Develop the React interface', 2, '2025-02-10', 'active'),
(1, 'Setup Backend', NULL, 1, '2025-02-20', 'planned'),
(2, 'Create App Layout', 'Basic UI structure for mobile app', 3, NULL, 'paused');


INSERT INTO Assignment (user_id, task_id) VALUES (1, 1);
INSERT INTO Assignment (user_id, task_id) VALUES (1, 2);
INSERT INTO Assignment (user_id, task_id) VALUES (2, 3);

INSERT INTO Comments (user_id, task_id, comm)
VALUES
(1, 1, 'Started working on the frontend today.'),
(2, 1, 'Please make sure to follow the new UI guidelines.'),
(1, 2, 'Backend setup will require additional libraries.');

