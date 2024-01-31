-- 保证incident_id的唯一性
DELETE c1
FROM crime_data c1
INNER JOIN crime_data c2
ON c1.incident_id = c2.incident_id
AND (c1.start_date_time < c2.start_date_time OR (c1.start_date_time = c2.start_date_time AND c1.offence_code < c2.offence_code));

-- 处理字段为空的记录
DELETE FROM crime_data WHERE dispatch_time IS NULL;
DELETE FROM crime_data WHERE COALESCE(incident_id, offence_code, dispatch_time, victims, crime_name1, crime_name2, crime_name3, city, start_date_time) IS NULL;

-- 删除start_date_time在2020年之前的记录
DELETE FROM crime_data WHERE start_date_time < '2020-01-01';

-- 城市名称转换为大写字母
UPDATE crime_data SET city = UPPER(city);

-- 创建crimes表
CREATE TABLE crimes AS
SELECT DISTINCT incident_id, offence_code, dispatch_time, victims, city, start_date_time
FROM crime_data;

-- 创建offences表
CREATE TABLE offences AS
SELECT DISTINCT offence_code, crime_name1, crime_name2, crime_name3
FROM crime_data;

-- 导入数据到crimes表
INSERT INTO crimes (incident_id, offence_code, dispatch_time, victims, city, start_date_time)
SELECT DISTINCT incident_id, offence_code, dispatch_time, victims, city, start_date_time
FROM crime_data;

-- 导入数据到offences表
INSERT INTO offences (offence_code, crime_name1, crime_name2, crime_name3)
SELECT DISTINCT offence_code, crime_name1, crime_name2, crime_name3
FROM crime_data;

UPDATE crimes SET dispatch_time = start_date_time WHERE dispatch_time IS NULL;
UPDATE offences SET crime_name1 = '' WHERE crime_name1 IS NULL;
UPDATE offences SET crime_name2 = '' WHERE crime_name2 IS NULL;
UPDATE offences SET crime_name3 = '' WHERE crime_name3 IS NULL;
