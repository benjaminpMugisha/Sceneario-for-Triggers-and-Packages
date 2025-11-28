# Sceneario-for-Triggers-and-Packages

# PL/SQL Database Development Project
**Course:** INSY 8311 - Database Development with PL/SQL  
**University:** Adventist University of Central Africa  
**Academic Year:** 2025-2026, SEM II  
**Instructor:** Eric Maniraguha  

## 📋 Project Overview
This project implements four comprehensive PL/SQL scenarios demonstrating advanced database programming concepts including triggers, packages, security contexts, and bulk processing operations.

## 👥 Group Members
- Bigwaneza Ishimwe Davidson  - 28494
- Mugisha Prince Benjamin - 26979 
- Bikorimana Eric - 27928
- Karuhanga Moses  - 27911

## 🎯 Assignment Scenarios

# PL/SQL Database Development Assignment

## 📋 What the Question Was About

This assignment consisted of **four comprehensive scenarios** testing advanced PL/SQL programming concepts:

### Scenario 1: AUCA System Access Policy
**Business Problem:** Implement a security system that restricts database access to business hours only (Monday-Friday, 8AM-5PM) and blocks Sabbath access (Saturday-Sunday).

### Scenario 2: HR Employee Management System  
**Business Problem:** Create a payroll system package that calculates RSSB tax deductions, computes net salaries, and handles salary updates using dynamic SQL with proper security contexts

### Scenario 3: Suspicious Login Monitoring
**Business Problem:** Build a security monitoring system that detects and alerts on suspicious login patterns (3+ failed attempts per user per day) for fraud prevention.

### Scenario 4: Hospital Management System
**Business Problem:** Develop a patient management system with bulk processing capabilities for efficient handling of multiple patient records and admission tracking.

## 🛠️ How We Solved It

### 🔒 Scenario 1 Solution: System Access Control
```sql
-- Created compound trigger with autonomous transaction
CREATE OR REPLACE TRIGGER enforce_system_access
    BEFORE INSERT OR UPDATE OR DELETE ON employees
DECLARE
    v_day VARCHAR2(20);
    v_time NUMBER;
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    v_day := TO_CHAR(SYSDATE, 'DY');
    v_time := TO_NUMBER(TO_CHAR(SYSDATE, 'HH24.MI'));

    -- Check Sabbath and business hours
    IF v_day IN ('SAT', 'SUN') OR (v_time < 8.00 OR v_time >= 17.00) THEN
        INSERT INTO system_access_audit (attempted_action, rejection_reason)
        VALUES (ORA_DICT_OBJ_NAME || ' Operation', 'Access violation');
        COMMIT;
        RAISE_APPLICATION_ERROR(-20001, 'System Access Denied');
    END IF;
END;
/
```

### 💼 Scenario 2 Solution: HR Management Package
```sql
-- Implemented invoker's rights package with tax calculations
CREATE OR REPLACE PACKAGE hr_management AUTHID CURRENT_USER IS
    FUNCTION calculate_net_salary(p_employee_id IN NUMBER) RETURN NUMBER;
    PROCEDURE update_employee_salary(p_employee_id IN NUMBER, p_new_salary IN NUMBER);
END hr_management;

-- Used dynamic SQL for flexible salary updates
PROCEDURE update_employee_salary(p_employee_id IN NUMBER, p_new_salary IN NUMBER) IS
    v_sql_stmt VARCHAR2(1000);
BEGIN
    v_sql_stmt := 'UPDATE employees SET salary = :1 WHERE employee_id = :2';
    EXECUTE IMMEDIATE v_sql_stmt USING p_new_salary, p_employee_id;
    COMMIT;
END;
```

### 🔐 Scenario 3 Solution: Security Monitoring
```sql
-- Implemented compound trigger to avoid mutating table issues
CREATE OR REPLACE TRIGGER track_suspicious_logins
    FOR INSERT ON login_audit COMPOUND TRIGGER
    
    TYPE username_table_type IS TABLE OF NUMBER INDEX BY VARCHAR2(100);
    g_failed_counts username_table_type;

    BEFORE EACH ROW IS
    BEGIN
        IF :NEW.status = 'FAILED' THEN
            -- Count failed attempts per user
            g_failed_counts(:NEW.username) := NVL(g_failed_counts(:NEW.username), 0) + 1;
        END IF;
    END BEFORE EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        -- Generate alerts for users with 3+ failed attempts
        FOR i IN 1..g_failed_counts.COUNT LOOP
            IF g_failed_counts(i) >= 3 THEN
                INSERT INTO security_alerts VALUES (...);
            END IF;
        END LOOP;
    END AFTER STATEMENT;
END;
/
```

### 🏥 Scenario 4 Solution: Hospital Management with Bulk Processing
```sql
-- Used collections and FORALL for efficient bulk operations
CREATE OR REPLACE PACKAGE hospital_mgmt AS
    TYPE patient_rec_type IS RECORD (...);
    TYPE patient_tbl_type IS TABLE OF patient_rec_type;
    
    PROCEDURE bulk_load_patients(p_patient_list IN patient_tbl_type);
END hospital_mgmt;

-- Bulk insert using FORALL
PROCEDURE bulk_load_patients(p_patient_list IN patient_tbl_type) IS
BEGIN
    FORALL i IN 1..p_patient_list.COUNT
        INSERT INTO patients VALUES p_patient_list(i);
    COMMIT;
END;
```

## 🎯 Key Technical Achievements

### ✅ Advanced PL/SQL Concepts Implemented:
- **Compound Triggers** - Solved mutating table problems
- **Bulk Processing** - FORALL operations for performance
- **Dynamic SQL** - Flexible database operations
- **Security Contexts** - INVOKER vs DEFINER rights
- **Autonomous Transactions** - Independent logging
- **Collection Types** - Efficient data handling

### ✅ Robust Error Handling:
- Custom application errors with RAISE_APPLICATION_ERROR
- Comprehensive exception handling blocks
- Transaction management with COMMIT/ROLLBACK
- Data validation and integrity checks

## 📊 Screenshots of Results

### Screenshot 1: All Objects Compiled Successfully


**Shows:** All packages, package bodies, and triggers with VALID status

### Screenshot 2: Sample Data Verification


**Shows:** Comprehensive sample data across all tables

### Screenshot 3: HR Package Test Results


**Shows:** Successful salary calculations and updates

### Screenshot 4: Hospital System Output


**Shows:** Patient management with bulk operations

### Screenshot 5: Security Monitoring Working


**Shows:** Login attempt tracking and alert generation

### Screenshot 6: Final System Status


**Shows:** Comprehensive verification of all assignment requirements

## 📈 Results Summary

| Scenario | Status | Key Achievements |
|----------|--------|------------------|
| 1. Access Policy | ✅ Complete | Business hours enforcement, Sabbath blocking, Audit logging |
| 2. HR Management | ✅ Complete | Tax calculations, Dynamic SQL, Security contexts |
| 3. Security Monitoring | ✅ Complete | Real-time alerts, Compound triggers, Fraud detection |
| 4. Hospital System | ✅ Complete | Bulk processing, Collections, Patient management |

## 🎓 Learning Outcomes

This assignment successfully demonstrated our team's proficiency in:
- Advanced database trigger design and implementation
- PL/SQL package development and modular programming
- Security and auditing best practices
- Performance optimization with bulk processing
- Real-world business problem solving
- Comprehensive testing and validation

**All assignment requirements were successfully implemented and tested!** 🎉

### 1. AUCA System Access Policy
**Business Rules:**
- No system access on Sabbath (Saturday & Sunday)
- Access limited to Monday-Friday, 8:00 AM - 5:00 PM
- Automatic blocking and logging of unauthorized access attempts

**Implementation:**
- `enforce_system_access` trigger - Prevents unauthorized operations
- `system_access_audit` table - Logs access violation attempts

### 2. HR Employee Management System
**Features:**
- RSSB tax calculation (10% deduction)
- Net salary computation
- Dynamic SQL for salary updates
- Invoker rights security context

**Components:**
- `hr_management` package with functions and procedures
- Dynamic salary update procedure
- Security context demonstration

### 3. Suspicious Login Monitoring
**Security Policy:**
- Monitor failed login attempts
- Trigger security alerts after 3+ failed attempts
- Comprehensive audit logging

**Implementation:**
- `login_audit` table - Tracks all login attempts
- `security_alerts` table - Stores security alerts
- `track_suspicious_logins` trigger - Compound trigger for real-time monitoring

### 4. Hospital Management System
**Features:**
- Bulk patient data processing
- Patient admission management
- Doctor specialty tracking
- Efficient collection operations

**Components:**
- `hospital_mgmt` package with bulk operations
- Patient and doctor tables
- FORALL bulk processing techniques

## 🗄️ Database Schema

### Tables Created:
1. **employees** - HR employee data with salaries
2. **login_audit** - User login attempt tracking  
3. **security_alerts** - Security incident records
4. **system_access_audit** - Access violation logs
5. **patients** - Hospital patient information
6. **doctors** - Medical staff details

### Packages:
- `HR_MANAGEMENT` - Employee salary and tax operations
- `HOSPITAL_MGMT` - Patient management with bulk processing

### Triggers:
- `ENFORCE_SYSTEM_ACCESS` - Business hours access control
- `TRACK_SUSPICIOUS_LOGINS` - Security monitoring

## 🚀 Installation & Execution

### Prerequisites
- Oracle Database 11g or higher
- SQL*Plus or SQL Developer
- PL/SQL execution privileges

### Setup Instructions
1. Clone the repository:
   ```bash
   gh repo clone benjaminpMugisha/Sceneario-for-Triggers-and-Packages
