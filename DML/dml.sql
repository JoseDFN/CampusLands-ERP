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

-- Additional inserts to ensure queries return multiple results

-- Additional countries
INSERT INTO countries (country_name, iso_code_country) VALUES ('México', 'MEX');
INSERT INTO countries (country_name, iso_code_country) VALUES ('Ecuador', 'ECU');
INSERT INTO countries (country_name, iso_code_country) VALUES ('Venezuela', 'VEN');
INSERT INTO countries (country_name, iso_code_country) VALUES ('Uruguay', 'URY');
INSERT INTO countries (country_name, iso_code_country) VALUES ('Paraguay', 'PRY');

-- Additional regions
INSERT INTO regions (region_name, country_id) VALUES ('Antioquia', 1);
INSERT INTO regions (region_name, country_id) VALUES ('Valle del Cauca', 1);
INSERT INTO regions (region_name, country_id) VALUES ('Buenos Aires', 2);
INSERT INTO regions (region_name, country_id) VALUES ('Córdoba', 2);
INSERT INTO regions (region_name, country_id) VALUES ('São Paulo', 3);

-- Additional cities
INSERT INTO cities (city_name, region_id) VALUES ('Medellín', 4);
INSERT INTO cities (city_name, region_id) VALUES ('Cali', 5);
INSERT INTO cities (city_name, region_id) VALUES ('La Plata', 6);
INSERT INTO cities (city_name, region_id) VALUES ('Córdoba', 7);
INSERT INTO cities (city_name, region_id) VALUES ('São Paulo', 8);

-- Additional addresses
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Carrera 45', '145', '050001', 11, 'Dirección en Medellín');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Calle 5', '55', '760001', 12, 'Dirección en Cali');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Avenida 7', '700', '1900', 13, 'Dirección en La Plata');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Calle 10', '100', '5000', 14, 'Dirección en Córdoba');
INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info) VALUES ('Av. Paulista', '1000', '01310', 15, 'Dirección en São Paulo');

-- Additional companies
INSERT INTO companies (register_number, legal_name, comercial_name, country_id, foundation_date, juridical_form) VALUES ('REG002', 'Tech Solutions', 'TechSol', 2, '2005-05-15', 'SA');
INSERT INTO companies (register_number, legal_name, comercial_name, country_id, foundation_date, juridical_form) VALUES ('REG003', 'Global Learning', 'GLearn', 3, '2010-07-20', 'LLC');

-- Additional branches
INSERT INTO branches (branch_name, address_id, company_id) VALUES ('Campus Medellín', 30, 1);
INSERT INTO branches (branch_name, address_id, company_id) VALUES ('Sucursal Buenos Aires', 32, 2);
INSERT INTO branches (branch_name, address_id, company_id) VALUES ('Sede São Paulo', 34, 3);

-- Additional phone numbers
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000017', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000018', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000019', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('3001000020', '057', 1);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('6012000014', '057', 2);
INSERT INTO phone_numbers (phone_number, extension, phone_type_id) VALUES ('6012000015', '057', 2);

-- Additional persons
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Carlos', 'Gómez Torres', 'carlos.gomez@example.com', '200000031', 2, 30);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Laura', 'Jiménez Vargas', 'laura.jimenez@example.com', '200000032', 2, 31);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Alejandro', 'Pérez López', 'alejandro.perez@example.com', '200000033', 2, 32);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('María', 'González Soto', 'maria.gonzalez@example.com', '200000034', 2, 33);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Juan', 'Ramírez Ortega', 'juan.ramirez@campuslands.com', '100000007', 2, 34);
INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id) VALUES ('Ana', 'Fernández Ruiz', 'ana.fernandez@campuslands.com', '100000008', 2, 29);

-- Link persons with phones
INSERT INTO person_phones (person_id, phone_id) VALUES (27, 30);
INSERT INTO person_phones (person_id, phone_id) VALUES (28, 31);
INSERT INTO person_phones (person_id, phone_id) VALUES (29, 32);
INSERT INTO person_phones (person_id, phone_id) VALUES (30, 33);
INSERT INTO person_phones (person_id, phone_id) VALUES (31, 34);
INSERT INTO person_phones (person_id, phone_id) VALUES (32, 35);

-- Additional guardians
INSERT INTO guardian (person_id) VALUES (27);
INSERT INTO guardian (person_id) VALUES (28);
INSERT INTO guardian (person_id) VALUES (29);
INSERT INTO guardian (person_id) VALUES (30);

-- Additional campers
INSERT INTO camper (person_id, guardian_id, branch_id, enrollment_date, status_camper, risk_level) VALUES (28, 11, 1, '2023-10-01', 'En proceso de ingreso', 'Bajo');
INSERT INTO camper (person_id, guardian_id, branch_id, enrollment_date, status_camper, risk_level) VALUES (29, 12, 2, '2023-10-02', 'En proceso de ingreso', 'Medio');
INSERT INTO camper (person_id, guardian_id, branch_id, enrollment_date, status_camper, risk_level) VALUES (30, 13, 3, '2023-10-03', 'En proceso de ingreso', 'Alto');

-- Additional camper state history
INSERT INTO camper_state_history (camper_id, old_state, new_state, reason) VALUES (11, 'En proceso de ingreso', 'Inscrito', 'Completó documentación');
INSERT INTO camper_state_history (camper_id, old_state, new_state, reason) VALUES (12, 'En proceso de ingreso', 'Inscrito', 'Completó pago inicial');
INSERT INTO camper_state_history (camper_id, old_state, new_state, reason) VALUES (13, 'En proceso de ingreso', 'Inscrito', 'Completó entrevista');
INSERT INTO camper_state_history (camper_id, old_state, new_state, reason) VALUES (11, 'Inscrito', 'Aprobado', 'Pasó evaluación inicial');
INSERT INTO camper_state_history (camper_id, old_state, new_state, reason) VALUES (12, 'Inscrito', 'Aprobado', 'Pasó evaluación inicial');

-- Additional trainers
INSERT INTO trainer (person_id, branch_id) VALUES (31, 2);
INSERT INTO trainer (person_id, branch_id) VALUES (32, 3);

-- Additional competencies
INSERT INTO competencies (competency_name) VALUES ('React');
INSERT INTO competencies (competency_name) VALUES ('Node.js');
INSERT INTO competencies (competency_name) VALUES ('Ruby');
INSERT INTO competencies (competency_name) VALUES ('Docker');
INSERT INTO competencies (competency_name) VALUES ('AWS');

-- Additional trainer competencies
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (7, 11);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (7, 12);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (8, 13);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (8, 14);
INSERT INTO trainer_competencies (trainer_id, competency_id) VALUES (8, 15);

-- Additional notifications
INSERT INTO notifications (trainer_id, message, created_at) VALUES (7, 'Notification for new trainer', '2023-10-20 10:00:00');
INSERT INTO notifications (trainer_id, message, created_at) VALUES (8, 'Notification for new trainer', '2023-10-20 10:30:00');
INSERT INTO notifications (trainer_id, message, created_at) VALUES (1, 'Class canceled tomorrow', '2023-10-21 09:00:00');
INSERT INTO notifications (trainer_id, message, created_at) VALUES (2, 'Meeting scheduled for next week', '2023-10-21 11:00:00');

-- Additional routes
INSERT INTO routes (route_name, main_sgbd, alternative_sgbd) VALUES ('DevOps', 9, 10);
INSERT INTO routes (route_name, main_sgbd, alternative_sgbd) VALUES ('Mobile Development', 2, 6);
INSERT INTO routes (route_name, main_sgbd, alternative_sgbd) VALUES ('Data Science', 1, 3);

-- Additional skills
INSERT INTO skills (skill_name, skill_description, theoretical_weight, practical_weight, quizzes_weight) VALUES ('Docker & Kubernetes', 'Containers and orchestration', 30, 60, 10);
INSERT INTO skills (skill_name, skill_description, theoretical_weight, practical_weight, quizzes_weight) VALUES ('React Native', 'Mobile app development', 30, 60, 10);
INSERT INTO skills (skill_name, skill_description, theoretical_weight, practical_weight, quizzes_weight) VALUES ('Data Analysis', 'Statistics and visualization', 30, 60, 10);
INSERT INTO skills (skill_name, skill_description, theoretical_weight, practical_weight, quizzes_weight) VALUES ('Cloud Computing', 'AWS, Azure, GCP basics', 30, 60, 10);
INSERT INTO skills (skill_name, skill_description, theoretical_weight, practical_weight, quizzes_weight) VALUES ('Machine Learning', 'ML fundamentals', 30, 60, 10);

-- Additional base route skills
INSERT INTO base_route_skills (skill_id, base_route_description) VALUES (11, 'Base description for DevOps module');
INSERT INTO base_route_skills (skill_id, base_route_description) VALUES (12, 'Base description for Mobile Development module');
INSERT INTO base_route_skills (skill_id, base_route_description) VALUES (13, 'Base description for Data Analysis module');
INSERT INTO base_route_skills (skill_id, base_route_description) VALUES (14, 'Base description for Cloud Computing module');
INSERT INTO base_route_skills (skill_id, base_route_description) VALUES (15, 'Base description for Machine Learning module');

-- Additional route skills
INSERT INTO route_skills (route_id, skill_id, main_sgbd, alternative_sgbd) VALUES (6, 11, 9, 10);
INSERT INTO route_skills (route_id, skill_id, main_sgbd, alternative_sgbd) VALUES (7, 12, 2, 6);
INSERT INTO route_skills (route_id, skill_id, main_sgbd, alternative_sgbd) VALUES (8, 13, 1, 3);
INSERT INTO route_skills (route_id, skill_id, main_sgbd, alternative_sgbd) VALUES (8, 14, 1, 3);
INSERT INTO route_skills (route_id, skill_id, main_sgbd, alternative_sgbd) VALUES (8, 15, 1, 3);

-- Additional modules
INSERT INTO modules (module_name, module_description, module_status) VALUES 
  ('DevOps Essentials', 'Introduction to DevOps practices and tools', 'Activo'),
  ('Mobile Development', 'Creating applications for iOS and Android', 'Activo'),
  ('Data Science Fundamentals', 'Introduction to data analysis and visualization', 'Activo');

-- Additional module skills
INSERT INTO module_skills (module_id, skill_id) VALUES 
  (4, 11), 
  (5, 12), 
  (6, 13),
  (6, 14),
  (6, 15);

-- Additional module competencies
INSERT INTO module_competencies (module_id, competency_id) VALUES
  (4, 14), -- DevOps Essentials - Docker
  (4, 15), -- DevOps Essentials - AWS
  (5, 11), -- Mobile Development - React
  (5, 12), -- Mobile Development - Node.js
  (6, 3);  -- Data Science Fundamentals - Python

-- Additional sessions
INSERT INTO sessions_class (session_name, session_description, session_date) VALUES 
  ('DevOps Workshop', 'Hands-on workshop on containerization', '2023-11-10'),
  ('Mobile App Development', 'Creating your first mobile app', '2023-11-15'),
  ('Data Science Introduction', 'Basic concepts of data analysis', '2023-11-20');

-- Additional session modules
INSERT INTO session_modules (session_id, module_id) VALUES 
  (3, 4), 
  (4, 5), 
  (5, 6);

-- Additional trainer module assignments
INSERT INTO trainer_module_assignments (trainer_id, module_id) VALUES 
  (7, 4), -- New trainer assigned to DevOps
  (8, 5), -- New trainer assigned to Mobile Development
  (8, 6); -- New trainer also assigned to Data Science

-- Additional campers groups
INSERT INTO campers_group (group_name, route_id, creation_date) VALUES ('DevOps Group', 6, CURRENT_DATE);
INSERT INTO campers_group (group_name, route_id, creation_date) VALUES ('Mobile Dev Group', 7, CURRENT_DATE);
INSERT INTO campers_group (group_name, route_id, creation_date) VALUES ('Data Science Group', 8, CURRENT_DATE);

-- Additional campers group members
INSERT INTO campers_group_members (group_id, camper_id) VALUES (2, 11);
INSERT INTO campers_group_members (group_id, camper_id) VALUES (2, 12);
INSERT INTO campers_group_members (group_id, camper_id) VALUES (3, 13);
INSERT INTO campers_group_members (group_id, camper_id) VALUES (3, 1);
INSERT INTO campers_group_members (group_id, camper_id) VALUES (4, 2);
INSERT INTO campers_group_members (group_id, camper_id) VALUES (4, 3);

-- Additional route assignments
INSERT INTO route_assignments (route_id, area_id, trainer_id, campers_group_id) VALUES (6, 2, 7, 2);
INSERT INTO route_assignments (route_id, area_id, trainer_id, campers_group_id) VALUES (7, 3, 8, 3);
INSERT INTO route_assignments (route_id, area_id, trainer_id, campers_group_id) VALUES (8, 4, 1, 4);

-- Additional camper route enrollments
INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status) VALUES (11, 6, '2023-10-05', 'Active');
INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status) VALUES (12, 6, '2023-10-06', 'Active');
INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status) VALUES (13, 7, '2023-10-07', 'Active');
INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status) VALUES (1, 7, '2023-10-08', 'Active');
INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status) VALUES (2, 8, '2023-10-09', 'Active');
INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status) VALUES (3, 8, '2023-10-10', 'Active');

-- Additional trainer schedules
INSERT INTO trainer_schedule (trainer_id, schedule_id, area_id, route_id, campers_group_id) VALUES (7, 11, 2, 6, 2);
INSERT INTO trainer_schedule (trainer_id, schedule_id, area_id, route_id, campers_group_id) VALUES (8, 12, 3, 7, 3);
INSERT INTO trainer_schedule (trainer_id, schedule_id, area_id, route_id, campers_group_id) VALUES (1, 13, 4, 8, 4);

-- Additional general schedules
INSERT INTO general_schedule (route_id, skill_id, schedule_id) VALUES (6, 11, 11);
INSERT INTO general_schedule (route_id, skill_id, schedule_id) VALUES (7, 12, 12);
INSERT INTO general_schedule (route_id, skill_id, schedule_id) VALUES (8, 13, 13);
INSERT INTO general_schedule (route_id, skill_id, schedule_id) VALUES (8, 14, 14);
INSERT INTO general_schedule (route_id, skill_id, schedule_id) VALUES (8, 15, 15);

-- Additional evaluations
INSERT INTO evaluations (camper_id, skill_id) VALUES (11, 11);
INSERT INTO evaluations (camper_id, skill_id) VALUES (12, 11);
INSERT INTO evaluations (camper_id, skill_id) VALUES (13, 12);
INSERT INTO evaluations (camper_id, skill_id) VALUES (1, 12);
INSERT INTO evaluations (camper_id, skill_id) VALUES (2, 13);
INSERT INTO evaluations (camper_id, skill_id) VALUES (3, 13);

-- Additional evaluation components
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (11, 'Teorico', 90.00, '2023-10-20');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (11, 'Practico', 85.00, '2023-10-21');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (11, 'Quiz', 88.00, '2023-10-22');

INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (12, 'Teorico', 75.00, '2023-10-23');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (12, 'Practico', 65.00, '2023-10-24');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (12, 'Quiz', 70.00, '2023-10-25');

INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (13, 'Teorico', 95.00, '2023-10-26');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (13, 'Practico', 92.00, '2023-10-27');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (13, 'Quiz', 90.00, '2023-10-28');

INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (14, 'Teorico', 80.00, '2023-10-29');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (14, 'Practico', 82.00, '2023-10-30');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (14, 'Quiz', 78.00, '2023-10-31');

INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (15, 'Teorico', 85.00, '2023-11-01');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (15, 'Practico', 87.00, '2023-11-02');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (15, 'Quiz', 83.00, '2023-11-03');

INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (16, 'Teorico', 70.00, '2023-11-04');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (16, 'Practico', 75.00, '2023-11-05');
INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date) VALUES (16, 'Quiz', 72.00, '2023-11-06');

-- Additional attendance records
INSERT INTO attendance (camper_id, route_id, skill_id, schedule_id, attendance_date, attendance_status, arrival_time, justification) 
VALUES (11, 6, 11, 11, '2023-10-20', 'Present', '14:00:00', 'On time');
INSERT INTO attendance (camper_id, route_id, skill_id, schedule_id, attendance_date, attendance_status, arrival_time, justification) 
VALUES (12, 6, 11, 11, '2023-10-20', 'Present', '14:05:00', 'On time');
INSERT INTO attendance (camper_id, route_id, skill_id, schedule_id, attendance_date, attendance_status, arrival_time, justification) 
VALUES (13, 7, 12, 12, '2023-10-21', 'Present', '14:00:00', 'On time');
INSERT INTO attendance (camper_id, route_id, skill_id, schedule_id, attendance_date, attendance_status, arrival_time, justification) 
VALUES (1, 7, 12, 12, '2023-10-21', 'Present', '14:02:00', 'On time');
INSERT INTO attendance (camper_id, route_id, skill_id, schedule_id, attendance_date, attendance_status, arrival_time, justification) 
VALUES (2, 8, 13, 13, '2023-10-22', 'Present', '14:00:00', 'On time');
INSERT INTO attendance (camper_id, route_id, skill_id, schedule_id, attendance_date, attendance_status, arrival_time, justification) 
VALUES (3, 8, 13, 13, '2023-10-22', 'Present', '14:00:00', 'On time');

-- Graduate a second camper
UPDATE camper SET status_camper = 'Graduado' WHERE id = 2;

-- Insert into alumni for the second graduate
INSERT INTO alumni (camper_id, graduation_date, route_id, additional_info) 
VALUES (2, '2023-11-30', 5, 'Completed with distinction');

-- Add a second alumni record for first camper with another route
INSERT INTO alumni (camper_id, graduation_date, route_id, additional_info) 
VALUES (1, '2023-12-15', 6, 'Completed additional certification');
