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

-- 6. Listar campers con nivel de riesgo “Alto”.

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

SELECT m.module_name AS Modulo, c.id, p.first_name AS Nombre, ec.component_type AS Tipo_Nota, ec.note AS Nota
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN evaluations e ON c.id = e.camper_id
INNER JOIN evaluation_components ec ON e.id = ec.evaluation_id
INNER JOIN modules m ON e.module_id = m.id
WHERE ec.component_type IN ('Teorico', 'Practico', 'Quiz')
ORDER BY m.module_name ASC;

-- 2. Calcular la nota final de cada camper por módulo.



-- 3. Mostrar los campers que reprobaron algún módulo (nota < 60).



-- 4. Listar los módulos con más campers en bajo rendimiento.



-- 5. Obtener el promedio de notas finales por cada módulo.



-- 6. Consultar el rendimiento general por ruta de entrenamiento.



-- 7. Mostrar los trainers responsables de campers con bajo rendimiento.



-- 8. Comparar el promedio de rendimiento por trainer.



-- 9. Listar los mejores 5 campers por nota final en cada ruta.



-- 10. Mostrar cuántos campers pasaron cada módulo por ruta.


