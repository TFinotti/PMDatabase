DROP TABLE PM_ASSIGNMENTS CASCADE CONSTRAINTS;
DROP TABLE PM_PROJECTS CASCADE CONSTRAINTS;
DROP TABLE PM_CLIENTS CASCADE CONSTRAINTS;
DROP TABLE PM_EMPLOYEE CASCADE CONSTRAINTS;
DROP TABLE PM_BILLINGS CASCADE CONSTRAINTS;
DROP TABLE PM_EMPRATES CASCADE CONSTRAINTS;
DROP SEQUENCE pm_assgnno_seq;
DROP SEQUENCE pm_projectid_seq;
DROP SEQUENCE pm_clientid_seq;
DROP SEQUENCE pm_employeeid_seq;
DROP SEQUENCE pm_billingid_seq;
DROP SEQUENCE pm_empratesid_seq;

CREATE SEQUENCE pm_assgnno_seq increment by 1 start with 1000 maxvalue 9999999999 nocycle;
CREATE SEQUENCE pm_projectid_seq increment by 1 start with 1000 maxvalue 999999999 nocycle;
CREATE SEQUENCE pm_clientid_seq increment by 1 start with 1000 maxvalue 999999999 nocycle;
CREATE SEQUENCE pm_employeeid_seq increment by 1 start with 1000 maxvalue 999999999 nocycle;
CREATE SEQUENCE pm_billingid_seq increment by 1 start with 1000 maxvalue 9999999999 nocycle;
CREATE SEQUENCE pm_empratesid_seq increment by 1 start with 10 maxvalue 999 nocycle;

CREATE TABLE PM_CLIENTS (
    ClientID number(9),
    CompanyName varchar2(255) NOT NULL,
    Address varchar2(255) NOT NULL,
    Telephone number(16) NOT NULL,
    CONSTRAINT client_id_pk PRIMARY KEY (ClientID)
);

CREATE TABLE PM_EMPRATES (
    EmpRateID number(3),
    Qualification varchar2(64) NOT NULL,
    RatePerHour number(5,2) NOT NULL,    
    CONSTRAINT emp_rate_id_pk PRIMARY KEY (EmpRateID)
);

CREATE TABLE PM_EMPLOYEE (
    EmployeeID number(9),
    Title varchar2(8) NOT NULL,
    Firstname varchar2(255) NOT NULL,
    Lastname varchar2(255) NOT NULL,
    Initials varchar2(3),
    DateHired date NOT NULL,
    EmpRateID number(3),
    YearsExperience number(3),
    CONSTRAINT emp_id_pk PRIMARY KEY (EmployeeID),
    CONSTRAINT emp_rate_ide_fk FOREIGN KEY (EmpRateID)
           REFERENCES PM_EMPRATES (EmpRateID) 
);

CREATE TABLE PM_PROJECTS (
    ProjectID number(9) NOT NULL,
    ProjectAlias varchar2(255) NOT NULL,
    ProjectName varchar2(255),
    ProjectStatus number(1) DEFAULT 0,
    StartDate date NOT NULL,
    EndDate date NOT NULL,
    Budget number(16,2) NOT NULL,
    ClientID number(9) NOT NULL,
    ProjLeader number(9),
    CONSTRAINT proj_id_pk PRIMARY KEY (ProjectID),
    CONSTRAINT client_idp_fk FOREIGN KEY (ClientID)
           REFERENCES PM_CLIENTS (ClientID),
    CONSTRAINT proj_leader_fk FOREIGN KEY (ProjLeader)
           REFERENCES PM_EMPLOYEE (EmployeeID)
);

CREATE TABLE PM_ASSIGNMENTS (
    AssgnID number(10),
    AssgnDetails varchar2(255),
    HoursWorked number(6) NOT NULL,
    ProjectID number(9) NOT NULL,
    EmployeeID number(9) NOT NULL,
    CONSTRAINT assgn_id_pk PRIMARY KEY (AssgnID),
    CONSTRAINT proj_ida_fk FOREIGN KEY (ProjectID)
           REFERENCES PM_PROJECTS (ProjectID),
    CONSTRAINT emp_ida_fk FOREIGN KEY (EmployeeID)
           REFERENCES PM_EMPLOYEE (EmployeeID)
);

CREATE TABLE PM_BILLINGS (
    BillingID number(10),
    ProjectID number(9) NOT NULL,
    ClientID number(9) NOT NULL,
    Amount number(16,2) NOT NULL,    
    CONSTRAINT bill_id_pk PRIMARY KEY (BillingID),
    CONSTRAINT proj_idb_fk FOREIGN KEY (ProjectID)
           REFERENCES PM_PROJECTS (ProjectID),
    CONSTRAINT client_idb_fk FOREIGN KEY (ClientID)
           REFERENCES PM_CLIENTS (ClientID)
);

commit;



-- ** Database Project: Project Management
-- ** Table: PM_EMPRATES

-- ** Create PM_EMPRATES record
INSERT INTO PM_EMPRATES (EmpRateID, Qualification, RatePerHour) VALUES (pm_empratesid_seq.NEXTVAL,'Programmer',35.75);
INSERT INTO PM_EMPRATES (EmpRateID, Qualification, RatePerHour) VALUES (pm_empratesid_seq.NEXTVAL,'Systems Analyst',96.75);
INSERT INTO PM_EMPRATES (EmpRateID, Qualification, RatePerHour) VALUES (pm_empratesid_seq.NEXTVAL,'Database Designer',125.00);
INSERT INTO PM_EMPRATES (EmpRateID, Qualification, RatePerHour) VALUES (pm_empratesid_seq.NEXTVAL,'Mechanical Engineer',67.90);
INSERT INTO PM_EMPRATES (EmpRateID, Qualification, RatePerHour) VALUES (pm_empratesid_seq.NEXTVAL,'Civil Engineer',55.78);
INSERT INTO PM_EMPRATES (EmpRateID, Qualification, RatePerHour) VALUES (pm_empratesid_seq.NEXTVAL,'Clerical Support',26.87);
INSERT INTO PM_EMPRATES (EmpRateID, Qualification, RatePerHour) VALUES (pm_empratesid_seq.NEXTVAL,'DSS Analyst',45.95);
INSERT INTO PM_EMPRATES (EmpRateID, Qualification, RatePerHour) VALUES (pm_empratesid_seq.NEXTVAL,'Applications Designer',48.10);
INSERT INTO PM_EMPRATES (EmpRateID, Qualification, RatePerHour) VALUES (pm_empratesid_seq.NEXTVAL,'Bio Technician',34.55);
INSERT INTO PM_EMPRATES (EmpRateID, Qualification, RatePerHour) VALUES (pm_empratesid_seq.NEXTVAL,'General Support',18.36);

commit;

create or replace PACKAGE pm_project_mgmt_pkg AS
    
    -- All Functions
    FUNCTION BILLING_EXISTS_SF
    (proj_id in PM_BILLINGS.ProjectID%type ) 
    return boolean;

    FUNCTION number_assgn_for_emp_sf
    (emp_id IN PM_ASSIGNMENTS.employeeid%TYPE)
    RETURN number;

    FUNCTION projBillClient_sf
        (bill_proj IN PM_PROJECTS.ProjectID%TYPE,
        bill_client IN PM_CLIENTS.ClientID%TYPE)
        RETURN number;

    -- All Procedures
    PROCEDURE pm_add_assgn
        (assn_assgndetails IN PM_ASSIGNMENTS.AssgnDetails%TYPE,
        assn_hoursworked IN PM_ASSIGNMENTS.HoursWorked%TYPE,
        assn_projectid IN PM_ASSIGNMENTS.ProjectID%TYPE,
        assn_employeeid IN PM_ASSIGNMENTS.EmployeeID%TYPE);

    PROCEDURE pm_add_billing
        (bill_proj IN PM_BILLINGS.ProjectID%TYPE,
        client_bill IN PM_BILLINGS.ClientID%TYPE,
        amount IN PM_BILLINGS.Amount%TYPE);

    PROCEDURE pm_add_clients
        (client_name IN PM_CLIENTS.CompanyName%TYPE,
        client_address IN PM_CLIENTS.Address%TYPE,
        client_telephone IN PM_CLIENTS.Telephone%TYPE);

    PROCEDURE pm_add_employee
      (emp_title IN PM_EMPLOYEE.Title%TYPE,
       emp_fname IN PM_EMPLOYEE.Firstname%TYPE,
       emp_lname IN PM_EMPLOYEE.Lastname%TYPE,
       emp_initials IN PM_EMPLOYEE.Initials%TYPE,
       emp_datehired IN PM_EMPLOYEE.DateHired%TYPE,
       emp_rateid IN PM_EMPLOYEE.EmpRateID%TYPE,
       emp_yrsExp IN PM_EMPLOYEE.YearsExperience%TYPE);

    PROCEDURE pm_add_projects
        (proj_alias IN PM_PROJECTS.ProjectAlias%TYPE,
        proj_projname IN PM_PROJECTS.ProjectName%TYPE,
        proj_startdate IN PM_PROJECTS.StartDate%TYPE,
        proj_enddate IN PM_PROJECTS.EndDate%TYPE,
        proj_budget IN PM_PROJECTS.Budget%TYPE,
        proj_clientid IN PM_PROJECTS.ClientID%TYPE,
        proj_projleader IN PM_PROJECTS.ProjLeader%TYPE);

     PROCEDURE pm_set_projstatus
        (projid IN PM_PROJECTS.ProjectID%TYPE,
        projstatus IN PM_PROJECTS.ProjectStatus%TYPE);

END;


create or replace PACKAGE BODY PM_PROJECT_MGMT_PKG AS

    -- All Functions

    --This function checks if billing already exists in billing table
    function BILLING_EXISTS_SF
    (proj_id in PM_BILLINGS.ProjectID%type ) 
    return boolean is
    res boolean := false;
    begin
      for c1 in ( select 1 from PM_BILLINGS where ProjectID = proj_id and rownum = 1 ) loop
        res := true;
        exit; -- only care about one record, so exit.
      end loop;
      return( res );
    end;

    FUNCTION number_assgn_for_emp_sf
    (emp_id IN PM_ASSIGNMENTS.employeeid%TYPE)
    RETURN number IS 
    total_assgn number(16,2); 
    BEGIN 
       select count(PM_ASSIGNMENTS.ProjectID) into total_assgn
        from PM_ASSIGNMENTS where employeeid = emp_id group by employeeid;

       RETURN total_assgn; 
    END;

    FUNCTION projBillClient_sf
    (bill_proj IN PM_PROJECTS.ProjectID%TYPE,
    bill_client IN PM_CLIENTS.ClientID%TYPE)
    RETURN number IS 
    projectbilling number(16,2); 
    BEGIN 
       select sum(Billing) as TotalBilling into projectbilling from 
        (select TotalHours, ProjID, EmpID, Rate, Billing, pm_projects.clientid as ClientID from 
        (select TotalHours, ProjID, EmpID, Rate, (TotalHours * Rate) as Billing from 
        (select sum(PM_ASSIGNMENTS.hoursworked) as TotalHours, pm_assignments.projectid as ProjID, pm_assignments.employeeid as EmpID from PM_ASSIGNMENTS 
        group by pm_assignments.projectid, pm_assignments.employeeid) inner join 
        (select PM_EMPLOYEE.EmployeeID as EMPPID, PM_EMPRATES.RatePerHour as Rate from PM_EMPLOYEE inner join PM_EMPRATES on pm_employee.emprateid = PM_EMPRATES.EmpRateID)
        ON EmpID = EMPPID) inner join PM_PROJECTS on ProjID = PM_PROJECTS.ProjectID) where ProjID = bill_proj and ClientID = bill_client group by ClientID, ProjID;

       RETURN projectbilling; 
    END;

    -- All Procedures
    PROCEDURE pm_add_assgn
        (assn_assgndetails IN PM_ASSIGNMENTS.AssgnDetails%TYPE,
        assn_hoursworked IN PM_ASSIGNMENTS.HoursWorked%TYPE,
        assn_projectid IN PM_ASSIGNMENTS.ProjectID%TYPE,
        assn_employeeid IN PM_ASSIGNMENTS.EmployeeID%TYPE)
    IS
    BEGIN
      INSERT INTO PM_ASSIGNMENTS (AssgnID,AssgnDetails,HoursWorked,ProjectID,EmployeeID)
      VALUES (pm_assgnno_seq.NEXTVAL, assn_assgndetails, assn_hoursworked, assn_projectid, assn_employeeid);
      COMMIT;
    END;

    PROCEDURE pm_add_billing
        (bill_proj IN PM_BILLINGS.ProjectID%TYPE,
        client_bill IN PM_BILLINGS.ClientID%TYPE,
        amount IN PM_BILLINGS.Amount%TYPE)
    IS
    BEGIN
      INSERT INTO PM_BILLINGS (BillingID,ProjectID,ClientID,Amount)
      VALUES (pm_billingid_seq.NEXTVAL, bill_proj, client_bill, amount);
    END;

    PROCEDURE pm_add_clients
        (client_name IN PM_CLIENTS.CompanyName%TYPE,
        client_address IN PM_CLIENTS.Address%TYPE,
        client_telephone IN PM_CLIENTS.Telephone%TYPE)
    IS
    BEGIN
      INSERT INTO PM_CLIENTS (ClientID, CompanyName, Address, Telephone)
      VALUES (pm_clientid_seq.NEXTVAL, client_name, client_address, client_telephone);
      COMMIT;
    END;

    PROCEDURE pm_add_employee
        (emp_title IN PM_EMPLOYEE.Title%TYPE,
        emp_fname IN PM_EMPLOYEE.Firstname%TYPE,
        emp_lname IN PM_EMPLOYEE.Lastname%TYPE,
        emp_initials IN PM_EMPLOYEE.Initials%TYPE,
        emp_datehired IN PM_EMPLOYEE.DateHired%TYPE,
        emp_rateid IN PM_EMPLOYEE.EmpRateID%TYPE,
        emp_yrsExp IN PM_EMPLOYEE.YearsExperience%TYPE)
    IS
    BEGIN
      INSERT INTO PM_EMPLOYEE (EmployeeID, Title, Firstname, Lastname, Initials, DateHired, EmpRateID, YearsExperience)
      VALUES (pm_employeeid_seq.NEXTVAL, emp_title, emp_fname, emp_lname, emp_initials, emp_datehired, emp_rateid, emp_yrsExp);
      COMMIT;
    END;

    PROCEDURE pm_add_projects
        (proj_alias IN PM_PROJECTS.ProjectAlias%TYPE,
        proj_projname IN PM_PROJECTS.ProjectName%TYPE,
        proj_startdate IN PM_PROJECTS.StartDate%TYPE,
        proj_enddate IN PM_PROJECTS.EndDate%TYPE,
        proj_budget IN PM_PROJECTS.Budget%TYPE,
        proj_clientid IN PM_PROJECTS.ClientID%TYPE,
        proj_projleader IN PM_PROJECTS.ProjLeader%TYPE)
    IS
    BEGIN
      INSERT INTO PM_PROJECTS (PROJECTID,PROJECTALIAS,PROJECTNAME,STARTDATE,ENDDATE,BUDGET,CLIENTID,PROJLEADER)
      VALUES (pm_projectid_seq.NEXTVAL, proj_alias, proj_projname, proj_startdate, proj_enddate, proj_budget, proj_clientid, proj_projleader);
      COMMIT;
    END;

    PROCEDURE pm_set_projstatus
        (projid IN PM_PROJECTS.ProjectID%TYPE,
        projstatus IN PM_PROJECTS.ProjectStatus%TYPE)
    IS
    BEGIN
      UPDATE PM_PROJECTS
      SET ProjectStatus = projstatus
      WHERE PM_PROJECTS.ProjectID = projid;
      COMMIT;
    END;
END;


-- ** Database Project: Project Management
-- ** Table: PM_EMPLOYEE

-- ** Create PM_EMPLOYEE records

-- ** Create PM_EMPLOYEES records for the qualifications Programmer and Systems Analyst, using the stored package/procedure
--CALL pm_project_mgmt_pkg.pm_add_employee(emp_title, emp_fname, emp_lname, emp_initials, emp_datehired, emp_rateid, emp_yrsExp);
CALL pm_project_mgmt_pkg.pm_add_employee('Mr', 'Harbin', 'Ramo', 'HR', TO_DATE('07/22/2008','MM/DD/YYYY'), 10, 10);
CALL pm_project_mgmt_pkg.pm_add_employee('Mr', 'Michael', 'Davin', 'MD', TO_DATE('12/01/2013','MM/DD/YYYY'), 10, 5);
CALL pm_project_mgmt_pkg.pm_add_employee('Ms', 'Brittany', 'Lee', 'BL', TO_DATE('08/13/2014','MM/DD/YYYY'), 10, 13); 
CALL pm_project_mgmt_pkg.pm_add_employee('Ms', 'Lisa', 'Brown', 'LB', TO_DATE('01/19/2010','MM/DD/YYYY'), 11, 8);
CALL pm_project_mgmt_pkg.pm_add_employee('Mr', 'David', 'Schmitt', 'DS', TO_DATE('05/16/2017','MM/DD/YYYY'), 11, 6);
CALL pm_project_mgmt_pkg.pm_add_employee('Ms', 'Yen', 'Porter', 'YP', TO_DATE('12/12/2012','MM/DD/YYYY'), 11, 4);

-- ** Create PM_EMPLOYEES records for the qualifications Database Designer and Mechanical Engineer
CALL pm_project_mgmt_pkg.pm_add_employee('Ms', 'Sandy', 'Marquis', 'P', TO_DATE('12/20/2016', 'MM/DD/YYYY'), 12, 5);
CALL pm_project_mgmt_pkg.pm_add_employee('Mr', 'Gavin', 'Belson', 'GB', TO_DATE('11/11/2011', 'MM/DD/YYYY'), 12, 2);
CALL pm_project_mgmt_pkg.pm_add_employee('Mrs', 'Sue', 'Wood', 'SW', TO_DATE('05/13/2002', 'MM/DD/YYYY'), 12, 6);
CALL pm_project_mgmt_pkg.pm_add_employee('Mr', 'Sean', 'Morden', 'SM', TO_DATE('07/13/2000', 'MM/DD/YYYY'), 13, 22);
CALL pm_project_mgmt_pkg.pm_add_employee('Ms', 'Stephanie', 'Pollard', 'SP', TO_DATE('03/29/2003', 'MM/DD/YYYY'), 13, 9);
CALL pm_project_mgmt_pkg.pm_add_employee('Mrs', 'Jessika', 'Dalrymple', 'JD', TO_DATE('07/08/2017', 'MM/DD/YYYY'), 13, 15);

-- ** Create PM_EMPLOYEES records for the qualifications Civil Engineer and Clerical Support
CALL pm_project_mgmt_pkg.pm_add_employee('Mr', 'Tiago', 'Finotti', 'F', TO_DATE('12/17/2015', 'MM/DD/YYYY'), 14, 3);
CALL pm_project_mgmt_pkg.pm_add_employee('Ms', 'Bruna', 'Resende', 'H', TO_DATE('11/07/2013', 'MM/DD/YYYY'), 14, 8);
CALL pm_project_mgmt_pkg.pm_add_employee('Mrs', 'Jess', 'Diseris', 'JD', TO_DATE('03/28/2005', 'MM/DD/YYYY'), 14, 16);
CALL pm_project_mgmt_pkg.pm_add_employee('Ms', 'Sydney', 'McCarthy', 'TK', TO_DATE('04/30/2011', 'MM/DD/YYYY'), 15, 9);
CALL pm_project_mgmt_pkg.pm_add_employee('Mr', 'Vladimir', 'Neri', 'VN', TO_DATE('10/11/2010', 'MM/DD/YYYY'), 15, 10);
CALL pm_project_mgmt_pkg.pm_add_employee('Mrs', 'Sue', 'Mooney', 'Y', TO_DATE('05/21/2001', 'MM/DD/YYYY'), 15, 18);

-- ** Create PM_EMPLOYEES records for the qualifications Bio Technician and General Support
CALL pm_project_mgmt_pkg.pm_add_employee('Mr', 'Travis', 'Hanz', 'S', TO_DATE('12/17/2015', 'MM/DD/YYYY'), 18, 3);
CALL pm_project_mgmt_pkg.pm_add_employee('Ms', 'Zbelle', 'Mari', 'S', TO_DATE('05/24/2011', 'MM/DD/YYYY'), 18, 6);
CALL pm_project_mgmt_pkg.pm_add_employee('Mr', 'Jake', 'Madrigal', 'T', TO_DATE('01/04/2014', 'MM/DD/YYYY'), 18, 9);
CALL pm_project_mgmt_pkg.pm_add_employee('Ms', 'Zhannia', 'Tamarah', 'S', TO_DATE('11/12/2015', 'MM/DD/YYYY'), 19, 9);
CALL pm_project_mgmt_pkg.pm_add_employee('Mr', 'Lionel', 'Santos', 'A', TO_DATE('02/02/2011', 'MM/DD/YYYY'), 19, 4);
CALL pm_project_mgmt_pkg.pm_add_employee('Ms', 'Charlene', 'Tolentino', 'B', TO_DATE('08/14/2017', 'MM/DD/YYYY'), 19, 7);

-- ** Create PM_EMPLOYEES records for the qualifications DSS Analyst and Applications Designer
CALL pm_project_mgmt_pkg.pm_add_employee('Mr', 'Alex', 'Morgan', 'AM', TO_DATE('11/1/2008', 'MM/DD/YYYY'), 16, 10);
CALL pm_project_mgmt_pkg.pm_add_employee('Mr', 'Felix', 'Watson', 'FW', TO_DATE('08/12/2011', 'MM/DD/YYYY'), 16, 12);
CALL pm_project_mgmt_pkg.pm_add_employee('Mr', 'James', 'Torquay', 'JT', TO_DATE('04/29/2016', 'MM/DD/YYYY'), 16, 7);
CALL pm_project_mgmt_pkg.pm_add_employee('Mr', 'Daniel', 'Jones', 'DJ', TO_DATE('03/19/2018', 'MM/DD/YYYY'), 17, 11);
CALL pm_project_mgmt_pkg.pm_add_employee('Ms', 'Harley', 'Davidson', 'HD', TO_DATE('01/01/2018', 'MM/DD/YYYY'), 17, 6);
CALL pm_project_mgmt_pkg.pm_add_employee('Ms', 'Sarah', 'Jameson', 'SJ', TO_DATE('07/26/2015', 'MM/DD/YYYY'), 17, 10);

-- ** Create PM_CLINETS records
CALL pm_project_mgmt_pkg.pm_add_clients('BMW', '50 Ultimate Drive, Richmond Hill, ON L4S 0C8', 18005672691);
CALL pm_project_mgmt_pkg.pm_add_clients('Shopify', '80 Spadina Avenue, 4th Floor, Toronto, ON M5V 2J4', 18558163857);
CALL pm_project_mgmt_pkg.pm_add_clients('Push', '147 Liberty St, Toronto, ON M6K 3G3', 14164790775);
CALL pm_project_mgmt_pkg.pm_add_clients('Ubisoft', '224 Wallace Ave #200, Toronto, ON M6H 1V7', 14168401240);
CALL pm_project_mgmt_pkg.pm_add_clients('Caterpillar', '501 Southwest Jefferson Avenue, Peoria, IL, 61630', 13096752337);
CALL pm_project_mgmt_pkg.pm_add_clients('BlueDot Inc.', '207 Queens Quay W #801b, Toronto, ON M5J 1A7', 14163489600);

-- ** Database Project: Project Management
-- ** Table: PM_PROJECTS

-- ** Create PM_PROJECTS records (JANUARY to APRIL)

-- JANUARY
-- 5 months old
CALL pm_project_mgmt_pkg.pm_add_projects('CTRACK','Car Tracker System',TO_DATE('01/01/2019','MM/DD/YYYY'),TO_DATE('07/29/2019','MM/DD/YYYY'),4123,1000,1001);
-- 1 month old
CALL pm_project_mgmt_pkg.pm_add_projects('MAPAUDIT','Map Audit System',TO_DATE('01/13/2019','MM/DD/YYYY'),TO_DATE('11/05/2019','MM/DD/YYYY'),4214,1000,1001);
-- FEBRUARY
-- 5 months old
CALL pm_project_mgmt_pkg.pm_add_projects('PLOC','Package Locator',TO_DATE('02/01/2019','MM/DD/YYYY'),TO_DATE('07/13/2019','MM/DD/YYYY'),3999,1001,1004);
CALL pm_project_mgmt_pkg.pm_add_projects('NOTIFYME','Package Notification Tool',TO_DATE('02/02/2019','MM/DD/YYYY'),TO_DATE('11/01/2019','MM/DD/YYYY'),2999, 1001,1004);

-- MARCH
-- 5 months old
CALL pm_project_mgmt_pkg.pm_add_projects('ITEMFINDER','Item Finder v1',TO_DATE('03/26/2019','MM/DD/YYYY'),TO_DATE('07/26/2019','MM/DD/YYYY'),1976,1002,1009);
CALL pm_project_mgmt_pkg.pm_add_projects('REPAUDIT','Report Auditor',TO_DATE('03/27/2019','MM/DD/YYYY'),TO_DATE('11/16/2019','MM/DD/YYYY'),2315,1002,1002);

-- APRIL
-- 5 months old
CALL pm_project_mgmt_pkg.pm_add_projects('TRUCKME','Truck Monitoring System',TO_DATE('04/01/2019','MM/DD/YYYY'),TO_DATE('07/01/2019','MM/DD/YYYY'),3645,1004,1001);
CALL pm_project_mgmt_pkg.pm_add_projects('TRUCKREPS','Repair Checking System',TO_DATE('04/15/2019','MM/DD/YYYY'),TO_DATE('11/15/2019','MM/DD/YYYY'),9742,1004,1001);

--TRIGGER to generate billing for customers
create or replace TRIGGER generate_billing_tr
AFTER INSERT
ON PM_ASSIGNMENTS
FOR EACH ROW 

DECLARE

    proj_id  PM_BILLINGS.ProjectID%TYPE;
    client_id  PM_BILLINGS.ClientID%TYPE;
    emp_id  PM_EMPLOYEE.EmployeeID%TYPE;
    Hrs number(16,2);
    Rates number(16,2);
    Amt number(16,2);

BEGIN
    proj_id:=:new.ProjectID;
    emp_id:=:new.EmployeeID;
    Hrs:=:new.HoursWorked;

    select clientid into client_id from PM_PROJECTS where projectid = proj_id;

    select PM_EMPRATES.RatePerHour into Rates from PM_EMPLOYEE inner join PM_EMPRATES
    on PM_EMPLOYEE.EmpRateID = PM_EMPRATES.EmpRateID where PM_EMPLOYEE.EmployeeID = emp_id;

    Amt := Hrs * Rates;

    IF pm_project_mgmt_pkg.BILLING_EXISTS_SF(proj_id) THEN
        UPDATE PM_BILLINGS
        SET Amount = Amount + Amt
        Where ProjectID = proj_id;
        DBMS_OUTPUT.PUT_LINE ('Billing updated for Client: '|| client_id);
        DBMS_OUTPUT.PUT_LINE ('With Project ID: '|| proj_id);
    ELSE
        pm_project_mgmt_pkg.pm_add_billing(proj_id,client_id,Amt);
        DBMS_OUTPUT.PUT_LINE ('New billing generated for Client: '|| client_id);
        DBMS_OUTPUT.PUT_LINE ('With Project ID: '|| proj_id);
    END IF;
END;

--Trigger updates billing for client on a particular project
create or replace TRIGGER UPDATE_BILLING_trg
AFTER UPDATE OF HoursWorked
ON PM_ASSIGNMENTS
FOR EACH ROW 

DECLARE

    proj_id  PM_BILLINGS.ProjectID%TYPE;
    client_id  PM_BILLINGS.ClientID%TYPE;
    emp_id  PM_EMPLOYEE.EmployeeID%TYPE;
    NewHrs number(16,2);
    OldHrs number(16,2);
    Hrs number(16,2);
    Rates number(16,2);
    Amt number(16,2);

BEGIN
    proj_id:=:new.ProjectID;
    emp_id:=:new.EmployeeID;
    NewHrs:=:new.HoursWorked;
    OldHrs:=:old.HoursWorked;

    Hrs:= abs(OldHrs - NewHrs);

    select clientid into client_id from PM_PROJECTS where projectid = proj_id;

    select PM_EMPRATES.RatePerHour into Rates from PM_EMPLOYEE inner join PM_EMPRATES
    on PM_EMPLOYEE.EmpRateID = PM_EMPRATES.EmpRateID where PM_EMPLOYEE.EmployeeID = emp_id;

    Amt := Hrs * Rates;

    IF pm_project_mgmt_pkg.BILLING_EXISTS_SF(proj_id) THEN
        IF NewHrs > OldHrs THEN
            UPDATE PM_BILLINGS
            SET Amount = Amount + Amt
            Where ProjectID = proj_id;
            DBMS_OUTPUT.PUT_LINE ('Billing updated for Client: '|| client_id);
            DBMS_OUTPUT.PUT_LINE ('With Project ID: '|| proj_id);
        ELSIF NewHrs < OldHrs THEN
            UPDATE PM_BILLINGS
            SET Amount = Amount - Amt
            Where ProjectID = proj_id;
            DBMS_OUTPUT.PUT_LINE ('Billing updated for Client: '|| client_id);
            DBMS_OUTPUT.PUT_LINE ('With Project ID: '|| proj_id);
        ELSIF NewHrs = OldHrs THEN
            DBMS_OUTPUT.PUT_LINE ('No update made on the billing.');
        END IF;
    ELSE
        pm_project_mgmt_pkg.pm_add_billing(proj_id,client_id,Amt);
        DBMS_OUTPUT.PUT_LINE ('New billing generated for Client: '|| client_id);
        DBMS_OUTPUT.PUT_LINE ('With Project ID: '|| proj_id);
    END IF;
END;

--TRIGGER TO DELETE BILLING and ASSIGNMENTS on deletion of project
CREATE OR REPLACE TRIGGER delete_billing_tr
AFTER DELETE
ON PM_PROJECTS
FOR EACH ROW 

DECLARE
  proj_id  PM_BILLINGS.ProjectID%TYPE;

BEGIN
    proj_id:=:old.ProjectID;
    
    DELETE FROM PM_BILLINGS 
    WHERE pm_billings.projectid = proj_id;
    
    DELETE FROM PM_ASSIGNMENTS 
    WHERE PM_ASSIGNMENTS.projectid = proj_id;

END;

-- ** Database Project: Project Management
-- ** Table: PM_ASSIGNMENT

-- ** Map Audit System
CALL pm_project_mgmt_pkg.pm_add_assgn('Creation of Map API', 3, 1001, 1010);
CALL pm_project_mgmt_pkg.pm_add_assgn('Creation of Application Stage 1', 10, 1001, 1010);
                    
-- ** Package Notification Tool
CALL pm_project_mgmt_pkg.pm_add_assgn('Accessing AWS Portal', 5, 1003, 1013);
CALL pm_project_mgmt_pkg.pm_add_assgn('Generation of Backlog Reports', 2, 1003, 1013);

-- ** Item Finder v1
CALL pm_project_mgmt_pkg.pm_add_assgn('Maintenance of Items', 6, 1004, 1015);
CALL pm_project_mgmt_pkg.pm_add_assgn('Creation of Item UI', 6, 1004, 1015);
                    
-- ** Report Auditor
CALL pm_project_mgmt_pkg.pm_add_assgn('Generation of Weekly Reports', 3, 1005, 1004);
CALL pm_project_mgmt_pkg.pm_add_assgn('Generation of Monthly Reports', 5, 1005, 1004);
                    
-- ** Truck Monitoring System
CALL pm_project_mgmt_pkg.pm_add_assgn('Designing geofence API', 3, 1006, 1020);
CALL pm_project_mgmt_pkg.pm_add_assgn('Generation of Delivery Reports', 5, 1006, 1004);


/*
Reference for ProjectStatus column in PM_PORJECTS table

    0 - Project Initiation
    1 - Project Planning
    2 - Project Execution
    3 - Project Deployed
*/
--**Setting 3 projects to status 3 (deployed)
CALL pm_project_mgmt_pkg.pm_set_projstatus(1000,3);
CALL pm_project_mgmt_pkg.pm_set_projstatus(1001,3);
CALL pm_project_mgmt_pkg.pm_set_projstatus(1002,0);
CALL pm_project_mgmt_pkg.pm_set_projstatus(1003,3);
CALL pm_project_mgmt_pkg.pm_set_projstatus(1004,3);
CALL pm_project_mgmt_pkg.pm_set_projstatus(1005,2);
CALL pm_project_mgmt_pkg.pm_set_projstatus(1006,2);
CALL pm_project_mgmt_pkg.pm_set_projstatus(1007,1);


-- ** Database Project: Project Management
-- ** Anonymous Block to Generate reports such as status of projects,
DECLARE 
   proj_id PM_PROJECTS.ProjectID%type; 
   proj_alias PM_PROJECTS.ProjectAlias%type; 
   proj_name PM_PROJECTS.ProjectName%type;
   proj_status PM_PROJECTS.ProjectStatus%type;
   
   proj_status_desc VARCHAR2(255);
   CURSOR pm_list_projstats is 
      SELECT ProjectID, ProjectAlias, ProjectName, ProjectStatus FROM PM_PROJECTS; 
BEGIN 
   OPEN pm_list_projstats; 
   LOOP 
   FETCH pm_list_projstats into proj_id, proj_alias, proj_name, proj_status; 
      EXIT WHEN pm_list_projstats%notfound;
      
      IF proj_status = 3 THEN 
      proj_status_desc := 'Project Deployed';
      dbms_output.put_line('PROJECT DETAILS'); 
      dbms_output.put_line('PROJECT ID: '||proj_id); 
      dbms_output.put_line('PROJECT NAME: '||proj_name); 
      dbms_output.put_line('PROJECT ALIAS: '||proj_alias);
      dbms_output.put_line('PROJECT STATUS: '||proj_status_desc);
      dbms_output.put_line('');
      
      ELSIF proj_status = 2 THEN 
      proj_status_desc := 'Project Execution Phase';
      dbms_output.put_line('PROJECT DETAILS'); 
      dbms_output.put_line('PROJECT ID: '||proj_id); 
      dbms_output.put_line('PROJECT NAME: '||proj_name); 
      dbms_output.put_line('PROJECT ALIAS: '||proj_alias);
      dbms_output.put_line('PROJECT STATUS: '||proj_status_desc);
      dbms_output.put_line('');
      
      ELSIF proj_status = 1 THEN 
      proj_status_desc := 'Project Planning';
      dbms_output.put_line('PROJECT DETAILS'); 
      dbms_output.put_line('PROJECT ID: '||proj_id); 
      dbms_output.put_line('PROJECT NAME: '||proj_name); 
      dbms_output.put_line('PROJECT ALIAS: '||proj_alias);
      dbms_output.put_line('PROJECT STATUS: '||proj_status_desc);
      dbms_output.put_line('');
      
      ELSIF proj_status = 0 THEN 
      proj_status_desc := 'Project Initiation';
      dbms_output.put_line('PROJECT DETAILS'); 
      dbms_output.put_line('PROJECT ID: '||proj_id); 
      dbms_output.put_line('PROJECT NAME: '||proj_name); 
      dbms_output.put_line('PROJECT ALIAS: '||proj_alias);
      dbms_output.put_line('PROJECT STATUS: '||proj_status_desc);
      dbms_output.put_line('');
      END IF;
      
   END LOOP; 
   CLOSE pm_list_projstats; 
END; 


-- ** Database Project: Project Management
-- ** Anonymous Block to Generate total amount charged per project.
DECLARE 
   proj_name PM_PROJECTS.ProjectName%type;
   proj_amount_charged PM_BILLINGS.Amount%type;

   CURSOR pm_proj_tot_amount is 
      Select PM_PROJECTS.ProjectName, PM_BILLINGS.Amount from PM_PROJECTS inner join PM_BILLINGS on PM_PROJECTS.ProjectID = PM_BILLINGS.ProjectID; 
BEGIN 
   OPEN pm_proj_tot_amount; 
   LOOP 
   FETCH pm_proj_tot_amount into proj_name, proj_amount_charged; 
      EXIT WHEN pm_proj_tot_amount%notfound;
      
      dbms_output.put_line('PROJECT DETAILS'); 
      dbms_output.put_line('PROJECT NAME: '||proj_name); 
      dbms_output.put_line('PROJECT TOTAL AMOUNT CHARGED: $'||proj_amount_charged);
      dbms_output.put_line('');
      
   END LOOP; 
   CLOSE pm_proj_tot_amount; 
END; 


-- ** Database Project: Project Management
-- ** Anonymous Block to generate number of assignments worked by each employee
DECLARE 
   emp_title PM_EMPLOYEE.Title%type;
   emp_fname PM_EMPLOYEE.Firstname%type;
   assgn_worked number(3);

   CURSOR pm_assgns_wrkd_cur is 
      SELECT PM_EMPLOYEE.Title, PM_EMPLOYEE.Firstname, NUMBER_OF_ASSIGNMENTS FROM
        PM_EMPLOYEE INNER JOIN 
        (SELECT COUNT(PM_ASSIGNMENTS.ProjectID) AS NUMBER_OF_ASSIGNMENTS, PM_ASSIGNMENTS.EmployeeID AS EMP_ID
        FROM PM_ASSIGNMENTS
        GROUP BY PM_ASSIGNMENTS.EmployeeID) ON PM_EMPLOYEE.EmployeeID = EMP_ID; 
BEGIN 
   OPEN pm_assgns_wrkd_cur; 
   LOOP 
   FETCH pm_assgns_wrkd_cur into emp_title, emp_fname, assgn_worked; 
      EXIT WHEN pm_assgns_wrkd_cur%notfound;
      
      dbms_output.put_line(emp_title ||' '|| emp_fname ||' worked on '|| assgn_worked||' assignments'); 
      
   END LOOP; 
   CLOSE pm_assgns_wrkd_cur; 
END; 


-- ** Database Project: Project Management
-- ** Anonymous Block to generate number of hours worked on each employee worked by each project
DECLARE 
   emp_title PM_EMPLOYEE.Title%type;
   emp_fname PM_EMPLOYEE.Firstname%type;
   proj_name PM_PROJECTS.ProjectName%type;
   hrs_worked number(3);

   CURSOR pm_hrs_wrkd_cur is 
      SELECT PM_EMPLOYEE.Title, PM_EMPLOYEE.Firstname, PROJ_NAME, NUM_HOURS FROM
        PM_EMPLOYEE INNER JOIN 
        (SELECT PM_PROJECTS.ProjectName AS PROJ_NAME, NUM_HOURS, P_ID, EMP_ID FROM
        PM_PROJECTS INNER JOIN 
        (SELECT SUM(PM_ASSIGNMENTS.HoursWorked) AS NUM_HOURS, PM_ASSIGNMENTS.ProjectID AS P_ID, PM_ASSIGNMENTS.EmployeeID AS EMP_ID 
        FROM PM_ASSIGNMENTS
        GROUP BY PM_ASSIGNMENTS.ProjectID, PM_ASSIGNMENTS.EmployeeID) ON PM_PROJECTS.ProjectID = P_ID) ON PM_EMPLOYEE.EmployeeID = EMP_ID; 
BEGIN 
   OPEN pm_hrs_wrkd_cur; 
   LOOP 
   FETCH pm_hrs_wrkd_cur into emp_title, emp_fname, proj_name, hrs_worked; 
      EXIT WHEN pm_hrs_wrkd_cur%notfound;
      
      dbms_output.put_line(emp_title ||' '|| emp_fname ||' worked on '|| proj_name||' for '|| hrs_worked ||' hrs'); 
      
   END LOOP; 
   CLOSE pm_hrs_wrkd_cur; 
END; 