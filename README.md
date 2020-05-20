# PMDatabase
SQL scripts to create a database for project management.

The Project Company is a consulting company that allocates qualified engineers and support personnel to her clients. Employees are assigned to projects owned by clients and clients are billed at the end of each month based on work performed in the month. The work performed by each employee within a project is documented in terms of an assignment. An assignment is identified by a unique assignment number, and documents when it is issued, which project it belongs to, which employee is involved, the number of hours scheduled, what rate to be applied. The hourly rate is fixed based on the employee's qualification and experience. Clients are companies and project owners. They are identified by a unique client id number. Information needed for each client is company name, address, and telephone number. Each employee is identified by a unique employee id number, a title such as Mr./Ms.... etc, first name, last name, a one letter initial, if any, date hired, qualification, and years of experience. Qualifications and the applicable rates areas follows :

* Programmer, $35.75/hr
* Systems Analyst, $96.75/hr
* Database Designer, $125.00/hr
* Mechanical Engineer, $67.90/hr
* Civil Engineer, $55.78/hr
* Clerical Support, $26.87/hr
* DSS Analyst, $45.95/hr
* Applications Designer, $48.10/hr
* Bio Technician, $34.55/hr
* General Support, $18.36/hr

Projects are assigned a unique project number. The client, project owner, might be using a different identifier which must be known for reference purposes. Each project also has a descriptive name, a start and end date, a budget allocated to it, and a project leader who is also an employee.The Project Company keeps 3 to 5 employees in each qualification area. The Company has 6 clients currently and is awarded 2 new projects each month. There are at least 2 assignments each month in each project. The oldest project is 5 months old and the newest is 1. 3 projects have been deployed successfully.Generate reports such as status of projects, total amount charged per project, how many employees were involved in how many assignments, how long resources (employees) were tied to which projects, ...etc.
