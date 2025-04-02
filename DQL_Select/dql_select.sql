USE campuslands;

-- Campers

-- 1. Obtener todos los campers inscritos actualmente.

SELECT c.id, p.first_name AS Nombre, p.last_names AS Apellidos, p.document_number AS Numero_Identificacion, c.status_camper AS Status
FROM camper c
INNER JOIN person p ON c.person_id = p.id
WHERE c.status_camper = 'Inscrito';

-- 2. Listar los campers con estado "Aprobado".

SELECT c.id, p.first_name AS Nombre, p.last_names AS Apellidos, p.document_number AS Numero_Identificacion, c.status_camper AS Status
FROM camper c
INNER JOIN person p ON c.person_id = p.id
WHERE c.status_camper = 'Aprobado';

-- 3. Mostrar los campers que ya están cursando alguna ruta.

SELECT c.id, p.first_name AS Nombre, p.last_names AS Apellidos, p.document_number AS Numero_Identificacion, r.route_name AS Ruta
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN camper_route_enrollments cre ON c.id = cre.camper_id
INNER JOIN routes r ON cre.route_id = r.id;

-- 4. Consultar los campers graduados por cada ruta.

SELECT p.first_name AS Nombre, p.last_names AS Apellidos, p.document_number AS Numero_Identificacion, r.route_name AS Ruta, a.graduation_date AS Fecha_Graduacion
FROM alumni a
INNER JOIN camper c ON a.camper_id = c.id
INNER JOIN person p ON c.person_id = p.id
INNER JOIN routes r ON a.route_id = r.id
ORDER BY r.route_name ASC;

-- 5. Obtener los campers que se encuentran en estado "Expulsado" o "Retirado".

SELECT c.id, p.first_name AS Nombre, p.last_names AS Apellidos, p.document_number AS Numero_Identificacion, c.status_camper AS Status
FROM camper c
INNER JOIN person p ON c.person_id = p.id
WHERE c.status_camper = 'Expulsado' OR c.status_camper = 'Retirado';

-- 6. Listar campers con nivel de riesgo "Alto".

SELECT c.id, p.first_name AS Nombre, p.last_names AS Apellidos, p.document_number AS Numero_Identificacion, c.risk_level AS Nivel_Riesgo
FROM camper c
INNER JOIN person p ON c.person_id = p.id
WHERE c.risk_level = 'Alto';

-- 7. Mostrar el total de campers por cada nivel de riesgo.

SELECT COUNT(c.id) AS Total_Campers, c.risk_level AS Nivel_Riesgo
FROM camper c
GROUP BY c.risk_level;

-- 8. Obtener campers con más de un número telefónico registrado.

SELECT c.id, p.first_name AS Nombre, p.last_names AS Apellidos, p.document_number AS Numero_Identificacion, COUNT(pp.person_id) AS Cantidad_Numeros_Telefonicos
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN person_phones pp ON p.id = pp.person_id
GROUP BY c.id
HAVING COUNT(pp.person_id) > 1;

-- 9. Listar los campers y sus respectivos acudientes y teléfonos.

SELECT c.id, p.first_name AS Nombre, p.last_names AS Apellidos, ps.first_name AS Acudiente_Nombre, ps.last_names AS Acudiente_Apellidos, pn.phone_number AS Telefono
FROM camper c
INNER JOIN guardian g ON c.guardian_id = g.id
INNER JOIN person p ON c.person_id = p.id
INNER JOIN person ps ON g.person_id = ps.id
INNER JOIN person_phones pp ON ps.id = pp.person_id
INNER JOIN phone_numbers pn ON pp.phone_id = pn.id;

-- 10. Mostrar campers que aún no han sido asignados a una ruta.

SELECT c.id, p.first_name AS Nombre, p.last_names AS Apellidos, p.document_number AS Numero_Identificacion
FROM camper c
INNER JOIN person p ON c.person_id = p.id
LEFT JOIN camper_route_enrollments cre ON c.id = cre.camper_id
WHERE cre.camper_id IS NULL;

-- Evaluaciones

-- 1. Obtener las notas teóricas, prácticas y quizzes de cada camper por módulo.

SELECT s.skill_name AS Modulo, c.id, p.first_name AS Nombre, ec.component_type AS Tipo_Nota, ec.note AS Nota
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN evaluations e ON c.id = e.camper_id
INNER JOIN evaluation_components ec ON e.id = ec.evaluation_id
INNER JOIN skills s ON e.skill_id = s.id
WHERE ec.component_type IN ('Teorico', 'Practico', 'Quiz')
ORDER BY s.skill_name ASC;

-- 2. Calcular la nota final de cada camper por módulo.

SELECT s.skill_name AS Modulo, c.id AS Camper_ID, p.first_name AS Nombre, p.last_names AS Apellidos,
    ROUND(
        SUM(CASE WHEN ec.component_type = 'Teorico' THEN ec.note * s.theoretical_weight/100 ELSE 0 END) +
        SUM(CASE WHEN ec.component_type = 'Practico' THEN ec.note * s.practical_weight/100 ELSE 0 END) +
        SUM(CASE WHEN ec.component_type = 'Quiz' THEN ec.note * s.quizzes_weight/100 ELSE 0 END)
    , 2) AS Nota_Final
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN evaluations e ON c.id = e.camper_id
INNER JOIN evaluation_components ec ON e.id = ec.evaluation_id
INNER JOIN skills s ON e.skill_id = s.id
GROUP BY s.id, c.id
ORDER BY s.skill_name, Nota_Final DESC;

-- 3. Mostrar los campers que reprobaron algún módulo (nota < 60).

SELECT s.skill_name AS Modulo, c.id AS Camper_ID, p.first_name AS Nombre, p.last_names AS Apellidos,
    ROUND(
        SUM(CASE WHEN ec.component_type = 'Teorico' THEN ec.note * s.theoretical_weight/100 ELSE 0 END) +
        SUM(CASE WHEN ec.component_type = 'Practico' THEN ec.note * s.practical_weight/100 ELSE 0 END) +
        SUM(CASE WHEN ec.component_type = 'Quiz' THEN ec.note * s.quizzes_weight/100 ELSE 0 END)
    , 2) AS Nota_Final
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN evaluations e ON c.id = e.camper_id
INNER JOIN evaluation_components ec ON e.id = ec.evaluation_id
INNER JOIN skills s ON e.skill_id = s.id
GROUP BY s.id, c.id
HAVING Nota_Final < 60
ORDER BY s.skill_name, Nota_Final;

-- 4. Listar los módulos con más campers en bajo rendimiento.

SELECT s.skill_name AS Modulo, COUNT(c.id) AS Campers_Bajo_Rendimiento
FROM camper c
INNER JOIN evaluations e ON c.id = e.camper_id
INNER JOIN skills s ON e.skill_id = s.id
WHERE e.camper_state = 'Reprobado' OR e.final_grade < 60
GROUP BY s.id
ORDER BY Campers_Bajo_Rendimiento DESC;

-- 5. Obtener el promedio de notas finales por cada módulo.

SELECT s.skill_name AS Modulo, ROUND(AVG(e.final_grade), 2) AS Promedio_Notas
FROM evaluations e
INNER JOIN skills s ON e.skill_id = s.id
GROUP BY s.id
ORDER BY Promedio_Notas DESC;

-- 6. Consultar el rendimiento general por ruta de entrenamiento.

SELECT r.route_name AS Ruta, ROUND(AVG(e.final_grade), 2) AS Promedio_Ruta,
    COUNT(CASE WHEN e.camper_state = 'Aprobado' THEN 1 END) AS Aprobados,
    COUNT(CASE WHEN e.camper_state = 'Reprobado' THEN 1 END) AS Reprobados
FROM evaluations e
INNER JOIN camper c ON e.camper_id = c.id
INNER JOIN camper_route_enrollments cre ON c.id = cre.camper_id
INNER JOIN routes r ON cre.route_id = r.id
GROUP BY r.id
ORDER BY Promedio_Ruta DESC;

-- 7. Mostrar los trainers responsables de campers con bajo rendimiento.

SELECT t.id AS Trainer_ID, p.first_name AS Nombre_Trainer, p.last_names AS Apellidos_Trainer, COUNT(DISTINCT c.id) AS Cantidad_Campers_Bajo_Rendimiento
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
INNER JOIN campers_group_members cgm ON ts.campers_group_id = cgm.group_id
INNER JOIN camper c ON cgm.camper_id = c.id
INNER JOIN evaluations e ON c.id = e.camper_id
WHERE e.camper_state = 'Reprobado' OR e.final_grade < 60
GROUP BY t.id
ORDER BY Cantidad_Campers_Bajo_Rendimiento DESC;

-- 8. Comparar el promedio de rendimiento por trainer.

SELECT t.id AS Trainer_ID, p.first_name AS Nombre_Trainer, p.last_names AS Apellidos_Trainer, ROUND(AVG(e.final_grade), 2) AS Promedio_Notas_Grupo
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
INNER JOIN campers_group_members cgm ON ts.campers_group_id = cgm.group_id
INNER JOIN camper c ON cgm.camper_id = c.id
INNER JOIN evaluations e ON c.id = e.camper_id
GROUP BY t.id
ORDER BY Promedio_Notas_Grupo DESC;

-- 9. Listar los mejores 5 campers por nota final en cada ruta.

SELECT Ruta, Camper_ID, Nombre, Apellidos, Nota_Final
FROM (
    SELECT r.route_name AS Ruta, c.id AS Camper_ID, p.first_name AS Nombre, p.last_names AS Apellidos,
        ROUND(AVG(e.final_grade), 2) AS Nota_Final,
        ROW_NUMBER() OVER (PARTITION BY r.id ORDER BY AVG(e.final_grade) DESC) AS rn
    FROM camper c
    INNER JOIN person p ON c.person_id = p.id
    INNER JOIN evaluations e ON c.id = e.camper_id
    INNER JOIN camper_route_enrollments cre ON c.id = cre.camper_id
    INNER JOIN routes r ON cre.route_id = r.id
    GROUP BY r.id, c.id
) ranked
WHERE rn <= 5
ORDER BY Ruta, Nota_Final DESC;

-- 10. Mostrar cuántos campers pasaron cada módulo por ruta.

SELECT r.route_name AS Ruta, s.skill_name AS Modulo,
    COUNT(CASE WHEN e.camper_state = 'Aprobado' THEN 1 END) AS Campers_Aprobados,
    COUNT(CASE WHEN e.camper_state = 'Reprobado' THEN 1 END) AS Campers_Reprobados,
    COUNT(e.camper_id) AS Total_Evaluados
FROM evaluations e
INNER JOIN skills s ON e.skill_id = s.id
INNER JOIN camper c ON e.camper_id = c.id
INNER JOIN camper_route_enrollments cre ON c.id = cre.camper_id
INNER JOIN routes r ON cre.route_id = r.id
GROUP BY r.id, s.id
ORDER BY r.route_name, s.skill_name;

-- Rutas y Áreas de Entrenamiento

-- 1. Mostrar todas las rutas de entrenamiento disponibles.

SELECT route_name AS Ruta
FROM routes;

-- 2. Obtener las rutas con su SGDB principal y alternativo.

SELECT route_name AS Ruta, main_sgbd AS SGDB_Principal, alternative_sgbd AS SGDB_Alternativo
FROM routes;

-- 3. Listar los módulos asociados a cada ruta.

SELECT r.route_name AS Ruta, s.skill_name AS Modulo
FROM routes r
INNER JOIN route_skills rs ON r.id = rs.route_id
INNER JOIN skills s ON rs.skill_id = s.id;

-- 4. Consultar cuántos campers hay en cada ruta.

SELECT r.route_name AS Ruta, COUNT(c.id) AS Campers_En_Ruta
FROM routes r
INNER JOIN camper_route_enrollments cre ON r.id = cre.route_id
INNER JOIN camper c ON cre.camper_id = c.id
GROUP BY r.id;

-- 5. Mostrar las áreas de entrenamiento y su capacidad máxima.

SELECT a.area_name AS Area, a.capacity AS Capacidad_Maxima
FROM training_areas a;

-- 6. Obtener las áreas que están ocupadas al 100%.

SELECT ta.area_name AS Area_Entrenamiento, ta.capacity AS Capacidad_Maxima, COUNT(cgm.camper_id) AS Campers_Asignados
FROM training_areas ta
INNER JOIN route_assignments ra ON ta.id = ra.area_id
INNER JOIN campers_group cg ON ra.campers_group_id = cg.id
INNER JOIN campers_group_members cgm ON cg.id = cgm.group_id
GROUP BY ta.id
HAVING COUNT(cgm.camper_id) >= ta.capacity
ORDER BY ta.area_name;

-- 7. Verificar la ocupación actual de cada área.

SELECT ta.area_name AS Area_Entrenamiento, ta.capacity AS Capacidad_Maxima, COUNT(cgm.camper_id) AS Campers_Asignados, ROUND((COUNT(cgm.camper_id) / ta.capacity) * 100, 2) AS Porcentaje_Ocupacion
FROM training_areas ta
LEFT JOIN route_assignments ra ON ta.id = ra.area_id
LEFT JOIN campers_group cg ON ra.campers_group_id = cg.id
LEFT JOIN campers_group_members cgm ON cg.id = cgm.group_id
WHERE ta.training_areas_status = 'Activo'
GROUP BY ta.id
ORDER BY Porcentaje_Ocupacion DESC;

-- 8. Consultar los horarios disponibles por cada área.

    SELECT ta.area_name AS Area_Entrenamiento, s.day_of_week AS Dia, s.start_time AS Hora_Inicio, s.end_time AS Hora_Fin,
        CASE 
            WHEN ts.id IS NULL THEN 'Disponible' 
            ELSE 'Ocupado' 
        END AS Estado
    FROM training_areas ta
    CROSS JOIN schedules s
    LEFT JOIN trainer_schedule ts ON ta.id = ts.area_id AND s.id = ts.schedule_id
    WHERE ta.training_areas_status = 'Activo'
    ORDER BY ta.area_name, s.day_of_week, s.start_time;

-- 9. Mostrar las áreas con más campers asignados.

SELECT ta.area_name AS Area_Entrenamiento, COUNT(cgm.camper_id) AS Cantidad_Campers
FROM training_areas ta
LEFT JOIN route_assignments ra ON ta.id = ra.area_id
LEFT JOIN campers_group cg ON ra.campers_group_id = cg.id
LEFT JOIN campers_group_members cgm ON cg.id = cgm.group_id
GROUP BY ta.id
ORDER BY Cantidad_Campers DESC;

-- 10. Listar las rutas con sus respectivos trainers y áreas asignadas.

SELECT r.route_name AS Ruta, p.first_name AS Nombre_Trainer, p.last_names AS Apellidos_Trainer, ta.area_name AS Area_Entrenamiento, cg.group_name AS Grupo_Campers
FROM routes r
INNER JOIN route_assignments ra ON r.id = ra.route_id
INNER JOIN trainer t ON ra.trainer_id = t.id
INNER JOIN person p ON t.person_id = p.id
INNER JOIN training_areas ta ON ra.area_id = ta.id
INNER JOIN campers_group cg ON ra.campers_group_id = cg.id
ORDER BY r.route_name, ta.area_name;

-- Trainers

-- 1. Listar todos los entrenadores registrados.

SELECT t.id AS Trainer_ID, p.first_name AS Nombre, p.last_names AS Apellidos, p.email AS Email, b.branch_name AS Sede
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN branches b ON t.branch_id = b.id;

-- 2. Mostrar los trainers con sus horarios asignados.

SELECT t.id AS Trainer_ID, p.first_name AS Nombre, p.last_names AS Apellidos, 
       s.day_of_week AS Dia, s.start_time AS Hora_Inicio, s.end_time AS Hora_Fin,
       ta.area_name AS Area, r.route_name AS Ruta
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
INNER JOIN schedules s ON ts.schedule_id = s.id
INNER JOIN training_areas ta ON ts.area_id = ta.id
INNER JOIN routes r ON ts.route_id = r.id
ORDER BY t.id, s.day_of_week, s.start_time;

-- 3. Consultar los trainers asignados a más de una ruta.

SELECT t.id AS Trainer_ID, p.first_name AS Nombre, p.last_names AS Apellidos, COUNT(DISTINCT ts.route_id) AS Cantidad_Rutas
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
GROUP BY t.id
HAVING COUNT(DISTINCT ts.route_id) > 1
ORDER BY Cantidad_Rutas DESC;

-- 4. Obtener el número de campers por trainer.

SELECT t.id AS Trainer_ID, p.first_name AS Nombre, p.last_names AS Apellidos, COUNT(DISTINCT cgm.camper_id) AS Cantidad_Campers
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
INNER JOIN campers_group_members cgm ON ts.campers_group_id = cgm.group_id
GROUP BY t.id
ORDER BY Cantidad_Campers DESC;

-- 5. Mostrar las áreas en las que trabaja cada trainer.

SELECT t.id AS Trainer_ID, p.first_name AS Nombre, p.last_names AS Apellidos, 
       GROUP_CONCAT(DISTINCT ta.area_name ORDER BY ta.area_name SEPARATOR ', ') AS Areas_Asignadas
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
INNER JOIN training_areas ta ON ts.area_id = ta.id
GROUP BY t.id;

-- 6. Listar los trainers sin asignación de área o ruta.

SELECT t.id AS Trainer_ID, p.first_name AS Nombre, p.last_names AS Apellidos, p.email AS Email
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
LEFT JOIN trainer_schedule ts ON t.id = ts.trainer_id
WHERE ts.id IS NULL;

-- 7. Mostrar cuántos módulos están a cargo de cada trainer.

SELECT t.id AS Trainer_ID, p.first_name AS Nombre, p.last_names AS Apellidos, 
       COUNT(tma.module_id) AS Cantidad_Modulos,
       GROUP_CONCAT(m.module_name ORDER BY m.module_name SEPARATOR ', ') AS Modulos_Asignados
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
LEFT JOIN trainer_module_assignments tma ON t.id = tma.trainer_id
LEFT JOIN modules m ON tma.module_id = m.id
GROUP BY t.id
ORDER BY Cantidad_Modulos DESC;

-- 8. Obtener el trainer con mejor rendimiento promedio de campers.

SELECT t.id AS Trainer_ID, p.first_name AS Nombre, p.last_names AS Apellidos, ROUND(AVG(e.final_grade), 2) AS Promedio_Notas
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
INNER JOIN campers_group_members cgm ON ts.campers_group_id = cgm.group_id
INNER JOIN camper c ON cgm.camper_id = c.id
INNER JOIN evaluations e ON c.id = e.camper_id
GROUP BY t.id
ORDER BY Promedio_Notas DESC
LIMIT 1;

-- 9. Consultar los horarios ocupados por cada trainer.

SELECT t.id AS Trainer_ID, p.first_name AS Nombre, p.last_names AS Apellidos, 
       s.day_of_week AS Dia, s.start_time AS Hora_Inicio, s.end_time AS Hora_Fin,
       ta.area_name AS Area, r.route_name AS Ruta
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
INNER JOIN schedules s ON ts.schedule_id = s.id
INNER JOIN training_areas ta ON ts.area_id = ta.id
INNER JOIN routes r ON ts.route_id = r.id
ORDER BY t.id, s.day_of_week, s.start_time;

-- 10. Mostrar la disponibilidad semanal de cada trainer.

SELECT t.id AS Trainer_ID, p.first_name AS Nombre, p.last_names AS Apellidos, 
       s.day_of_week AS Dia, s.start_time AS Hora_Inicio, s.end_time AS Hora_Fin,
       CASE 
           WHEN ts.id IS NULL THEN 'Disponible' 
           ELSE 'Ocupado' 
       END AS Estado
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
CROSS JOIN schedules s
LEFT JOIN trainer_schedule ts ON t.id = ts.trainer_id AND s.id = ts.schedule_id
ORDER BY t.id, s.day_of_week, s.start_time;

-- Consultas con Subconsultas y Cálculos Avanzados

-- 1. Obtener los campers con la nota más alta en cada módulo.

SELECT s.skill_name AS Modulo, p.first_name AS Nombre, p.last_names AS Apellidos, e.final_grade AS Nota_Final
FROM evaluations e
INNER JOIN (
    SELECT skill_id, MAX(final_grade) as max_grade
    FROM evaluations
    GROUP BY skill_id
) max_grades ON e.skill_id = max_grades.skill_id AND e.final_grade = max_grades.max_grade
INNER JOIN camper c ON e.camper_id = c.id
INNER JOIN person p ON c.person_id = p.id
INNER JOIN skills s ON e.skill_id = s.id
ORDER BY s.skill_name;

-- 2. Mostrar el promedio general de notas por ruta y comparar con el promedio global.

WITH PromedioGlobal AS (
    SELECT ROUND(AVG(e.final_grade), 2) AS Promedio_Global
    FROM evaluations e
)
SELECT r.route_name AS Ruta, 
       ROUND(AVG(e.final_grade), 2) AS Promedio_Ruta,
       (SELECT Promedio_Global FROM PromedioGlobal) AS Promedio_Global,
       ROUND(AVG(e.final_grade) - (SELECT Promedio_Global FROM PromedioGlobal), 2) AS Diferencia
FROM evaluations e
INNER JOIN camper c ON e.camper_id = c.id
INNER JOIN camper_route_enrollments cre ON c.id = cre.camper_id
INNER JOIN routes r ON cre.route_id = r.id
GROUP BY r.id
ORDER BY Diferencia DESC;

-- 3. Listar las áreas con más del 80% de ocupación.

SELECT 
    ta.area_name AS Area_Entrenamiento,
    ta.capacity AS Capacidad_Maxima,
    COUNT(cgm.camper_id) AS Campers_Asignados,
    ROUND((COUNT(cgm.camper_id) / ta.capacity) * 100, 2) AS Porcentaje_Ocupacion
FROM training_areas ta
LEFT JOIN route_assignments ra ON ta.id = ra.area_id
LEFT JOIN campers_group cg ON ra.campers_group_id = cg.id
LEFT JOIN campers_group_members cgm ON cg.id = cgm.group_id
GROUP BY ta.id
HAVING Porcentaje_Ocupacion > 80
ORDER BY Porcentaje_Ocupacion DESC;

-- 4. Mostrar los trainers con menos del 70% de rendimiento promedio.

WITH RendimientoGlobal AS (
    SELECT ROUND(AVG(e.final_grade), 2) AS Promedio_Global
    FROM evaluations e
)
SELECT 
    t.id AS Trainer_ID, 
    p.first_name AS Nombre, 
    p.last_names AS Apellidos,
    ROUND(AVG(e.final_grade), 2) AS Promedio_Trainer,
    (SELECT Promedio_Global FROM RendimientoGlobal) AS Promedio_Global,
    ROUND((AVG(e.final_grade) / (SELECT Promedio_Global FROM RendimientoGlobal)) * 100, 2) AS Porcentaje_Rendimiento
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
INNER JOIN campers_group_members cgm ON ts.campers_group_id = cgm.group_id
INNER JOIN camper c ON cgm.camper_id = c.id
INNER JOIN evaluations e ON c.id = e.camper_id
GROUP BY t.id
HAVING Porcentaje_Rendimiento < 70
ORDER BY Porcentaje_Rendimiento;

-- 5. Consultar los campers cuyo promedio está por debajo del promedio general.

WITH PromedioGlobal AS (
    SELECT AVG(e.final_grade) AS Promedio_Global
    FROM evaluations e
),
PromedioCamper AS (
    SELECT c.id AS camper_id, p.first_name, p.last_names, AVG(e.final_grade) AS Promedio_Individual
    FROM camper c
    INNER JOIN person p ON c.person_id = p.id
    INNER JOIN evaluations e ON c.id = e.camper_id
    GROUP BY c.id
)
SELECT pc.camper_id AS Camper_ID, pc.first_name AS Nombre, pc.last_names AS Apellidos, 
       ROUND(pc.Promedio_Individual, 2) AS Promedio_Individual,
       ROUND((SELECT Promedio_Global FROM PromedioGlobal), 2) AS Promedio_Global
FROM PromedioCamper pc
WHERE pc.Promedio_Individual < (SELECT Promedio_Global FROM PromedioGlobal)
ORDER BY pc.Promedio_Individual;

-- 6. Obtener los módulos con la menor tasa de aprobación.

SELECT 
    s.skill_name AS Modulo,
    COUNT(e.id) AS Total_Evaluaciones,
    COUNT(CASE WHEN e.camper_state = 'Aprobado' THEN 1 END) AS Aprobados,
    COUNT(CASE WHEN e.camper_state = 'Reprobado' THEN 1 END) AS Reprobados,
    ROUND((COUNT(CASE WHEN e.camper_state = 'Aprobado' THEN 1 END) / COUNT(e.id)) * 100, 2) AS Tasa_Aprobacion
FROM evaluations e
INNER JOIN skills s ON e.skill_id = s.id
GROUP BY s.id
HAVING COUNT(e.id) > 0
ORDER BY Tasa_Aprobacion ASC
LIMIT 5;

-- 7. Listar los campers que han aprobado todos los módulos de su ruta.

WITH ModulosPorRuta AS (
    SELECT r.id AS route_id, COUNT(rs.skill_id) AS total_modulos
    FROM routes r
    INNER JOIN route_skills rs ON r.id = rs.route_id
    GROUP BY r.id
),
ModulosAprobadosPorCamper AS (
    SELECT cre.camper_id, cre.route_id, COUNT(CASE WHEN e.final_grade >= 60 THEN 1 END) AS modulos_aprobados
    FROM camper_route_enrollments cre
    INNER JOIN evaluations e ON cre.camper_id = e.camper_id
    INNER JOIN route_skills rs ON cre.route_id = rs.route_id AND e.skill_id = rs.skill_id
    GROUP BY cre.camper_id, cre.route_id
)
SELECT c.id AS Camper_ID, p.first_name AS Nombre, p.last_names AS Apellidos, 
       r.route_name AS Ruta, mac.modulos_aprobados AS Modulos_Aprobados, mpr.total_modulos AS Total_Modulos
FROM ModulosAprobadosPorCamper mac
INNER JOIN ModulosPorRuta mpr ON mac.route_id = mpr.route_id
INNER JOIN camper c ON mac.camper_id = c.id
INNER JOIN person p ON c.person_id = p.id
INNER JOIN routes r ON mac.route_id = r.id
WHERE mac.modulos_aprobados = mpr.total_modulos;

-- 8. Mostrar rutas con más de 10 campers en bajo rendimiento.

SELECT 
    r.route_name AS Ruta,
    COUNT(DISTINCT c.id) AS Campers_Bajo_Rendimiento
FROM routes r
INNER JOIN camper_route_enrollments cre ON r.id = cre.route_id
INNER JOIN camper c ON cre.camper_id = c.id
INNER JOIN evaluations e ON c.id = e.camper_id
WHERE c.camper_performance = 'Bajo' OR e.camper_state = 'Reprobado' OR e.final_grade < 60
GROUP BY r.id
HAVING COUNT(DISTINCT c.id) > 10
ORDER BY Campers_Bajo_Rendimiento DESC;

-- 9. Calcular el promedio de rendimiento por SGDB principal.

SELECT 
    sg_main.sgbd_name AS SGBD_Principal,
    ROUND(AVG(e.final_grade), 2) AS Promedio_Rendimiento,
    COUNT(DISTINCT c.id) AS Total_Campers
FROM evaluations e
INNER JOIN camper c ON e.camper_id = c.id
INNER JOIN camper_route_enrollments cre ON c.id = cre.camper_id
INNER JOIN routes r ON cre.route_id = r.id
INNER JOIN sgbds sg_main ON r.main_sgbd = sg_main.id
GROUP BY sg_main.id
ORDER BY Promedio_Rendimiento DESC;

-- 10. Listar los módulos con al menos un 30% de campers reprobados.

SELECT 
    s.skill_name AS Modulo,
    COUNT(e.id) AS Total_Evaluaciones,
    COUNT(CASE WHEN e.camper_state = 'Reprobado' THEN 1 END) AS Reprobados,
    ROUND((COUNT(CASE WHEN e.camper_state = 'Reprobado' THEN 1 END) / COUNT(e.id)) * 100, 2) AS Porcentaje_Reprobados
FROM evaluations e
INNER JOIN skills s ON e.skill_id = s.id
GROUP BY s.id
HAVING Porcentaje_Reprobados >= 30
ORDER BY Porcentaje_Reprobados DESC;

-- 11. Mostrar el módulo más cursado por campers con riesgo alto.

SELECT 
    s.skill_name AS Modulo,
    COUNT(DISTINCT c.id) AS Cantidad_Campers_Riesgo_Alto
FROM skills s
INNER JOIN evaluations e ON s.id = e.skill_id
INNER JOIN camper c ON e.camper_id = c.id
WHERE c.risk_level = 'Alto'
GROUP BY s.id
ORDER BY Cantidad_Campers_Riesgo_Alto DESC
LIMIT 1;

-- 12. Consultar los trainers con más de 3 rutas asignadas.

SELECT 
    t.id AS Trainer_ID,
    p.first_name AS Nombre,
    p.last_names AS Apellidos,
    COUNT(DISTINCT ts.route_id) AS Cantidad_Rutas,
    GROUP_CONCAT(DISTINCT r.route_name ORDER BY r.route_name SEPARATOR ', ') AS Rutas_Asignadas
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
INNER JOIN routes r ON ts.route_id = r.id
GROUP BY t.id
HAVING COUNT(DISTINCT ts.route_id) > 3
ORDER BY Cantidad_Rutas DESC;

-- 13. Listar los horarios más ocupados por áreas.

SELECT 
    ta.area_name AS Area,
    s.day_of_week AS Dia,
    s.start_time AS Hora_Inicio,
    s.end_time AS Hora_Fin,
    COUNT(ts.id) AS Cantidad_Asignaciones
FROM training_areas ta
INNER JOIN trainer_schedule ts ON ta.id = ts.area_id
INNER JOIN schedules s ON ts.schedule_id = s.id
GROUP BY ta.id, s.id
ORDER BY Cantidad_Asignaciones DESC, ta.area_name, s.day_of_week, s.start_time
LIMIT 10;

-- 14. Consultar las rutas con el mayor número de módulos.

SELECT 
    r.route_name AS Ruta,
    COUNT(rs.skill_id) AS Cantidad_Modulos,
    GROUP_CONCAT(s.skill_name ORDER BY s.skill_name SEPARATOR ', ') AS Modulos
FROM routes r
INNER JOIN route_skills rs ON r.id = rs.route_id
INNER JOIN skills s ON rs.skill_id = s.id
GROUP BY r.id
ORDER BY Cantidad_Modulos DESC;

-- 15. Obtener los campers que han cambiado de estado más de una vez.

SELECT 
    c.id AS Camper_ID,
    p.first_name AS Nombre,
    p.last_names AS Apellidos,
    COUNT(csh.id) AS Cantidad_Cambios_Estado,
    GROUP_CONCAT(CONCAT(csh.old_state, ' -> ', csh.new_state) ORDER BY csh.change_date SEPARATOR ', ') AS Historial_Cambios
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN camper_state_history csh ON c.id = csh.camper_id
GROUP BY c.id
HAVING COUNT(csh.id) > 1
ORDER BY Cantidad_Cambios_Estado DESC;

-- 16. Mostrar las evaluaciones donde la nota teórica sea mayor a la práctica.

SELECT 
    s.skill_name AS Modulo,
    c.id AS Camper_ID,
    p.first_name AS Nombre,
    p.last_names AS Apellidos,
    teorico.note AS Nota_Teorica,
    practico.note AS Nota_Practica,
    (teorico.note - practico.note) AS Diferencia
FROM evaluations e
INNER JOIN skills s ON e.skill_id = s.id
INNER JOIN camper c ON e.camper_id = c.id
INNER JOIN person p ON c.person_id = p.id
INNER JOIN evaluation_components teorico ON e.id = teorico.evaluation_id AND teorico.component_type = 'Teorico'
INNER JOIN evaluation_components practico ON e.id = practico.evaluation_id AND practico.component_type = 'Practico'
WHERE teorico.note > practico.note
ORDER BY Diferencia DESC;

-- 17. Listar los módulos donde la media de quizzes supera el 90.

SELECT 
    s.skill_name AS Modulo,
    ROUND(AVG(ec.note), 2) AS Promedio_Quizzes,
    COUNT(DISTINCT e.camper_id) AS Cantidad_Campers
FROM skills s
INNER JOIN evaluations e ON s.id = e.skill_id
INNER JOIN evaluation_components ec ON e.id = ec.evaluation_id
WHERE ec.component_type = 'Quiz'
GROUP BY s.id
HAVING AVG(ec.note) > 90
ORDER BY Promedio_Quizzes DESC;

-- 18. Consultar la ruta con mayor tasa de graduación.

WITH GraduadosPorRuta AS (
    SELECT 
        r.id AS route_id,
        r.route_name AS route_name,
        COUNT(DISTINCT a.camper_id) AS graduados
    FROM routes r
    LEFT JOIN alumni a ON r.id = a.route_id
    GROUP BY r.id
),
InscritosPorRuta AS (
    SELECT 
        r.id AS route_id,
        COUNT(DISTINCT cre.camper_id) AS inscritos
    FROM routes r
    LEFT JOIN camper_route_enrollments cre ON r.id = cre.route_id
    GROUP BY r.id
)
SELECT 
    gpr.route_name AS Ruta,
    gpr.graduados AS Graduados,
    ipr.inscritos AS Inscritos_Totales,
    ROUND((gpr.graduados / ipr.inscritos) * 100, 2) AS Tasa_Graduacion
FROM GraduadosPorRuta gpr
INNER JOIN InscritosPorRuta ipr ON gpr.route_id = ipr.route_id
WHERE ipr.inscritos > 0
ORDER BY Tasa_Graduacion DESC
LIMIT 1;

-- 19. Mostrar los módulos cursados por campers de nivel de riesgo medio o alto.

SELECT 
    s.skill_name AS Modulo,
    COUNT(DISTINCT CASE WHEN c.risk_level = 'Alto' THEN c.id END) AS Campers_Riesgo_Alto,
    COUNT(DISTINCT CASE WHEN c.risk_level = 'Medio' THEN c.id END) AS Campers_Riesgo_Medio,
    COUNT(DISTINCT c.id) AS Total_Campers
FROM skills s
INNER JOIN evaluations e ON s.id = e.skill_id
INNER JOIN camper c ON e.camper_id = c.id
WHERE c.risk_level IN ('Medio', 'Alto')
GROUP BY s.id
ORDER BY Campers_Riesgo_Alto DESC, Campers_Riesgo_Medio DESC;

-- 20. Obtener la diferencia entre capacidad y ocupación en cada área.

SELECT 
    ta.area_name AS Area,
    ta.capacity AS Capacidad_Maxima,
    COUNT(DISTINCT cgm.camper_id) AS Campers_Asignados,
    (ta.capacity - COUNT(DISTINCT cgm.camper_id)) AS Espacios_Disponibles,
    ROUND((COUNT(DISTINCT cgm.camper_id) / ta.capacity) * 100, 2) AS Porcentaje_Ocupacion
FROM training_areas ta
LEFT JOIN route_assignments ra ON ta.id = ra.area_id
LEFT JOIN campers_group cg ON ra.campers_group_id = cg.id
LEFT JOIN campers_group_members cgm ON cg.id = cgm.group_id
GROUP BY ta.id
ORDER BY Porcentaje_Ocupacion DESC;

-- JOINs Básicos

-- 1. Obtener los nombres completos de los campers junto con el nombre de la ruta a la que están inscritos.

SELECT p.first_name AS Nombre, p.last_names AS Apellidos, r.route_name AS Ruta
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN camper_route_enrollments cre ON c.id = cre.camper_id
INNER JOIN routes r ON cre.route_id = r.id
ORDER BY r.route_name, p.last_names, p.first_name;

-- 2. Mostrar los campers con sus evaluaciones (nota teórica, práctica, quizzes y nota final) por cada módulo.

SELECT 
    p.first_name AS Nombre, 
    p.last_names AS Apellidos, 
    s.skill_name AS Modulo,
    MAX(CASE WHEN ec.component_type = 'Teorico' THEN ec.note ELSE 0 END) AS Nota_Teorica,
    MAX(CASE WHEN ec.component_type = 'Practico' THEN ec.note ELSE 0 END) AS Nota_Practica,
    MAX(CASE WHEN ec.component_type = 'Quiz' THEN ec.note ELSE 0 END) AS Nota_Quiz,
    e.final_grade AS Nota_Final
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN evaluations e ON c.id = e.camper_id
INNER JOIN skills s ON e.skill_id = s.id
INNER JOIN evaluation_components ec ON e.id = ec.evaluation_id
GROUP BY c.id, s.id, e.id
ORDER BY p.last_names, p.first_name, s.skill_name;

-- 3. Listar todos los módulos que componen cada ruta de entrenamiento.

SELECT 
    r.route_name AS Ruta, 
    s.skill_name AS Modulo,
    s.theoretical_weight AS Peso_Teorico,
    s.practical_weight AS Peso_Practico,
    s.quizzes_weight AS Peso_Quiz
FROM routes r
INNER JOIN route_skills rs ON r.id = rs.route_id
INNER JOIN skills s ON rs.skill_id = s.id
ORDER BY r.route_name, s.skill_name;

-- 4. Consultar las rutas con sus trainers asignados y las áreas en las que imparten clases.

SELECT 
    r.route_name AS Ruta, 
    p.first_name AS Nombre_Trainer, 
    p.last_names AS Apellidos_Trainer, 
    ta.area_name AS Area_Entrenamiento
FROM routes r
INNER JOIN trainer_schedule ts ON r.id = ts.route_id
INNER JOIN trainer t ON ts.trainer_id = t.id
INNER JOIN person p ON t.person_id = p.id
INNER JOIN training_areas ta ON ts.area_id = ta.id
ORDER BY r.route_name, p.last_names, p.first_name, ta.area_name;

-- 5. Mostrar los campers junto con el trainer responsable de su ruta actual.

SELECT 
    pc.first_name AS Nombre_Camper, 
    pc.last_names AS Apellidos_Camper,
    r.route_name AS Ruta,
    pt.first_name AS Nombre_Trainer, 
    pt.last_names AS Apellidos_Trainer
FROM camper c
INNER JOIN person pc ON c.person_id = pc.id
INNER JOIN camper_route_enrollments cre ON c.id = cre.camper_id
INNER JOIN routes r ON cre.route_id = r.id
INNER JOIN campers_group_members cgm ON c.id = cgm.camper_id
INNER JOIN trainer_schedule ts ON cgm.group_id = ts.campers_group_id AND ts.route_id = r.id
INNER JOIN trainer t ON ts.trainer_id = t.id
INNER JOIN person pt ON t.person_id = pt.id
ORDER BY pc.last_names, pc.first_name;

-- 6. Obtener el listado de evaluaciones realizadas con nombre de camper, módulo y ruta.

SELECT 
    p.first_name AS Nombre_Camper, 
    p.last_names AS Apellidos_Camper,
    s.skill_name AS Modulo,
    e.final_grade AS Nota_Final,
    e.camper_state AS Estado,
    r.route_name AS Ruta
FROM evaluations e
INNER JOIN camper c ON e.camper_id = c.id
INNER JOIN person p ON c.person_id = p.id
INNER JOIN skills s ON e.skill_id = s.id
INNER JOIN camper_route_enrollments cre ON c.id = cre.camper_id
INNER JOIN routes r ON cre.route_id = r.id
ORDER BY r.route_name, s.skill_name, p.last_names, p.first_name;

-- 7. Listar los trainers y los horarios en que están asignados a las áreas de entrenamiento.

SELECT 
    p.first_name AS Nombre_Trainer, 
    p.last_names AS Apellidos_Trainer,
    ta.area_name AS Area,
    s.day_of_week AS Dia,
    s.start_time AS Hora_Inicio,
    s.end_time AS Hora_Fin,
    r.route_name AS Ruta
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
INNER JOIN schedules s ON ts.schedule_id = s.id
INNER JOIN training_areas ta ON ts.area_id = ta.id
INNER JOIN routes r ON ts.route_id = r.id
ORDER BY p.last_names, p.first_name, s.day_of_week, s.start_time;

-- 8. Consultar todos los campers junto con su estado actual y el nivel de riesgo.

SELECT 
    p.first_name AS Nombre, 
    p.last_names AS Apellidos,
    p.document_number AS Documento,
    c.status_camper AS Estado,
    c.risk_level AS Nivel_Riesgo,
    CASE 
        WHEN c.risk_level = 'Alto' THEN 'Requiere atención inmediata'
        WHEN c.risk_level = 'Medio' THEN 'Seguimiento regular'
        WHEN c.risk_level = 'Bajo' THEN 'Progreso normal'
        ELSE 'No evaluado'
    END AS Recomendacion
FROM camper c
INNER JOIN person p ON c.person_id = p.id
ORDER BY 
    CASE 
        WHEN c.risk_level = 'Alto' THEN 1
        WHEN c.risk_level = 'Medio' THEN 2
        WHEN c.risk_level = 'Bajo' THEN 3
        ELSE 4
    END,
    p.last_names, p.first_name;

-- 9. Obtener todos los módulos de cada ruta junto con su porcentaje teórico, práctico y de quizzes.

SELECT 
    r.route_name AS Ruta,
    s.skill_name AS Modulo,
    s.theoretical_weight AS Porcentaje_Teorico,
    s.practical_weight AS Porcentaje_Practico,
    s.quizzes_weight AS Porcentaje_Quizzes,
    CASE 
        WHEN (s.theoretical_weight + s.practical_weight + s.quizzes_weight) = 100 THEN 'Correcto'
        ELSE 'Revisar pesos'
    END AS Validacion_Pesos
FROM routes r
INNER JOIN route_skills rs ON r.id = rs.route_id
INNER JOIN skills s ON rs.skill_id = s.id
ORDER BY r.route_name, s.skill_name;

-- 10. Mostrar los nombres de las áreas junto con los nombres de los campers que están asistiendo en esos espacios.

SELECT 
    ta.area_name AS Area_Entrenamiento,
    p.first_name AS Nombre_Camper,
    p.last_names AS Apellidos_Camper,
    r.route_name AS Ruta
FROM training_areas ta
INNER JOIN route_assignments ra ON ta.id = ra.area_id
INNER JOIN campers_group cg ON ra.campers_group_id = cg.id
INNER JOIN campers_group_members cgm ON cg.id = cgm.group_id
INNER JOIN camper c ON cgm.camper_id = c.id
INNER JOIN person p ON c.person_id = p.id
INNER JOIN routes r ON ra.route_id = r.id
ORDER BY ta.area_name, p.last_names, p.first_name;

-- JOINs con condiciones específicas

-- 1. Listar los campers que han aprobado todos los módulos de su ruta (nota_final >= 60).

WITH ModulosPorRuta AS (
    SELECT r.id AS route_id, COUNT(rs.skill_id) AS total_modulos
    FROM routes r
    INNER JOIN route_skills rs ON r.id = rs.route_id
    GROUP BY r.id
),
ModulosAprobadosPorCamper AS (
    SELECT cre.camper_id, cre.route_id, COUNT(CASE WHEN e.final_grade >= 60 THEN 1 END) AS modulos_aprobados
    FROM camper_route_enrollments cre
    INNER JOIN evaluations e ON cre.camper_id = e.camper_id
    INNER JOIN route_skills rs ON cre.route_id = rs.route_id AND e.skill_id = rs.skill_id
    GROUP BY cre.camper_id, cre.route_id
)
SELECT c.id AS Camper_ID, p.first_name AS Nombre, p.last_names AS Apellidos, 
       r.route_name AS Ruta, mac.modulos_aprobados AS Modulos_Aprobados, mpr.total_modulos AS Total_Modulos
FROM ModulosAprobadosPorCamper mac
INNER JOIN ModulosPorRuta mpr ON mac.route_id = mpr.route_id
INNER JOIN camper c ON mac.camper_id = c.id
INNER JOIN person p ON c.person_id = p.id
INNER JOIN routes r ON mac.route_id = r.id
WHERE mac.modulos_aprobados = mpr.total_modulos;

-- 2. Mostrar las rutas que tienen más de 10 campers inscritos actualmente.

SELECT r.route_name AS Ruta, COUNT(DISTINCT c.id) AS Cantidad_Campers
FROM routes r
INNER JOIN camper_route_enrollments cre ON r.id = cre.route_id
INNER JOIN camper c ON cre.camper_id = c.id
WHERE c.status_camper = 'Inscrito'
GROUP BY r.id
HAVING COUNT(DISTINCT c.id) > 10
ORDER BY Cantidad_Campers DESC;

-- 3. Consultar las áreas que superan el 80% de su capacidad con el número actual de campers asignados.

SELECT 
    ta.area_name AS Area_Entrenamiento,
    ta.capacity AS Capacidad_Maxima,
    COUNT(DISTINCT cgm.camper_id) AS Campers_Asignados,
    ROUND((COUNT(DISTINCT cgm.camper_id) / ta.capacity) * 100, 2) AS Porcentaje_Ocupacion
FROM training_areas ta
INNER JOIN route_assignments ra ON ta.id = ra.area_id
INNER JOIN campers_group cg ON ra.campers_group_id = cg.id
INNER JOIN campers_group_members cgm ON cg.id = cgm.group_id
GROUP BY ta.id
HAVING Porcentaje_Ocupacion > 80
ORDER BY Porcentaje_Ocupacion DESC;

-- 4. Obtener los trainers que imparten más de una ruta diferente.

SELECT 
    t.id AS Trainer_ID,
    p.first_name AS Nombre,
    p.last_names AS Apellidos,
    COUNT(DISTINCT ts.route_id) AS Cantidad_Rutas,
    GROUP_CONCAT(DISTINCT r.route_name ORDER BY r.route_name SEPARATOR ', ') AS Rutas_Asignadas
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
INNER JOIN routes r ON ts.route_id = r.id
GROUP BY t.id
HAVING COUNT(DISTINCT ts.route_id) > 1
ORDER BY Cantidad_Rutas DESC;

-- 5. Listar las evaluaciones donde la nota práctica es mayor que la nota teórica.

SELECT 
    s.skill_name AS Modulo,
    c.id AS Camper_ID,
    p.first_name AS Nombre,
    p.last_names AS Apellidos,
    teorico.note AS Nota_Teorica,
    practico.note AS Nota_Practica,
    (practico.note - teorico.note) AS Diferencia
FROM evaluations e
INNER JOIN skills s ON e.skill_id = s.id
INNER JOIN camper c ON e.camper_id = c.id
INNER JOIN person p ON c.person_id = p.id
INNER JOIN evaluation_components teorico ON e.id = teorico.evaluation_id AND teorico.component_type = 'Teorico'
INNER JOIN evaluation_components practico ON e.id = practico.evaluation_id AND practico.component_type = 'Practico'
WHERE practico.note > teorico.note
ORDER BY Diferencia DESC;

-- 6. Mostrar campers que están en rutas cuyo SGDB principal es MySQL.

SELECT 
    p.first_name AS Nombre,
    p.last_names AS Apellidos,
    r.route_name AS Ruta,
    sg.sgbd_name AS SGDB_Principal
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN camper_route_enrollments cre ON c.id = cre.camper_id
INNER JOIN routes r ON cre.route_id = r.id
INNER JOIN sgbds sg ON r.main_sgbd = sg.id
WHERE sg.sgbd_name = 'MySQL'
ORDER BY p.last_names, p.first_name;

-- 7. Obtener los nombres de los módulos donde los campers han tenido bajo rendimiento.

SELECT 
    s.skill_name AS Modulo,
    COUNT(DISTINCT c.id) AS Cantidad_Campers_Bajo_Rendimiento,
    ROUND(AVG(e.final_grade), 2) AS Promedio_Notas
FROM skills s
INNER JOIN evaluations e ON s.id = e.skill_id
INNER JOIN camper c ON e.camper_id = c.id
WHERE e.final_grade < 60 OR e.camper_state = 'Reprobado'
GROUP BY s.id
HAVING COUNT(DISTINCT c.id) > 5
ORDER BY Cantidad_Campers_Bajo_Rendimiento DESC;

-- 8. Consultar las rutas con más de 3 módulos asociados.

SELECT 
    r.route_name AS Ruta,
    COUNT(rs.skill_id) AS Cantidad_Modulos,
    GROUP_CONCAT(s.skill_name ORDER BY s.skill_name SEPARATOR ', ') AS Modulos
FROM routes r
INNER JOIN route_skills rs ON r.id = rs.route_id
INNER JOIN skills s ON rs.skill_id = s.id
GROUP BY r.id
HAVING COUNT(rs.skill_id) > 3
ORDER BY Cantidad_Modulos DESC;

-- 9. Listar las inscripciones realizadas en los últimos 30 días con sus respectivos campers y rutas.

SELECT 
    p.first_name AS Nombre,
    p.last_names AS Apellidos,
    r.route_name AS Ruta,
    cre.enrollment_date AS Fecha_Inscripcion
FROM camper_route_enrollments cre
INNER JOIN camper c ON cre.camper_id = c.id
INNER JOIN person p ON c.person_id = p.id
INNER JOIN routes r ON cre.route_id = r.id
WHERE cre.enrollment_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
ORDER BY cre.enrollment_date DESC;

-- 10. Obtener los trainers que están asignados a rutas con campers en estado de "Alto Riesgo".

SELECT DISTINCT
    t.id AS Trainer_ID,
    p.first_name AS Nombre_Trainer,
    p.last_names AS Apellidos_Trainer,
    r.route_name AS Ruta,
    COUNT(DISTINCT c.id) AS Cantidad_Campers_Riesgo_Alto
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
INNER JOIN routes r ON ts.route_id = r.id
INNER JOIN camper_route_enrollments cre ON r.id = cre.route_id
INNER JOIN camper c ON cre.camper_id = c.id
WHERE c.risk_level = 'Alto'
GROUP BY t.id, r.id
ORDER BY Cantidad_Campers_Riesgo_Alto DESC;

-- JOINs con funciones de agregación

-- 1. Obtener el promedio de nota final por módulo.

SELECT 
    s.skill_name AS Modulo,
    ROUND(AVG(e.final_grade), 2) AS Promedio_Notas,
    COUNT(DISTINCT e.camper_id) AS Cantidad_Campers
FROM skills s
INNER JOIN evaluations e ON s.id = e.skill_id
GROUP BY s.id
ORDER BY Promedio_Notas DESC;

-- 2. Calcular la cantidad total de campers por ruta.

SELECT 
    r.route_name AS Ruta,
    COUNT(DISTINCT c.id) AS Total_Campers,
    COUNT(DISTINCT CASE WHEN c.status_camper = 'Inscrito' THEN c.id END) AS Campers_Activos
FROM routes r
INNER JOIN camper_route_enrollments cre ON r.id = cre.route_id
INNER JOIN camper c ON cre.camper_id = c.id
GROUP BY r.id
ORDER BY Total_Campers DESC;

-- 3. Mostrar la cantidad de evaluaciones realizadas por cada trainer.

SELECT 
    t.id AS Trainer_ID,
    p.first_name AS Nombre_Trainer,
    p.last_names AS Apellidos_Trainer,
    COUNT(DISTINCT e.id) AS Cantidad_Evaluaciones,
    ROUND(AVG(e.final_grade), 2) AS Promedio_Notas
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
INNER JOIN campers_group_members cgm ON ts.campers_group_id = cgm.group_id
INNER JOIN camper c ON cgm.camper_id = c.id
INNER JOIN evaluations e ON c.id = e.camper_id
GROUP BY t.id
ORDER BY Cantidad_Evaluaciones DESC;

-- 4. Consultar el promedio general de rendimiento por cada área de entrenamiento.

SELECT 
    ta.area_name AS Area_Entrenamiento,
    ROUND(AVG(e.final_grade), 2) AS Promedio_Rendimiento,
    COUNT(DISTINCT c.id) AS Total_Campers,
    COUNT(DISTINCT CASE WHEN e.camper_state = 'Aprobado' THEN c.id END) AS Campers_Aprobados
FROM training_areas ta
INNER JOIN route_assignments ra ON ta.id = ra.area_id
INNER JOIN campers_group cg ON ra.campers_group_id = cg.id
INNER JOIN campers_group_members cgm ON cg.id = cgm.group_id
INNER JOIN camper c ON cgm.camper_id = c.id
INNER JOIN evaluations e ON c.id = e.camper_id
GROUP BY ta.id
ORDER BY Promedio_Rendimiento DESC;

-- 5. Obtener la cantidad de módulos asociados a cada ruta de entrenamiento.

SELECT 
    r.route_name AS Ruta,
    COUNT(rs.skill_id) AS Cantidad_Modulos,
    GROUP_CONCAT(s.skill_name ORDER BY s.skill_name SEPARATOR ', ') AS Modulos
FROM routes r
INNER JOIN route_skills rs ON r.id = rs.route_id
INNER JOIN skills s ON rs.skill_id = s.id
GROUP BY r.id
ORDER BY Cantidad_Modulos DESC;

-- 6. Mostrar el promedio de nota final de los campers en estado "Cursando".

SELECT 
    r.route_name AS Ruta,
    ROUND(AVG(e.final_grade), 2) AS Promedio_Notas,
    COUNT(DISTINCT c.id) AS Cantidad_Campers
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN camper_route_enrollments cre ON c.id = cre.camper_id
INNER JOIN routes r ON cre.route_id = r.id
INNER JOIN evaluations e ON c.id = e.camper_id
WHERE c.status_camper = 'Cursando'
GROUP BY r.id
ORDER BY Promedio_Notas DESC;

-- 7. Listar el número de campers evaluados en cada módulo.

SELECT 
    s.skill_name AS Modulo,
    COUNT(DISTINCT e.camper_id) AS Campers_Evaluados,
    COUNT(DISTINCT CASE WHEN e.camper_state = 'Aprobado' THEN e.camper_id END) AS Campers_Aprobados,
    COUNT(DISTINCT CASE WHEN e.camper_state = 'Reprobado' THEN e.camper_id END) AS Campers_Reprobados
FROM skills s
INNER JOIN evaluations e ON s.id = e.skill_id
GROUP BY s.id
ORDER BY Campers_Evaluados DESC;

-- 8. Consultar el porcentaje de ocupación actual por cada área de entrenamiento.

SELECT 
    ta.area_name AS Area_Entrenamiento,
    ta.capacity AS Capacidad_Maxima,
    COUNT(DISTINCT cgm.camper_id) AS Campers_Asignados,
    ROUND((COUNT(DISTINCT cgm.camper_id) / ta.capacity) * 100, 2) AS Porcentaje_Ocupacion
FROM training_areas ta
LEFT JOIN route_assignments ra ON ta.id = ra.area_id
LEFT JOIN campers_group cg ON ra.campers_group_id = cg.id
LEFT JOIN campers_group_members cgm ON cg.id = cgm.group_id
GROUP BY ta.id
ORDER BY Porcentaje_Ocupacion DESC;

-- 9. Mostrar cuántos trainers tiene asignados cada área.

SELECT 
    ta.area_name AS Area_Entrenamiento,
    COUNT(DISTINCT t.id) AS Cantidad_Trainers,
    GROUP_CONCAT(DISTINCT CONCAT(p.first_name, ' ', p.last_names) ORDER BY p.last_names SEPARATOR ', ') AS Trainers
FROM training_areas ta
INNER JOIN trainer_schedule ts ON ta.id = ts.area_id
INNER JOIN trainer t ON ts.trainer_id = t.id
INNER JOIN person p ON t.person_id = p.id
GROUP BY ta.id
ORDER BY Cantidad_Trainers DESC;

-- 10. Listar las rutas que tienen más campers en riesgo alto.

SELECT 
    r.route_name AS Ruta,
    COUNT(DISTINCT CASE WHEN c.risk_level = 'Alto' THEN c.id END) AS Campers_Riesgo_Alto,
    COUNT(DISTINCT c.id) AS Total_Campers,
    ROUND((COUNT(DISTINCT CASE WHEN c.risk_level = 'Alto' THEN c.id END) / COUNT(DISTINCT c.id)) * 100, 2) AS Porcentaje_Riesgo_Alto
FROM routes r
INNER JOIN camper_route_enrollments cre ON r.id = cre.route_id
INNER JOIN camper c ON cre.camper_id = c.id
GROUP BY r.id
HAVING Campers_Riesgo_Alto > 0
ORDER BY Campers_Riesgo_Alto DESC;