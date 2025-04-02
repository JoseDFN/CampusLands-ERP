USE campuslands;

-- PROCEDIMIENTOS ALMACENADOS

-- 1. Registrar un nuevo camper con toda su información personal y estado inicial.
DELIMITER //
CREATE PROCEDURE sp_register_new_camper(
    IN p_first_name VARCHAR(50),
    IN p_last_names VARCHAR(50),
    IN p_email VARCHAR(255),
    IN p_document_number VARCHAR(20),
    IN p_document_type_id INT,
    IN p_street VARCHAR(255),
    IN p_building_number VARCHAR(20),
    IN p_postal_code VARCHAR(20),
    IN p_city_id INT,
    IN p_additional_info TEXT,
    IN p_guardian_id INT,
    IN p_branch_id INT
)
BEGIN
    DECLARE v_address_id INT;
    DECLARE v_person_id INT;
    DECLARE v_camper_id INT;
    
    -- Insert address
    INSERT INTO addresses (street, building_number, postal_code, city_id, additional_info)
    VALUES (p_street, p_building_number, p_postal_code, p_city_id, p_additional_info);
    SET v_address_id = LAST_INSERT_ID();
    
    -- Insert person
    INSERT INTO person (first_name, last_names, email, document_number, document_type_id, address_id)
    VALUES (p_first_name, p_last_names, p_email, p_document_number, p_document_type_id, v_address_id);
    SET v_person_id = LAST_INSERT_ID();
    
    -- Insert camper with initial state
    INSERT INTO camper (person_id, guardian_id, branch_id, enrollment_date, status_camper, risk_level, camper_performance)
    VALUES (v_person_id, p_guardian_id, p_branch_id, CURRENT_DATE, 'En proceso de ingreso', 'Bajo', 'Medio');
    SET v_camper_id = LAST_INSERT_ID();
    
    -- Record initial state in history
    INSERT INTO camper_state_history (camper_id, old_state, new_state, change_date, reason)
    VALUES (v_camper_id, 'En proceso de ingreso', 'En proceso de ingreso', NOW(), 'Registro inicial');
    
    SELECT v_camper_id AS camper_id, 'Camper registrado exitosamente' AS message;
END //
DELIMITER ;

-- 2. Actualizar el estado de un camper luego de completar el proceso de ingreso.
DELIMITER //
CREATE PROCEDURE sp_update_camper_status(
    IN p_camper_id INT,
    IN p_new_status ENUM('En proceso de ingreso', 'Inscrito', 'Aprobado', 'Cursando', 'Graduado', 'Expulsado', 'Retirado'),
    IN p_reason TEXT
)
BEGIN
    DECLARE v_old_status ENUM('En proceso de ingreso', 'Inscrito', 'Aprobado', 'Cursando', 'Graduado', 'Expulsado', 'Retirado');
    
    -- Get current status
    SELECT status_camper INTO v_old_status FROM camper WHERE id = p_camper_id;
    
    -- Update camper status
    UPDATE camper SET status_camper = p_new_status WHERE id = p_camper_id;
    
    -- Record state change in history
    INSERT INTO camper_state_history (camper_id, old_state, new_state, change_date, reason)
    VALUES (p_camper_id, v_old_status, p_new_status, NOW(), p_reason);
    
    SELECT 'Estado del camper actualizado exitosamente' AS message;
END //
DELIMITER ;

-- 3. Procesar la inscripción de un camper a una ruta específica.
DELIMITER //
CREATE PROCEDURE sp_enroll_camper_to_route(
    IN p_camper_id INT,
    IN p_route_id INT
)
BEGIN
    DECLARE v_count INT;
    
    -- Check if camper exists
    SELECT COUNT(*) INTO v_count FROM camper WHERE id = p_camper_id;
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El camper no existe';
    END IF;
    
    -- Check if route exists
    SELECT COUNT(*) INTO v_count FROM routes WHERE id = p_route_id;
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La ruta no existe';
    END IF;
    
    -- Check if enrollment already exists
    SELECT COUNT(*) INTO v_count FROM camper_route_enrollments 
    WHERE camper_id = p_camper_id AND route_id = p_route_id;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El camper ya está inscrito en esta ruta';
    ELSE
        -- Create enrollment
        INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status)
        VALUES (p_camper_id, p_route_id, CURRENT_DATE, 'Active');
        
        -- This should trigger the existing trg_set_camper_inscrito trigger to update the camper status
        
        SELECT 'Inscripción exitosa' AS message;
    END IF;
END //
DELIMITER ;

-- 4. Registrar una evaluación completa (teórica, práctica y quizzes) para un camper.
DELIMITER //
CREATE PROCEDURE sp_register_complete_evaluation(
    IN p_camper_id INT,
    IN p_skill_id INT,
    IN p_theoretical_note DECIMAL(3,0),
    IN p_practical_note DECIMAL(3,0),
    IN p_quiz_note DECIMAL(3,0)
)
BEGIN
    DECLARE v_evaluation_id INT;
    DECLARE v_count INT;
    
    -- Check if evaluation already exists
    SELECT COUNT(*) INTO v_count FROM evaluations WHERE camper_id = p_camper_id AND skill_id = p_skill_id;
    
    IF v_count = 0 THEN
        -- Create new evaluation
        INSERT INTO evaluations (camper_id, skill_id) 
        VALUES (p_camper_id, p_skill_id);
        SET v_evaluation_id = LAST_INSERT_ID();
    ELSE
        -- Get existing evaluation id
        SELECT id INTO v_evaluation_id FROM evaluations 
        WHERE camper_id = p_camper_id AND skill_id = p_skill_id;
        
        -- Delete existing components if any
        DELETE FROM evaluation_components WHERE evaluation_id = v_evaluation_id;
    END IF;
    
    -- Insert evaluation components
    INSERT INTO evaluation_components (evaluation_id, component_type, note, evaluation_date)
    VALUES 
        (v_evaluation_id, 'Teorico', p_theoretical_note, CURRENT_DATE),
        (v_evaluation_id, 'Practico', p_practical_note, CURRENT_DATE),
        (v_evaluation_id, 'Quiz', p_quiz_note, CURRENT_DATE);
    
    -- The final grade should be calculated automatically by existing triggers
    
    SELECT 'Evaluación registrada exitosamente' AS message;
END //
DELIMITER ;

-- 5. Calcular y registrar automáticamente la nota final de un módulo.
DELIMITER //
CREATE PROCEDURE sp_calculate_final_grade(
    IN p_evaluation_id INT
)
BEGIN
    DECLARE v_theoretical_note DECIMAL(3,0) DEFAULT 0;
    DECLARE v_practical_note DECIMAL(3,0) DEFAULT 0;
    DECLARE v_quiz_note DECIMAL(3,0) DEFAULT 0;
    DECLARE v_final_grade DECIMAL(3,0);
    DECLARE v_theoretical_weight DECIMAL(2,0);
    DECLARE v_practical_weight DECIMAL(2,0);
    DECLARE v_quizzes_weight DECIMAL(2,0);
    DECLARE v_skill_id INT;
    
    -- Get the skill id for this evaluation
    SELECT skill_id INTO v_skill_id FROM evaluations WHERE id = p_evaluation_id;
    
    -- Get weights
    SELECT theoretical_weight, practical_weight, quizzes_weight 
    INTO v_theoretical_weight, v_practical_weight, v_quizzes_weight
    FROM skills WHERE id = v_skill_id;
    
    -- Get component notes
    SELECT note INTO v_theoretical_note FROM evaluation_components 
    WHERE evaluation_id = p_evaluation_id AND component_type = 'Teorico'
    LIMIT 1;
    
    SELECT note INTO v_practical_note FROM evaluation_components 
    WHERE evaluation_id = p_evaluation_id AND component_type = 'Practico'
    LIMIT 1;
    
    SELECT note INTO v_quiz_note FROM evaluation_components 
    WHERE evaluation_id = p_evaluation_id AND component_type = 'Quiz'
    LIMIT 1;
    
    -- Calculate final grade
    SET v_final_grade = (v_theoretical_note * (v_theoretical_weight/100)) + 
                        (v_practical_note * (v_practical_weight/100)) + 
                        (v_quiz_note * (v_quizzes_weight/100));
    
    -- Update evaluation with final grade
    UPDATE evaluations SET final_grade = v_final_grade WHERE id = p_evaluation_id;
    
    -- Set state based on final grade
    IF v_final_grade >= 60 THEN
        UPDATE evaluations SET camper_state = 'Aprobado' WHERE id = p_evaluation_id;
    ELSE
        UPDATE evaluations SET camper_state = 'Reprobado' WHERE id = p_evaluation_id;
    END IF;
    
    SELECT 'Nota final calculada exitosamente' AS message, v_final_grade AS final_grade;
END //
DELIMITER ;

-- 6. Asignar campers aprobados a una ruta de acuerdo con la disponibilidad del área.
DELIMITER //
CREATE PROCEDURE sp_assign_approved_campers_to_route(
    IN p_route_id INT,
    IN p_area_id INT,
    IN p_trainer_id INT,
    IN p_group_name VARCHAR(50)
)
BEGIN
    DECLARE v_area_capacity INT;
    DECLARE v_campers_count INT;
    DECLARE v_group_id INT;
    DECLARE v_trainer_competent BOOLEAN DEFAULT FALSE;
    DECLARE v_camper_id INT;
    DECLARE v_done BOOLEAN DEFAULT FALSE;
    
    -- Cursor to fetch approved campers not yet assigned to this route
    DECLARE approved_campers CURSOR FOR
        SELECT DISTINCT c.id
        FROM camper c
        JOIN evaluations e ON c.id = e.camper_id
        WHERE c.status_camper = 'Aprobado'
        AND NOT EXISTS (
            SELECT 1 FROM camper_route_enrollments cre
            WHERE cre.camper_id = c.id AND cre.route_id = p_route_id
        )
        GROUP BY c.id
        HAVING MIN(CASE WHEN e.camper_state = 'Reprobado' THEN 0 ELSE 1 END) = 1;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    
    -- Check area capacity
    SELECT capacity INTO v_area_capacity FROM training_areas WHERE id = p_area_id;
    
    -- Check if trainer has competencies for this route
    SELECT EXISTS (
        SELECT 1 FROM trainer_competencies tc
        JOIN module_competencies mc ON tc.competency_id = mc.competency_id
        JOIN module_skills ms ON mc.module_id = ms.module_id
        JOIN route_skills rs ON ms.skill_id = rs.skill_id
        WHERE tc.trainer_id = p_trainer_id AND rs.route_id = p_route_id
    ) INTO v_trainer_competent;
    
    IF NOT v_trainer_competent THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El trainer no tiene las competencias necesarias para esta ruta';
    END IF;
    
    -- Create group
    INSERT INTO campers_group (group_name, route_id, creation_date)
    VALUES (p_group_name, p_route_id, CURRENT_DATE);
    SET v_group_id = LAST_INSERT_ID();
    
    -- Assign route, area, trainer, and group
    INSERT INTO route_assignments (route_id, area_id, trainer_id, campers_group_id)
    VALUES (p_route_id, p_area_id, p_trainer_id, v_group_id);
    
    -- Initialize counter
    SET v_campers_count = 0;
    
    -- Open cursor
    OPEN approved_campers;
    
    -- Loop through approved campers
    camper_loop: LOOP
        FETCH approved_campers INTO v_camper_id;
        
        IF v_done OR v_campers_count >= v_area_capacity THEN
            LEAVE camper_loop;
        END IF;
        
        -- Add camper to group
        INSERT INTO campers_group_members (group_id, camper_id)
        VALUES (v_group_id, v_camper_id);
        
        -- Enroll camper in route
        INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status)
        VALUES (v_camper_id, p_route_id, CURRENT_DATE, 'Active');
        
        -- Update camper status to 'Cursando'
        CALL sp_update_camper_status(v_camper_id, 'Cursando', 'Asignado a ruta automáticamente');
        
        SET v_campers_count = v_campers_count + 1;
    END LOOP;
    
    -- Close cursor
    CLOSE approved_campers;
    
    SELECT 'Asignación de campers completada' AS message, v_campers_count AS campers_assigned;
END //
DELIMITER ;

-- 7. Asignar un trainer a una ruta y área específica, validando el horario.
DELIMITER //
CREATE PROCEDURE sp_assign_trainer_to_route_area(
    IN p_trainer_id INT,
    IN p_route_id INT,
    IN p_area_id INT,
    IN p_group_id INT,
    IN p_schedule_id INT
)
BEGIN
    DECLARE v_count INT;
    DECLARE v_trainer_competent BOOLEAN DEFAULT FALSE;
    
    -- Check if trainer exists
    SELECT COUNT(*) INTO v_count FROM trainer WHERE id = p_trainer_id;
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El trainer no existe';
    END IF;
    
    -- Check if schedule exists
    SELECT COUNT(*) INTO v_count FROM schedules WHERE id = p_schedule_id;
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El horario no existe';
    END IF;
    
    -- Check if trainer has competencies for this route
    SELECT EXISTS (
        SELECT 1 FROM trainer_competencies tc
        JOIN module_competencies mc ON tc.competency_id = mc.competency_id
        JOIN module_skills ms ON mc.module_id = ms.module_id
        JOIN route_skills rs ON ms.skill_id = rs.skill_id
        WHERE tc.trainer_id = p_trainer_id AND rs.route_id = p_route_id
    ) INTO v_trainer_competent;
    
    IF NOT v_trainer_competent THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El trainer no tiene las competencias necesarias para esta ruta';
    END IF;
    
    -- Check if trainer has schedule conflict
    SELECT COUNT(*) INTO v_count FROM trainer_schedule ts
    JOIN schedules s1 ON ts.schedule_id = s1.id
    JOIN schedules s2 ON p_schedule_id = s2.id
    WHERE ts.trainer_id = p_trainer_id
    AND s1.day_of_week = s2.day_of_week
    AND (
        (s1.start_time <= s2.start_time AND s1.end_time > s2.start_time) OR
        (s1.start_time < s2.end_time AND s1.end_time >= s2.end_time) OR
        (s1.start_time >= s2.start_time AND s1.end_time <= s2.end_time)
    );
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El trainer tiene un conflicto de horario';
    END IF;
    
    -- Assign trainer to route and area with the given schedule
    INSERT INTO trainer_schedule (trainer_id, schedule_id, area_id, route_id, campers_group_id)
    VALUES (p_trainer_id, p_schedule_id, p_area_id, p_route_id, p_group_id);
    
    -- Update or create route assignment if needed
    SELECT COUNT(*) INTO v_count FROM route_assignments 
    WHERE route_id = p_route_id AND area_id = p_area_id AND trainer_id = p_trainer_id AND campers_group_id = p_group_id;
    
    IF v_count = 0 THEN
        INSERT INTO route_assignments (route_id, area_id, trainer_id, campers_group_id)
        VALUES (p_route_id, p_area_id, p_trainer_id, p_group_id);
    END IF;
    
    SELECT 'Trainer asignado exitosamente' AS message;
END //
DELIMITER ;

-- 8. Registrar una nueva ruta con sus módulos y SGDB asociados.
DELIMITER //
CREATE PROCEDURE sp_register_new_route(
    IN p_route_name VARCHAR(30),
    IN p_main_sgbd_id INT,
    IN p_alternative_sgbd_id INT,
    IN p_skills_ids TEXT -- Comma-separated skill IDs
)
BEGIN
    DECLARE v_route_id INT;
    DECLARE v_skill_id INT;
    DECLARE v_pos INT DEFAULT 1;
    DECLARE v_next_pos INT;
    DECLARE v_skills_list TEXT;
    
    -- Create new route
    INSERT INTO routes (route_name, main_sgbd, alternative_sgbd)
    VALUES (p_route_name, p_main_sgbd_id, p_alternative_sgbd_id);
    SET v_route_id = LAST_INSERT_ID();
    
    -- Process skills list
    SET v_skills_list = p_skills_ids;
    
    WHILE v_skills_list IS NOT NULL AND LENGTH(v_skills_list) > 0 DO
        -- Find next comma position
        SET v_next_pos = INSTR(v_skills_list, ',');
        
        IF v_next_pos > 0 THEN
            SET v_skill_id = CAST(SUBSTRING(v_skills_list, 1, v_next_pos - 1) AS UNSIGNED);
            SET v_skills_list = SUBSTRING(v_skills_list, v_next_pos + 1);
        ELSE
            SET v_skill_id = CAST(v_skills_list AS UNSIGNED);
            SET v_skills_list = NULL;
        END IF;
        
        -- Add skill to route
        INSERT INTO route_skills (route_id, skill_id, main_sgbd, alternative_sgbd)
        VALUES (v_route_id, v_skill_id, p_main_sgbd_id, p_alternative_sgbd_id);
    END WHILE;
    
    SELECT 'Ruta registrada exitosamente' AS message, v_route_id AS route_id;
END //
DELIMITER ;

-- 9. Registrar una nueva área de entrenamiento con su capacidad y horarios.
DELIMITER //
CREATE PROCEDURE sp_register_new_training_area(
    IN p_area_name VARCHAR(50),
    IN p_capacity INT,
    IN p_schedules_json JSON -- JSON array with schedules {day_of_week, start_time, end_time}
)
BEGIN
    DECLARE v_area_id INT;
    DECLARE v_counter INT DEFAULT 0;
    DECLARE v_total INT;
    DECLARE v_day VARCHAR(20);
    DECLARE v_start TIME;
    DECLARE v_end TIME;
    
    -- Create new training area
    INSERT INTO training_areas (area_name, capacity, training_areas_status)
    VALUES (p_area_name, p_capacity, 'Activo');
    SET v_area_id = LAST_INSERT_ID();
    
    -- Count elements in JSON array
    SET v_total = JSON_LENGTH(p_schedules_json);
    
    -- Process schedules
    WHILE v_counter < v_total DO
        -- Extract schedule data
        SET v_day = JSON_UNQUOTE(JSON_EXTRACT(p_schedules_json, CONCAT('$[', v_counter, '].day_of_week')));
        SET v_start = JSON_UNQUOTE(JSON_EXTRACT(p_schedules_json, CONCAT('$[', v_counter, '].start_time')));
        SET v_end = JSON_UNQUOTE(JSON_EXTRACT(p_schedules_json, CONCAT('$[', v_counter, '].end_time')));
        
        -- Create schedule
        INSERT INTO schedules (day_of_week, start_time, end_time)
        VALUES (v_day, v_start, v_end);
        
        SET v_counter = v_counter + 1;
    END WHILE;
    
    SELECT 'Área de entrenamiento registrada exitosamente' AS message, v_area_id AS area_id;
END //
DELIMITER ;

-- 10. Consultar disponibilidad de horario en un área determinada.
DELIMITER //
CREATE PROCEDURE sp_check_area_schedule_availability(
    IN p_area_id INT,
    IN p_date DATE
)
BEGIN
    DECLARE v_day VARCHAR(20);
    
    -- Get day of week from date
    SET v_day = DAYNAME(p_date);
    
    -- Query available schedules
    SELECT 
        s.id AS schedule_id,
        s.day_of_week,
        s.start_time,
        s.end_time,
        CASE 
            WHEN ts.id IS NULL THEN 'Disponible'
            ELSE 'Ocupado'
        END AS status,
        IFNULL(t.id, 'N/A') AS trainer_id,
        IFNULL(CONCAT(p.first_name, ' ', p.last_names), 'N/A') AS trainer_name,
        IFNULL(r.route_name, 'N/A') AS route_name,
        IFNULL(cg.group_name, 'N/A') AS group_name
    FROM 
        schedules s
    LEFT JOIN 
        trainer_schedule ts ON s.id = ts.schedule_id AND ts.area_id = p_area_id
    LEFT JOIN 
        trainer t ON ts.trainer_id = t.id
    LEFT JOIN 
        person p ON t.person_id = p.id
    LEFT JOIN 
        routes r ON ts.route_id = r.id
    LEFT JOIN 
        campers_group cg ON ts.campers_group_id = cg.id
    WHERE 
        s.day_of_week = v_day
    ORDER BY 
        s.start_time;
END //
DELIMITER ;

-- 11. Reasignar a un camper a otra ruta en caso de bajo rendimiento.
DELIMITER //
CREATE PROCEDURE sp_reassign_camper_to_route(
    IN p_camper_id INT,
    IN p_old_route_id INT,
    IN p_new_route_id INT,
    IN p_reason TEXT
)
BEGIN
    DECLARE v_count INT;
    DECLARE v_old_group_id INT;
    DECLARE v_new_group_id INT;
    
    -- Check if camper is enrolled in the old route
    SELECT COUNT(*) INTO v_count FROM camper_route_enrollments 
    WHERE camper_id = p_camper_id AND route_id = p_old_route_id AND camper_route_enrollment_status = 'Active';
    
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El camper no está inscrito en la ruta especificada';
    END IF;
    
    -- Get current group ID
    SELECT cg.id INTO v_old_group_id
    FROM campers_group_members cgm
    JOIN campers_group cg ON cgm.group_id = cg.id
    WHERE cgm.camper_id = p_camper_id AND cg.route_id = p_old_route_id
    LIMIT 1;
    
    -- Get available group for new route
    SELECT cg.id INTO v_new_group_id
    FROM campers_group cg
    WHERE cg.route_id = p_new_route_id
    LIMIT 1;
    
    -- If no group exists, create one
    IF v_new_group_id IS NULL THEN
        INSERT INTO campers_group (group_name, route_id, creation_date)
        VALUES (CONCAT('Grupo reasignación ', p_new_route_id), p_new_route_id, CURRENT_DATE);
        SET v_new_group_id = LAST_INSERT_ID();
    END IF;
    
    -- Update enrollment status
    UPDATE camper_route_enrollments 
    SET camper_route_enrollment_status = 'Dropped' 
    WHERE camper_id = p_camper_id AND route_id = p_old_route_id;
    
    -- Create new enrollment
    INSERT INTO camper_route_enrollments (camper_id, route_id, enrollment_date, camper_route_enrollment_status)
    VALUES (p_camper_id, p_new_route_id, CURRENT_DATE, 'Active');
    
    -- Remove from old group
    DELETE FROM campers_group_members 
    WHERE camper_id = p_camper_id AND group_id = v_old_group_id;
    
    -- Add to new group
    INSERT INTO campers_group_members (group_id, camper_id)
    VALUES (v_new_group_id, p_camper_id);
    
    -- Add notification
    INSERT INTO notifications (trainer_id, message)
    SELECT trainer_id, CONCAT('El camper ID: ', p_camper_id, ' ha sido reasignado de la ruta ', p_old_route_id, ' a la ruta ', p_new_route_id, '. Razón: ', p_reason)
    FROM route_assignments
    WHERE route_id = p_new_route_id;
    
    SELECT 'Camper reasignado exitosamente a nueva ruta' AS message;
END //
DELIMITER ;

-- 12. Cambiar el estado de un camper a "Graduado" al finalizar todos los módulos.
DELIMITER //
CREATE PROCEDURE sp_graduate_camper(
    IN p_camper_id INT,
    IN p_route_id INT
)
BEGIN
    DECLARE v_total_skills INT;
    DECLARE v_approved_skills INT;
    DECLARE v_route_name VARCHAR(30);
    DECLARE v_error_message VARCHAR(255);
    
    -- Get route name
    SELECT route_name INTO v_route_name FROM routes WHERE id = p_route_id;
    
    -- Count total skills in route
    SELECT COUNT(*) INTO v_total_skills 
    FROM route_skills 
    WHERE route_id = p_route_id;
    
    -- Count approved skills
    SELECT COUNT(*) INTO v_approved_skills 
    FROM evaluations e
    JOIN route_skills rs ON e.skill_id = rs.skill_id
    WHERE e.camper_id = p_camper_id 
    AND rs.route_id = p_route_id
    AND e.camper_state = 'Aprobado';
    
    -- Check if all skills are approved
    IF v_approved_skills < v_total_skills THEN
        -- First create the error message in a variable
        SET v_error_message = CONCAT('El camper no ha aprobado todos los skills de la ruta. Aprobados: ', 
                                   v_approved_skills, ' de ', v_total_skills);
        -- Then use the variable in the SIGNAL statement
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_message;
    ELSE
        -- Update camper status
        CALL sp_update_camper_status(p_camper_id, 'Graduado', CONCAT('Completó todos los skills de la ruta ', v_route_name));
        
        -- Add to alumni table
        INSERT INTO alumni (camper_id, graduation_date, route_id, additional_info)
        VALUES (p_camper_id, CURRENT_DATE, p_route_id, CONCAT('Graduado de la ruta ', v_route_name));
        
        -- Update enrollment status
        UPDATE camper_route_enrollments
        SET camper_route_enrollment_status = 'Completed'
        WHERE camper_id = p_camper_id AND route_id = p_route_id;
        
        SELECT 'Camper graduado exitosamente' AS message;
    END IF;
END //
DELIMITER ;

-- 13. Consultar y exportar todos los datos de rendimiento de un camper.
DELIMITER //
CREATE PROCEDURE sp_get_camper_performance_data(
    IN p_camper_id INT
)
BEGIN
    -- Información personal y status actual
    SELECT 
        c.id AS camper_id,
        CONCAT(p.first_name, ' ', p.last_names) AS camper_name,
        p.email,
        dt.document_type,
        p.document_number,
        c.status_camper,
        c.risk_level,
        c.camper_performance,
        c.enrollment_date,
        (SELECT COUNT(*) FROM alumni WHERE camper_id = c.id) > 0 AS is_alumni
    FROM 
        camper c
    JOIN 
        person p ON c.person_id = p.id
    JOIN 
        document_types dt ON p.document_type_id = dt.id
    WHERE 
        c.id = p_camper_id;
    
    -- Historial de estados
    SELECT 
        old_state,
        new_state,
        change_date,
        reason
    FROM 
        camper_state_history
    WHERE 
        camper_id = p_camper_id
    ORDER BY 
        change_date DESC;
    
    -- Rutas inscritas
    SELECT 
        r.id AS route_id,
        r.route_name,
        cre.enrollment_date,
        cre.camper_route_enrollment_status,
        sgbd1.sgbd_name AS main_sgbd,
        sgbd2.sgbd_name AS alternative_sgbd
    FROM 
        camper_route_enrollments cre
    JOIN 
        routes r ON cre.route_id = r.id
    JOIN 
        sgbds sgbd1 ON r.main_sgbd = sgbd1.id
    JOIN 
        sgbds sgbd2 ON r.alternative_sgbd = sgbd2.id
    WHERE 
        cre.camper_id = p_camper_id;
    
    -- Evaluaciones y notas
    SELECT 
        e.id AS evaluation_id,
        s.skill_name,
        e.final_grade,
        e.camper_state,
        ec_t.note AS theoretical_note,
        ec_p.note AS practical_note,
        ec_q.note AS quiz_note,
        r.route_name,
        ec_t.evaluation_date
    FROM 
        evaluations e
    JOIN 
        skills s ON e.skill_id = s.id
    LEFT JOIN 
        evaluation_components ec_t ON e.id = ec_t.evaluation_id AND ec_t.component_type = 'Teorico'
    LEFT JOIN 
        evaluation_components ec_p ON e.id = ec_p.evaluation_id AND ec_p.component_type = 'Practico'
    LEFT JOIN 
        evaluation_components ec_q ON e.id = ec_q.evaluation_id AND ec_q.component_type = 'Quiz'
    LEFT JOIN
        route_skills rs ON e.skill_id = rs.skill_id
    LEFT JOIN
        routes r ON rs.route_id = r.id
    WHERE 
        e.camper_id = p_camper_id
    ORDER BY 
        ec_t.evaluation_date DESC;
    
    -- Asistencia
    SELECT 
        a.attendance_date,
        a.attendance_status,
        s.skill_name,
        r.route_name,
        a.arrival_time,
        a.justification
    FROM 
        attendance a
    JOIN 
        skills s ON a.skill_id = s.id
    JOIN 
        routes r ON a.route_id = r.id
    WHERE 
        a.camper_id = p_camper_id
    ORDER BY 
        a.attendance_date DESC;
    
    -- Grupos asignados
    SELECT 
        cg.group_name,
        cg.creation_date,
        r.route_name,
        CONCAT(p.first_name, ' ', p.last_names) AS trainer_name
    FROM 
        campers_group_members cgm
    JOIN 
        campers_group cg ON cgm.group_id = cg.id
    JOIN 
        routes r ON cg.route_id = r.id
    LEFT JOIN 
        route_assignments ra ON cg.id = ra.campers_group_id
    LEFT JOIN 
        trainer t ON ra.trainer_id = t.id
    LEFT JOIN 
        person p ON t.person_id = p.id
    WHERE 
        cgm.camper_id = p_camper_id;
END //
DELIMITER ;

-- 14. Registrar la asistencia a clases por área y horario.
DELIMITER //
CREATE PROCEDURE sp_register_attendance(
    IN p_camper_id INT,
    IN p_route_id INT,
    IN p_skill_id INT,
    IN p_schedule_id INT,
    IN p_attendance_status ENUM('Present', 'Absent', 'Late'),
    IN p_arrival_time TIME,
    IN p_justification TEXT,
    IN p_evidence_url VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    DECLARE v_schedule_day VARCHAR(20);
    DECLARE v_scheduled_start TIME;
    DECLARE v_scheduled_end TIME;
    
    -- Check if camper is enrolled in route
    SELECT COUNT(*) INTO v_count FROM camper_route_enrollments
    WHERE camper_id = p_camper_id AND route_id = p_route_id AND camper_route_enrollment_status = 'Active';
    
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El camper no está inscrito en la ruta especificada';
    END IF;
    
    -- Get schedule details
    SELECT day_of_week, start_time, end_time 
    INTO v_schedule_day, v_scheduled_start, v_scheduled_end
    FROM schedules WHERE id = p_schedule_id;
    
    -- Validate attendance status and arrival time
    IF p_attendance_status = 'Present' AND p_arrival_time IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Se requiere hora de llegada para estado Present';
    END IF;
    
    IF p_attendance_status = 'Late' AND (p_arrival_time IS NULL OR p_arrival_time <= v_scheduled_start) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estado Late requiere hora de llegada posterior a la hora de inicio';
    END IF;
    
    IF p_attendance_status = 'Absent' AND p_justification IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Se requiere justificación para ausencia';
    END IF;
    
    -- Check if attendance already registered for this date
    SELECT COUNT(*) INTO v_count FROM attendance
    WHERE camper_id = p_camper_id AND route_id = p_route_id AND skill_id = p_skill_id 
    AND schedule_id = p_schedule_id AND attendance_date = CURRENT_DATE;
    
    IF v_count > 0 THEN
        -- Update existing record
        UPDATE attendance
        SET attendance_status = p_attendance_status,
            arrival_time = p_arrival_time,
            justification = p_justification,
            evidence_url = p_evidence_url
        WHERE camper_id = p_camper_id AND route_id = p_route_id AND skill_id = p_skill_id 
        AND schedule_id = p_schedule_id AND attendance_date = CURRENT_DATE;
    ELSE
        -- Create new attendance record
        INSERT INTO attendance (
            camper_id, route_id, skill_id, schedule_id, attendance_date,
            attendance_status, arrival_time, justification, evidence_url
        ) VALUES (
            p_camper_id, p_route_id, p_skill_id, p_schedule_id, CURRENT_DATE,
            p_attendance_status, p_arrival_time, p_justification, p_evidence_url
        );
    END IF;
    
    -- If more than 3 absences in the last 30 days, update risk level
    SELECT COUNT(*) INTO v_count FROM attendance
    WHERE camper_id = p_camper_id AND attendance_status = 'Absent'
    AND attendance_date BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY) AND CURRENT_DATE;
    
    IF v_count >= 3 THEN
        UPDATE camper SET risk_level = 'Alto' WHERE id = p_camper_id;
    END IF;
    
    SELECT 'Asistencia registrada exitosamente' AS message;
END //
DELIMITER ;

-- 15. Generar reporte mensual de notas por ruta.
DELIMITER //
CREATE PROCEDURE sp_generate_monthly_route_report(
    IN p_route_id INT,
    IN p_month INT,
    IN p_year INT
)
BEGIN
    DECLARE v_start_date DATE;
    DECLARE v_end_date DATE;
    DECLARE v_route_name VARCHAR(30);
    
    -- Set date range
    SET v_start_date = CONCAT(p_year, '-', LPAD(p_month, 2, '0'), '-01');
    SET v_end_date = LAST_DAY(v_start_date);
    
    -- Get route name
    SELECT route_name INTO v_route_name FROM routes WHERE id = p_route_id;
    
    -- Header information
    SELECT 
        CONCAT('Reporte mensual de la ruta: ', v_route_name) AS report_title,
        CONCAT('Período: ', DATE_FORMAT(v_start_date, '%d/%m/%Y'), ' - ', DATE_FORMAT(v_end_date, '%d/%m/%Y')) AS period,
        COUNT(DISTINCT e.camper_id) AS total_campers,
        AVG(e.final_grade) AS average_grade,
        SUM(CASE WHEN e.camper_state = 'Aprobado' THEN 1 ELSE 0 END) AS total_approved,
        SUM(CASE WHEN e.camper_state = 'Reprobado' THEN 1 ELSE 0 END) AS total_failed
    FROM 
        evaluations e
    JOIN 
        route_skills rs ON e.skill_id = rs.skill_id
    JOIN 
        evaluation_components ec ON e.id = ec.evaluation_id
    WHERE 
        rs.route_id = p_route_id
    AND 
        ec.evaluation_date BETWEEN v_start_date AND v_end_date;
    
    -- Detailed report by skill
    SELECT 
        s.skill_name,
        COUNT(DISTINCT e.camper_id) AS evaluated_campers,
        AVG(e.final_grade) AS average_grade,
        MIN(e.final_grade) AS min_grade,
        MAX(e.final_grade) AS max_grade,
        SUM(CASE WHEN e.camper_state = 'Aprobado' THEN 1 ELSE 0 END) AS approved_count,
        SUM(CASE WHEN e.camper_state = 'Reprobado' THEN 1 ELSE 0 END) AS failed_count,
        (SUM(CASE WHEN e.camper_state = 'Aprobado' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS approval_rate
    FROM 
        evaluations e
    JOIN 
        skills s ON e.skill_id = s.id
    JOIN 
        route_skills rs ON e.skill_id = rs.skill_id
    JOIN 
        evaluation_components ec ON e.id = ec.evaluation_id
    WHERE 
        rs.route_id = p_route_id
    AND 
        ec.evaluation_date BETWEEN v_start_date AND v_end_date
    GROUP BY 
        s.skill_name
    ORDER BY 
        average_grade DESC;
    
    -- Detailed report by camper
    SELECT 
        CONCAT(p.first_name, ' ', p.last_names) AS camper_name,
        c.status_camper,
        c.risk_level,
        c.camper_performance,
        COUNT(DISTINCT e.skill_id) AS skills_evaluated,
        AVG(e.final_grade) AS average_grade,
        SUM(CASE WHEN e.camper_state = 'Aprobado' THEN 1 ELSE 0 END) AS approved_skills,
        SUM(CASE WHEN e.camper_state = 'Reprobado' THEN 1 ELSE 0 END) AS failed_skills,
        COUNT(DISTINCT CASE WHEN a.attendance_status = 'Absent' THEN a.id END) AS absences,
        COUNT(DISTINCT CASE WHEN a.attendance_status = 'Late' THEN a.id END) AS late_arrivals
    FROM 
        camper c
    JOIN 
        person p ON c.person_id = p.id
    JOIN 
        camper_route_enrollments cre ON c.id = cre.camper_id
    LEFT JOIN 
        evaluations e ON c.id = e.camper_id
    LEFT JOIN 
        evaluation_components ec ON e.id = ec.evaluation_id
    LEFT JOIN 
        attendance a ON c.id = a.camper_id AND a.route_id = p_route_id 
                     AND a.attendance_date BETWEEN v_start_date AND v_end_date
    WHERE 
        cre.route_id = p_route_id
    AND 
        (ec.evaluation_date BETWEEN v_start_date AND v_end_date OR ec.evaluation_date IS NULL)
    GROUP BY 
        c.id, p.first_name, p.last_names, c.status_camper, c.risk_level, c.camper_performance
    ORDER BY 
        average_grade DESC;
    
    -- Attendance summary
    SELECT 
        COUNT(*) AS total_sessions,
        SUM(CASE WHEN attendance_status = 'Present' THEN 1 ELSE 0 END) AS present_count,
        SUM(CASE WHEN attendance_status = 'Absent' THEN 1 ELSE 0 END) AS absent_count,
        SUM(CASE WHEN attendance_status = 'Late' THEN 1 ELSE 0 END) AS late_count,
        (SUM(CASE WHEN attendance_status = 'Present' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS attendance_rate
    FROM 
        attendance
    WHERE 
        route_id = p_route_id
    AND 
        attendance_date BETWEEN v_start_date AND v_end_date;
END //
DELIMITER ;

-- 16. Validar y registrar la asignación de un salón a una ruta sin exceder la capacidad.
DELIMITER //
CREATE PROCEDURE sp_assign_route_to_area(
    IN p_route_id INT,
    IN p_area_id INT,
    IN p_trainer_id INT,
    IN p_group_id INT
)
BEGIN
    DECLARE v_area_capacity INT;
    DECLARE v_group_size INT;
    DECLARE v_trainer_competent BOOLEAN DEFAULT FALSE;
    DECLARE v_error_message VARCHAR(255);
    
    -- Get area capacity
    SELECT capacity INTO v_area_capacity FROM training_areas WHERE id = p_area_id;
    
    -- Get group size
    SELECT COUNT(*) INTO v_group_size FROM campers_group_members WHERE group_id = p_group_id;
    
    -- Check if group size exceeds area capacity
    IF v_group_size > v_area_capacity THEN
        -- Store the error message in a variable first
        SET v_error_message = CONCAT('El tamaño del grupo (', v_group_size, 
                                ') excede la capacidad del área (', v_area_capacity, ')');
        -- Use the variable in the SIGNAL statement
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_message;
    END IF;
    
    -- Check if trainer has competencies for this route
    SELECT EXISTS (
        SELECT 1 FROM trainer_competencies tc
        JOIN module_competencies mc ON tc.competency_id = mc.competency_id
        JOIN module_skills ms ON mc.module_id = ms.module_id
        JOIN route_skills rs ON ms.skill_id = rs.skill_id
        WHERE tc.trainer_id = p_trainer_id AND rs.route_id = p_route_id
    ) INTO v_trainer_competent;
    
    IF NOT v_trainer_competent THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El trainer no tiene las competencias necesarias para esta ruta';
    END IF;
    
    -- Check if area is active
    IF NOT EXISTS (SELECT 1 FROM training_areas WHERE id = p_area_id AND training_areas_status = 'Activo') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El área de entrenamiento no está activa';
    END IF;
    
    -- Register assignment
    INSERT INTO route_assignments (route_id, area_id, trainer_id, campers_group_id)
    VALUES (p_route_id, p_area_id, p_trainer_id, p_group_id);
    
    SELECT 'Asignación de salón registrada exitosamente' AS message;
END //
DELIMITER ;

-- 17. Registrar cambio de horario de un trainer.
DELIMITER //
CREATE PROCEDURE sp_change_trainer_schedule(
    IN p_trainer_id INT,
    IN p_old_schedule_id INT,
    IN p_new_schedule_id INT
)
BEGIN
    DECLARE v_area_id INT;
    DECLARE v_route_id INT;
    DECLARE v_group_id INT;
    DECLARE v_count INT;
    DECLARE v_trainer_name VARCHAR(100);
    
    -- Get trainer name for notifications
    SELECT CONCAT(p.first_name, ' ', p.last_names) INTO v_trainer_name
    FROM trainer t
    JOIN person p ON t.person_id = p.id
    WHERE t.id = p_trainer_id;
    
    -- Check if old schedule exists for this trainer
    SELECT COUNT(*) INTO v_count FROM trainer_schedule
    WHERE trainer_id = p_trainer_id AND schedule_id = p_old_schedule_id;
    
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El entrenador no tiene el horario especificado';
    END IF;
    
    -- Check if new schedule exists
    SELECT COUNT(*) INTO v_count FROM schedules WHERE id = p_new_schedule_id;
    
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nuevo horario no existe';
    END IF;
    
    -- Check for schedule conflicts
    SELECT COUNT(*) INTO v_count FROM trainer_schedule ts
    JOIN schedules s1 ON ts.schedule_id = s1.id
    JOIN schedules s2 ON p_new_schedule_id = s2.id
    WHERE ts.trainer_id = p_trainer_id
    AND ts.schedule_id <> p_old_schedule_id
    AND s1.day_of_week = s2.day_of_week
    AND (
        (s1.start_time <= s2.start_time AND s1.end_time > s2.start_time) OR
        (s1.start_time < s2.end_time AND s1.end_time >= s2.end_time) OR
        (s1.start_time >= s2.start_time AND s1.end_time <= s2.end_time)
    );
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nuevo horario genera un conflicto con otro horario del trainer';
    END IF;
    
    -- Get current assignment details
    SELECT area_id, route_id, campers_group_id INTO v_area_id, v_route_id, v_group_id
    FROM trainer_schedule
    WHERE trainer_id = p_trainer_id AND schedule_id = p_old_schedule_id;
    
    -- Update the schedule
    UPDATE trainer_schedule
    SET schedule_id = p_new_schedule_id
    WHERE trainer_id = p_trainer_id AND schedule_id = p_old_schedule_id;
    
    -- Notify affected campers
    INSERT INTO notifications (trainer_id, message)
    SELECT DISTINCT t.id, CONCAT('El trainer ', v_trainer_name, ' ha cambiado su horario para la ruta ', r.route_name)
    FROM trainer t
    JOIN route_assignments ra ON t.id = ra.trainer_id
    JOIN routes r ON ra.route_id = v_route_id
    JOIN campers_group_members cgm ON ra.campers_group_id = cgm.group_id
    WHERE ra.route_id = v_route_id AND ra.campers_group_id = v_group_id;
    
    SELECT 'Horario del trainer actualizado exitosamente' AS message;
END //
DELIMITER ;

-- 18. Eliminar la inscripción de un camper a una ruta (en caso de retiro).
DELIMITER //
CREATE PROCEDURE sp_delete_camper_enrollment(
    IN p_camper_id INT,
    IN p_route_id INT,
    IN p_reason TEXT
)
BEGIN
    DECLARE v_count INT;
    DECLARE v_group_id INT;
    DECLARE v_old_status ENUM('En proceso de ingreso', 'Inscrito', 'Aprobado', 'Cursando', 'Graduado', 'Expulsado', 'Retirado');
    
    -- Check if enrollment exists
    SELECT COUNT(*) INTO v_count FROM camper_route_enrollments
    WHERE camper_id = p_camper_id AND route_id = p_route_id AND camper_route_enrollment_status = 'Active';
    
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El camper no está inscrito en la ruta especificada o ya está retirado';
    END IF;
    
    -- Get current group ID
    SELECT cg.id INTO v_group_id
    FROM campers_group_members cgm
    JOIN campers_group cg ON cgm.group_id = cg.id
    WHERE cgm.camper_id = p_camper_id AND cg.route_id = p_route_id
    LIMIT 1;
    
    -- Get current status
    SELECT status_camper INTO v_old_status FROM camper WHERE id = p_camper_id;
    
    -- Update enrollment status
    UPDATE camper_route_enrollments
    SET camper_route_enrollment_status = 'Dropped'
    WHERE camper_id = p_camper_id AND route_id = p_route_id;
    
    -- Remove from group
    IF v_group_id IS NOT NULL THEN
        DELETE FROM campers_group_members
        WHERE camper_id = p_camper_id AND group_id = v_group_id;
    END IF;
    
    -- Update camper status
    UPDATE camper SET status_camper = 'Retirado' WHERE id = p_camper_id;
    
    -- Record state change in history
    INSERT INTO camper_state_history (camper_id, old_state, new_state, change_date, reason)
    VALUES (p_camper_id, v_old_status, 'Retirado', NOW(), p_reason);
    
    -- Notify trainers
    INSERT INTO notifications (trainer_id, message)
    SELECT trainer_id, CONCAT('El camper ID: ', p_camper_id, ' se ha retirado de la ruta ', p_route_id, '. Razón: ', p_reason)
    FROM route_assignments
    WHERE route_id = p_route_id;
    
    SELECT 'Inscripción del camper eliminada exitosamente' AS message;
END //
DELIMITER ;

-- 19. Recalcular el estado de todos los campers según su rendimiento acumulado.
DELIMITER //
CREATE PROCEDURE sp_recalculate_all_campers_status()
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_camper_id INT;
    DECLARE v_old_performance ENUM('Bajo', 'Medio', 'Alto');
    DECLARE v_new_performance ENUM('Bajo', 'Medio', 'Alto');
    DECLARE v_old_risk ENUM('Bajo', 'Medio', 'Alto');
    DECLARE v_new_risk ENUM('Bajo', 'Medio', 'Alto');
    DECLARE v_avg_grade DECIMAL(5,2);
    DECLARE v_failed_count INT;
    DECLARE v_absence_count INT;
    
    -- Cursor for all active campers
    DECLARE campers_cursor CURSOR FOR
        SELECT id FROM camper
        WHERE status_camper IN ('Inscrito', 'Aprobado', 'Cursando');
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    
    OPEN campers_cursor;
    
    camper_loop: LOOP
        FETCH campers_cursor INTO v_camper_id;
        
        IF v_done THEN
            LEAVE camper_loop;
        END IF;
        
        -- Get current performance and risk level
        SELECT camper_performance, risk_level INTO v_old_performance, v_old_risk
        FROM camper WHERE id = v_camper_id;
        
        -- Calculate average grade from all evaluations
        SELECT AVG(final_grade) INTO v_avg_grade
        FROM evaluations
        WHERE camper_id = v_camper_id;
        
        -- Count failed evaluations in the last 3 months
        SELECT COUNT(*) INTO v_failed_count
        FROM evaluations e
        JOIN evaluation_components ec ON e.id = ec.evaluation_id
        WHERE e.camper_id = v_camper_id
        AND e.camper_state = 'Reprobado'
        AND ec.evaluation_date >= DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH);
        
        -- Count absences in the last month
        SELECT COUNT(*) INTO v_absence_count
        FROM attendance
        WHERE camper_id = v_camper_id
        AND attendance_status = 'Absent'
        AND attendance_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH);
        
        -- Determine new performance level
        IF v_avg_grade IS NULL THEN
            SET v_new_performance = 'Medio'; -- Default if no evaluations
        ELSEIF v_avg_grade >= 85 THEN
            SET v_new_performance = 'Alto';
        ELSEIF v_avg_grade >= 60 THEN
            SET v_new_performance = 'Medio';
        ELSE
            SET v_new_performance = 'Bajo';
        END IF;
        
        -- Determine new risk level
        IF v_failed_count >= 2 OR v_absence_count >= 3 THEN
            SET v_new_risk = 'Alto';
        ELSEIF v_failed_count = 1 OR v_absence_count = 2 THEN
            SET v_new_risk = 'Medio';
        ELSE
            SET v_new_risk = 'Bajo';
        END IF;
        
        -- Update camper if needed
        IF v_old_performance <> v_new_performance OR v_old_risk <> v_new_risk THEN
            UPDATE camper
            SET camper_performance = v_new_performance,
                risk_level = v_new_risk
            WHERE id = v_camper_id;
            
            -- Notify if high risk
            IF v_new_risk = 'Alto' AND v_old_risk <> 'Alto' THEN
                INSERT INTO notifications (trainer_id, message)
                SELECT DISTINCT ra.trainer_id, 
                       CONCAT('El camper ID: ', v_camper_id, ' ha sido marcado como de alto riesgo debido a su rendimiento académico o asistencia.')
                FROM camper_route_enrollments cre
                JOIN route_assignments ra ON cre.route_id = ra.route_id
                WHERE cre.camper_id = v_camper_id
                AND cre.camper_route_enrollment_status = 'Active';
            END IF;
        END IF;
    END LOOP;
    
    CLOSE campers_cursor;
    
    SELECT 'Estado de todos los campers recalculado exitosamente' AS message;
END //
DELIMITER ;

-- 20. Asignar horarios automáticamente a trainers disponibles según sus áreas.
DELIMITER //
CREATE PROCEDURE sp_auto_assign_trainer_schedules(
    IN p_route_id INT
)
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_trainer_id INT;
    DECLARE v_area_id INT;
    DECLARE v_schedule_id INT;
    DECLARE v_group_id INT;
    DECLARE v_skill_count INT;
    DECLARE v_assigned_count INT DEFAULT 0;
    
    -- Cursor for competent trainers not fully scheduled
    DECLARE trainers_cursor CURSOR FOR
        SELECT DISTINCT tc.trainer_id
        FROM trainer_competencies tc
        JOIN module_competencies mc ON tc.competency_id = mc.competency_id
        JOIN module_skills ms ON mc.module_id = ms.module_id
        JOIN route_skills rs ON ms.skill_id = rs.skill_id
        WHERE rs.route_id = p_route_id
        AND NOT EXISTS (
            -- Exclude trainers that already have a full schedule for this route
            SELECT 1 FROM trainer_schedule ts
            JOIN routes r ON ts.route_id = r.id
            WHERE ts.trainer_id = tc.trainer_id
            AND ts.route_id = p_route_id
            GROUP BY ts.trainer_id
            HAVING COUNT(*) >= (
                SELECT COUNT(*) FROM general_schedule
                WHERE route_id = p_route_id
            )
        );
    
    -- Cursor for available schedules in active areas
    DECLARE schedules_cursor CURSOR FOR
        SELECT s.id, ta.id
        FROM schedules s
        CROSS JOIN training_areas ta
        WHERE ta.training_areas_status = 'Activo'
        AND NOT EXISTS (
            -- Exclude schedules already assigned for this route
            SELECT 1 FROM trainer_schedule ts
            WHERE ts.schedule_id = s.id
            AND ts.route_id = p_route_id
        )
        ORDER BY ta.id, s.day_of_week, s.start_time;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    
    -- Count skills in the route to know how many schedules we need
    SELECT COUNT(*) INTO v_skill_count FROM route_skills WHERE route_id = p_route_id;
    
    -- Check if we have a group for this route, create if not
    SELECT id INTO v_group_id FROM campers_group WHERE route_id = p_route_id LIMIT 1;
    
    IF v_group_id IS NULL THEN
        -- Create a group
        INSERT INTO campers_group (group_name, route_id, creation_date)
        VALUES (CONCAT('Grupo Auto ', p_route_id), p_route_id, CURRENT_DATE);
        SET v_group_id = LAST_INSERT_ID();
    END IF;
    
    -- Open trainers cursor
    OPEN trainers_cursor;
    
    trainer_loop: LOOP
        FETCH trainers_cursor INTO v_trainer_id;
        
        IF v_done OR v_assigned_count >= v_skill_count THEN
            LEAVE trainer_loop;
        END IF;
        
        -- Reset schedules cursor flag
        SET v_done = FALSE;
        
        -- Open schedules cursor
        OPEN schedules_cursor;
        
        schedule_loop: LOOP
            FETCH schedules_cursor INTO v_schedule_id, v_area_id;
            
            IF v_done THEN
                LEAVE schedule_loop;
            END IF;
            
            -- Check if this schedule conflicts with the trainer's existing schedules
            IF NOT EXISTS (
                SELECT 1 FROM trainer_schedule ts
                JOIN schedules s1 ON ts.schedule_id = s1.id
                JOIN schedules s2 ON v_schedule_id = s2.id
                WHERE ts.trainer_id = v_trainer_id
                AND s1.day_of_week = s2.day_of_week
                AND (
                    (s1.start_time <= s2.start_time AND s1.end_time > s2.start_time) OR
                    (s1.start_time < s2.end_time AND s1.end_time >= s2.end_time) OR
                    (s1.start_time >= s2.start_time AND s1.end_time <= s2.end_time)
                )
            ) THEN
                -- Assign this schedule to the trainer
                INSERT INTO trainer_schedule (trainer_id, schedule_id, area_id, route_id, campers_group_id)
                VALUES (v_trainer_id, v_schedule_id, v_area_id, p_route_id, v_group_id);
                
                -- Create route assignment if it doesn't exist
                IF NOT EXISTS (
                    SELECT 1 FROM route_assignments
                    WHERE route_id = p_route_id AND area_id = v_area_id
                    AND trainer_id = v_trainer_id AND campers_group_id = v_group_id
                ) THEN
                    INSERT INTO route_assignments (route_id, area_id, trainer_id, campers_group_id)
                    VALUES (p_route_id, v_area_id, v_trainer_id, v_group_id);
                END IF;
                
                SET v_assigned_count = v_assigned_count + 1;
                LEAVE schedule_loop;
            END IF;
        END LOOP schedule_loop;
        
        CLOSE schedules_cursor;
    END LOOP trainer_loop;
    
    CLOSE trainers_cursor;
    
    SELECT CONCAT('Asignación automática completada. ', v_assigned_count, ' horarios asignados de ', v_skill_count, ' requeridos.') AS message;
END //
DELIMITER ;


