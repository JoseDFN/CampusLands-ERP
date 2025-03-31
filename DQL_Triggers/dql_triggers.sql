-- 1. Al insertar una evaluación, calcular automáticamente la nota final.

DELIMITER //

CREATE TRIGGER trg_calculates_final_grade
AFTER INSERT ON evaluation_components
FOR EACH ROW
BEGIN
    DECLARE v_module_id INT;
    DECLARE v_theo DECIMAL(3,0) DEFAULT 0.00;
    DECLARE v_prac DECIMAL(3,0) DEFAULT 0.00;
    DECLARE v_quiz DECIMAL(3,0) DEFAULT 0.00;
    DECLARE v_weight_theo DECIMAL(2,0);
    DECLARE v_weight_prac DECIMAL(2,0);
    DECLARE v_weight_quiz DECIMAL(2,0);
    DECLARE v_final DECIMAL(3,0);

    -- Obtener el módulo asociado a la evaluación
    SELECT module_id 
      INTO v_module_id
      FROM evaluations
      WHERE id = NEW.evaluation_id;

    IF v_module_id IS NOT NULL THEN
        -- Obtener los pesos definidos en el módulo
        SELECT theoretical_weight, practical_weight, quizzes_weight
          INTO v_weight_theo, v_weight_prac, v_weight_quiz
          FROM modules
          WHERE id = v_module_id;

        -- Calcular la suma de notas por cada componente utilizando COALESCE para definir 0.00 si no existe
        SELECT 
            COALESCE(SUM(CASE WHEN component_type = 'Teorico' THEN note ELSE 0.00 END), 0.00),
            COALESCE(SUM(CASE WHEN component_type = 'Practico' THEN note ELSE 0.00 END), 0.00),
            COALESCE(SUM(CASE WHEN component_type = 'Quiz' THEN note ELSE 0.00 END), 0.00)
          INTO v_theo, v_prac, v_quiz
          FROM evaluation_components
          WHERE evaluation_id = NEW.evaluation_id;

        -- Calcular la nota final aplicando los pesos (cada uno dividido entre 100)
        SET v_final = (v_theo * v_weight_theo / 100) +
                      (v_prac * v_weight_prac / 100) +
                      (v_quiz * v_weight_quiz / 100);

        -- Actualizar la evaluación con la nota final calculada
        UPDATE evaluations
           SET final_grade = v_final
           WHERE id = NEW.evaluation_id;
    END IF;
END//

DELIMITER ;

-- 2. Al actualizar la nota final de un módulo, verificar si el camper aprueba o reprueba.



-- 3. Al insertar una inscripción, cambiar el estado del camper a "Inscrito".



-- 4. Al actualizar una evaluación, recalcular su promedio inmediatamente.



-- 5. Al eliminar una inscripción, marcar al camper como “Retirado”.



-- 6. Al insertar un nuevo módulo, registrar automáticamente su SGDB asociado.



-- 7. Al insertar un nuevo trainer, verificar duplicados por identificación.



-- 8. Al asignar un área, validar que no exceda su capacidad.



-- 9. Al insertar una evaluación con nota < 60, marcar al camper como “Bajo rendimiento”.



-- 10. Al cambiar de estado a “Graduado”, mover registro a la tabla de egresados.



-- 11. Al modificar horarios de trainer, verificar solapamiento con otros.



-- 12. Al eliminar un trainer, liberar sus horarios y rutas asignadas.



-- 13. Al cambiar la ruta de un camper, actualizar automáticamente sus módulos.



-- 14. Al insertar un nuevo camper, verificar si ya existe por número de documento.



-- 15. Al actualizar la nota final, recalcular el estado del módulo automáticamente.



-- 16. Al asignar un módulo, verificar que el trainer tenga ese conocimiento.



-- 17. Al cambiar el estado de un área a inactiva, liberar campers asignados.



-- 18. Al crear una nueva ruta, clonar la plantilla base de módulos y SGDBs.



-- 19. Al registrar la nota práctica, verificar que no supere 60% del total.



-- 20. Al modificar una ruta, notificar cambios a los trainers asignados.


