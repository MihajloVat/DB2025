--simple selects with agregations

SELECT COUNT(DISTINCT loc_city) as "Міста де було щось продано"
FROM soldonday;

SELECT COUNT(*) as "Кількість документів"
FROM document;

SELECT SUM(price) AS "Сума продажів"
FROM soldonday;

SELECT SUM(price) AS "Сума продажів зі Львова"
FROM soldonday
WHERE loc_city='Львів';

SELECT MIN(price) AS "Найдешевше продане"
FROM soldonday;

SELECT MAX(price) AS "Найдорожче продане"
FROM soldonday;

SELECT AVG(price) AS "Середня ціна проданого"
FROM soldonday;

--selects with grouping

SELECT loc_city, SUM(price) AS "Сума продажів по містах"
FROM soldonday
GROUP BY loc_city;

SELECT date_, SUM(price) AS "Сума продажів в день"
FROM soldonday
GROUP BY date_;

--selects with filtering

SELECT menu_id, SUM(current_price) AS "Сумарна ціна меню"
FROM item
GROUP BY menu_id
HAVING COUNT(*)<3;

SELECT menu_id, SUM(current_price) AS "Сумарна ціна меню"
FROM item
GROUP BY menu_id
HAVING SUM(current_price)<190;

SELECT menu_id, SUM(current_price) AS "Сумарна ціна меню"
FROM item
GROUP BY menu_id
HAVING menu_id IN (4,3);

SELECT loc_city, SUM(price) AS "Сума продажів по містах"
FROM soldonday
GROUP BY loc_city
HAVING loc_city in ('Харків','Вінниця');

--joins

--дізнатись який товар належить якому меню
SELECT menu.title AS "Меню", item.title AS "Позиція"
FROM item
INNER JOIN menu ON item.menu_id = menu.menu_id;

--порівняти актуальні ціни, та за які продавались (серед актуальних позицій)
SELECT item.title, soldonday.date_, item.current_price, soldonday.price AS "sold_prise"
FROM item
LEFT JOIN soldonday ON item.item_id = soldonday.item_id
ORDER BY item.title;

--відношення робітників до документів
SELECT employee.surname, document.title
FROM document
INNER JOIN employeedoc ON employeedoc.doc_id = document.doc_id
INNER JOIN employee ON employeedoc.emp_id = employee.emp_id;

--Підзапити

--всі позиції, що продались хоч раз
SELECT *
FROM item
WHERE item_id IN (SELECT item_id FROM soldonday WHERE item_id IS NOT NULL);

--позиції меню, що продавались дорожче за свою поточну ціну
SELECT title, current_price
FROM item
WHERE current_price < (
SELECT MAX(price)
FROM soldonday
WHERE item_title = item.title);

--документи щодо локації, де працює найбільше співробітників
SELECT *
FROM document
WHERE loc_id = (
SELECT COUNT(*) AS C
FROM employee
GROUP BY loc_id
ORDER BY C DESC 
LIMIT 1
);

--Багатотаблична агрегація

--порівняти актуальні ціни, та за які продавались (серед актуальних позицій)
-- + побачити кількість проданої позиції
SELECT item.title, soldonday.date_, item.current_price, soldonday.price AS "sold_prise",
COUNT(*) OVER (PARTITION BY item.title) as "Кількість"
FROM item
LEFT JOIN soldonday ON item.item_id = soldonday.item_id
ORDER BY item.title;

--відношення робітників до документів + 
SELECT CONCAT( employee.surname,' ',employee.name_) AS full_name, STRING_AGG(document.title,',  ') as "Документи"
FROM document
INNER JOIN employeedoc ON employeedoc.doc_id = document.doc_id
INNER JOIN employee ON employeedoc.emp_id = employee.emp_id
GROUP BY full_name











