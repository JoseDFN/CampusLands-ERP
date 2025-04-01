USE campuslands;

-- 1. Countries (10 inserts)
INSERT INTO countries (country_name, iso_code_country) VALUES ('Colombia', 'COL');
INSERT INTO countries (country_name, iso_code_country) VALUES ('Argentina', 'ARG');
INSERT INTO countries (country_name, iso_code_country) VALUES ('Brasil', 'BRA');
INSERT INTO countries (country_name, iso_code_country) VALUES ('Chile', 'CHL');
INSERT INTO countries (country_name, iso_code_country) VALUES ('Perú', 'PER');

-- Inserting regions (departments) for Colombia  
INSERT INTO regions (region_name, country_id) VALUES ('Santander', 1);
INSERT INTO regions (region_name, country_id) VALUES ('Cundinamarca', 1);
INSERT INTO regions (region_name, country_id) VALUES ('Norte de Santander', 1);

-- 3. Cities (10 inserts)
INSERT INTO cities (city_name, region_id) VALUES ('Bucaramanga', 1);
INSERT INTO cities (city_name, region_id) VALUES ('Piedecuesta', 1);
INSERT INTO cities (city_name, region_id) VALUES ('Girón', 1);
INSERT INTO cities (city_name, region_id) VALUES ('Floridablanca', 1);
INSERT INTO cities (city_name, region_id) VALUES ('Bogotá', 2);
INSERT INTO cities (city_name, region_id) VALUES ('Soacha', 2);
INSERT INTO cities (city_name, region_id) VALUES ('Chía', 2);
INSERT INTO cities (city_name, region_id) VALUES ('Cúcuta', 3);
INSERT INTO cities (city_name, region_id) VALUES ('Ocaña', 3);
INSERT INTO cities (city_name, region_id) VALUES ('Los Patios', 3);

-- 4. Addresses (29 inserts)
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Calle 10', '100', '680001', 1, 'Dirección en Bucaramanga');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Carrera 20', '101', '680002', 2, 'Dirección en Piedecuesta');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Avenida 30', '102', '680003', 3, 'Dirección en Girón');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Calle 40', '103', '680004', 4, 'Dirección en Floridablanca');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Avenida 50', '104', '110111', 1, 'Dirección en Bucaramanga');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Calle 60', '105', '110112', 2, 'Dirección en Piedecuesta');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Carrera 70', '106', '110113', 3, 'Dirección en Giron');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Avenida 80', '107', '540001', 4, 'Dirección en Floridablanca');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Calle 90', '108', '540002', 1, 'Dirección en Bucaramanga');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Carrera 100', '109', '540003', 2, 'Dirección en Piedecuesta');

-- Nuevas direcciones para Bucaramanga (city_id = 1)

INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Calle 11', '111', '680011', 1, 'Nueva dirección en Bucaramanga 1');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Calle 12', '112', '680012', 1, 'Nueva dirección en Bucaramanga 2');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Carrera 13', '113', '680013', 1, 'Nueva dirección en Bucaramanga 3');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Avenida 14', '114', '680014', 1, 'Nueva dirección en Bucaramanga 4');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Calle 15', '115', '680015', 1, 'Nueva dirección en Bucaramanga 5');

-- Nuevas direcciones para Piedecuesta (city_id = 2)

INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Calle 21', '121', '680021', 2, 'Nueva dirección en Piedecuesta 1');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Carrera 22', '122', '680022', 2, 'Nueva dirección en Piedecuesta 2');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Avenida 23', '123', '680023', 2, 'Nueva dirección en Piedecuesta 3');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Calle 24', '124', '680024', 2, 'Nueva dirección en Piedecuesta 4');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Carrera 25', '125', '680025', 2, 'Nueva dirección en Piedecuesta 5');

-- Nuevas direcciones para Girón (city_id = 3)

INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Calle 31', '131', '680031', 3, 'Nueva dirección en Girón 1');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Carrera 32', '132', '680032', 3, 'Nueva dirección en Girón 2');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Avenida 33', '133', '680033', 3, 'Nueva dirección en Girón 3');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Calle 34', '134', '680034', 3, 'Nueva dirección en Girón 4');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Carrera 35', '135', '680035', 3, 'Nueva dirección en Girón 5');

-- Nuevas direcciones para Floridablanca (city_id = 4)

INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Calle 41', '141', '680041', 4, 'Nueva dirección en Floridablanca 1');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Carrera 42', '142', '680042', 4, 'Nueva dirección en Floridablanca 2');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Avenida 43', '143', '680043', 4, 'Nueva dirección en Floridablanca 3');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Calle 44', '144', '680044', 4, 'Nueva dirección en Floridablanca 4');

-- 5. Companies (1 insert, solo "Campuslands")

INSERT INTO companies (register_number, legal_name, comercial_name, country_id, foundation_date, juridical_form) VALUES ('REG001', 'Campuslands', 'Campuslands', 1, '2000-01-01', 'LTDA');

-- 6. Branches (3 inserts: Campus Bucaramanga, Campus Bogota y Campus Cucuta)
INSERT INTO branches (branch_name, address_id, company_id) VALUES ('Campus Bucaramanga', 1, 1);
INSERT INTO branches (branch_name, address_id, company_id) VALUES ('Campus Bogota', 2, 1);
INSERT INTO branches (branch_name, address_id, company_id) VALUES ('Campus Cucuta', 3, 1);

-- 7. Phone Types (10 inserts)
INSERT INTO phone_types (phone_type) VALUES ('Mobile');
INSERT INTO phone_types (phone_type) VALUES ('Home');
INSERT INTO phone_types (phone_type) VALUES ('Work');
INSERT INTO phone_types (phone_type) VALUES ('Fax');
INSERT INTO phone_types (phone_type) VALUES ('Other');
INSERT INTO phone_types (phone_type) VALUES ('Emergency');
INSERT INTO phone_types (phone_type) VALUES ('Office');
INSERT INTO phone_types (phone_type) VALUES ('Personal');
INSERT INTO phone_types (phone_type) VALUES ('Business');
INSERT INTO phone_types (phone_type) VALUES ('Secondary');

-- 8. Phone Numbers (29 inserts)
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000001', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000002', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000003', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000004', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000005', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000006', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('6012000001', '057', 2);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('6012000002', '057', 2);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('6012000003', '057', 2);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('6012000004', '057', 2);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000007', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000008', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000009', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000010', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000011', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000012', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000013', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000014', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000015', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000016', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('6012000005', '057', 2);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('6012000006', '057', 2);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('6012000007', '057', 2);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('6012000008', '057', 2);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('6012000009', '057', 2);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('6012000010', '057', 2);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('6012000011', '057', 2);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('6012000012', '057', 2);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('6012000013', '057', 2);

-- 9. Document Types (10 inserts)
INSERT INTO document_types (document_type) VALUES ('Passport');
INSERT INTO document_types (document_type) VALUES ('ID Card');
INSERT INTO document_types (document_type) VALUES ('Driver License');
INSERT INTO document_types (document_type) VALUES ('Voter ID');
INSERT INTO document_types (document_type) VALUES ('Student ID');
INSERT INTO document_types (document_type) VALUES ('Employee ID');
INSERT INTO document_types (document_type) VALUES ('Social Security');
INSERT INTO document_types (document_type) VALUES ('Residence Permit');
INSERT INTO document_types (document_type) VALUES ('Tax ID');
INSERT INTO document_types (document_type) VALUES ('Other');

-- 10. Person (26 inserts)

INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Pedro', 'Ruiz González', 'pedro.ruiz@example.com', '200000011', 2, 4);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Valentina', 'Díaz Herrera', 'valentina.diaz@example.com', '200000012', 2, 5);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Luis', 'Castro Navarro', 'luis.castro@example.com', '200000013', 8, 6);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Camila', 'Morales Rojas', 'camila.morales@example.com', '200000014', 4, 7);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Jorge', 'Ortiz Rivera', 'jorge.ortiz@example.com', '200000015', 8, 8);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Daniela', 'Vargas Mendoza', 'daniela.vargas@example.com', '200000016', 8, 9);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Francisco', 'Salazar Rincón', 'francisco.salazar@example.com', '200000017', 2, 10);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Paola', 'Rojas Quintana', 'paola.rojas@example.com', '200000018', 8, 11);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Sebastián', 'Molina Castro', 'sebastian.molina@example.com', '200000019', 2, 12);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Andrea', 'Cruz Martínez', 'andrea.cruz@example.com', '200000020', 2, 13);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Diego', 'Romero Vega', 'diego.romero@example.com', '200000021', 1, 14);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Lorena', 'Cabrera Salinas', 'lorena.cabrera@example.com', '200000022', 1, 15);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Ricardo', 'Delgado Contreras', 'ricardo.delgado@example.com', '200000023', 1, 16);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Elena', 'Méndez Suárez', 'elena.mendez@example.com', '200000024', 1, 17);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Esteban', 'Bravo Guzmán', 'esteban.bravo@example.com', '200000025', 8, 18);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Mónica', 'Vega Pacheco', 'monica.vega@example.com', '200000026', 2, 19);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Rafael', 'Acosta Figueroa', 'rafael.acosta@example.com', '200000027', 2, 20);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Beatriz', 'Fuentes Olivares', 'beatriz.fuentes@example.com', '200000028', 2, 21);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Manuel', 'Herrera Miranda', 'manuel.herrera@example.com', '200000029', 2, 22);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Verónica', 'Orozco Páez', 'veronica.orozco@example.com', '200000030', 2, 23);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Jholver', 'Pardo', 'jholver.pardo@campuslands.com', '100000001', 2, 24);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Miguel', 'Rodriguez', 'miguel.rodriguez@campuslands.com', '100000002', 2, 25);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Pedro', 'Martinez', 'pedro.martinez@campuslands.com', '100000003', 2, 26);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Jose', 'Gomez', 'jose.gomez@campuslands.com', '100000004', 2, 27);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Monica', 'Lopez', 'monica.lopez@campuslands.com', '100000005', 2, 28);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Michael', 'Torres', 'michael.torres@campuslands.com', '100000006', 2, 29);

-- 11. Person Phones (26 inserts)
INSERT INTO person_phones (person_id, phone_id) VALUES (1, 1);
INSERT INTO person_phones (person_id, phone_id) VALUES (2, 2);
INSERT INTO person_phones (person_id, phone_id) VALUES (3, 3);
INSERT INTO person_phones (person_id, phone_id) VALUES (4, 4);
INSERT INTO person_phones (person_id, phone_id) VALUES (5, 5);
INSERT INTO person_phones (person_id, phone_id) VALUES (6, 6);
INSERT INTO person_phones (person_id, phone_id) VALUES (7, 7);
INSERT INTO person_phones (person_id, phone_id) VALUES (8, 8);
INSERT INTO person_phones (person_id, phone_id) VALUES (9, 9);
INSERT INTO person_phones (person_id, phone_id) VALUES (10, 10);
INSERT INTO person_phones (person_id, phone_id) VALUES (11, 11);
INSERT INTO person_phones (person_id, phone_id) VALUES (12, 12);
INSERT INTO person_phones (person_id, phone_id) VALUES (13, 13);
INSERT INTO person_phones (person_id, phone_id) VALUES (14, 14);
INSERT INTO person_phones (person_id, phone_id) VALUES (15, 15);
INSERT INTO person_phones (person_id, phone_id) VALUES (16, 16);
INSERT INTO person_phones (person_id, phone_id) VALUES (17, 17);
INSERT INTO person_phones (person_id, phone_id) VALUES (18, 18);
INSERT INTO person_phones (person_id, phone_id) VALUES (19, 19);
INSERT INTO person_phones (person_id, phone_id) VALUES (20, 20);
INSERT INTO person_phones (person_id, phone_id) VALUES (21, 21);
INSERT INTO person_phones (person_id, phone_id) VALUES (22, 22);
INSERT INTO person_phones (person_id, phone_id) VALUES (23, 23);
INSERT INTO person_phones (person_id, phone_id) VALUES (24, 24);
INSERT INTO person_phones (person_id, phone_id) VALUES (25, 25);
INSERT INTO person_phones (person_id, phone_id) VALUES (26, 26);


-- 12. Guardian (10 inserts)
INSERT INTO guardian (person_id) VALUES (1);
INSERT INTO guardian (person_id) VALUES (2);
INSERT INTO guardian (person_id) VALUES (3);
INSERT INTO guardian (person_id) VALUES (4);
INSERT INTO guardian (person_id) VALUES (5);
INSERT INTO guardian (person_id) VALUES (6);
INSERT INTO guardian (person_id) VALUES (7);
INSERT INTO guardian (person_id) VALUES (8);
INSERT INTO guardian (person_id) VALUES (9);
INSERT INTO guardian (person_id) VALUES (10);

-- 13. Camper (10 inserts)
INSERT INTO camper (person_id, guardian_id, branch_id, enrollment_date, status_camper, risk_level) VALUES (11, 1, 1, '2023-09-01', 'En proceso de ingreso', 'Bajo');
INSERT INTO camper (person_id, guardian_id, branch_id, enrollment_date, status_camper, risk_level) VALUES (12, 2, 2, '2023-09-01', 'En proceso de ingreso', 'Bajo');
INSERT INTO camper (person_id, guardian_id, branch_id, enrollment_date, status_camper, risk_level) VALUES (13, 3, 3, '2023-09-01', 'En proceso de ingreso', 'Bajo');
INSERT INTO camper (person_id, guardian_id, branch_id, enrollment_date, status_camper, risk_level) VALUES (14, 4, 1, '2023-09-01', 'En proceso de ingreso', 'Bajo');
INSERT INTO camper (person_id, guardian_id, branch_id, enrollment_date, status_camper, risk_level) VALUES (15, 5, 2, '2023-09-01', 'En proceso de ingreso', 'Bajo');
INSERT INTO camper (person_id, guardian_id, branch_id, enrollment_date, status_camper, risk_level) VALUES (16, 6, 3, '2023-09-01', 'En proceso de ingreso', 'Bajo');
INSERT INTO camper (person_id, guardian_id, branch_id, enrollment_date, status_camper, risk_level) VALUES (17, 7, 1, '2023-09-01', 'En proceso de ingreso', 'Bajo');
INSERT INTO camper (person_id, guardian_id, branch_id, enrollment_date, status_camper, risk_level) VALUES (18, 8, 2, '2023-09-01', 'En proceso de ingreso', 'Bajo');
INSERT INTO camper (person_id, guardian_id, branch_id, enrollment_date, status_camper, risk_level) VALUES (19, 9, 3, '2023-09-01', 'En proceso de ingreso', 'Bajo');
INSERT INTO camper (person_id, guardian_id, branch_id, enrollment_date, status_camper, risk_level) VALUES (20, 10, 1, '2023-09-01', 'En proceso de ingreso', 'Bajo');

-- 14. Camper State History (10 inserts)
INSERT INTO camper_state_history (camper_id, old_state, new_state, reason) VALUES (1, 'En proceso de ingreso', 'Inscrito', 'Completó el proceso de inscripción');
INSERT INTO camper_state_history (camper_id, old_state, new_state, reason) VALUES (2, 'En proceso de ingreso', 'Inscrito', 'Completó el proceso de inscripción');
INSERT INTO camper_state_history (camper_id, old_state, new_state, reason) VALUES (3, 'En proceso de ingreso', 'Inscrito', 'Completó el proceso de inscripción');
INSERT INTO camper_state_history (camper_id, old_state, new_state, reason) VALUES (4, 'En proceso de ingreso', 'Inscrito', 'Completó el proceso de inscripción');
INSERT INTO camper_state_history (camper_id, old_state, new_state, reason) VALUES (5, 'En proceso de ingreso', 'Inscrito', 'Completó el proceso de inscripción');
INSERT INTO camper_state_history (camper_id, old_state, new_state, reason) VALUES (6, 'En proceso de ingreso', 'Inscrito', 'Completó el proceso de inscripción');
INSERT INTO camper_state_history (camper_id, old_state, new_state, reason) VALUES (7, 'En proceso de ingreso', 'Inscrito', 'Completó el proceso de inscripción');
INSERT INTO camper_state_history (camper_id, old_state, new_state, reason) VALUES (8, 'En proceso de ingreso', 'Inscrito', 'Completó el proceso de inscripción');
INSERT INTO camper_state_history (camper_id, old_state, new_state, reason) VALUES (9, 'En proceso de ingreso', 'Inscrito', 'Completó el proceso de inscripción');
INSERT INTO camper_state_history (camper_id, old_state, new_state, reason) VALUES (10, 'En proceso de ingreso', 'Inscrito', 'Completó el proceso de inscripción');

-- 15. Trainer (6 inserts)
INSERT INTO trainer (person_id, branch_id) VALUES (21, 1);
INSERT INTO trainer (person_id, branch_id) VALUES (22, 1);
INSERT INTO trainer (person_id, branch_id) VALUES (23, 1);
INSERT INTO trainer (person_id, branch_id) VALUES (24, 1);
INSERT INTO trainer (person_id, branch_id) VALUES (25, 1);
INSERT INTO trainer (person_id, branch_id) VALUES (26, 1);

-- 16. Competencies (10 inserts)
INSERT INTO competencies (competency_name) VALUES ('C#');
INSERT INTO competencies (competency_name) VALUES ('Java');
INSERT INTO competencies (competency_name) VALUES ('Python');
INSERT INTO competencies (competency_name) VALUES ('SQL');
INSERT INTO competencies (competency_name) VALUES ('HTML');
INSERT INTO competencies (competency_name) VALUES ('CSS');
INSERT INTO competencies (competency_name) VALUES ('JavaScript');
INSERT INTO competencies (competency_name) VALUES ('PHP');
INSERT INTO competencies (competency_name) VALUES ('INGLES');
INSERT INTO competencies (competency_name) VALUES ('SER');

-- 17. Trainer Competencies (17 inserts)
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (1, 1);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (1, 2);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (1, 3);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (1, 8);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (1, 4);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (2, 4);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (2, 5);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (2, 6);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (2, 7);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (3, 1);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (3, 2);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (3, 3);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (3, 8);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (3, 4);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (4, 9);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (5, 10);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (6, 9);

-- 18. Notifications (6 inserts)
INSERT INTO notifications (trainer_id, message, created_at) VALUES (1, 'Notification for trainer 1', '2023-09-03 09:00:00');
INSERT INTO notifications (trainer_id, message, created_at) VALUES (2, 'Notification for trainer 2', '2023-09-03 09:01:00');
INSERT INTO notifications (trainer_id, message, created_at) VALUES (3, 'Notification for trainer 3', '2023-09-03 09:02:00');
INSERT INTO notifications (trainer_id, message, created_at) VALUES (4, 'Notification for trainer 4', '2023-09-03 09:03:00');
INSERT INTO notifications (trainer_id, message, created_at) VALUES (5, 'Notification for trainer 5', '2023-09-03 09:04:00');
INSERT INTO notifications (trainer_id, message, created_at) VALUES (6, 'Notification for trainer 6', '2023-09-03 09:05:00');

-- 19. SGBDs (10 inserts)
INSERT INTO sgbds (sgbd_name) VALUES ('MySQL');
INSERT INTO sgbds (sgbd_name) VALUES ('MongoDB');
INSERT INTO sgbds (sgbd_name) VALUES ('PostgreSQL');
INSERT INTO sgbds (sgbd_name) VALUES ('Oracle');
INSERT INTO sgbds (sgbd_name) VALUES ('SQLServer');
INSERT INTO sgbds (sgbd_name) VALUES ('SQLite');
INSERT INTO sgbds (sgbd_name) VALUES ('MariaDB');
INSERT INTO sgbds (sgbd_name) VALUES ('Cassandra');
INSERT INTO sgbds (sgbd_name) VALUES ('Redis');
INSERT INTO sgbds (sgbd_name) VALUES ('DB2');

-- 20. Routes (5 inserts)
INSERT INTO routes (route_name, main_sgbd, alternative_sgbd) VALUES ('Fundamentos de programación', 1, 2);
INSERT INTO routes (route_name, main_sgbd, alternative_sgbd) VALUES ('Programación Web', 3, 4);
INSERT INTO routes (route_name, main_sgbd, alternative_sgbd) VALUES ('Programación formal', 5, 6);
INSERT INTO routes (route_name, main_sgbd, alternative_sgbd) VALUES ('Bases de datos', 1, 3);
INSERT INTO routes (route_name, main_sgbd, alternative_sgbd) VALUES ('Backend', 7, 8);

-- 21. Skills (10 inserts)
INSERT INTO skills (skill_name, skill_description, theoretical_weight, practical_weight, quizzes_weight) VALUES ('Introducción a la algoritmia', 'Module on basic algorithm concepts', 30, 60, 10);
INSERT INTO skills (skill_name, skill_description, theoretical_weight, practical_weight, quizzes_weight) VALUES ('PSeInt', 'Module for PSeInt programming', 30, 60, 10);
INSERT INTO skills (skill_name, skill_description, theoretical_weight, practical_weight, quizzes_weight) VALUES ('Python', 'Module for Python programming', 30, 60, 10);
INSERT INTO skills (skill_name, skill_description, theoretical_weight, practical_weight, quizzes_weight) VALUES ('HTML', 'Module for HTML basics', 30, 60, 10);
INSERT INTO skills (skill_name, skill_description, theoretical_weight, practical_weight, quizzes_weight) VALUES ('CSS', 'Module for CSS styling', 30, 60, 10);
INSERT INTO skills (skill_name, skill_description, theoretical_weight, practical_weight, quizzes_weight) VALUES ('Bootstrap', 'Module for Bootstrap framework', 30, 60, 10);
INSERT INTO skills (skill_name, skill_description, theoretical_weight, practical_weight, quizzes_weight) VALUES ('Java', 'Module for Java programming', 30, 60, 10);
INSERT INTO skills (skill_name, skill_description, theoretical_weight, practical_weight, quizzes_weight) VALUES ('JavaScript', 'Module for JavaScript programming', 30, 60, 10);
INSERT INTO skills (skill_name, skill_description, theoretical_weight, practical_weight, quizzes_weight) VALUES ('C#', 'Module for C# programming', 30, 60, 10);
INSERT INTO skills (skill_name, skill_description, theoretical_weight, practical_weight, quizzes_weight) VALUES ('NetCore', 'Module for .NET Core framework', 30, 60, 10);

-- 22. Base Route Skills
INSERT INTO base_route_skills (skill_id, base_route_description) VALUES (1, 'Base description for module 1');
INSERT INTO base_route_skills (skill_id, base_route_description) VALUES (2, 'Base description for module 2');
INSERT INTO base_route_skills (skill_id, base_route_description) VALUES (3, 'Base description for module 3');
INSERT INTO base_route_skills (skill_id, base_route_description) VALUES (4, 'Base description for module 4');
INSERT INTO base_route_skills (skill_id, base_route_description) VALUES (5, 'Base description for module 5');

-- 23. Route Skills
INSERT INTO route_skills (route_id, skill_id, main_sgbd, alternative_sgbd) VALUES (5, 1, 3, 1);
INSERT INTO route_skills (route_id, skill_id, main_sgbd, alternative_sgbd) VALUES (5, 2, 3, 1);
INSERT INTO route_skills (route_id, skill_id, main_sgbd, alternative_sgbd) VALUES (5, 3, 3, 1);
INSERT INTO route_skills (route_id, skill_id, main_sgbd, alternative_sgbd) VALUES (5, 4, 3, 1);
INSERT INTO route_skills (route_id, skill_id, main_sgbd, alternative_sgbd) VALUES (5, 5, 3, 1);
INSERT INTO route_skills (route_id, skill_id, main_sgbd, alternative_sgbd) VALUES (5, 6, 3, 1);
INSERT INTO route_skills (route_id, skill_id, main_sgbd, alternative_sgbd) VALUES (5, 7, 3, 1);
INSERT INTO route_skills (route_id, skill_id, main_sgbd, alternative_sgbd) VALUES (5, 8, 3, 1);
INSERT INTO route_skills (route_id, skill_id, main_sgbd, alternative_sgbd) VALUES (5, 9, 3, 1);
INSERT INTO route_skills (route_id, skill_id, main_sgbd, alternative_sgbd) VALUES (5, 10, 3, 1);

-- 24. Modules
INSERT INTO modules (module_name, module_description, module_status) VALUES 
  ('Fundamentos de Algoritmia', 'Introducción a conceptos básicos de algoritmia', 'Activo'),
  ('Programación Avanzada', 'Conceptos avanzados de programación y desarrollo de software', 'Activo'),
  ('Desarrollo Web', 'Fundamentos de desarrollo web con HTML, CSS y JavaScript', 'Activo');

-- 25. Module Skills
INSERT INTO module_skills (module_id, skill_id) VALUES 
  (1, 1), 
  (1, 2), 
  (2, 3), 
  (3, 4), 
  (3, 5), 
  (3, 8);

-- 26. Module Competencies
INSERT INTO module_competencies (module_id, competency_id) VALUES
  (1, 3), -- Módulo Fundamentos de Algoritmia - Python
  (2, 2), -- Módulo Programación Avanzada - Java
  (2, 1), -- Módulo Programación Avanzada - C#
  (3, 7), -- Módulo Desarrollo Web - JavaScript
  (3, 5), -- Módulo Desarrollo Web - CSS
  (3, 4); -- Módulo Desarrollo Web - HTML

-- 27. Sessions Class
INSERT INTO sessions_class (session_name, session_description, session_date) VALUES 
  ('Sesion Introductoria', 'Presentación del curso y fundamentos iniciales', '2023-10-20'),
  ('Sesion Avanzada', 'Profundización en temas avanzados', '2023-10-21');

-- 28. Session Modules
INSERT INTO session_modules (session_id, module_id) VALUES 
  (1, 1), 
  (1, 3), 
  (2, 2);

-- 29. Trainer Module Assignments
INSERT INTO trainer_module_assignments (trainer_id, module_id) VALUES 
  (1, 1), -- Jholver asignado a Fundamentos de Algoritmia
  (1, 2), -- Jholver asignado a Programación Avanzada
  (2, 3), -- Miguel asignado a Desarrollo Web
  (3, 1), -- Pedro asignado a Fundamentos de Algoritmia
  (3, 2); -- Pedro asignado a Programación Avanzada

-- 30. Campers Group
INSERT INTO campers_group (group_name, route_id, creation_date) VALUES ('Group 1', 5, CURRENT_DATE);

-- 31. Campers Group Members
INSERT INTO campers_group_members (group_id, camper_id) VALUES (1, 1);
INSERT INTO campers_group_members (group_id, camper_id) VALUES (1, 2);
INSERT INTO campers_group_members (group_id, camper_id) VALUES (1, 3);
INSERT INTO campers_group_members (group_id, camper_id) VALUES (1, 4);
INSERT INTO campers_group_members (group_id, camper_id) VALUES (1, 5);
INSERT INTO campers_group_members (group_id, camper_id) VALUES (1, 6);
INSERT INTO campers_group_members (group_id, camper_id) VALUES (1, 7);
INSERT INTO campers_group_members (group_id, camper_id) VALUES (1, 8);
INSERT INTO campers_group_members (group_id, camper_id) VALUES (1, 9);
INSERT INTO campers_group_members (group_id, camper_id) VALUES (1, 10);

-- 32. Training Areas
INSERT INTO training_areas (area_name, capacity, training_areas_status) VALUES ('Apolo', 33, 'Activo');
INSERT INTO training_areas (area_name, capacity, training_areas_status) VALUES ('Sputnik', 33, 'Activo');
INSERT INTO training_areas (area_name, capacity, training_areas_status) VALUES ('Satelite', 33, 'Activo');
INSERT INTO training_areas (area_name, capacity, training_areas_status) VALUES ('Luna', 33, 'Activo');
INSERT INTO training_areas (area_name, capacity, training_areas_status) VALUES ('Mercurio', 33, 'Activo');
INSERT INTO training_areas (area_name, capacity, training_areas_status) VALUES ('Venus', 33, 'Inactivo');
INSERT INTO training_areas (area_name, capacity, training_areas_status) VALUES ('Tierra', 33, 'Inactivo');
INSERT INTO training_areas (area_name, capacity, training_areas_status) VALUES ('Marte', 33, 'Inactivo');
INSERT INTO training_areas (area_name, capacity, training_areas_status) VALUES ('Jupiter', 33, 'Inactivo');
INSERT INTO training_areas (area_name, capacity, training_areas_status) VALUES ('Saturno', 33, 'Inactivo');

-- 33. Schedules
INSERT INTO schedules (day_of_week, start_time, end_time) VALUES ('Monday', '06:00:00', '9:00:00');
INSERT INTO schedules (day_of_week, start_time, end_time) VALUES ('Tuesday', '06:00:00', '9:00:00');
INSERT INTO schedules (day_of_week, start_time, end_time) VALUES ('Wednesday', '06:00:00', '9:00:00');
INSERT INTO schedules (day_of_week, start_time, end_time) VALUES ('Thursday', '06:00:00', '9:00:00');
INSERT INTO schedules (day_of_week, start_time, end_time) VALUES ('Friday', '06:00:00', '9:00:00');
INSERT INTO schedules (day_of_week, start_time, end_time) VALUES ('Monday', '10:00:00', '13:00:00');
INSERT INTO schedules (day_of_week, start_time, end_time) VALUES ('Tuesday', '10:00:00', '13:00:00');
INSERT INTO schedules (day_of_week, start_time, end_time) VALUES ('Wednesday', '10:00:00', '13:00:00');
INSERT INTO schedules (day_of_week, start_time, end_time) VALUES ('Thursday', '10:00:00', '13:00:00');
INSERT INTO schedules (day_of_week, start_time, end_time) VALUES ('Friday', '10:00:00', '13:00:00');
INSERT INTO schedules (day_of_week, start_time, end_time) VALUES ('Monday', '14:00:00', '17:00:00');
INSERT INTO schedules (day_of_week, start_time, end_time) VALUES ('Tuesday', '14:00:00', '17:00:00');
INSERT INTO schedules (day_of_week, start_time, end_time) VALUES ('Wednesday', '14:00:00', '17:00:00');
INSERT INTO schedules (day_of_week, start_time, end_time) VALUES ('Thursday', '14:00:00', '17:00:00');
INSERT INTO schedules (day_of_week, start_time, end_time) VALUES ('Friday', '14:00:00', '17:00:00');

-- 34. Route Assignments (considering area capacity check trigger)
INSERT INTO route_assignments (route_id, area_id, trainer_id, campers_group_id) VALUES (5, 1, 1, 1);

-- 35. Camper Route Enrollments (will trigger camper status change)
INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status) VALUES (1, 5, '2023-09-05', 'Active');
INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status) VALUES (2, 5, '2023-09-06', 'Active');
INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status) VALUES (3, 5, '2023-09-07', 'Active');
INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status) VALUES (4, 5, '2023-09-08', 'Active');
INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status) VALUES (5, 5, '2023-09-09', 'Active');
INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status) VALUES (6, 5, '2023-09-10', 'Active');
INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status) VALUES (7, 5, '2023-09-11', 'Active');
INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status) VALUES (8, 5, '2023-09-12', 'Active');
INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status) VALUES (9, 5, '2023-09-13', 'Active');
INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status) VALUES (10, 5, '2023-09-14', 'Active');

-- 36. Trainer Schedule (considering overlap check trigger)
INSERT INTO trainer_schedule (trainer_id, schedule_id, area_id, route_id, campers_group_id) VALUES (1, 1, 1, 5, 1);
INSERT INTO trainer_schedule (trainer_id, schedule_id, area_id, route_id, campers_group_id) VALUES (2, 2, 2, 5, 1);
INSERT INTO trainer_schedule (trainer_id, schedule_id, area_id, route_id, campers_group_id) VALUES (3, 3, 3, 5, 1);
INSERT INTO trainer_schedule (trainer_id, schedule_id, area_id, route_id, campers_group_id) VALUES (4, 4, 4, 5, 1);
INSERT INTO trainer_schedule (trainer_id, schedule_id, area_id, route_id, campers_group_id) VALUES (5, 5, 5, 5, 1);
INSERT INTO trainer_schedule (trainer_id, schedule_id, area_id, route_id, campers_group_id) VALUES (6, 6, 1, 5, 1);
INSERT INTO trainer_schedule (trainer_id, schedule_id, area_id, route_id, campers_group_id) VALUES (1, 7, 2, 5, 1);
INSERT INTO trainer_schedule (trainer_id, schedule_id, area_id, route_id, campers_group_id) VALUES (2, 8, 3, 5, 1);
INSERT INTO trainer_schedule (trainer_id, schedule_id, area_id, route_id, campers_group_id) VALUES (3, 9, 4, 5, 1);
INSERT INTO trainer_schedule (trainer_id, schedule_id, area_id, route_id, campers_group_id) VALUES (4, 10, 5, 5, 1);

-- 37. General Schedule
INSERT INTO general_schedule (route_id, skill_id, schedule_id) VALUES (5, 1, 1);
INSERT INTO general_schedule (route_id, skill_id, schedule_id) VALUES (5, 2, 2);
INSERT INTO general_schedule (route_id, skill_id, schedule_id) VALUES (5, 3, 3);
INSERT INTO general_schedule (route_id, skill_id, schedule_id) VALUES (5, 4, 4);
INSERT INTO general_schedule (route_id, skill_id, schedule_id) VALUES (5, 5, 5);
INSERT INTO general_schedule (route_id, skill_id, schedule_id) VALUES (5, 6, 6);
INSERT INTO general_schedule (route_id, skill_id, schedule_id) VALUES (5, 7, 7);
INSERT INTO general_schedule (route_id, skill_id, schedule_id) VALUES (5, 8, 8);
INSERT INTO general_schedule (route_id, skill_id, schedule_id) VALUES (5, 9, 9);
INSERT INTO general_schedule (route_id, skill_id, schedule_id) VALUES (5, 10, 10);

-- 38. Evaluations
INSERT INTO evaluations (camper_id, skill_id) VALUES (1, 9);
INSERT INTO evaluations (camper_id, skill_id) VALUES (2, 9);
INSERT INTO evaluations (camper_id, skill_id) VALUES (3, 9);
INSERT INTO evaluations (camper_id, skill_id) VALUES (4, 9);
INSERT INTO evaluations (camper_id, skill_id) VALUES (5, 9);
INSERT INTO evaluations (camper_id, skill_id) VALUES (6, 9);
INSERT INTO evaluations (camper_id, skill_id) VALUES (7, 9);
INSERT INTO evaluations (camper_id, skill_id) VALUES (8, 9);
INSERT INTO evaluations (camper_id, skill_id) VALUES (9, 9);
INSERT INTO evaluations (camper_id, skill_id) VALUES (10, 9);

-- 39. Evaluation Components (30 inserts)
-- For camper 1, all passing grades (triggering skill state update)
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (1, 'Teorico', 85.00, '2023-09-10');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (1, 'Practico', 60.00, '2023-09-11');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (1, 'Quiz', 75.00, '2023-09-12');

-- For camper 2, all passing grades
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (2, 'Teorico', 88.00, '2023-09-14');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (2, 'Practico', 60.00, '2023-09-15');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (2, 'Quiz', 78.00, '2023-09-16');

-- For camper 3
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (3, 'Teorico', 79.00, '2023-09-18');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (3, 'Practico', 60.00, '2023-09-19');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (3, 'Quiz', 81.00, '2023-09-20');

-- For camper 4
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (4, 'Teorico', 82.00, '2023-09-22');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (4, 'Practico', 58.00, '2023-09-23');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (4, 'Quiz', 79.00, '2023-09-24');

-- For camper 5
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (5, 'Teorico', 83.00, '2023-09-26');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (5, 'Practico', 59.00, '2023-09-27');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (5, 'Quiz', 77.00, '2023-09-28');

-- For camper 6
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (6, 'Teorico', 84.00, '2023-09-30');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (6, 'Practico', 60.00, '2023-10-01');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (6, 'Quiz', 80.00, '2023-10-02');

-- For camper 7
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (7, 'Teorico', 85.00, '2023-10-04');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (7, 'Practico', 60.00, '2023-10-05');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (7, 'Quiz', 78.00, '2023-10-06');

-- For camper 8
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (8, 'Teorico', 86.00, '2023-10-08');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (8, 'Practico', 60.00, '2023-10-09');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (8, 'Quiz', 82.00, '2023-10-10');

-- For camper 9
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (9, 'Teorico', 87.00, '2023-10-12');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (9, 'Practico', 60.00, '2023-10-13');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (9, 'Quiz', 83.00, '2023-10-14');

-- For camper 10
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (10, 'Teorico', 88.00, '2023-10-16');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (10, 'Practico', 60.00, '2023-10-17');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (10, 'Quiz', 84.00, '2023-10-18');

-- 40. Attendance
INSERT INTO attendance (camper_id, route_id, skill_id, schedule_id, attendance_date, attendance_status, arrival_time, justification) VALUES (1, 5, 9, 9, '2023-09-20', 'Present', '06:00:00', 'On time');
INSERT INTO attendance (camper_id, route_id, skill_id, schedule_id, attendance_date, attendance_status, arrival_time, justification) VALUES (2, 5, 9, 9, '2023-09-21', 'Present', '06:00:00', 'On time');
INSERT INTO attendance (camper_id, route_id, skill_id, schedule_id, attendance_date, attendance_status, arrival_time, justification) VALUES (3, 5, 9, 9, '2023-09-22', 'Present', '06:00:00', 'On time');
INSERT INTO attendance (camper_id, route_id, skill_id, schedule_id, attendance_date, attendance_status, arrival_time, justification) VALUES (4, 5, 9, 9, '2023-09-23', 'Present', '06:00:00', 'On time');
INSERT INTO attendance (camper_id, route_id, skill_id, schedule_id, attendance_date, attendance_status, arrival_time, justification) VALUES (5, 5, 9, 9, '2023-09-24', 'Present', '06:00:00', 'On time');
INSERT INTO attendance (camper_id, route_id, skill_id, schedule_id, attendance_date, attendance_status, arrival_time, justification) VALUES (6, 5, 9, 9, '2023-09-25', 'Present', '06:00:00', 'On time');
INSERT INTO attendance (camper_id, route_id, skill_id, schedule_id, attendance_date, attendance_status, arrival_time, justification) VALUES (7, 5, 9, 9, '2023-09-26', 'Present', '06:00:00', 'On time');
INSERT INTO attendance (camper_id, route_id, skill_id, schedule_id, attendance_date, attendance_status, arrival_time, justification) VALUES (8, 5, 9, 9, '2023-09-27', 'Present', '06:00:00', 'On time');
INSERT INTO attendance (camper_id, route_id, skill_id, schedule_id, attendance_date, attendance_status, arrival_time, justification) VALUES (9, 5, 9, 9, '2023-09-28', 'Present', '06:00:00', 'On time');
INSERT INTO attendance (camper_id, route_id, skill_id, schedule_id, attendance_date, attendance_status, arrival_time, justification) VALUES (10, 5, 9, 9, '2023-09-29', 'Present', '06:00:00', 'On time');

-- 41. Alumni (for graduated campers)
-- First graduate camper 1
UPDATE camper SET status_camper = 'Graduado' WHERE id = 1;

-- --------------------------------------------------------------------------------------
-- TEST OPERATIONS FOR TRIGGERS
-- --------------------------------------------------------------------------------------

-- Test 1: trg_calculates_final_grade
-- Already tested with initial data, but we can check with a new evaluation
INSERT INTO evaluations (camper_id, skill_id) VALUES (1, 8);
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) 
VALUES (LAST_INSERT_ID(), 'Teorico', 90.00, CURRENT_DATE);
-- Verify: SELECT * FROM evaluations WHERE camper_id = 1 AND skill_id = 8;

-- Test 2: trg_update_evaluation_status_log
-- Already triggered by the previous test
-- Verify: SELECT * FROM evaluations WHERE camper_id = 1 AND skill_id = 8;

-- Test 3: trg_set_camper_inscrito
-- Create a new camper and enroll them
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) 
VALUES ('Test', 'Camper', 'test.camper@example.com', '999999999', 2, 4);
INSERT INTO camper (person_id, guardian_id, branch_id, enrollment_date, status_camper, risk_level) 
VALUES (LAST_INSERT_ID(), 1, 1, CURRENT_DATE, 'En proceso de ingreso', 'Bajo');
INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status) 
VALUES (LAST_INSERT_ID(), 5, CURRENT_DATE, 'Active');
-- Verify: SELECT * FROM camper WHERE person_id = (SELECT id FROM person WHERE email = 'test.camper@example.com');

-- Test 4: trg_recalculate_evaluation_grade
-- Update an evaluation component
UPDATE evaluation_components SET note = 95.00 WHERE evaluation_id = 1 AND component_type = 'Teorico';
-- Verify: SELECT * FROM evaluations WHERE id = 1;

-- Test 5: trg_mark_camper_retirado
-- Delete a route enrollment
DELETE FROM camper_route_enrollments WHERE camper_id = 11 AND route_id = 5;
-- Verify: SELECT * FROM camper WHERE id = 11;
-- Verify: SELECT * FROM camper_state_history WHERE camper_id = 11;

-- Test 6: trg_register_module_sgdb
-- Insert a new module with SGBD
INSERT INTO modules (module_name, module_description, main_sgbd, alternative_sgbd, module_status) 
VALUES ('SQL Fundamentals', 'Learning SQL basics', 1, 3, 'Activo');
-- Verify: SELECT * FROM module_competencies WHERE module_id = LAST_INSERT_ID();
-- Verify: SELECT * FROM notifications WHERE message LIKE '%SQL Fundamentals%';

-- Test 7: trg_check_trainer_duplicates
-- Try to insert a duplicate trainer (will generate error)
-- INSERT INTO trainer (person_id, branch_id) VALUES (21, 1);
-- This line is commented out because it will cause an error

-- Test 8: trg_check_area_capacity
-- Try to assign too many campers (will generate error if uncommented)
-- INSERT INTO route_assignments (route_id, area_id, trainer_id, campers_group_id) VALUES (5, 6, 1, 1);
-- This is commented out as it would generate an error

-- Test 9: trg_update_camper_performance
-- Insert a low-score evaluation to test performance update
INSERT INTO evaluations (camper_id, skill_id) VALUES (2, 8);
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) 
VALUES (LAST_INSERT_ID(), 'Teorico', 55.00, CURRENT_DATE);
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) 
VALUES (LAST_INSERT_ID(), 'Practico', 45.00, CURRENT_DATE);
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) 
VALUES (LAST_INSERT_ID(), 'Quiz', 50.00, CURRENT_DATE);
-- Verify: SELECT * FROM camper WHERE id = 2;

-- Test 10: trg_move_to_alumni
-- Graduate another camper
UPDATE camper SET status_camper = 'Graduado' WHERE id = 2;
-- Verify: SELECT * FROM alumni WHERE camper_id = 2;

-- Test 11: trg_check_trainer_schedule_overlap
-- Try to create overlapping schedule (will generate error if uncommented)
-- INSERT INTO trainer_schedule (trainer_id, schedule_id, area_id, route_id, campers_group_id) VALUES (1, 1, 2, 5, 1);
-- This is commented out as it would generate an error

-- Test 12: trg_free_trainer_schedules
-- Delete a trainer and check if schedules are freed
-- First, let's make a copy of a trainer to delete
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) 
VALUES ('Temp', 'Trainer', 'temp.trainer@example.com', '888888888', 2, 5);
INSERT INTO trainer (person_id, branch_id) VALUES (LAST_INSERT_ID(), 1);
INSERT INTO trainer_schedule (trainer_id, schedule_id, area_id, route_id, campers_group_id) 
VALUES (LAST_INSERT_ID(), 11, 2, 5, 1);
-- Now delete the trainer
DELETE FROM trainer WHERE person_id = (SELECT id FROM person WHERE email = 'temp.trainer@example.com');
-- Verify: SELECT * FROM trainer_schedule WHERE trainer_id = (SELECT id FROM trainer WHERE person_id = (SELECT id FROM person WHERE email = 'temp.trainer@example.com'));

-- Test 13: trg_update_camper_modules
-- Update a camper's route
UPDATE camper_route_enrollments SET route_id = 1 WHERE camper_id = 3 AND route_id = 5;
-- Verify: SELECT * FROM notifications WHERE message LIKE '%camper ID: 3%';

-- Test 14: trg_check_camper_duplicate
-- Try to insert a duplicate camper (will generate error if uncommented)
-- INSERT INTO camper (person_id, guardian_id, branch_id, enrollment_date) VALUES (11, 1, 1, CURRENT_DATE);
-- This is commented out as it would generate an error

-- Test 15: trg_update_skill_state
-- Update an evaluation
UPDATE evaluations SET final_grade = 95 WHERE camper_id = 3 AND skill_id = 9;
-- Verify: SELECT * FROM skills WHERE id = 9;

-- Test 16: trg_check_trainer_knowledge
-- Try to assign a module to a trainer without required competencies (will generate error if uncommented)
-- INSERT INTO trainer_module_assignments (trainer_id, module_id) VALUES (6, 1);
-- This is commented out as it would generate an error

-- Test 17: trg_free_area_campers
-- Change an area to inactive
UPDATE training_areas SET training_areas_status = 'Inactivo' WHERE id = 1;
-- Verify: SELECT * FROM route_assignments WHERE area_id = 1;
-- Verify: SELECT * FROM trainer_schedule WHERE area_id = 1;

-- Test 18: trg_clone_route_template
-- Create a new route
INSERT INTO routes (route_name, main_sgbd, alternative_sgbd) 
VALUES ('New Test Route', 2, 4);
-- Verify: SELECT * FROM route_skills WHERE route_id = LAST_INSERT_ID();

-- Test 19: trg_verify_practical_note
-- Try to insert a practical note above 60 (will generate error if uncommented)
-- INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (1, 'Practico', 101.00, CURRENT_DATE);
-- This is commented out as it would generate an error

-- Test 20: trg_notify_route_changes
-- Update a route
-- Crear la ruta primero:
INSERT INTO routes (route_name, main_sgbd, alternative_sgbd) 
VALUES ('New Test Route', 2, 4);
-- Obtener el ID de la ruta recién creada
SELECT id FROM routes WHERE route_name = 'New Test Route';
-- Usar ese ID real en tu comando de asignación
INSERT INTO route_assignments (route_id, area_id, trainer_id, campers_group_id)
VALUES (6, 2, 1, 1);  -- Reemplaza 6 con el ID real obtenido
-- Ahora actualiza la ruta
UPDATE routes SET route_name = 'Updated Test Route' WHERE route_name = 'New Test Route';
-- Verifica las notificaciones: SELECT * FROM notifications WHERE message LIKE '%Updated Test Route%';

-- Cleanup test data if needed:
-- DELETE FROM person WHERE email = 'test.camper@example.com';
-- DELETE FROM person WHERE email = 'temp.trainer@example.com';


