DROP database emrsystem;
CREATE DATABASE IF NOT EXISTS emrsystem;
use emrsystem;

-- CREATE STORE PROCEDURE TO CREATE TABLES
DROP PROCEDURE IF EXISTS sp_create_tbl_zip_code;
DELIMITER $$
CREATE PROCEDURE sp_create_tbl_zip_code()
BEGIN
	CREATE TABLE IF NOT EXISTS zip_code (
    id CHAR(5) NOT NULL,
    city_name VARCHAR(20) NOT NULL,
    state VARCHAR(20) NOT NULL,
    PRIMARY KEY (id)
);
END
$$
GO

DROP PROCEDURE IF EXISTS sp_create_tbl_insurance_type;
DELIMITER $$
CREATE PROCEDURE sp_create_tbl_insurance_type()
BEGIN
	CREATE TABLE IF NOT EXISTS insurance_type (
    id INT AUTO_INCREMENT,
    type VARCHAR(15) NOT NULL,
    PRIMARY KEY (id)
);
END
$$
GO

DROP PROCEDURE IF EXISTS sp_create_tbl_visit_type;
DELIMITER $$
CREATE PROCEDURE sp_create_tbl_visit_type()
BEGIN
	CREATE TABLE IF NOT EXISTS visit_type (
    id INT AUTO_INCREMENT,
    type VARCHAR(20) NOT NULL,
    PRIMARY KEY (id)
);
END
$$
GO

DROP PROCEDURE IF EXISTS sp_create_tbl_clinic_department;
DELIMITER $$
CREATE PROCEDURE sp_create_tbl_clinic_department()
BEGIN
	CREATE TABLE IF NOT EXISTS clinic_department (
    id INT AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    PRIMARY KEY (id)
);
END
$$
GO

DROP PROCEDURE IF EXISTS sp_create_tbl_medicine;
DELIMITER $$
CREATE PROCEDURE sp_create_tbl_medicine()
BEGIN
	CREATE TABLE IF NOT EXISTS medicine (
    id INT AUTO_INCREMENT,
    name VARCHAR(60) NOT NULL,
    PRIMARY KEY (id)
);
END
$$
GO

DROP PROCEDURE IF EXISTS sp_create_tbl_patient_information;
DELIMITER $$
CREATE PROCEDURE sp_create_tbl_patient_information()
BEGIN
	CREATE TABLE IF NOT EXISTS patient_information (
		id INT AUTO_INCREMENT,
		first_name VARCHAR(20) NOT NULL,
		last_name VARCHAR(20) NOT NULL,
		gender CHAR(10) NOT NULL,
		date_of_birth DATE NOT NULL,
		age INT NOT NULL,
		race VARCHAR(20) NOT NULL,
		phone VARCHAR(20) NOT NULL,
		address VARCHAR(30) NOT NULL,
		zip_code CHAR(5) DEFAULT NULL,
		email VARCHAR(30) NOT NULL,
		maratial_status CHAR(10) DEFAULT NULL,
		snn VARCHAR(20) DEFAULT NULL,
		preferred_language VARCHAR(20) DEFAULT NULL,
		PRIMARY KEY (id),
		FOREIGN KEY (zip_code)
			REFERENCES zip_code (id)
			ON DELETE SET NULL ON UPDATE CASCADE											
);
END
$$
GO

DROP PROCEDURE IF EXISTS sp_create_tbl_patient_emergency_contact_information;
DELIMITER $$
CREATE PROCEDURE sp_create_tbl_patient_emergency_contact_information()
BEGIN
	CREATE TABLE IF NOT EXISTS patient_emergency_contact_information (
		id INT AUTO_INCREMENT,
		patient_id INT NOT NULL,
		first_name VARCHAR(20) NOT NULL,
		last_name VARCHAR(20) NOT NULL,
		relation_to_patient VARCHAR(20) NOT NULL,
		phone VARCHAR(20) NOT NULL,
		address VARCHAR(30) DEFAULT NULL,
		zip_code CHAR(5) DEFAULT NULL,
		PRIMARY KEY (id),
		FOREIGN KEY (zip_code)
			REFERENCES zip_code (id)
			ON DELETE SET NULL ON UPDATE CASCADE,
		FOREIGN KEY (patient_id)
			REFERENCES patient_information (id)
			ON DELETE CASCADE ON UPDATE CASCADE
);
END
$$
GO

DROP PROCEDURE IF EXISTS sp_create_tbl_insurance_information;
DELIMITER $$
CREATE PROCEDURE sp_create_tbl_insurance_information()
BEGIN
	CREATE TABLE IF NOT EXISTS insurance_information (
    id INT AUTO_INCREMENT,
    patient_id INT NOT NULL,
    insurance_name VARCHAR(50) DEFAULT NULL,
    member_id VARCHAR(20) DEFAULT NULL,
    insurance_type INT DEFAULT NULL,
    patient_relationship_to_insured VARCHAR(20) DEFAULT NULL,
    patient_status VARCHAR(20) DEFAULT NULL,
    provided_by_employeer BOOLEAN DEFAULT NULL,
    payer_name VARCHAR(20) DEFAULT NULL,
    plan_name VARCHAR(20) DEFAULT NULL,
    co_pay VARCHAR(30) DEFAULT NULL,
    balance DECIMAL(10 , 2 ) NOT NULL,
    address VARCHAR(20) NOT NULL,
    zip_code CHAR(5) DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (patient_id)
        REFERENCES patient_information (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (insurance_type)
        REFERENCES insurance_type (id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (zip_code)
        REFERENCES zip_code (id)
        ON DELETE SET NULL ON UPDATE CASCADE
);
END
$$
GO

DROP PROCEDURE IF EXISTS sp_create_tbl_provider_information;
DELIMITER $$
CREATE PROCEDURE sp_create_tbl_provider_information()
BEGIN
	CREATE TABLE IF NOT EXISTS provider_information (
    id INT AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    specialty VARCHAR(20) NOT NULL,
    from_time TIME NOT NULL,
    to_time TIME NOT NULL,
    available VARCHAR(10) NOT NULL,
    address VARCHAR(30) DEFAULT NULL,
    zip_code CHAR(5) DEFAULT NULL,
    phone VARCHAR(20) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (zip_code)
        REFERENCES zip_code (id)
        ON DELETE SET NULL ON UPDATE CASCADE
);
END
$$
GO

DROP PROCEDURE IF EXISTS sp_create_tbl_check_in_information;
DELIMITER $$
CREATE PROCEDURE sp_create_tbl_check_in_information()
BEGIN
	CREATE TABLE IF NOT EXISTS check_in_information (
    id INT AUTO_INCREMENT,
    clinic_department_id INT DEFAULT NULL,
    visit_type INT DEFAULT NULL,
    patient_weight FLOAT NOT NULL,
    date DATE NOT NULL,
    from_time TIME NOT NULL,
    to_time TIME NOT NULL,
    status VARCHAR(50) NOT NULL,
    new_patient BOOLEAN NOT NULL,
    walk_in BOOLEAN NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (clinic_department_id)
        REFERENCES clinic_department (id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (visit_type)
        REFERENCES visit_type (id)
        ON DELETE SET NULL ON UPDATE CASCADE
);
END
$$
GO

DROP PROCEDURE IF EXISTS sp_create_tbl_patient_check_in;
DELIMITER $$
CREATE PROCEDURE sp_create_tbl_patient_check_in()
BEGIN
	CREATE TABLE IF NOT EXISTS patient_check_in (
    patient_id INT NOT NULL,
    check_in_info_id INT NOT NULL,
    CONSTRAINT patient_check_in_composite_key PRIMARY KEY (patient_id , check_in_info_id),
    FOREIGN KEY (patient_id)
        REFERENCES patient_information (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (check_in_info_id)
        REFERENCES check_in_information (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
END
$$
GO

DROP PROCEDURE IF EXISTS sp_create_tbl_provider_patient_check_in;
DELIMITER $$
CREATE PROCEDURE sp_create_tbl_provider_patient_check_in()
BEGIN
	CREATE TABLE IF NOT EXISTS provider_patient_check_in (
    provider_id INT NOT NULL,
    patient_check_in_id INT NOT NULL,
    CONSTRAINT provider_checkin_composite_key PRIMARY KEY (provider_id , patient_check_in_id),
    FOREIGN KEY (provider_id)
        REFERENCES provider_information (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (patient_check_in_id)
        REFERENCES check_in_information (id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
END
$$
GO

DROP PROCEDURE IF EXISTS sp_create_tbl_clinic_care_information;
DELIMITER $$
CREATE PROCEDURE sp_create_tbl_clinic_care_information()
BEGIN
	CREATE TABLE IF NOT EXISTS clinic_care_information (
    id INT AUTO_INCREMENT,
    check_in_info_id INT NOT NULL,
    diagnoses VARCHAR(50) DEFAULT NULL,
    test VARCHAR(60) DEFAULT NULL,
    test_results VARCHAR(50) DEFAULT NULL,
    prescription VARCHAR(150) NOT NULL,
    fees DECIMAL(10 , 2 ) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (check_in_info_id)
        REFERENCES check_in_information (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
END
$$
GO

DROP PROCEDURE IF EXISTS sp_create_tbl_bill;
DELIMITER $$
CREATE PROCEDURE sp_create_tbl_bill()
BEGIN
	CREATE TABLE IF NOT EXISTS bill (
    id INT AUTO_INCREMENT,
    clinic_care_info_id INT NOT NULL,
    fees DECIMAL(10 , 2 ) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (clinic_care_info_id)
        REFERENCES clinic_care_information (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
END
$$
GO

DROP PROCEDURE IF EXISTS sp_create_tbl_prescription;
DELIMITER $$
CREATE PROCEDURE sp_create_tbl_prescription()
BEGIN
	CREATE TABLE IF NOT EXISTS prescription (
    id INT AUTO_INCREMENT,
    clinic_care_info_id INT NOT NULL,
    pharmacy_name VARCHAR(20) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10 , 2 ) NOT NULL,
    duration VARCHAR(60) DEFAULT NULL,
    date DATE NOT NULL,
    caution VARCHAR(60) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (clinic_care_info_id)
        REFERENCES clinic_care_information (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
END
$$
GO

DROP PROCEDURE IF EXISTS sp_create_tbl_prescribe_medicine;
DELIMITER $$
CREATE PROCEDURE sp_create_tbl_prescribe_medicine()
BEGIN
	CREATE TABLE IF NOT EXISTS prescribe_medicine (
    medicine_id INT NOT NULL,
    prescription_id INT NOT NULL,
    CONSTRAINT prescribe_medicine_composite_key PRIMARY KEY (medicine_id , prescription_id),
    FOREIGN KEY (medicine_id)
        REFERENCES medicine (id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (prescription_id)
        REFERENCES prescription (id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
END
$$
GO

DROP PROCEDURE IF EXISTS sp_create_tbl_supplier;
DELIMITER $$
CREATE PROCEDURE sp_create_tbl_supplier()
BEGIN
	CREATE TABLE IF NOT EXISTS supplier (
    id INT AUTO_INCREMENT,
    clinic_care_info_id INT NOT NULL,
    order_name VARCHAR(20) NOT NULL,
    date DATE DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (clinic_care_info_id)
        REFERENCES clinic_care_information (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
END
$$

-- CALL CREATE STORE PROCEDURE TO CREATE TABLES
call sp_create_tbl_zip_code;
call sp_create_tbl_insurance_type();
call sp_create_tbl_visit_type();
call sp_create_tbl_clinic_department();
call sp_create_tbl_medicine();
call sp_create_tbl_patient_information();
call sp_create_tbl_patient_emergency_contact_information();
call sp_create_tbl_insurance_information();
call sp_create_tbl_provider_information();
call sp_create_tbl_check_in_information();
call sp_create_tbl_patient_check_in();
call sp_create_tbl_provider_patient_check_in();
call sp_create_tbl_clinic_care_information();
call sp_create_tbl_bill();
call sp_create_tbl_prescription();
call sp_create_tbl_prescribe_medicine();
call sp_create_tbl_supplier();


-- CREATE STORE PROCEDURE TO INSERT INTO TABLES

DROP PROCEDURE IF EXISTS sp_insert_zip_code;
DELIMITER $$
CREATE PROCEDURE sp_insert_zip_code(
	IN id CHAR(5),
    IN city_name VARCHAR(20),
    IN state VARCHAR(20))
BEGIN
	INSERT INTO zip_code (id, city_name, state) 
    VALUES  (id, city_name, state);
END
$$

DROP PROCEDURE IF EXISTS sp_insert_insurance_type;
DELIMITER $$
CREATE PROCEDURE sp_insert_insurance_type(IN type VARCHAR(15))
BEGIN
	INSERT INTO insurance_type (type) 
	VALUES (type);
END
$$

DROP PROCEDURE IF EXISTS sp_insert_visit_type;
DELIMITER $$
CREATE PROCEDURE sp_insert_visit_type(IN type VARCHAR(20))
BEGIN
	INSERT INTO visit_type (type)
	VALUES (type);
END
$$

DROP PROCEDURE IF EXISTS sp_insert_clinic_department;
DELIMITER $$
CREATE PROCEDURE sp_insert_clinic_department(IN name VARCHAR(20))
BEGIN
	INSERT INTO clinic_department (name)
	VALUES (name);
END
$$

DROP PROCEDURE IF EXISTS sp_insert_medicine;
DELIMITER $$
CREATE PROCEDURE sp_insert_medicine(IN name VARCHAR(60))
BEGIN
	INSERT INTO medicine (name)
	VALUES (name);
END
$$

DROP PROCEDURE IF EXISTS sp_insert_patient_information;
DELIMITER $$
CREATE PROCEDURE sp_insert_patient_information(
		first_name VARCHAR(20),
		last_name VARCHAR(20),
		gender CHAR(10),
		date_of_birth DATE,
		age INT,
		race VARCHAR(20),
		phone VARCHAR(20),
		address VARCHAR(30),
		zip_code CHAR(5),
		email VARCHAR(30),
		maratial_status CHAR(10),
		snn VARCHAR(20),
		preferred_language VARCHAR(20))
BEGIN
	INSERT INTO patient_information (first_name, last_name, gender, date_of_birth, age, race, phone, address, zip_code, email, maratial_status, snn, preferred_language)
	VALUES (first_name, last_name, gender, date_of_birth, age, race, phone, address, zip_code, email, maratial_status, snn, preferred_language);
END
$$

DROP PROCEDURE IF EXISTS sp_insert_patient_emergency_contact_information;
DELIMITER $$
CREATE PROCEDURE sp_insert_patient_emergency_contact_information(
		patient_id INT,
		first_name VARCHAR(20),
		last_name VARCHAR(20),
		relation_to_patient VARCHAR(20),
		phone VARCHAR(20),
		address VARCHAR(30),
		zip_code CHAR(5))
BEGIN
	INSERT INTO patient_emergency_contact_information (patient_id, first_name, last_name, relation_to_patient, phone, address, zip_code)
	VALUES (patient_id, first_name, last_name, relation_to_patient, phone, address, zip_code);
END
$$

DROP PROCEDURE IF EXISTS sp_insert_insurance_information;
DELIMITER $$
CREATE PROCEDURE sp_insert_insurance_information(
	patient_id INT,
    insurance_name VARCHAR(50),
    member_id VARCHAR(20),
    insurance_type INT,
    patient_relationship_to_insured VARCHAR(20),
    patient_status VARCHAR(20),
    provided_by_employeer BOOLEAN,
    payer_name VARCHAR(20),
    plan_name VARCHAR(20),
    co_pay VARCHAR(30),
    balance DECIMAL(10,2),
    address VARCHAR(20),
    zip_code CHAR(5))
BEGIN
	INSERT INTO insurance_information (patient_id, insurance_name, member_id, insurance_type, patient_relationship_to_insured, patient_status, provided_by_employeer, payer_name, co_pay, balance, address, zip_code)
	Values (patient_id, insurance_name, member_id, insurance_type, patient_relationship_to_insured, patient_status, provided_by_employeer, payer_name, co_pay, balance, address, zip_code);
END
$$

DROP PROCEDURE IF EXISTS sp_insert_provider_information;
DELIMITER $$
CREATE PROCEDURE sp_insert_provider_information(
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    specialty VARCHAR(20),
    from_time TIME,
    to_time TIME,
    available VARCHAR(10),
    address VARCHAR(30),
    zip_code CHAR(5),
    phone VARCHAR(20))
BEGIN
	INSERT INTO provider_information (first_name, last_name, specialty, from_time, to_time, available, address, zip_code, phone)
	VALUES (first_name, last_name, specialty, from_time, to_time, available, address, zip_code, phone);
END
$$

DROP PROCEDURE IF EXISTS sp_insert_check_in_information;
DELIMITER $$
CREATE PROCEDURE sp_insert_check_in_information(
    clinic_department_id INT,
    visit_type INT,
    patient_weight FLOAT,
    date DATE,
    from_time TIME,
    to_time TIME,
    status VARCHAR(50),
    new_patient BOOLEAN,
    walk_in BOOLEAN)
BEGIN
	INSERT INTO check_in_information (clinic_department_id, visit_type, patient_weight, date, from_time, to_time, status, new_patient, walk_in)  
	VALUES (clinic_department_id, visit_type, patient_weight, date, from_time, to_time, status, new_patient, walk_in) ;
END
$$

DROP PROCEDURE IF EXISTS sp_insert_patient_check_in;
DELIMITER $$
CREATE PROCEDURE sp_insert_patient_check_in (
    patient_id INT,
    check_in_info_id INT)
BEGIN
	INSERT INTO patient_check_in (patient_id, check_in_info_id)
	VALUES (patient_id, check_in_info_id);
END
$$

DROP PROCEDURE IF EXISTS sp_insert_provider_patient_check_in;
DELIMITER $$
CREATE PROCEDURE sp_insert_provider_patient_check_in (
    provider_id INT,
    patient_check_in_id INT)
BEGIN
	INSERT INTO provider_patient_check_in (provider_id, patient_check_in_id)
	VALUES (provider_id, patient_check_in_id);
END
$$

DROP PROCEDURE IF EXISTS sp_insert_clinic_care_information;
DELIMITER $$
CREATE PROCEDURE sp_insert_clinic_care_information (
    check_in_info_id INT,
    diagnoses VARCHAR(50),
    test VARCHAR(60),
    test_results VARCHAR(50),
    prescription VARCHAR(150),
    fees DECIMAL(10, 2))
BEGIN
	INSERT INTO clinic_care_information (check_in_info_id, diagnoses, test, test_results, prescription, fees)
	VALUES (check_in_info_id, diagnoses, test, test_results, prescription, fees);
END
$$

DROP PROCEDURE IF EXISTS sp_insert_bill;
DELIMITER $$
CREATE PROCEDURE sp_insert_bill (
    clinic_care_info_id INT,
    fees DECIMAL(10, 2))
BEGIN
	INSERT INTO bill (clinic_care_info_id, fees)
	VALUES (clinic_care_info_id, fees);
END
$$

DROP PROCEDURE IF EXISTS sp_insert_prescription;
DELIMITER $$
CREATE PROCEDURE sp_insert_prescription (
    clinic_care_info_id INT,
    pharmacy_name VARCHAR(20),
    quantity INT,
    price DECIMAL(10 , 2 ),
    duration VARCHAR(60),
    date DATE,
    caution VARCHAR(60))
BEGIN
	INSERT INTO prescription (clinic_care_info_id, pharmacy_name, quantity, price, duration, date, caution)
	VALUES (clinic_care_info_id, pharmacy_name, quantity, price, duration, date, caution);		
END
$$

DROP PROCEDURE IF EXISTS sp_insert_prescribe_medicine;
DELIMITER $$
CREATE PROCEDURE sp_insert_prescribe_medicine (
    medicine_id INT,
    prescription_id INT)
BEGIN
	INSERT INTO prescribe_medicine (medicine_id, prescription_id)
	VALUES (medicine_id, prescription_id);		
END
$$

DROP PROCEDURE IF EXISTS sp_insert_supplier;
DELIMITER $$
CREATE PROCEDURE sp_insert_supplier (
    clinic_care_info_id INT,
    order_name VARCHAR(20),
    date DATE)
BEGIN
	INSERT INTO supplier (clinic_care_info_id, order_name, date)
	VALUES (clinic_care_info_id, order_name, date);
END
$$


-- INSERT PROCEDURE CALL
CALL sp_insert_zip_code('73301', 'Austin', 'Texas');
CALL sp_insert_zip_code('73344', 'Austin', 'Texas');
CALL sp_insert_zip_code('75001', 'Addison', 'Texas');
CALL sp_insert_zip_code('76301', 'Wichita Falls', 'Texas');
CALL sp_insert_zip_code('78833', 'Camp Wood', 'Texas');
CALL sp_insert_zip_code('75006', 'Carrollton', 'Texas');
CALL sp_insert_zip_code('75080', 'Richardson', 'Texas');
CALL sp_insert_zip_code('75040', 'Garland', 'Texas');
CALL sp_insert_zip_code('75059', 'Irving ', 'Texas');

CALL sp_insert_insurance_type('Medicare');
CALL sp_insert_insurance_type('Medicaid');
CALL sp_insert_insurance_type('Tri care');
CALL sp_insert_insurance_type('Champva');
CALL sp_insert_insurance_type('Feca');
CALL sp_insert_insurance_type('Other');

CALL sp_insert_visit_type ('Follow up');
CALL sp_insert_visit_type('Sick visit');
CALL sp_insert_visit_type('Check up');
CALL sp_insert_visit_type('Well child check');
CALL sp_insert_visit_type('Physical exam');
CALL sp_insert_visit_type('Blood test');
CALL sp_insert_visit_type('Immunization shot');
CALL sp_insert_visit_type('Other');

CALL sp_insert_clinic_department('Exam room');
CALL sp_insert_clinic_department('Check up room no. 1');
CALL sp_insert_clinic_department('Check up room no. 2');
CALL sp_insert_clinic_department('Check up room no. 3');
CALL sp_insert_clinic_department('Check up room no. 4');
CALL sp_insert_clinic_department('Emergency room');
CALL sp_insert_clinic_department('Other');

CALL sp_insert_medicine('Renzo’s Picky Eater Multi with Iron daily');
CALL sp_insert_medicine('Thorne Kids Multi+');
CALL sp_insert_medicine('Delta D3');
CALL sp_insert_medicine('Cholecalciferol');
CALL sp_insert_medicine('Flu Shot');
CALL sp_insert_medicine('Atovaquone');
CALL sp_insert_medicine('Tylenol');
CALL sp_insert_medicine('DTaP Shot');

CALL sp_insert_patient_information('Jack', 'Peterson', 'male', '2015-07-02', 6, 'america', '801 234 9867', '234 hunts ln', '73301', 'jackpeterson@gmail.com', false, '', 'English');
CALL sp_insert_patient_information('Emma', 'Watson', 'female', '2010-03-08', 12, 'america', '401 675 4675', '112 star ln', '73344', 'emmawatson@yahoo.com', false, '', 'English');
CALL sp_insert_patient_information('John', 'Smith', 'male', '2019-10-05', 3, 'america', '771 234 4567', '345 creek ln', '75001', 'johnsmith@hotmail.com', false, '', '');
CALL sp_insert_patient_information('Dayana', 'Jones', 'female', '2005-04-20', 16, 'america', '601 834 4867', '789 little stone ln', '76301', 'dayanajones@yahoo.com', false, '', '');
CALL sp_insert_patient_information('David', 'Wilson', 'male', '1990-11-17', 32, 'america', '301 234 0860', '121 stream ln', '78833', 'davidwilson@gmail.com', true, '', 'English');

CALL sp_insert_patient_emergency_contact_information(1, 'Lesly', 'Peterson', 'Mother', '801 234 9867', '234 hunts ln', '73301');
CALL sp_insert_patient_emergency_contact_information(2, 'Bob', 'Watson', 'Father', '401 675 4676', '112 star ln', '73344');
CALL sp_insert_patient_emergency_contact_information(3, 'Henly', 'Smith', 'Mother', '771 234 4567', '345 creek ln', '75001');
CALL sp_insert_patient_emergency_contact_information(4, 'Emily', 'Jones', 'Mother', '601 834 6767', '789 little stone ln', '76301');
CALL sp_insert_patient_emergency_contact_information(5, 'Marry', 'Wilson', 'Wife', '301 234 1243', '121 stream ln', '78833');

CALL sp_insert_insurance_information(1, 'United Health', '123 456 697', 4, 'Son', 'not working', true, '', '', '', 400.00, '12 South Ln', '78833');
CALL sp_insert_insurance_information(2, 'CIGNA', '567 989 690', 3, 'Daughter', 'not working', true, '', '', '', 568.78, '43 East Ln', '75006');
CALL sp_insert_insurance_information(3, 'Metropolitan', '245 780 261', 2, 'Son', 'not working', true, '', '', '', 100.50, '78 North Ln', '75080');
CALL sp_insert_insurance_information(4, 'Point32Health', '789 346 900', 3, 'Self', 'working', true, '', '', '', 670.00, '99 Wood walk Ln', '73301');
CALL sp_insert_insurance_information(5, 'Metropolitan', '879 258 878', 1, 'Self', 'working', false, '', '', '', 250.78, '55 Stream Ln', '75080');

CALL sp_insert_provider_information('Danial', 'Hall', 'Pediatric', '08:30:00', '17:00:00', 'Mon-Fri', '123 Tom Hl', '78833', '342 544 6665');
CALL sp_insert_provider_information('Kevin', 'Lee', 'general practitioner', '08:30:00', '17:00:00', 'Mon-Fri', '233 Back St', '75080', '567 134 9800');
CALL sp_insert_provider_information('Matthew', 'Scott', 'Family Medicine', '08:30:00', '17:00:00', 'Mon-Fri', '677 Park St', '76301', '324 121 7875');
CALL sp_insert_provider_information('Sandra', 'Clark', 'Ophthalmology', '08:30:00', '17:00:00', 'Mon-Fri', '567 River Rd', '75006', '213 633 3212');
CALL sp_insert_provider_information('Amanda', 'White', 'gynecology ', '08:30:00', '17:00:00', 'Mon-Fri', '678 Peak Ln', '73344', '785 533 2334');

CALL sp_insert_check_in_information(3, 4, 20, '2022-02-23', '13:30:00', '15:00:00', 'Checked In', true, true);
CALL sp_insert_check_in_information(2, 1, 30, '2022-03-13', '9:30:00', '11:00:00', 'Checked In', true, true);
CALL sp_insert_check_in_information(1, 7, 10, '2022-04-08', '10:30:00', '11:00:00', 'Checked In', true, true);
CALL sp_insert_check_in_information(4, 2, 38, '2022-05-06', '9:00:00', '11:00:00', 'Checked In', true, true);
CALL sp_insert_check_in_information(5, 5, 60, '2022-06-07', '14:30:00', '16:00:00', 'Checked In', true, true);
CALL sp_insert_check_in_information(1, 4, 21, '2022-09-12', '13:30:00', '15:00:00', 'Checked In', false, true);
CALL sp_insert_check_in_information(1, 7, 11, '2022-10-08', '10:30:00', '11:00:00', 'Checked In', false, true);
CALL sp_insert_check_in_information(3, 2, 40, '2022-11-21', '13:30:00', '15:00:00', 'Checked In', false, true);
CALL sp_insert_check_in_information(4, 2, 65, '2022-11-25', '15:30:00', '16:00:00', 'Checked In', false, true);
CALL sp_insert_check_in_information(1, 3, 12, '2023-01-08', '10:00:00', '11:00:00', 'Scheduled Appointment', false, true);
CALL sp_insert_check_in_information(5, 5, 60, '2022-06-07', '14:30:00', '16:00:00', 'Scheduled Appointment', false, true);

CALL sp_insert_patient_check_in(1, 1);
CALL sp_insert_patient_check_in(2, 2);
CALL sp_insert_patient_check_in(3, 3);
CALL sp_insert_patient_check_in(4, 4);
CALL sp_insert_patient_check_in(5, 5);
CALL sp_insert_patient_check_in(1, 6);
CALL sp_insert_patient_check_in(3, 7);
CALL sp_insert_patient_check_in(3, 8);
CALL sp_insert_patient_check_in(5, 9);
CALL sp_insert_patient_check_in(4, 10);
CALL sp_insert_patient_check_in(5,11);

CALL sp_insert_provider_patient_check_in(1 , 1);
CALL sp_insert_provider_patient_check_in(3 , 2);
CALL sp_insert_provider_patient_check_in(1 , 3);
CALL sp_insert_provider_patient_check_in(3 , 4);
CALL sp_insert_provider_patient_check_in(2 , 5);
CALL sp_insert_provider_patient_check_in(1 , 6);
CALL sp_insert_provider_patient_check_in(1 , 7);
CALL sp_insert_provider_patient_check_in(2, 8);
CALL sp_insert_provider_patient_check_in(2, 9);
CALL sp_insert_provider_patient_check_in(2, 10);
CALL sp_insert_provider_patient_check_in(2, 11);

CALL sp_insert_clinic_care_information(1, 'Iron deficiency', 'Blood Screening', 'All good', 'Renzo’s Picky Eater Multi with Iron daily and Thorne Kids Multi+ each tabet daily till next visit', 250.00);
CALL sp_insert_clinic_care_information(2, 'Vitamin D defficiency', 'Vitamin D', '20-Hydroxyvitamin D', 'Take Delta D3 and cholecalciferol regularly for a 6 months and recommended sun exposure daily for atleast 1 hour.', 300.00);
CALL sp_insert_clinic_care_information(3, NULL, NULL, NULL, 'Flu Immunization Shot', 150.00);
CALL sp_insert_clinic_care_information(4, 'Cold and Fever', 'Blood Screening', 'Malaria positive', 'Take Atovaquone tablet daily morining and evening for 7 days', 350.00);
CALL sp_insert_clinic_care_information(5, 'Joint pain', 'Imaging Tests, Blood, Fluid and Tissue Tests, Nerve Tests', 'Diagnosed Arthritis', 'Tylenol to help ease the pain and exercise daily waliking or low-impact aerobic exercise is the best', 600.00);
CALL sp_insert_clinic_care_information(6, 'Iron deficiency', NULL, NULL, 'Continue the Thorne Kids Multi+ tablet', 100.00);
CALL sp_insert_clinic_care_information(7, NULL, NULL, NULL, 'DTaP Immunization Shot', 200.00);
CALL sp_insert_clinic_care_information(8, 'Covid', 'Covid-19', 'positive', 'Take Tylenol daily morning and evening for 10 days and quarantine for 10 days', 150.00);
CALL sp_insert_clinic_care_information(9, 'Covid', 'Covid-19', 'positive', 'Take Tylenol daily morning and evening for 10 days and quarantine for 10 days', 150.00);

CALL sp_insert_bill(1, 425.00);
CALL sp_insert_bill(2, 335.00);
CALL sp_insert_bill(3, 230.00);
CALL sp_insert_bill(4, 360.00);
CALL sp_insert_bill(5, 620.00);
CALL sp_insert_bill(6, 140.00);
CALL sp_insert_bill(7, 320.00);
CALL sp_insert_bill(8, 170.00);
CALL sp_insert_bill(9, 170.00);

CALL sp_insert_prescription(1, 'CVS', 250, 35.00, 'Regularly for 6-7 months', '2022-02-23', 'With Doctor prescription only');
CALL sp_insert_prescription(1, 'CVS', 250, 40.00, 'Regularly for 6-7 months', '2022-02-23', 'With Doctor prescription only');
CALL sp_insert_prescription(2, 'CVS', 180, 15.00, '6 months',  '2022-03-13', 'With Doctor prescription only');
CALL sp_insert_prescription(2, 'CVS', 180, 20.00, '6 months',  '2022-03-13', 'With Doctor prescription only');
CALL sp_insert_prescription(3, 'Walgreens', 1, 80.00, NULL, '2022-04-08', 'With Doctor prescription only');
CALL sp_insert_prescription(4, 'CVS', 14, 10.00, '7 days', '2022-05-06', 'With Doctor prescription only');
CALL sp_insert_prescription(5, 'Walgreens', 30, 20.00, '1 month', '2022-06-07', 'With Doctor prescription only');
CALL sp_insert_prescription(6, 'CVS',356, 40.00, 'Regularly for around 1 year', '2022-09-12', 'With Doctor prescription only');
CALL sp_insert_prescription(7, 'Walgreens',1, 120.00, NULL, '2022-10-08', 'With Doctor prescription only');
CALL sp_insert_prescription(8, 'Walgreens', 20, 50.00, '10 days', '2022-11-21', 'With Doctor prescription only');
CALL sp_insert_prescription(9, 'Walgreens', 20, 50.00, '10 days', '2022-11-25', 'With Doctor prescription only');

CALL sp_insert_prescribe_medicine(1, 1);
CALL sp_insert_prescribe_medicine(2, 2);
CALL sp_insert_prescribe_medicine(3, 3);
CALL sp_insert_prescribe_medicine(4, 4);
CALL sp_insert_prescribe_medicine(5, 5);
CALL sp_insert_prescribe_medicine(6, 6);
CALL sp_insert_prescribe_medicine(7, 7);
CALL sp_insert_prescribe_medicine(2, 8);
CALL sp_insert_prescribe_medicine(8, 9);
CALL sp_insert_prescribe_medicine(7, 10);
CALL sp_insert_prescribe_medicine(7, 11);

call sp_insert_supplier(1, 'Blood test Lab', '2022-02-23');
call sp_insert_supplier(2, 'Blood test Lab', '2022-03-13');
call sp_insert_supplier(4, 'Blood test Lab', '2022-05-06');
call sp_insert_supplier(5, 'X-ray Lab', '2022-06-07');

