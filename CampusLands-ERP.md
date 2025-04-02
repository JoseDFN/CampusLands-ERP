# Consultas SQL

## 👨‍🎓 Campers

### 1. Obtener todos los campers inscritos actualmente. 

```mysql
SELECT c.id, p.first_name AS Nombre, p.last_names AS Apellidos, p.document_number AS Numero_Identificacion, c.status_camper AS Status
FROM camper c
INNER JOIN person p ON c.person_id = p.id
WHERE c.status_camper = 'Inscrito';
```



### 2. Listar los campers con estado "Aprobado". 

```mysql
SELECT c.id, p.first_name AS Nombre, p.last_names AS Apellidos, p.document_number AS Numero_Identificacion, c.status_camper AS Status
FROM camper c
INNER JOIN person p ON c.person_id = p.id
WHERE c.status_camper = 'Aprobado';
```



### 3. Mostrar los campers que ya están cursando alguna ruta. 

```mysql
SELECT c.id, p.first_name AS Nombre, p.last_names AS Apellidos, p.document_number AS Numero_Identificacion, r.route_name AS Ruta
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN camper_route_enrollments cre ON c.id = cre.camper_id
INNER JOIN routes r ON cre.route_id = r.id;
```



### 4. Consultar los campers graduados por cada ruta. 

```mysql
SELECT p.first_name AS Nombre, p.last_names AS Apellidos, p.document_number AS Numero_Identificacion, r.route_name AS Ruta, a.graduation_date AS Fecha_Graduacion
FROM alumni a
INNER JOIN camper c ON a.camper_id = c.id
INNER JOIN person p ON c.person_id = p.id
INNER JOIN routes r ON a.route_id = r.id
ORDER BY r.route_name ASC;
```



### 5. Obtener los campers que se encuentran en estado "Expulsado" o "Retirado". 

```mysql
SELECT c.id, p.first_name AS Nombre, p.last_names AS Apellidos, p.document_number AS Numero_Identificacion, c.status_camper AS Status
FROM camper c
INNER JOIN person p ON c.person_id = p.id
WHERE c.status_camper = 'Expulsado' OR c.status_camper = 'Retirado';
```



### 6. Listar campers con nivel de riesgo “Alto”.  

```mysql
SELECT c.id, p.first_name AS Nombre, p.last_names AS Apellidos, p.document_number AS Numero_Identificacion, c.risk_level AS Nivel_Riesgo
FROM camper c
INNER JOIN person p ON c.person_id = p.id
WHERE c.risk_level = 'Alto';
```



### 7. Mostrar el total de campers por cada nivel de riesgo. 

```mysql
SELECT COUNT(c.id) AS Total_Campers, c.risk_level AS Nivel_Riesgo
FROM camper c
GROUP BY c.risk_level;
```



### 8. Obtener campers con más de un número telefónico registrado. 

```mysql
SELECT c.id, p.first_name AS Nombre, p.last_names AS Apellidos, p.document_number AS Numero_Identificacion, COUNT(pp.person_id) AS Cantidad_Numeros_Telefonicos
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN person_phones pp ON p.id = pp.person_id
GROUP BY c.id
HAVING COUNT(pp.person_id) > 1;
```



### 9. Listar los campers y sus respectivos acudientes y teléfonos. 

```mysql
SELECT c.id, p.first_name AS Nombre, p.last_names AS Apellidos, ps.first_name AS Acudiente_Nombre, ps.last_names AS Acudiente_Apellidos, pn.phone_number AS Telefono
FROM camper c
INNER JOIN guardian g ON c.guardian_id = g.id
INNER JOIN person p ON c.person_id = p.id
INNER JOIN person ps ON g.person_id = ps.id
INNER JOIN person_phones pp ON ps.id = pp.person_id
INNER JOIN phone_numbers pn ON pp.phone_id = pn.id;
```



### 10. Mostrar campers que aún no han sido asignados a una ruta.

```mysql
SELECT c.id, p.first_name AS Nombre, p.last_names AS Apellidos, p.document_number AS Numero_Identificacion
FROM camper c
INNER JOIN person p ON c.person_id = p.id
LEFT JOIN camper_route_enrollments cre ON c.id = cre.camper_id
WHERE cre.camper_id IS NULL;
```



## 📊 Evaluaciones 

### 1. Obtener las notas teóricas, prácticas y quizzes de cada camper por módulo. 

```mysql
SELECT s.skill_name AS Modulo, c.id, p.first_name AS Nombre, ec.component_type AS Tipo_Nota, ec.note AS Nota
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN evaluations e ON c.id = e.camper_id
INNER JOIN evaluation_components ec ON e.id = ec.evaluation_id
INNER JOIN skills s ON e.skill_id = s.id
WHERE ec.component_type IN ('Teorico', 'Practico', 'Quiz')
ORDER BY s.skill_name ASC;
```



### 2. Calcular la nota final de cada camper por módulo. 

```mysql
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
```



### 3. Mostrar los campers que reprobaron algún módulo (nota < 60). 

```mysql
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
```



### 4. Listar los módulos con más campers en bajo rendimiento. 

```mysql
SELECT s.skill_name AS Modulo, COUNT(c.id) AS Campers_Bajo_Rendimiento
FROM camper c
INNER JOIN evaluations e ON c.id = e.camper_id
INNER JOIN skills s ON e.skill_id = s.id
WHERE e.camper_state = 'Reprobado' OR e.final_grade < 60
GROUP BY s.id
ORDER BY Campers_Bajo_Rendimiento DESC;
```



### 5. Obtener el promedio de notas finales por cada módulo. 

```mysql
SELECT s.skill_name AS Modulo, ROUND(AVG(e.final_grade), 2) AS Promedio_Notas
FROM evaluations e
INNER JOIN skills s ON e.skill_id = s.id
GROUP BY s.id
ORDER BY Promedio_Notas DESC;
```



### 6. Consultar el rendimiento general por ruta de entrenamiento. 

```mysql
SELECT r.route_name AS Ruta, ROUND(AVG(e.final_grade), 2) AS Promedio_Ruta,
    COUNT(CASE WHEN e.camper_state = 'Aprobado' THEN 1 END) AS Aprobados,
    COUNT(CASE WHEN e.camper_state = 'Reprobado' THEN 1 END) AS Reprobados
FROM evaluations e
INNER JOIN camper c ON e.camper_id = c.id
INNER JOIN camper_route_enrollments cre ON c.id = cre.camper_id
INNER JOIN routes r ON cre.route_id = r.id
GROUP BY r.id
ORDER BY Promedio_Ruta DESC;
```



### 7. Mostrar los trainers responsables de campers con bajo rendimiento. 

```mysql
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
```



### 8. Comparar el promedio de rendimiento por trainer. 

```mysql
SELECT t.id AS Trainer_ID, p.first_name AS Nombre_Trainer, p.last_names AS Apellidos_Trainer, ROUND(AVG(e.final_grade), 2) AS Promedio_Notas_Grupo
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
INNER JOIN campers_group_members cgm ON ts.campers_group_id = cgm.group_id
INNER JOIN camper c ON cgm.camper_id = c.id
INNER JOIN evaluations e ON c.id = e.camper_id
GROUP BY t.id
ORDER BY Promedio_Notas_Grupo DESC;
```



### 9. Listar los mejores 5 campers por nota final en cada ruta. 

```mysql
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
```



### 10. Mostrar cuántos campers pasaron cada módulo por ruta.

```mysql
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
```



## 🧭 Rutas y Áreas de Entrenamiento

### 1. Mostrar todas las rutas de entrenamiento disponibles. 

```mysql
SELECT route_name AS Ruta
FROM routes;
```



### 2. Obtener las rutas con su SGDB principal y alternativo. 

```mysql
SELECT route_name AS Ruta, main_sgbd AS SGDB_Principal, alternative_sgbd AS SGDB_Alternativo
FROM routes;
```



### 3. Listar los módulos asociados a cada ruta. 

```mysql
SELECT r.route_name AS Ruta, s.skill_name AS Modulo
FROM routes r
INNER JOIN route_skills rs ON r.id = rs.route_id
INNER JOIN skills s ON rs.skill_id = s.id;
```



### 4. Consultar cuántos campers hay en cada ruta. 

```mysql
SELECT r.route_name AS Ruta, COUNT(c.id) AS Campers_En_Ruta
FROM routes r
INNER JOIN camper_route_enrollments cre ON r.id = cre.route_id
INNER JOIN camper c ON cre.camper_id = c.id
GROUP BY r.id;
```



### 5. Mostrar las áreas de entrenamiento y su capacidad máxima. 

```mysql
SELECT a.area_name AS Area, a.capacity AS Capacidad_Maxima
FROM training_areas a;
```



### 6. Obtener las áreas que están ocupadas al 100%. 

```mysql
SELECT ta.area_name AS Area_Entrenamiento, ta.capacity AS Capacidad_Maxima, COUNT(cgm.camper_id) AS Campers_Asignados
FROM training_areas ta
INNER JOIN route_assignments ra ON ta.id = ra.area_id
INNER JOIN campers_group cg ON ra.campers_group_id = cg.id
INNER JOIN campers_group_members cgm ON cg.id = cgm.group_id
GROUP BY ta.id
HAVING COUNT(cgm.camper_id) >= ta.capacity
ORDER BY ta.area_name;
```



### 7. Verificar la ocupación actual de cada área. 

```mysql
SELECT ta.area_name AS Area_Entrenamiento, ta.capacity AS Capacidad_Maxima, COUNT(cgm.camper_id) AS Campers_Asignados, ROUND((COUNT(cgm.camper_id) / ta.capacity) * 100, 2) AS Porcentaje_Ocupacion
FROM training_areas ta
LEFT JOIN route_assignments ra ON ta.id = ra.area_id
LEFT JOIN campers_group cg ON ra.campers_group_id = cg.id
LEFT JOIN campers_group_members cgm ON cg.id = cgm.group_id
WHERE ta.training_areas_status = 'Activo'
GROUP BY ta.id
ORDER BY Porcentaje_Ocupacion DESC;
```



### 8. Consultar los horarios disponibles por cada área. 

```mysql
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
```



### 9. Mostrar las áreas con más campers asignados. 

```mysql
SELECT ta.area_name AS Area_Entrenamiento, COUNT(cgm.camper_id) AS Cantidad_Campers
FROM training_areas ta
LEFT JOIN route_assignments ra ON ta.id = ra.area_id
LEFT JOIN campers_group cg ON ra.campers_group_id = cg.id
LEFT JOIN campers_group_members cgm ON cg.id = cgm.group_id
GROUP BY ta.id
ORDER BY Cantidad_Campers DESC;
```



### 10. Listar las rutas con sus respectivos trainers y áreas asignadas.

```mysql
SELECT r.route_name AS Ruta, p.first_name AS Nombre_Trainer, p.last_names AS Apellidos_Trainer, ta.area_name AS Area_Entrenamiento, cg.group_name AS Grupo_Campers
FROM routes r
INNER JOIN route_assignments ra ON r.id = ra.route_id
INNER JOIN trainer t ON ra.trainer_id = t.id
INNER JOIN person p ON t.person_id = p.id
INNER JOIN training_areas ta ON ra.area_id = ta.id
INNER JOIN campers_group cg ON ra.campers_group_id = cg.id
ORDER BY r.route_name, ta.area_name;
```



## 👨‍🏫 Trainers

### 1. Listar todos los entrenadores registrados. 

```mysql
SELECT t.id AS Trainer_ID, p.first_name AS Nombre, p.last_names AS Apellidos, p.email AS Email, b.branch_name AS Sede
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN branches b ON t.branch_id = b.id;
```



### 2. Mostrar los trainers con sus horarios asignados. 

```mysql
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
```



### 3. Consultar los trainers asignados a más de una ruta. 

```mysql
SELECT t.id AS Trainer_ID, p.first_name AS Nombre, p.last_names AS Apellidos, COUNT(DISTINCT ts.route_id) AS Cantidad_Rutas
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
GROUP BY t.id
HAVING COUNT(DISTINCT ts.route_id) > 1
ORDER BY Cantidad_Rutas DESC;
```



### 4. Obtener el número de campers por trainer. 

```mysql
SELECT t.id AS Trainer_ID, p.first_name AS Nombre, p.last_names AS Apellidos, COUNT(DISTINCT cgm.camper_id) AS Cantidad_Campers
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
INNER JOIN campers_group_members cgm ON ts.campers_group_id = cgm.group_id
GROUP BY t.id
ORDER BY Cantidad_Campers DESC;
```



### 5. Mostrar las áreas en las que trabaja cada trainer. 

```mysql
SELECT t.id AS Trainer_ID, p.first_name AS Nombre, p.last_names AS Apellidos, 
       GROUP_CONCAT(DISTINCT ta.area_name ORDER BY ta.area_name SEPARATOR ', ') AS Areas_Asignadas
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
INNER JOIN trainer_schedule ts ON t.id = ts.trainer_id
INNER JOIN training_areas ta ON ts.area_id = ta.id
GROUP BY t.id;
```



### 6. Listar los trainers sin asignación de área o ruta. 

```mysql
SELECT t.id AS Trainer_ID, p.first_name AS Nombre, p.last_names AS Apellidos, p.email AS Email
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
LEFT JOIN trainer_schedule ts ON t.id = ts.trainer_id
WHERE ts.id IS NULL;
```



### 7. Mostrar cuántos módulos están a cargo de cada trainer. 

```mysql
SELECT t.id AS Trainer_ID, p.first_name AS Nombre, p.last_names AS Apellidos, 
       COUNT(tma.module_id) AS Cantidad_Modulos,
       GROUP_CONCAT(m.module_name ORDER BY m.module_name SEPARATOR ', ') AS Modulos_Asignados
FROM trainer t
INNER JOIN person p ON t.person_id = p.id
LEFT JOIN trainer_module_assignments tma ON t.id = tma.trainer_id
LEFT JOIN modules m ON tma.module_id = m.id
GROUP BY t.id
ORDER BY Cantidad_Modulos DESC;
```



### 8. Obtener el trainer con mejor rendimiento promedio de campers. 

```mysql
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
```



### 9. Consultar los horarios ocupados por cada trainer. 

```mysql
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
```



### 10. Mostrar la disponibilidad semanal de cada trainer.

```mysql
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
```



## 🔍 Consultas con Subconsultas y Cálculos Avanzados

### 1. Obtener los campers con la nota más alta en cada módulo. 

```mysql
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
```



### 2. Mostrar el promedio general de notas por ruta y comparar con el promedio global. 

```mysql
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
```



### 3. Listar las áreas con más del 80% de ocupación. 

```mysql
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
```



### 4. Mostrar los trainers con menos del 70% de rendimiento promedio. 

```mysql
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
```



### 5. Consultar los campers cuyo promedio está por debajo del promedio general. 

```mysql
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
```



### 6. Obtener los módulos con la menor tasa de aprobación. 7. Listar los campers que han aprobado todos los módulos de su ruta.

```mysql
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
```

### 7. Listar los campers que han aprobado todos los módulos de su ruta.

```mysql
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
```



### 8. Mostrar rutas con más de 10 campers en bajo rendimiento.

```mysql
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
```



### 9. Calcular el promedio de rendimiento por SGDB principal.

```mysql
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
```



### 10. Listar los módulos con al menos un 30% de campers reprobados.

```mysql
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
```



### 11. Mostrar el módulo más cursado por campers con riesgo alto.

```mysql
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
```



### 12. Consultar los trainers con más de 3 rutas asignadas.

```mysql
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
```



### 13. Listar los horarios más ocupados por áreas.

```mysql
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
```



### 14. Consultar las rutas con el mayor número de módulos.

```mysql
SELECT 
    r.route_name AS Ruta,
    COUNT(rs.skill_id) AS Cantidad_Modulos,
    GROUP_CONCAT(s.skill_name ORDER BY s.skill_name SEPARATOR ', ') AS Modulos
FROM routes r
INNER JOIN route_skills rs ON r.id = rs.route_id
INNER JOIN skills s ON rs.skill_id = s.id
GROUP BY r.id
ORDER BY Cantidad_Modulos DESC;
```



### 15. Obtener los campers que han cambiado de estado más de una vez.

```mysql
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
```



### 16. Mostrar las evaluaciones donde la nota teórica sea mayor a la práctica.

```mysql
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
```



### 17. Listar los módulos donde la media de quizzes supera el 90.

```mysql
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
```



### 18. Consultar la ruta con mayor tasa de graduación.

```mysql
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
```



### 19. Mostrar los módulos cursados por campers de nivel de riesgo medio o alto.

```mysql
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
```



### 20. Obtener la diferencia entre capacidad y ocupación en cada área.

```mysql
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
```



## 🔁 JOINs Básicos (INNER JOIN, LEFT JOIN, etc.)

### 1. Obtener los nombres completos de los campers junto con el nombre de la ruta a la que están inscritos.

```mysql
SELECT p.first_name AS Nombre, p.last_names AS Apellidos, r.route_name AS Ruta
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN camper_route_enrollments cre ON c.id = cre.camper_id
INNER JOIN routes r ON cre.route_id = r.id
ORDER BY r.route_name, p.last_names, p.first_name;
```



### 2. Mostrar los campers con sus evaluaciones (nota teórica, práctica, quizzes y nota final) por cada módulo.

```mysql
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
```



### 3. Listar todos los módulos que componen cada ruta de entrenamiento.

```mysql
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
```



### 4. Consultar las rutas con sus trainers asignados y las áreas en las que imparten clases.

```mysql
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
```



### 5. Mostrar los campers junto con el trainer responsable de su ruta actual.

```mysql
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
```



### 6. Obtener el listado de evaluaciones realizadas con nombre de camper, módulo y ruta.

```mysql
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
```



### 7. Listar los trainers y los horarios en que están asignados a las áreas de entrenamiento.

```mysql
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
```



### 8. Consultar todos los campers junto con su estado actual y el nivel de riesgo.

```mysql
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
```



### 9. Obtener todos los módulos de cada ruta junto con su porcentaje teórico, práctico y de quizzes.

```mysql
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
```



### 10. Mostrar los nombres de las áreas junto con los nombres de los campers que están asistiendo en esos espacios.

```mysql
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
```



## 🔀 JOINs con condiciones específicas

### 1.Listar los campers que han aprobado todos los módulos de su ruta (nota_final >= 60).

```mysql
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
```



### 2. Mostrar las rutas que tienen más de 10 campers inscritos actualmente.

```mysql
SELECT r.route_name AS Ruta, COUNT(DISTINCT c.id) AS Cantidad_Campers
FROM routes r
INNER JOIN camper_route_enrollments cre ON r.id = cre.route_id
INNER JOIN camper c ON cre.camper_id = c.id
WHERE c.status_camper = 'Inscrito'
GROUP BY r.id
HAVING COUNT(DISTINCT c.id) > 10
ORDER BY Cantidad_Campers DESC;
```



### 3. Consultar las áreas que superan el 80% de su capacidad con el número actual de campers asignados.

```mysql
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
```



### 4. Obtener los trainers que imparten más de una ruta diferente.

```mysql
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
```



### 5. Listar las evaluaciones donde la nota práctica es mayor que la nota teórica.

```mysql
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
```



### 6. Mostrar campers que están en rutas cuyo SGDB principal es MySQL.

```mysql
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
```



### 7. Obtener los nombres de los módulos donde los campers han tenido bajo rendimiento.

```mysql
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
```



### 8. Consultar las rutas con más de 3 módulos asociados.

```mysql
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
```



### 9. Listar las inscripciones realizadas en los últimos 30 días con sus respectivos campers y rutas.

```mysql
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
```



### 10. Obtener los trainers que están asignados a rutas con campers en estado de “Alto Riesgo”.

```mysql
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
```



## 🔎 JOINs con funciones de agregación

### 1. Obtener el promedio de nota final por módulo.

```mysql
SELECT 
    s.skill_name AS Modulo,
    ROUND(AVG(e.final_grade), 2) AS Promedio_Notas,
    COUNT(DISTINCT e.camper_id) AS Cantidad_Campers
FROM skills s
INNER JOIN evaluations e ON s.id = e.skill_id
GROUP BY s.id
ORDER BY Promedio_Notas DESC;
```



### 2. Calcular la cantidad total de campers por ruta.

```mysql
SELECT 
    r.route_name AS Ruta,
    COUNT(DISTINCT c.id) AS Total_Campers,
    COUNT(DISTINCT CASE WHEN c.status_camper = 'Inscrito' THEN c.id END) AS Campers_Activos
FROM routes r
INNER JOIN camper_route_enrollments cre ON r.id = cre.route_id
INNER JOIN camper c ON cre.camper_id = c.id
GROUP BY r.id
ORDER BY Total_Campers DESC;
```



### 3. Mostrar la cantidad de evaluaciones realizadas por cada trainer (según las rutas que imparte).

```mysql
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
```



### 4. Consultar el promedio general de rendimiento por cada área de entrenamiento.

```mysql
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
```



### 5. Obtener la cantidad de módulos asociados a cada ruta de entrenamiento.

```mysql
SELECT 
    r.route_name AS Ruta,
    COUNT(rs.skill_id) AS Cantidad_Modulos,
    GROUP_CONCAT(s.skill_name ORDER BY s.skill_name SEPARATOR ', ') AS Modulos
FROM routes r
INNER JOIN route_skills rs ON r.id = rs.route_id
INNER JOIN skills s ON rs.skill_id = s.id
GROUP BY r.id
ORDER BY Cantidad_Modulos DESC;
```



### 6. Mostrar el promedio de nota final de los campers en estado “Cursando”.

```mysql
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
```



### 7. Listar el número de campers evaluados en cada módulo.

```mysql
SELECT 
    s.skill_name AS Modulo,
    COUNT(DISTINCT e.camper_id) AS Campers_Evaluados,
    COUNT(DISTINCT CASE WHEN e.camper_state = 'Aprobado' THEN e.camper_id END) AS Campers_Aprobados,
    COUNT(DISTINCT CASE WHEN e.camper_state = 'Reprobado' THEN e.camper_id END) AS Campers_Reprobados
FROM skills s
INNER JOIN evaluations e ON s.id = e.skill_id
GROUP BY s.id
ORDER BY Campers_Evaluados DESC;
```



### 8. Consultar el porcentaje de ocupación actual por cada área de entrenamiento.

```mysql
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
```



### 9. Mostrar cuántos trainers tiene asignados cada área.

```mysql
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
```



### 10. Listar las rutas que tienen más campers en riesgo alto.

```mysql
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
```



# Procedimientos Almacenados

## ⚙️ PROCEDIMIENTOS ALMACENADOS

### 1.Registrar un nuevo camper con toda su información personal y estado inicial.

```mysql
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
```



### 2. Actualizar el estado de un camper luego de completar el proceso de ingreso.

```mysql
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
```



### 3. Procesar la inscripción de un camper a una ruta específica.

```mysql
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
```



### 4. Registrar una evaluación completa (teórica, práctica y quizzes) para un camper.

```mysql
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
```



### 5. Calcular y registrar automáticamente la nota final de un módulo.

```mysql
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
```



### 6. Asignar campers aprobados a una ruta de acuerdo con la disponibilidad del área.

```mysql
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
```



### 7. Asignar un trainer a una ruta y área específica, validando el horario.

```mysql
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
```



### 8. Registrar una nueva ruta con sus módulos y SGDB asociados.

```mysql
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
```



### 9. Registrar una nueva área de entrenamiento con su capacidad y horarios.

```mysql
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
```



### 10. Consultar disponibilidad de horario en un área determinada.

```mysql
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
```



### 11. Reasignar a un camper a otra ruta en caso de bajo rendimiento.

```mysql
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
```



### 12. Cambiar el estado de un camper a “Graduado” al finalizar todos los módulos.

```mysql
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
```



### 13. Consultar y exportar todos los datos de rendimiento de un camper.

```mysql
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
```



### 14. Registrar la asistencia a clases por área y horario.

```mysql
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
```



### 15. Generar reporte mensual de notas por ruta.

```mysql
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
```



### 16. Validar y registrar la asignación de un salón a una ruta sin exceder la capacidad.

```mysql
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
```



### 17. Registrar cambio de horario de un trainer.

```mysql
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
```



### 18. Eliminar la inscripción de un camper a una ruta (en caso de retiro).

```mysql
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
```



### 19. Recalcular el estado de todos los campers según su rendimiento acumulado.

```mysql
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
```



### 20. Asignar horarios automáticamente a trainers disponibles según sus áreas

```mysql
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
```

# Funciones SQL

## 🧮 FUNCIONES SQL

### 1. Calcular el promedio ponderado de evaluaciones de un camper.

```mysql
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
```



### 2. Determinar si un camper aprueba o no un módulo específico.

```mysql
DELIMITER //
DROP FUNCTION IF EXISTS verificar_aprobacion_modulo;
CREATE FUNCTION verificar_aprobacion_modulo(camper_id INT, skill_id INT) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE nota DECIMAL(5,2);
    DECLARE estado VARCHAR(20);
    
    SELECT final_grade INTO nota
    FROM evaluations
    WHERE camper_id = camper_id AND skill_id = skill_id;
    
    IF nota IS NULL THEN
        RETURN 'No evaluado';
    ELSEIF nota >= 60 THEN
        RETURN 'Aprobado';
    ELSE
        RETURN 'Reprobado';
    END IF;
END //
DELIMITER ;
```



### 3. Evaluar el nivel de riesgo de un camper según su rendimiento promedio.

```mysql
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
```



### 4. Obtener el total de campers asignados a una ruta específica.

```mysql
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
```



### 5. Consultar la cantidad de módulos que ha aprobado un camper.

```mysql
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
```



### 6. Validar si hay cupos disponibles en una determinada área.

```mysql
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
```



### 7. Calcular el porcentaje de ocupación de un área de entrenamiento.

```mysql
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
```



### 8. Determinar la nota más alta obtenida en un módulo.

```mysql
DELIMITER //
DROP FUNCTION IF EXISTS obtener_nota_mas_alta;
CREATE FUNCTION obtener_nota_mas_alta(skill_id INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE nota_maxima DECIMAL(5,2);
    
    SELECT MAX(final_grade) INTO nota_maxima
    FROM evaluations
    WHERE skill_id = skill_id;
    
    RETURN IFNULL(nota_maxima, 0);
END //
DELIMITER ;
```



### 9. Calcular la tasa de aprobación de una ruta.

```mysql
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
```



### 10. Verificar si un trainer tiene horario disponible.

```mysql
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
```



### 11. Obtener el promedio de notas por ruta.

```mysql
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
```



### 12. Calcular cuántas rutas tiene asignadas un trainer.

```mysql
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
```



### 13. Verificar si un camper puede ser graduado.

```mysql
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
```



### 14. Obtener el estado actual de un camper en función de sus evaluaciones.

```mysql
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
```



### 15. Calcular la carga horaria semanal de un trainer.

```mysql
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
```



### 16. Determinar si una ruta tiene módulos pendientes por evaluación.

```mysql
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
```



### 17. Calcular el promedio general del programa.

```mysql
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
```



### 18. Verificar si un horario choca con otros entrenadores en el área.

```mysql
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
```



### 19. Calcular cuántos campers están en riesgo en una ruta específica.

```mysql
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
```



### 20. Consultar el número de módulos evaluados por un camper.

```mysql
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
```

