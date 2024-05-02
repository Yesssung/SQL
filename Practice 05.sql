-- 문제 1.
SELECT first_name, manager_id, commission_pct, salary FROM employees WHERE manager_id IS NOT NULL AND commission_pct IS NULL AND salary > 3000;

-- 문제 2.
SELECT employee_id, first_name, salary, TO_CHAR(hire_date,'YYYY-MM-DD DAY'), REPLACE(phone_number,'.','-'), department_id FROM employees JOIN GROUP BY department_id ORDER BY salary DESC;