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

SELECT location.address, locmenu.menu_id--, menu.title
FROM locmenu
INNER JOIN location ON locmenu.loc_id = location.loc_id
--INNER JOIN menu ON menu.menu_id = locmenu.menu_id;
--які меню за якими локаціями доступні








