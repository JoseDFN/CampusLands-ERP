USE campuslands;

-- 1. Al insertar una evaluación, calcular automáticamente la nota final.

DELIMITER //

CREATE TRIGGER trg_calculates_final_grade
AFTER INSERT ON evaluation_components
FOR EACH ROW
BEGIN
    DECLARE v_skill_id INT;
    DECLARE v_theo DECIMAL(3,0) DEFAULT 0.00;
    DECLARE v_prac DECIMAL(3,0) DEFAULT 0.00;
    DECLARE v_quiz DECIMAL(3,0) DEFAULT 0.00;
    DECLARE v_weight_theo DECIMAL(2,0);
    DECLARE v_weight_prac DECIMAL(2,0);
    DECLARE v_weight_quiz DECIMAL(2,0);
    DECLARE v_final DECIMAL(3,0);

    -- Obtain the skill associated with the evaluation (updated column name: skill_id)
    SELECT skill_id 
      INTO v_skill_id
      FROM evaluations
      WHERE id = NEW.evaluation_id;

    IF v_skill_id IS NOT NULL THEN
        -- Obtain the weights defined in the skills table instead of modules
        SELECT theoretical_weight, practical_weight, quizzes_weight
          INTO v_weight_theo, v_weight_prac, v_weight_quiz
          FROM skills
          WHERE id = v_skill_id;

        -- Calculate the sum of notes for each component using COALESCE to return 0.00 if no row exists
        SELECT 
            COALESCE(SUM(CASE WHEN component_type = 'Teorico' THEN note ELSE 0.00 END), 0.00),
            COALESCE(SUM(CASE WHEN component_type = 'Practico' THEN note ELSE 0.00 END), 0.00),
            COALESCE(SUM(CASE WHEN component_type = 'Quiz' THEN note ELSE 0.00 END), 0.00)
          INTO v_theo, v_prac, v_quiz
          FROM evaluation_components
          WHERE evaluation_id = NEW.evaluation_id;

        -- Calculate the final grade applying the respective weights
        SET v_final = (v_theo * v_weight_theo / 100) +
                      (v_prac * v_weight_prac / 100) +
                      (v_quiz * v_weight_quiz / 100);

        -- Update the evaluation with the calculated final grade
        UPDATE evaluations
           SET final_grade = v_final
           WHERE id = NEW.evaluation_id;
    END IF;
END//
DELIMITER ;

-- 2. Al actualizar la nota final de un módulo, verificar si el camper aprueba o reprueba.

DELIMITER //
CREATE TRIGGER trg_update_evaluation_status_log
BEFORE UPDATE ON evaluations
FOR EACH ROW
BEGIN
    IF NEW.final_grade >= 60 THEN
       SET NEW.camper_state = 'Aprobado';
    ELSE
       SET NEW.camper_state = 'Reprobado';
    END IF;
END//
DELIMITER ;

-- 3. Al insertar una inscripción, cambiar el estado del camper a "Inscrito".

DELIMITER //

CREATE TRIGGER trg_set_camper_inscrito
AFTER INSERT ON camper_route_enrollments
FOR EACH ROW
BEGIN
    -- Update camper status to 'Inscrito'
    UPDATE camper
    SET status_camper = 'Inscrito'
    WHERE id = NEW.camper_id;
    
    -- Record status change in history table
    INSERT INTO camper_state_history (camper_id, old_state, new_state, reason)
    SELECT id, status_camper, 'Inscrito', 'Inscripción automática en ruta'
    FROM camper
    WHERE id = NEW.camper_id AND status_camper != 'Inscrito';
END//

DELIMITER ;

-- 4. Al actualizar una evaluación, recalcular su promedio inmediatamente.

DELIMITER //

CREATE TRIGGER trg_recalculate_evaluation_grade
AFTER UPDATE ON evaluation_components
FOR EACH ROW
BEGIN
    DECLARE v_skill_id INT;
    DECLARE v_theo DECIMAL(3,0) DEFAULT 0.00;
    DECLARE v_prac DECIMAL(3,0) DEFAULT 0.00;
    DECLARE v_quiz DECIMAL(3,0) DEFAULT 0.00;
    DECLARE v_weight_theo DECIMAL(2,0);
    DECLARE v_weight_prac DECIMAL(2,0);
    DECLARE v_weight_quiz DECIMAL(2,0);
    DECLARE v_final DECIMAL(3,0);

    -- Obtain the skill associated with the evaluation
    SELECT skill_id 
      INTO v_skill_id
      FROM evaluations
      WHERE id = NEW.evaluation_id;

    IF v_skill_id IS NOT NULL THEN
        -- Obtain the weights defined in the skills table
        SELECT theoretical_weight, practical_weight, quizzes_weight
          INTO v_weight_theo, v_weight_prac, v_weight_quiz
          FROM skills
          WHERE id = v_skill_id;

        -- Calculate the sum of notes for each component
        SELECT 
            COALESCE(SUM(CASE WHEN component_type = 'Teorico' THEN note ELSE 0.00 END), 0.00),
            COALESCE(SUM(CASE WHEN component_type = 'Practico' THEN note ELSE 0.00 END), 0.00),
            COALESCE(SUM(CASE WHEN component_type = 'Quiz' THEN note ELSE 0.00 END), 0.00)
          INTO v_theo, v_prac, v_quiz
          FROM evaluation_components
          WHERE evaluation_id = NEW.evaluation_id;

        -- Calculate the final grade applying the respective weights
        SET v_final = (v_theo * v_weight_theo / 100) +
                      (v_prac * v_weight_prac / 100) +
                      (v_quiz * v_weight_quiz / 100);

        -- Update the evaluation with the recalculated final grade
        UPDATE evaluations
           SET final_grade = v_final
           WHERE id = NEW.evaluation_id;
    END IF;
END//

DELIMITER ;

-- 5. Al eliminar una inscripción, marcar al camper como "Retirado".

DELIMITER //

CREATE TRIGGER trg_mark_camper_retirado
BEFORE DELETE ON camper_route_enrollments
FOR EACH ROW
BEGIN
    -- Get current status to save in history
    DECLARE v_current_status VARCHAR(50);
    
    SELECT status_camper INTO v_current_status
    FROM camper
    WHERE id = OLD.camper_id;
    
    -- Mark camper as "Retirado"
    UPDATE camper
    SET status_camper = 'Retirado'
    WHERE id = OLD.camper_id;
    
    -- Record the status change in history
    INSERT INTO camper_state_history (camper_id, old_state, new_state, reason)
    VALUES (OLD.camper_id, v_current_status, 'Retirado', 'Eliminación de inscripción');
END//

DELIMITER ;

-- 6. Al insertar un nuevo módulo, registrar automáticamente su SGDB asociado.

DELIMITER //

CREATE TRIGGER trg_register_module_sgdb
AFTER INSERT ON modules
FOR EACH ROW
BEGIN
    DECLARE v_main_sgbd_name VARCHAR(80);
    DECLARE v_alt_sgbd_name VARCHAR(80);
    
    -- Obtener los nombres de los SGBDs asociados al módulo
    SELECT sgbd_name INTO v_main_sgbd_name
    FROM sgbds
    WHERE id = NEW.main_sgbd;
    
    SELECT sgbd_name INTO v_alt_sgbd_name
    FROM sgbds
    WHERE id = NEW.alternative_sgbd;
    
    -- Asegurar que los módulos de competencia relacionados con estos SGBD se asocien correctamente
    IF NEW.main_sgbd IS NOT NULL THEN
        -- Obtener todas las competencias relacionadas con este SGBD y asignarlas al módulo
        INSERT INTO module_competencies (module_id, competency_id)
        SELECT NEW.id, c.id
        FROM competencies c
        WHERE c.competency_name LIKE CONCAT('%', v_main_sgbd_name, '%')
        AND NOT EXISTS (
            SELECT 1 FROM module_competencies 
            WHERE module_id = NEW.id AND competency_id = c.id
        );
    END IF;
    
    IF NEW.alternative_sgbd IS NOT NULL AND NEW.alternative_sgbd != NEW.main_sgbd THEN
        -- Hacer lo mismo para el SGBD alternativo
        INSERT INTO module_competencies (module_id, competency_id)
        SELECT NEW.id, c.id
        FROM competencies c
        WHERE c.competency_name LIKE CONCAT('%', v_alt_sgbd_name, '%')
        AND NOT EXISTS (
            SELECT 1 FROM module_competencies 
            WHERE module_id = NEW.id AND competency_id = c.id
        );
    END IF;
    
    -- Lanzar una notificación a los trainers que tienen competencias en estos SGBDs
    INSERT INTO notifications (trainer_id, message)
    SELECT DISTINCT tc.trainer_id, 
           CONCAT('Nuevo módulo creado: ', NEW.module_name, ' con SGBD principal: ', v_main_sgbd_name, 
                 ' y SGBD alternativo: ', v_alt_sgbd_name)
    FROM trainer_competencies tc
    JOIN competencies c ON tc.competency_id = c.id
    WHERE c.competency_name LIKE CONCAT('%', v_main_sgbd_name, '%')
    OR c.competency_name LIKE CONCAT('%', v_alt_sgbd_name, '%');
END//

DELIMITER ;

-- 7. Al insertar un nuevo trainer, verificar duplicados por identificación.

DELIMITER //

CREATE TRIGGER trg_check_trainer_duplicates
BEFORE INSERT ON trainer
FOR EACH ROW
BEGIN
    DECLARE v_document_number VARCHAR(20);
    DECLARE v_count INT;
    
    -- Get the document number of the person being registered as trainer
    SELECT document_number INTO v_document_number
    FROM person
    WHERE id = NEW.person_id;
    
    -- Check if any trainer already exists with this document number
    SELECT COUNT(*) INTO v_count
    FROM trainer t
    JOIN person p ON t.person_id = p.id
    WHERE p.document_number = v_document_number;
    
    -- If a duplicate exists, raise an error
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe un trainer con este número de documento';
    END IF;
END//

DELIMITER ;

-- 8. Al asignar un área, validar que no exceda su capacidad.

DELIMITER //
CREATE TRIGGER trg_check_area_capacity
BEFORE INSERT ON route_assignments
FOR EACH ROW
BEGIN
    DECLARE group_count INT;
    DECLARE area_capacity INT;
    
    SELECT capacity INTO area_capacity FROM training_areas WHERE id = NEW.area_id;
    SELECT COUNT(*) INTO group_count FROM campers_group_members WHERE group_id = NEW.campers_group_id;
    
    IF group_count > area_capacity THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La capacidad del área ha sido excedida';
    END IF;
END//
DELIMITER ;

-- 9. Al insertar una evaluación con nota < 60, marcar al camper como "Bajo rendimiento".

DELIMITER //
CREATE TRIGGER trg_update_camper_performance
AFTER UPDATE ON evaluations
FOR EACH ROW
BEGIN
   -- Only update if the final_grade has changed and is not zero
   IF NEW.final_grade != OLD.final_grade AND NEW.final_grade > 0 THEN
       IF NEW.final_grade < 60 THEN
           UPDATE camper SET camper_performance = 'Bajo' WHERE id = NEW.camper_id;
       ELSEIF NEW.final_grade < 85 THEN
           UPDATE camper SET camper_performance = 'Medio' WHERE id = NEW.camper_id;
       ELSE
           UPDATE camper SET camper_performance = 'Alto' WHERE id = NEW.camper_id;
       END IF;
   END IF;
END//

DELIMITER ;

-- 10. Al cambiar de estado a "Graduado", mover registro a la tabla de egresados.

DELIMITER //

CREATE TRIGGER trg_move_to_alumni
AFTER UPDATE ON camper
FOR EACH ROW
BEGIN
    DECLARE v_route_id INT;
    
    -- If the camper status changed to "Graduado"
    IF NEW.status_camper = 'Graduado' AND OLD.status_camper != 'Graduado' THEN
        -- Find the route the camper was enrolled in
        SELECT route_id INTO v_route_id
        FROM camper_route_enrollments
        WHERE camper_id = NEW.id
        ORDER BY enrollment_date DESC
        LIMIT 1;
        
        -- Insert the record into the alumni table
        INSERT INTO alumni (camper_id, graduation_date, route_id, additional_info)
        VALUES (NEW.id, CURRENT_DATE, v_route_id, CONCAT('Graduado de la ruta ID: ', v_route_id));
        
        -- Update the camper route enrollment status to "Completed"
        UPDATE camper_route_enrollments
        SET camper_route_enrollment_status = 'Completed'
        WHERE camper_id = NEW.id AND route_id = v_route_id;
    END IF;
END//

DELIMITER ;

-- 11. Al modificar horarios de trainer, verificar solapamiento con otros.

DELIMITER //

CREATE TRIGGER trg_check_trainer_schedule_overlap
BEFORE INSERT ON trainer_schedule
FOR EACH ROW
BEGIN
    DECLARE v_overlap_count INT;
    DECLARE v_day_of_week VARCHAR(20);
    DECLARE v_start_time TIME;
    DECLARE v_end_time TIME;
    
    -- Get schedule details
    SELECT day_of_week, start_time, end_time 
    INTO v_day_of_week, v_start_time, v_end_time
    FROM schedules
    WHERE id = NEW.schedule_id;
    
    -- Check for overlapping schedules for the same trainer
    SELECT COUNT(*) INTO v_overlap_count
    FROM trainer_schedule ts
    JOIN schedules s ON ts.schedule_id = s.id
    WHERE ts.trainer_id = NEW.trainer_id
    AND s.day_of_week = v_day_of_week
    AND ((s.start_time <= v_end_time AND s.end_time >= v_start_time)
         OR (v_start_time <= s.end_time AND v_end_time >= s.start_time));
    
    -- If there's an overlap, raise an error
    IF v_overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Hay un solapamiento de horarios para este trainer';
    END IF;
END//

DELIMITER ;

-- 12. Al eliminar un trainer, liberar sus horarios y rutas asignadas.

DELIMITER //

CREATE TRIGGER trg_free_trainer_schedules
BEFORE DELETE ON trainer
FOR EACH ROW
BEGIN
    -- Delete all trainer schedule assignments
    DELETE FROM trainer_schedule
    WHERE trainer_id = OLD.id;
    
    -- Option 2: Delete route assignments
    DELETE FROM route_assignments
    WHERE trainer_id = OLD.id;
    
    -- You might also want to clean up any notifications for this trainer
    DELETE FROM notifications
    WHERE trainer_id = OLD.id;
END//

DELIMITER ;

-- 13. Al cambiar la ruta de un camper, actualizar automáticamente sus módulos.

DELIMITER //

CREATE TRIGGER trg_update_camper_modules
AFTER UPDATE ON camper_route_enrollments
FOR EACH ROW
BEGIN
    -- Only proceed if the route has changed
    IF NEW.route_id != OLD.route_id THEN
        INSERT INTO notifications (trainer_id, message)
        SELECT t.id, CONCAT('El camper ID: ', NEW.camper_id, ' ha cambiado de la ruta ID: ', 
                           OLD.route_id, ' a la ruta ID: ', NEW.route_id)
        FROM trainer t
        JOIN trainer_module_assignments tma ON t.id = tma.trainer_id
        JOIN module_skills ms ON tma.module_id = ms.module_id
        JOIN route_skills rs ON ms.skill_id = rs.skill_id
        WHERE rs.route_id = NEW.route_id
        GROUP BY t.id;
    END IF;
END//

DELIMITER ;

-- 14. Al insertar un nuevo camper, verificar si ya existe por número de documento.

DELIMITER //

CREATE TRIGGER trg_check_camper_duplicate
BEFORE INSERT ON camper
FOR EACH ROW
BEGIN
    DECLARE v_document_number VARCHAR(20);
    DECLARE v_count INT;
    
    -- Get the document number of the person being registered as camper
    SELECT document_number INTO v_document_number
    FROM person
    WHERE id = NEW.person_id;
    
    -- Check if any camper already exists with this document number
    SELECT COUNT(*) INTO v_count
    FROM camper c
    JOIN person p ON c.person_id = p.id
    WHERE p.document_number = v_document_number;
    
    -- If a duplicate exists, raise an error
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe un camper con este número de documento';
    END IF;
END//

DELIMITER ;

-- 15. Al actualizar la nota final, recalcular el estado del módulo automáticamente.

DELIMITER //

CREATE TRIGGER trg_update_skill_state
AFTER UPDATE ON evaluations
FOR EACH ROW
BEGIN
    -- If the final grade or state has changed
    IF NEW.final_grade != OLD.final_grade OR 
       NEW.camper_state != OLD.camper_state THEN
        
        -- Update the skill state based on the evaluation result
        IF NEW.camper_state = 'Aprobado' THEN
            UPDATE skills
            SET skill_state = 'Aprobado'
            WHERE id = NEW.skill_id;
        ELSE
            UPDATE skills
            SET skill_state = 'Reprobado'
            WHERE id = NEW.skill_id;
        END IF;
    END IF;
END//

DELIMITER ;

-- 16. Al asignar un módulo, verificar que el trainer tenga ese conocimiento.

DELIMITER //

CREATE TRIGGER trg_check_trainer_knowledge
BEFORE INSERT ON trainer_module_assignments
FOR EACH ROW
BEGIN
    DECLARE v_competency_count INT;
    
    -- Check if the trainer has the required competencies for this module
    SELECT COUNT(*) INTO v_competency_count
    FROM module_competencies mc
    JOIN trainer_competencies tc ON mc.competency_id = tc.competency_id
    WHERE mc.module_id = NEW.module_id
    AND tc.trainer_id = NEW.trainer_id;
    
    -- If the trainer doesn't have any matching competencies, raise an error
    IF v_competency_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El trainer no tiene las competencias necesarias para este módulo';
    END IF;
END//

DELIMITER ;

-- 17. Al cambiar el estado de un área a inactiva, liberar campers asignados.

DELIMITER //

CREATE TRIGGER trg_free_area_campers
BEFORE UPDATE ON training_areas
FOR EACH ROW
BEGIN
    -- If the area's status is being changed to 'Inactivo'
    IF NEW.training_areas_status = 'Inactivo' AND OLD.training_areas_status = 'Activo' THEN
        -- Delete route assignments for this area
        DELETE FROM route_assignments
        WHERE area_id = NEW.id;
        
        -- Also delete any trainer schedules for this area
        DELETE FROM trainer_schedule
        WHERE area_id = NEW.id;
    END IF;
END//

DELIMITER ;

-- 18. Al crear una nueva ruta, clonar la plantilla base de módulos y SGDBs.

DELIMITER //

CREATE TRIGGER trg_clone_route_template
AFTER INSERT ON routes
FOR EACH ROW
BEGIN
    -- Define a base route ID (you might want to set this to a fixed value or determine it dynamically)
    DECLARE v_base_route_id INT DEFAULT 1; -- Assuming route ID 1 is your template/base route
    
    -- Clone skills from the base route to the new route
    -- Include the main_sgbd and alternative_sgbd from the newly created route
    INSERT INTO route_skills (route_id, skill_id, main_sgbd, alternative_sgbd)
    SELECT NEW.id, skill_id, NEW.main_sgbd, NEW.alternative_sgbd
    FROM base_route_skills
    WHERE EXISTS (SELECT 1 FROM skills WHERE id = skill_id);
    
    -- Notify trainers with competencies in these SGBDs
    INSERT INTO notifications (trainer_id, message)
    SELECT DISTINCT tc.trainer_id, 
           CONCAT('Nueva ruta creada: ', NEW.route_name, 
                 ' con SGBD principal: ', (SELECT sgbd_name FROM sgbds WHERE id = NEW.main_sgbd), 
                 ' y SGBD alternativo: ', (SELECT sgbd_name FROM sgbds WHERE id = NEW.alternative_sgbd))
    FROM trainer_competencies tc
    JOIN competencies c ON tc.competency_id = c.id
    WHERE c.competency_name LIKE CONCAT('%', (SELECT sgbd_name FROM sgbds WHERE id = NEW.main_sgbd), '%')
    OR c.competency_name LIKE CONCAT('%', (SELECT sgbd_name FROM sgbds WHERE id = NEW.alternative_sgbd), '%');
END//

DELIMITER ;

-- 19. Al registrar la nota práctica, verificar que no supere 60% del total.

DELIMITER //

CREATE TRIGGER trg_verify_practical_note
BEFORE INSERT ON evaluation_components
FOR EACH ROW
BEGIN
    DECLARE v_skill_id INT;
    DECLARE v_practical_weight DECIMAL(2,0);
    
    -- Only proceed if this is a practical component
    IF NEW.component_type = 'Practico' THEN
        -- Get the skill ID for this evaluation
        SELECT skill_id INTO v_skill_id
        FROM evaluations
        WHERE id = NEW.evaluation_id;
        
        -- Get the practical weight for this skill
        SELECT practical_weight INTO v_practical_weight
        FROM skills
        WHERE id = v_skill_id;
        
        -- Verify that the note doesn't exceed the maximum allowed (60%)
        IF NEW.note > 100 OR (NEW.note / 100 * 100) > v_practical_weight THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La nota práctica no puede superar el 60% del total';
        END IF;
    END IF;
END//

DELIMITER ;

-- 20. Al modificar una ruta, notificar cambios a los trainers asignados.

DELIMITER //

CREATE TRIGGER trg_notify_route_changes
AFTER UPDATE ON routes
FOR EACH ROW
BEGIN
    -- Insert notifications for all trainers assigned to this route
    INSERT INTO notifications (trainer_id, message)
    SELECT DISTINCT trainer_id, 
           CONCAT('La ruta ', NEW.route_name, ' (ID: ', NEW.id, ') ha sido modificada')
    FROM route_assignments
    WHERE route_id = NEW.id;
END//

DELIMITER ;
