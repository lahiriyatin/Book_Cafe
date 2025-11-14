CREATE TABLE employee(
	employee_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	position VARCHAR(50),
	department VARCHAR(50),
	hire_date DATE,
	salary NUMERIC(10,2)
);

SELECT * FROM employee;

INSERT INTO employee (name, position, department, hire_date, salary)
VALUES
('ABC', 'MANAGER', 'Sales', '2022-05-08', 87000.00),
('John Doe', 'Sales Executive', 'Sales', '2023-01-15', 55000.00),
('Emily Carter', 'HR Manager', 'Human Resources', '2021-11-02', 72000.00),
('Raj Malhotra', 'Software Engineer', 'IT', '2022-07-19', 80000.00),
('Sophia Williams', 'Marketing Specialist', 'Marketing', '2023-03-10', 60000.00),
('Amit Sharma', 'Accountant', 'Finance', '2021-09-25', 65000.00),
('Lisa Thompson', 'Project Manager', 'Operations', '2020-05-30', 90000.00),
('Carlos Rivera', 'Data Analyst', 'Business Intelligence', '2022-12-01', 70000.00),
('Neha Kapoor', 'Customer Support', 'Support', '2023-06-05', 45000.00),
('David Miller', 'Network Administrator', 'IT', '2021-02-18', 75000.00);


SELECT * FROM employee;

UPDATE employee
SET department = 'Sales'
WHERE name = 'ABC';

TRUNCATE TABLE employee RESTART IDENTITY;