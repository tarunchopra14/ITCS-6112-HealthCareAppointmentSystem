use emrsystem;

DROP PROCEDURE IF EXISTS sp_get_patient_information;
DELIMITER $$
CREATE PROCEDURE sp_get_patient_information()
BEGIN
	SELECT * FROM patient_information;
END
$$

DROP VIEW IF EXISTS all_visits_view; 
CREATE OR REPLACE VIEW all_visits_view AS
    SELECT
		patient_information.id,
        CONCAT(patient_information.first_name,' ',patient_information.last_name) AS patient_full_name,
        check_in_information.status,
        check_in_information.date,
        check_in_information.from_time,
        clinic_care_information.diagnoses,
        CONCAT(provider_information.first_name,' ',provider_information.last_name) AS provider_full_name
    FROM
        patient_information
            JOIN
        patient_check_in ON patient_information.id = patient_check_in.patient_id
            JOIN
        check_in_information ON patient_check_in.check_in_info_id = check_in_information.id
            JOIN
        clinic_care_information ON check_in_information.id = clinic_care_information.check_in_info_id
            JOIN
        provider_patient_check_in ON check_in_information.id = provider_patient_check_in.patient_check_in_id
            JOIN
        provider_information ON provider_patient_check_in.provider_id = provider_information.id
    WHERE
        check_in_information.status = 'Checked In'
    ORDER BY check_in_information.date , check_in_information.from_time , 
			CONCAT(patient_information.first_name,' ',patient_information.last_name) , 
            clinic_care_information.diagnoses , 
            CONCAT(provider_information.first_name,' ',provider_information.last_name);
    
DROP PROCEDURE IF EXISTS sp_get_all_visits_view;
DELIMITER $$
CREATE PROCEDURE sp_get_all_visits_view ()
BEGIN
	SELECT * FROM all_visits_view;
END
$$

DROP PROCEDURE IF EXISTS sp_get_provider_information;
DELIMITER $$
CREATE PROCEDURE sp_get_provider_information()
BEGIN
	SELECT * FROM provider_information;
END
$$
    