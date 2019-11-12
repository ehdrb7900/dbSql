SELECT * FROM countries;
SELECT * FROM regions;
SELECT * FROM locations;
SELECT * FROM departments;
SELECT * FROM employees;

-- 데이터 결합 실습 join 8
SELECT c.region_id, region_name, country_name
FROM countries c, regions r
WHERE c.region_id = r.region_id
  AND region_name = 'Europe';
  
-- 데이터 결합 실습 join 9
SELECT c.region_id, region_name, country_name, city
FROM countries c, regions r, locations l
WHERE c.region_id = r.region_id
  AND c.country_id = l.country_id
  AND region_name = 'Europe';

-- 데이터 결합 실습 join 10
SELECT c.region_id, region_name, country_name, city, department_name
FROM countries c, regions r, locations l, departments d
WHERE c.region_id = r.region_id
  AND c.country_id = l.country_id
  AND l.location_id = d.location_id
  AND region_name = 'Europe';
  
-- 데이터 결합 실습 join 11
SELECT c.region_id, region_name, country_name, city, department_name, (first_name || last_name) name
FROM countries c, regions r, locations l, departments d, employees e
WHERE c.region_id = r.region_id
  AND c.country_id = l.country_id
  AND l.location_id = d.location_id
  AND d.department_id = e.department_id
  AND region_name = 'Europe';
  
-- 데이터 결합 실습 join 12
SELECT employee_id, (first_name || last_name) name, e.job_id, job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id;

-- 데이터 결합 실습 join 13
SELECT e2.employee_id mng_id, (e2.first_name || e2.last_name) mgr_name, e1.employee_id, (e1.first_name || e1.last_name) name, e1.job_id, job_title
FROM employees e1, employees e2, jobs j
WHERE e1.manager_id = e2.employee_id
   AND e1.job_id = j.job_id;


SELECT * FROM employees;
SELECT * FROM jobs;