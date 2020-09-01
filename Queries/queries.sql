-- using conditional to find employees who are eligible for retirement
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

--find employees born in 1952
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

--find employees born in 1953
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

--find employees born in 1954
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

--find employees born in 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

--retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--number of employees retiring
SELECT COUNT (first_name) 
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
	
--create a table from the results of the query
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
	
--dropping table because I didn't run the last line of the query
DROP TABLE retirement_info CASCADE;

--running query again to create the correct table
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--inspect the new table
SELECT * FROM retirement_info;

--Joining departments and dept_manager tables with alias
SELECT d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

--Joining retirement_info and dept_emp tables.
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

DROP TABLE curent_emp CASCADE; 

--Joining retirement_info and dept_emp tables with alias
--use conditional to pull current employees
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

--employee count by department number in order of dept_no
SELECT COUNT(ce.emp_no), de.dept_no
INTO emp_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM current_emp;
SELECT * FROM salaries
ORDER BY to_date DESC;


--Creating employee info list
SELECT 	e.emp_no,
		e.last_name,
		e.first_name,
		e.gender,
		s.salary,
		de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON e.emp_no = s.emp_no
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (de.to_date = '9999-01-01')
ORDER BY e.last_name;

SELECT * FROM emp_info;
SELECT * FROM emp_count;

--create management list
SELECT 	dm.dept_no,
		d.dept_name,
		ei.emp_no,
		ei.last_name,
		ei.first_name,
		dm.from_date,
		ei.to_date
INTO manager_info
FROM emp_info as ei
INNER JOIN dept_manager as dm
ON (ei.emp_no = dm.emp_no)
INNER JOIN departments as d
ON (dm.dept_no = d.dept_no);

--create department retirees list
SELECT	ce.emp_no,
		ce.first_name,
		ce.last_name,
		d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp as de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no);

--create list for sales department
SELECT 	di.emp_no,
		di.first_name,
		di.last_name,
		di.dept_name
INTO sales_emp
FROM dept_info as di
WHERE di.dept_name = ('Sales');

--create list for sales and development mentor program
SELECT 	di.emp_no,
		di.first_name,
		di.last_name,
		di.dept_name
INTO mentor_prog
FROM dept_info as di
WHERE dept_name IN ('Sales', 'Development');