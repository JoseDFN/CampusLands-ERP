USE campuslands;

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