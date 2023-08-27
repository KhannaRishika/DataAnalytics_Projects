USE HR;

-- Task 1: Use sub-query to fetch details of employees from emp and dept tables.
-- USING SUB-QUERY
	SELECT E.first_name, E.last_name, E.salary, 
	(select x.department_name from departments x where E.department_id=x.department_id ) as Dept_Name
	FROM employees E ;
    
-- USING JOIN
	SELECT E.first_name, E.last_name, E.salary, D.department_name
    FROM employees E inner join departments D
	on E.department_id=D.department_id 

-- Task 2: Display details of employees whose salaries are greater than average salary of all employees, grouped by department_id's.

-- USING SUB-QUERY

	SELECT Y.first_name, Y.last_name, Y.salary FROM (
	SELECT E.department_id, ROUND(AVG(E.salary),2) AS AVG_SAL 
    FROM employees E GROUP BY E.department_id ) X , employees Y 
    WHERE X.department_id=Y.department_id 
    AND Y.salary > X.AVG_SAL
    
-- USING JOIN
    SELECT E1.first_name, E1.last_name, E1.salary, E.department_id FROM (
	SELECT department_id, ROUND(AVG(salary),2) AS AVG_SAL 
    FROM employees GROUP BY department_id ) E
    INNER JOIN
    employees E1 ON E.department_ID = E1.department_ID
    WHERE E1.salary > E.AVG_SAL
    

-- Task 3: Display details of employees of sales department whose salaries are less than average salary of all employees of sales department.

-- SELECT department_name FROM departments WHERE department_name like '%Sales%'
-- SELECT department_name FROM departments X, employees Y where Y.department_id=X.department_id  AND  department_name like '%Sales%'

-- USING SUB-QUERY
    
	SELECT Y.first_name, Y.last_name
    -- ,Y.salary , X.AVG_SAL, X.department_name
    FROM employees Y , (SELECT D1.department_name,E.department_id, ROUND(AVG(E.salary),2) AS AVG_SAL 
    FROM employees E, departments D1 WHERE E.department_id = D1.department_id AND D1.department_name like '%Sales%' GROUP BY E.department_id ) X 
    WHERE Y.department_id = X.department_id 
    AND Y.salary < X.AVG_SAL 
 
-- USING JOIN

    SELECT E1.first_name, E1.last_name 
    -- ,E1.salary, E.AVG_SAL, E.department_name
    FROM ( SELECT Y.department_NAME ,X.department_id, ROUND(AVG(X.salary),2) AS AVG_SAL FROM employees X, departments Y 
    WHERE X.department_id=Y.department_id GROUP BY department_id HAVING Y.department_name like '%Sales%' ) E
    INNER JOIN employees E1 
    ON E.department_ID = E1.department_ID
    WHERE E1.salary < E.AVG_SAL

-- Task 4: Use subquery to - display details of emploees whose salaries are higher than salary of all IT programmers.

-- select job_id, max_salary from jobs where job_id = 'IT_PROG'
-- SELECT SALARY FROM employees WHERE SALARY >10000

	SELECT X.first_name, X.last_name, X.salary
    -- , J.max_salary, J.job_id 
    FROM (SELECT 1 AS A, E1.first_name, E1.last_name, E1.salary, J.max_salary, J.job_id
    FROM employees E1, jobs J WHERE E1.job_id=J.job_id AND J.job_id <> 'IT_PROG' ) X,
    ( SELECT  1 AS B, Y.job_id, Y.max_salary FROM  jobs Y WHERE  Y.job_id = 'IT_PROG' ) Y
    WHERE X.A = Y.B AND X.salary > Y.max_salary 
    ORDER BY X.salary 
    

-- Task 5: Display details of employees with min salary in emp table, grouped by job_id column, arranged in asc order.

   SELECT E2.*
   -- , E1.MIN_SALARY 
   FROM EMPLOYEES E2 INNER JOIN
   (SELECT JOB_ID, MIN(salary) AS MIN_SALARY  FROM EMPLOYEES GROUP BY JOB_ID) E1
   ON E2.JOB_ID=E1.JOB_ID AND E2.SALARY=E1.MIN_SALARY

-- Task 6: Display details of employees whose salary> 60% of sum of salaries of all emp of respective departments.
	
    SELECT E1.first_name, E1.last_name , E1.salary
    -- (TOTAL_SAL*60)/100, E.department_name
    FROM ( SELECT Y.department_NAME ,Y.department_id, SUM(X.salary) AS TOTAL_SAL FROM employees X, departments Y 
    WHERE X.department_id=Y.department_id GROUP BY department_id ) E
    INNER JOIN employees E1 
    ON E.department_ID = E1.department_ID
    WHERE E1.salary > (TOTAL_SAL*60)/100 ;
    
-- Task 7 Use subquery to - display details of employees whose managers are based in UK.

    SELECT X.first_name, X.last_name FROM (
    SELECT E.first_name, E.last_name, 
    (SELECT D.location_id FROM departments D where E.manager_id= D.manager_id and E.department_id= D.department_id ) AS LOCID,
    (SELECT L.country_id FROM locations L where L.location_id= D1.location_id ) AS CID 
    FROM EMPLOYEES E , DEPARTMENTS D1 WHERE E.department_id= D1.department_id 
    ) X
    WHERE X.CID='UK'

-- Task 8 Display details of top 5 highest paid employees 

   SELECT E.first_name, E.last_name, E.salary FROM EMPLOYEES E ORDER BY E.SALARY DESC LIMIT 5;
