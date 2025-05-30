CREATE TABLE department (
    department_id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE employee (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department_id INTEGER NOT NULL,
    manager_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES department(department_id),
    FOREIGN KEY (manager_id) REFERENCES employee(employee_id)
);
