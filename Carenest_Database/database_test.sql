CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    age INT,
    condition TEXT,
    mobility_level VARCHAR(50),
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20)
);
CREATE TABLE caregivers (
    caregiver_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    hourly_rate DECIMAL(10,2),
    verified BOOLEAN DEFAULT TRUE
);
CREATE TABLE visits (
    visit_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    caregiver_id INT REFERENCES caregivers(caregiver_id),
    visit_date DATE,
    start_time TIME,
    end_time TIME,
    status VARCHAR(30)
);
INSERT INTO patients (
    full_name, age, condition, mobility_level,
    emergency_contact_name, emergency_contact_phone
) VALUES (
    'Mr. J. Perera', 72, 'Post-surgery', 'Low',
    'S. Perera (Son)', '0775558899'
);
INSERT INTO caregivers (
    full_name, hourly_rate, verified
) VALUES (
    'Kumari Perera', 800.00, TRUE
);
INSERT INTO visits (
    patient_id, caregiver_id,
    visit_date, start_time, end_time, status
) VALUES (
    1, 1,
    '2026-02-05', '09:00', '11:00', 'REQUESTED'
);
