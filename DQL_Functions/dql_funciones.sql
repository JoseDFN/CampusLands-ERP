USE campuslands;

-- 1. Calcular el promedio ponderado de evaluaciones de un camper.
DELIMITER //
DROP FUNCTION IF EXISTS calcular_promedio_camper;
CREATE FUNCTION calcular_promedio_camper(camper_id INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    
    SELECT IFNULL(AVG(e.final_grade), 0) INTO promedio
    FROM evaluations e
    WHERE e.camper_id = camper_id;
    
    RETURN promedio;
END //
DELIMITER ;

-- 2. Determinar si un camper aprueba o no un módulo específico.
DELIMITER //
DROP FUNCTION IF EXISTS verificar_aprobacion_modulo;
CREATE FUNCTION verificar_aprobacion_modulo(p_camper_id INT, p_skill_id INT) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE nota DECIMAL(5,2);
    DECLARE estado VARCHAR(20);
    
    SELECT final_grade INTO nota
    FROM evaluations
    WHERE camper_id = p_camper_id AND skill_id = p_skill_id;
    
    IF nota IS NULL THEN
        RETURN 'No evaluado';
    ELSEIF nota >= 60 THEN
        RETURN 'Aprobado';
    ELSE
        RETURN 'Reprobado';
    END IF;
END //
DELIMITER ;

-- 3. Evaluar el nivel de riesgo de un camper según su rendimiento promedio.
DELIMITER //
DROP FUNCTION IF EXISTS evaluar_nivel_riesgo;
CREATE FUNCTION evaluar_nivel_riesgo(camper_id INT) 
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    
    SELECT IFNULL(AVG(e.final_grade), 0) INTO promedio
    FROM evaluations e
    WHERE e.camper_id = camper_id;
    
    IF promedio >= 80 THEN
        RETURN 'Bajo';
    ELSEIF promedio >= 60 THEN
        RETURN 'Medio';
    ELSE
        RETURN 'Alto';
    END IF;
END //
DELIMITER ;

-- 4. Obtener el total de campers asignados a una ruta específica.
DELIMITER //
DROP FUNCTION IF EXISTS contar_campers_ruta;
CREATE FUNCTION contar_campers_ruta(ruta_id INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(DISTINCT camper_id) INTO total
    FROM camper_route_enrollments
    WHERE route_id = ruta_id;
    
    RETURN total;
END //
DELIMITER ;

-- 5. Consultar la cantidad de módulos que ha aprobado un camper.
DELIMITER //
DROP FUNCTION IF EXISTS contar_modulos_aprobados;
CREATE FUNCTION contar_modulos_aprobados(camper_id INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(*) INTO total
    FROM evaluations
    WHERE camper_id = camper_id AND (camper_state = 'Aprobado' OR final_grade >= 60);
    
    RETURN total;
END //
DELIMITER ;

-- 6. Validar si hay cupos disponibles en una determinada área.
DELIMITER //
DROP FUNCTION IF EXISTS validar_cupos_area;
CREATE FUNCTION validar_cupos_area(area_id INT) 
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE capacidad INT;
    DECLARE ocupacion INT;
    DECLARE disponibles INT;
    
    SELECT capacity INTO capacidad
    FROM training_areas
    WHERE id = area_id;
    
    SELECT COUNT(DISTINCT cgm.camper_id) INTO ocupacion
    FROM training_areas ta
    LEFT JOIN route_assignments ra ON ta.id = ra.area_id
    LEFT JOIN campers_group cg ON ra.campers_group_id = cg.id
    LEFT JOIN campers_group_members cgm ON cg.id = cgm.group_id
    WHERE ta.id = area_id;
    
    SET disponibles = capacidad - ocupacion;
    
    IF disponibles > 0 THEN
        RETURN CONCAT('Hay ', disponibles, ' cupos disponibles');
    ELSE
        RETURN 'No hay cupos disponibles';
    END IF;
END //
DELIMITER ;

-- 7. Calcular el porcentaje de ocupación de un área de entrenamiento.
DELIMITER //
DROP FUNCTION IF EXISTS calcular_porcentaje_ocupacion;
CREATE FUNCTION calcular_porcentaje_ocupacion(area_id INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE capacidad INT;
    DECLARE ocupacion INT;
    DECLARE porcentaje DECIMAL(5,2);
    
    SELECT capacity INTO capacidad
    FROM training_areas
    WHERE id = area_id;
    
    SELECT COUNT(DISTINCT cgm.camper_id) INTO ocupacion
    FROM training_areas ta
    LEFT JOIN route_assignments ra ON ta.id = ra.area_id
    LEFT JOIN campers_group cg ON ra.campers_group_id = cg.id
    LEFT JOIN campers_group_members cgm ON cg.id = cgm.group_id
    WHERE ta.id = area_id;
    
    IF capacidad = 0 THEN
        RETURN 0;
    ELSE
        SET porcentaje = (ocupacion / capacidad) * 100;
        RETURN porcentaje;
    END IF;
END //
DELIMITER ;

-- 8. Determinar la nota más alta obtenida en un módulo.
DELIMITER //
DROP FUNCTION IF EXISTS obtener_nota_mas_alta;
CREATE FUNCTION obtener_nota_mas_alta(p_skill_id INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE nota_maxima DECIMAL(5,2);
    
    SELECT MAX(final_grade) INTO nota_maxima
    FROM evaluations
    WHERE skill_id = p_skill_id;
    
    RETURN IFNULL(nota_maxima, 0);
END //
DELIMITER ;

-- 9. Calcular la tasa de aprobación de una ruta.
DELIMITER //
DROP FUNCTION IF EXISTS calcular_tasa_aprobacion;
CREATE FUNCTION calcular_tasa_aprobacion(ruta_id INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE total_evaluaciones INT;
    DECLARE aprobados INT;
    DECLARE tasa DECIMAL(5,2);
    
    SELECT COUNT(*) INTO total_evaluaciones
    FROM evaluations e
    JOIN camper_route_enrollments cre ON e.camper_id = cre.camper_id
    WHERE cre.route_id = ruta_id;
    
    SELECT COUNT(*) INTO aprobados
    FROM evaluations e
    JOIN camper_route_enrollments cre ON e.camper_id = cre.camper_id
    WHERE cre.route_id = ruta_id AND (e.camper_state = 'Aprobado' OR e.final_grade >= 60);
    
    IF total_evaluaciones = 0 THEN
        RETURN 0;
    ELSE
        SET tasa = (aprobados / total_evaluaciones) * 100;
        RETURN tasa;
    END IF;
END //
DELIMITER ;

-- 10. Verificar si un trainer tiene horario disponible.
DELIMITER //
DROP FUNCTION IF EXISTS verificar_horario_disponible;
CREATE FUNCTION verificar_horario_disponible(trainer_id INT, schedule_id INT) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE ocupado INT;
    
    SELECT COUNT(*) INTO ocupado
    FROM trainer_schedule
    WHERE trainer_id = trainer_id AND schedule_id = schedule_id;
    
    IF ocupado > 0 THEN
        RETURN 'Ocupado';
    ELSE
        RETURN 'Disponible';
    END IF;
END //
DELIMITER ;

-- 11. Obtener el promedio de notas por ruta.
DELIMITER //
DROP FUNCTION IF EXISTS obtener_promedio_ruta;
CREATE FUNCTION obtener_promedio_ruta(ruta_id INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    
    SELECT AVG(e.final_grade) INTO promedio
    FROM evaluations e
    JOIN camper_route_enrollments cre ON e.camper_id = cre.camper_id
    WHERE cre.route_id = ruta_id;
    
    RETURN IFNULL(promedio, 0);
END //
DELIMITER ;

-- 12. Calcular cuántas rutas tiene asignadas un trainer.
DELIMITER //
DROP FUNCTION IF EXISTS contar_rutas_trainer;
CREATE FUNCTION contar_rutas_trainer(trainer_id INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(DISTINCT route_id) INTO total
    FROM trainer_schedule
    WHERE trainer_id = trainer_id;
    
    RETURN total;
END //
DELIMITER ;

-- 13. Verificar si un camper puede ser graduado.
DELIMITER //
DROP FUNCTION IF EXISTS verificar_graduacion;
CREATE FUNCTION verificar_graduacion(camper_id INT) 
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE ruta_id INT;
    DECLARE total_modulos INT;
    DECLARE modulos_aprobados INT;
    
    -- Obtener la ruta del camper
    SELECT route_id INTO ruta_id
    FROM camper_route_enrollments
    WHERE camper_id = camper_id
    LIMIT 1;
    
    -- Contar total de módulos en la ruta
    SELECT COUNT(skill_id) INTO total_modulos
    FROM route_skills
    WHERE route_id = ruta_id;
    
    -- Contar módulos aprobados por el camper
    SELECT COUNT(*) INTO modulos_aprobados
    FROM evaluations e
    JOIN route_skills rs ON e.skill_id = rs.skill_id
    WHERE e.camper_id = camper_id 
    AND rs.route_id = ruta_id 
    AND (e.camper_state = 'Aprobado' OR e.final_grade >= 60);
    
    IF modulos_aprobados >= total_modulos THEN
        RETURN 'Puede graduarse';
    ELSE
        RETURN CONCAT('No puede graduarse. Ha aprobado ', modulos_aprobados, ' de ', total_modulos, ' módulos');
    END IF;
END //
DELIMITER ;

-- 14. Obtener el estado actual de un camper en función de sus evaluaciones.
DELIMITER //
DROP FUNCTION IF EXISTS obtener_estado_camper;
CREATE FUNCTION obtener_estado_camper(camper_id INT) 
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    DECLARE reprobados INT;
    DECLARE total_evaluaciones INT;
    
    SELECT AVG(final_grade) INTO promedio
    FROM evaluations
    WHERE camper_id = camper_id;
    
    SELECT COUNT(*) INTO reprobados
    FROM evaluations
    WHERE camper_id = camper_id AND (camper_state = 'Reprobado' OR final_grade < 60);
    
    SELECT COUNT(*) INTO total_evaluaciones
    FROM evaluations
    WHERE camper_id = camper_id;
    
    IF total_evaluaciones = 0 THEN
        RETURN 'Sin evaluaciones';
    ELSEIF reprobados > 0 THEN
        RETURN 'Requiere atención';
    ELSEIF promedio >= 80 THEN
        RETURN 'Excelente';
    ELSEIF promedio >= 60 THEN
        RETURN 'Promedio';
    ELSE
        RETURN 'Bajo rendimiento';
    END IF;
END //
DELIMITER ;

-- 15. Calcular la carga horaria semanal de un trainer.
DELIMITER //
DROP FUNCTION IF EXISTS calcular_carga_horaria;
CREATE FUNCTION calcular_carga_horaria(trainer_id INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_horas INT;
    
    SELECT COUNT(*) INTO total_horas
    FROM trainer_schedule ts
    JOIN schedules s ON ts.schedule_id = s.id
    WHERE ts.trainer_id = trainer_id;
    
    RETURN total_horas;
END //
DELIMITER ;

-- 16. Determinar si una ruta tiene módulos pendientes por evaluación.
DELIMITER //
DROP FUNCTION IF EXISTS verificar_modulos_pendientes;
CREATE FUNCTION verificar_modulos_pendientes(ruta_id INT) 
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE total_modulos INT;
    DECLARE modulos_evaluados INT;
    DECLARE pendientes INT;
    
    -- Total de módulos en la ruta
    SELECT COUNT(skill_id) INTO total_modulos
    FROM route_skills
    WHERE route_id = ruta_id;
    
    -- Módulos que tienen al menos una evaluación
    SELECT COUNT(DISTINCT rs.skill_id) INTO modulos_evaluados
    FROM route_skills rs
    JOIN evaluations e ON rs.skill_id = e.skill_id
    WHERE rs.route_id = ruta_id;
    
    SET pendientes = total_modulos - modulos_evaluados;
    
    IF pendientes > 0 THEN
        RETURN CONCAT('Hay ', pendientes, ' módulos pendientes por evaluar');
    ELSE
        RETURN 'Todos los módulos han sido evaluados';
    END IF;
END //
DELIMITER ;

-- 17. Calcular el promedio general del programa.
DELIMITER //
DROP FUNCTION IF EXISTS calcular_promedio_general;
CREATE FUNCTION calcular_promedio_general() 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    
    SELECT AVG(final_grade) INTO promedio
    FROM evaluations;
    
    RETURN IFNULL(promedio, 0);
END //
DELIMITER ;

-- 18. Verificar si un horario choca con otros entrenadores en el área.
DELIMITER //
DROP FUNCTION IF EXISTS verificar_choque_horario;
CREATE FUNCTION verificar_choque_horario(area_id INT, schedule_id INT) 
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE ocupado INT;
    
    SELECT COUNT(*) INTO ocupado
    FROM trainer_schedule
    WHERE area_id = area_id AND schedule_id = schedule_id;
    
    IF ocupado > 0 THEN
        RETURN 'Horario ocupado en esta área';
    ELSE
        RETURN 'Horario disponible';
    END IF;
END //
DELIMITER ;

-- 19. Calcular cuántos campers están en riesgo en una ruta específica.
DELIMITER //
DROP FUNCTION IF EXISTS contar_campers_riesgo;
CREATE FUNCTION contar_campers_riesgo(ruta_id INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(DISTINCT c.id) INTO total
    FROM camper c
    JOIN camper_route_enrollments cre ON c.id = cre.camper_id
    WHERE cre.route_id = ruta_id AND c.risk_level = 'Alto';
    
    RETURN total;
END //
DELIMITER ;

-- 20. Consultar el número de módulos evaluados por un camper.
DELIMITER //
DROP FUNCTION IF EXISTS contar_modulos_evaluados;
CREATE FUNCTION contar_modulos_evaluados(camper_id INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(DISTINCT skill_id) INTO total
    FROM evaluations
    WHERE camper_id = camper_id;
    
    RETURN total;
END //
DELIMITER ;



