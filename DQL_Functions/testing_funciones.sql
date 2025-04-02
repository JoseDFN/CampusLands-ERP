USE campuslands;

-- Test cases for the SQL functions
-- Note: Functions have been updated to use p_ prefix for parameters to avoid conflicts with column names

-- 1. Test calcular_promedio_camper
SELECT calcular_promedio_camper(1) AS Promedio_Camper_1;
SELECT calcular_promedio_camper(2) AS Promedio_Camper_2;
SELECT calcular_promedio_camper(3) AS Promedio_Camper_3;

-- 2. Test verificar_aprobacion_modulo
SELECT verificar_aprobacion_modulo(1, 1) AS Estado_Modulo_Camper1_Skill1;
SELECT verificar_aprobacion_modulo(2, 2) AS Estado_Modulo_Camper2_Skill2;
SELECT verificar_aprobacion_modulo(3, 3) AS Estado_Modulo_Camper3_Skill3;

-- 3. Test evaluar_nivel_riesgo
SELECT evaluar_nivel_riesgo(1) AS Nivel_Riesgo_Camper1;
SELECT evaluar_nivel_riesgo(2) AS Nivel_Riesgo_Camper2;
SELECT evaluar_nivel_riesgo(3) AS Nivel_Riesgo_Camper3;

-- 4. Test contar_campers_ruta
SELECT contar_campers_ruta(1) AS Total_Campers_Ruta1;
SELECT contar_campers_ruta(2) AS Total_Campers_Ruta2;
SELECT contar_campers_ruta(3) AS Total_Campers_Ruta3;

-- 5. Test contar_modulos_aprobados
SELECT contar_modulos_aprobados(1) AS Modulos_Aprobados_Camper1;
SELECT contar_modulos_aprobados(2) AS Modulos_Aprobados_Camper2;
SELECT contar_modulos_aprobados(3) AS Modulos_Aprobados_Camper3;

-- 6. Test validar_cupos_area
SELECT validar_cupos_area(1) AS Cupos_Area1;
SELECT validar_cupos_area(2) AS Cupos_Area2;
SELECT validar_cupos_area(3) AS Cupos_Area3;

-- 7. Test calcular_porcentaje_ocupacion
SELECT calcular_porcentaje_ocupacion(1) AS Porcentaje_Ocupacion_Area1;
SELECT calcular_porcentaje_ocupacion(2) AS Porcentaje_Ocupacion_Area2;
SELECT calcular_porcentaje_ocupacion(3) AS Porcentaje_Ocupacion_Area3;

-- 8. Test obtener_nota_mas_alta
SELECT obtener_nota_mas_alta(1) AS Nota_Maxima_Skill1;
SELECT obtener_nota_mas_alta(2) AS Nota_Maxima_Skill2;
SELECT obtener_nota_mas_alta(3) AS Nota_Maxima_Skill3;

-- 9. Test calcular_tasa_aprobacion
SELECT calcular_tasa_aprobacion(1) AS Tasa_Aprobacion_Ruta1;
SELECT calcular_tasa_aprobacion(2) AS Tasa_Aprobacion_Ruta2;
SELECT calcular_tasa_aprobacion(3) AS Tasa_Aprobacion_Ruta3;

-- 10. Test verificar_horario_disponible
-- Asumiendo que los schedule_id son 1, 2, 3
SELECT verificar_horario_disponible(1, 1) AS Estado_Horario_Trainer1_Schedule1;
SELECT verificar_horario_disponible(2, 2) AS Estado_Horario_Trainer2_Schedule2;
SELECT verificar_horario_disponible(3, 3) AS Estado_Horario_Trainer3_Schedule3;

-- 11. Test obtener_promedio_ruta
SELECT obtener_promedio_ruta(1) AS Promedio_Ruta1;
SELECT obtener_promedio_ruta(2) AS Promedio_Ruta2;
SELECT obtener_promedio_ruta(3) AS Promedio_Ruta3;

-- 12. Test contar_rutas_trainer
SELECT contar_rutas_trainer(1) AS Rutas_Trainer1;
SELECT contar_rutas_trainer(2) AS Rutas_Trainer2;
SELECT contar_rutas_trainer(3) AS Rutas_Trainer3;

-- 13. Test verificar_graduacion
SELECT verificar_graduacion(1) AS Estado_Graduacion_Camper1;
SELECT verificar_graduacion(2) AS Estado_Graduacion_Camper2;
SELECT verificar_graduacion(3) AS Estado_Graduacion_Camper3;

-- 14. Test obtener_estado_camper
SELECT obtener_estado_camper(1) AS Estado_Camper1;
SELECT obtener_estado_camper(2) AS Estado_Camper2;
SELECT obtener_estado_camper(3) AS Estado_Camper3;

-- 15. Test calcular_carga_horaria
SELECT calcular_carga_horaria(1) AS Carga_Horaria_Trainer1;
SELECT calcular_carga_horaria(2) AS Carga_Horaria_Trainer2;
SELECT calcular_carga_horaria(3) AS Carga_Horaria_Trainer3;

-- 16. Test verificar_modulos_pendientes
SELECT verificar_modulos_pendientes(1) AS Modulos_Pendientes_Ruta1;
SELECT verificar_modulos_pendientes(2) AS Modulos_Pendientes_Ruta2;
SELECT verificar_modulos_pendientes(3) AS Modulos_Pendientes_Ruta3;

-- 17. Test calcular_promedio_general
SELECT calcular_promedio_general() AS Promedio_General_Programa;

-- 18. Test verificar_choque_horario
SELECT verificar_choque_horario(1, 1) AS Estado_Horario_Area1_Schedule1;
SELECT verificar_choque_horario(2, 2) AS Estado_Horario_Area2_Schedule2;
SELECT verificar_choque_horario(3, 3) AS Estado_Horario_Area3_Schedule3;

-- 19. Test contar_campers_riesgo
SELECT contar_campers_riesgo(1) AS Campers_Riesgo_Ruta1;
SELECT contar_campers_riesgo(2) AS Campers_Riesgo_Ruta2;
SELECT contar_campers_riesgo(3) AS Campers_Riesgo_Ruta3;

-- 20. Test contar_modulos_evaluados
SELECT contar_modulos_evaluados(1) AS Modulos_Evaluados_Camper1;
SELECT contar_modulos_evaluados(2) AS Modulos_Evaluados_Camper2;
SELECT contar_modulos_evaluados(3) AS Modulos_Evaluados_Camper3;

-- Example of more complex tests with multiple functions and real data

-- Test para ver los campers con bajo rendimiento y alto riesgo
SELECT 
    c.id AS Camper_ID,
    p.first_name AS Nombre,
    p.last_names AS Apellidos,
    calcular_promedio_camper(c.id) AS Promedio,
    evaluar_nivel_riesgo(c.id) AS Nivel_Riesgo,
    contar_modulos_aprobados(c.id) AS Modulos_Aprobados,
    contar_modulos_evaluados(c.id) AS Total_Modulos_Evaluados,
    obtener_estado_camper(c.id) AS Estado_Actual
FROM 
    camper c
JOIN 
    person p ON c.person_id = p.id
WHERE 
    evaluar_nivel_riesgo(c.id) = 'Alto'
ORDER BY 
    Promedio ASC;

-- Test para verificar áreas con alta ocupación
SELECT 
    ta.id AS Area_ID,
    ta.area_name AS Nombre_Area,
    ta.capacity AS Capacidad,
    calcular_porcentaje_ocupacion(ta.id) AS Porcentaje_Ocupacion,
    validar_cupos_area(ta.id) AS Estado_Cupos
FROM 
    training_areas ta
WHERE 
    calcular_porcentaje_ocupacion(ta.id) > 80
ORDER BY 
    Porcentaje_Ocupacion DESC;

-- Test para evaluar el rendimiento general de las rutas
SELECT 
    r.id AS Ruta_ID,
    r.route_name AS Nombre_Ruta,
    contar_campers_ruta(r.id) AS Total_Campers,
    obtener_promedio_ruta(r.id) AS Promedio_Ruta,
    calcular_tasa_aprobacion(r.id) AS Tasa_Aprobacion,
    contar_campers_riesgo(r.id) AS Campers_En_Riesgo,
    verificar_modulos_pendientes(r.id) AS Estado_Modulos
FROM 
    routes r
ORDER BY 
    Promedio_Ruta DESC;

-- Test para evaluar la carga de trabajo de trainers
SELECT 
    t.id AS Trainer_ID,
    p.first_name AS Nombre,
    p.last_names AS Apellidos,
    contar_rutas_trainer(t.id) AS Rutas_Asignadas,
    calcular_carga_horaria(t.id) AS Carga_Horaria
FROM 
    trainer t
JOIN 
    person p ON t.person_id = p.id
ORDER BY 
    Carga_Horaria DESC;
