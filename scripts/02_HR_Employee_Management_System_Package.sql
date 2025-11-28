-- =============================================
-- PART 2: HR EMPLOYEE MANAGEMENT PACKAGE
-- =============================================
CREATE OR REPLACE PACKAGE hr_management 
AUTHID CURRENT_USER
IS
    FUNCTION calculate_net_salary(p_employee_id IN NUMBER) RETURN NUMBER;
    PROCEDURE update_employee_salary(p_employee_id IN NUMBER, p_new_salary IN NUMBER);
END hr_management;
/

CREATE OR REPLACE PACKAGE BODY hr_management IS
    FUNCTION calculate_net_salary(p_employee_id IN NUMBER) RETURN NUMBER IS
        v_gross_salary NUMBER;
        v_tax_rate     NUMBER := 0.10;
        v_net_salary   NUMBER;
    BEGIN
        SELECT salary INTO v_gross_salary
        FROM employees
        WHERE employee_id = p_employee_id;

        v_net_salary := v_gross_salary * (1 - v_tax_rate);
        RETURN v_net_salary;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Employee ID ' || p_employee_id || ' not found.');
            RETURN NULL;
    END calculate_net_salary;

    PROCEDURE update_employee_salary(
        p_employee_id IN NUMBER,
        p_new_salary IN NUMBER
    ) IS
        v_sql_stmt VARCHAR2(1000);
    BEGIN
        IF p_new_salary < 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: Salary cannot be negative.');
            RETURN;
        END IF;

        v_sql_stmt := 'UPDATE employees SET salary = :1 WHERE employee_id = :2';
        EXECUTE IMMEDIATE v_sql_stmt USING p_new_salary, p_employee_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No employee found with ID: ' || p_employee_id);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Salary updated successfully for employee ID: ' || p_employee_id);
        END IF;
        COMMIT;
        
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error updating salary: ' || SQLERRM);
            ROLLBACK;
    END update_employee_salary;
END hr_management;
/

-- Test HR Package
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== HR MANAGEMENT PACKAGE TEST ===');
    
    DECLARE
        v_net_sal NUMBER;
    BEGIN
        v_net_sal := hr_management.calculate_net_salary(101);
        DBMS_OUTPUT.PUT_LINE('Net Salary for employee 101: ' || v_net_sal);
        
        v_net_sal := hr_management.calculate_net_salary(102);
        DBMS_OUTPUT.PUT_LINE('Net Salary for employee 102: ' || v_net_sal);
    END;
    
    hr_management.update_employee_salary(101, 55000);
    
    DECLARE
        v_net_sal NUMBER;
    BEGIN
        v_net_sal := hr_management.calculate_net_salary(101);
        DBMS_OUTPUT.PUT_LINE('New Net Salary after update: ' || v_net_sal);
    END;
END;
/
