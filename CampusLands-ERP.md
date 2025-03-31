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
SELECT m.module_name AS Modulo, c.id, p.first_name AS Nombre, ec.component_type AS Tipo_Nota, ec.note AS Nota
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN evaluations e ON c.id = e.camper_id
INNER JOIN evaluation_components ec ON e.id = ec.evaluation_id
INNER JOIN modules m ON e.module_id = m.id
WHERE ec.component_type IN ('Teorico', 'Practico', 'Quiz')
ORDER BY m.module_name ASC;
```



### 2. Calcular la nota final de cada camper por módulo. 

```mysql
SELECT m.module_name AS Modulo, c.id, p.first_name AS Nombre,
    SUM(
      CASE 
         WHEN ec.component_type = 'Teorico' THEN ec.note * (m.theoretical_weight / 100)
         WHEN ec.component_type = 'Practico' THEN ec.note * (m.practical_weight / 100)
         WHEN ec.component_type = 'Quiz' THEN ec.note * (m.quizzes_weight / 100)
         ELSE 0 
      END
    ) AS Nota_total
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN evaluations e ON c.id = e.camper_id
INNER JOIN evaluation_components ec ON e.id = ec.evaluation_id
INNER JOIN modules m ON e.module_id = m.id
GROUP BY m.module_name, c.id, p.first_name
ORDER BY m.module_name ASC;
```



### 3. Mostrar los campers que reprobaron algún módulo (nota < 60). 

```mysql
SELECT m.module_name AS Modulo, c.id, p.first_name AS Nombre,
    SUM(
      CASE 
         WHEN ec.component_type = 'Teorico' THEN ec.note * (m.theoretical_weight / 100)
         WHEN ec.component_type = 'Practico' THEN ec.note * (m.practical_weight / 100)
         WHEN ec.component_type = 'Quiz' THEN ec.note * (m.quizzes_weight / 100)
         ELSE 0 
      END
    ) AS Nota_total
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN evaluations e ON c.id = e.camper_id
INNER JOIN evaluation_components ec ON e.id = ec.evaluation_id
INNER JOIN modules m ON e.module_id = m.id
GROUP BY m.module_name, c.id, p.first_name
HAVING Nota_total < 60.00
ORDER BY m.module_name ASC;
```



### 4. Listar los módulos con más campers en bajo rendimiento. 

```mysql
SELECT sub.Modulo, COUNT(sub.id) AS Total_Campers_Bajo_Rendimiento
FROM (
    SELECT m.module_name AS Modulo,c.id,
        SUM(
          CASE 
             WHEN ec.component_type = 'Teorico' THEN ec.note * (m.theoretical_weight / 100)
             WHEN ec.component_type = 'Practico' THEN ec.note * (m.practical_weight / 100)
             WHEN ec.component_type = 'Quiz' THEN ec.note * (m.quizzes_weight / 100)
             ELSE 0 
          END
        ) AS Nota_total
    FROM camper c
    INNER JOIN evaluations e ON c.id = e.camper_id
    INNER JOIN evaluation_components ec ON e.id = ec.evaluation_id
    INNER JOIN modules m ON e.module_id = m.id
    GROUP BY m.module_name, c.id
) AS sub
WHERE sub.Nota_total < 60
GROUP BY sub.Modulo
ORDER BY Total_Campers_Bajo_Rendimiento DESC;
```



### 5. Obtener el promedio de notas finales por cada módulo. 

```mysql
SELECT sub.Modulo, AVG(sub.Nota_total) AS Promedio_Notas_Finales
FROM (
    SELECT m.module_name AS Modulo,c.id,
        SUM(
          CASE 
             WHEN ec.component_type = 'Teorico' THEN ec.note * (m.theoretical_weight / 100)
             WHEN ec.component_type = 'Practico' THEN ec.note * (m.practical_weight / 100)
             WHEN ec.component_type = 'Quiz' THEN ec.note * (m.quizzes_weight / 100)
             ELSE 0 
          END
        ) AS Nota_total
    FROM camper c
    INNER JOIN evaluations e ON c.id = e.camper_id
    INNER JOIN evaluation_components ec ON e.id = ec.evaluation_id
    INNER JOIN modules m ON e.module_id = m.id
    GROUP BY m.module_name, c.id
) AS sub
GROUP BY sub.Modulo
ORDER BY Promedio_Notas_Finales DESC;
```



### 6. Consultar el rendimiento general por ruta de entrenamiento. 

```mysql
SELECT r.route_name AS Ruta, AVG(mp.Promedio_Notas_Finales) AS Promedio_Ruta
FROM routes r
INNER JOIN route_modules rm ON r.id = rm.route_id
INNER JOIN (
    SELECT sub.module_id, AVG(Nota_total) AS Promedio_Notas_Finales
    FROM (
        SELECT m.id AS module_id, c.id AS camper_id,
            SUM(
              CASE 
                 WHEN ec.component_type = 'Teorico' THEN ec.note * (m.theoretical_weight / 100)
                 WHEN ec.component_type = 'Practico' THEN ec.note * (m.practical_weight / 100)
                 WHEN ec.component_type = 'Quiz' THEN ec.note * (m.quizzes_weight / 100)
                 ELSE 0 
              END
            ) AS Nota_total
        FROM camper c
        INNER JOIN evaluations e ON c.id = e.camper_id
        INNER JOIN evaluation_components ec ON e.id = ec.evaluation_id
        INNER JOIN modules m ON e.module_id = m.id
        GROUP BY m.id, c.id
    ) AS sub
    GROUP BY sub.module_id
) AS mp ON rm.module_id = mp.module_id
GROUP BY r.route_name
ORDER BY Promedio_Ruta DESC;
```



### 7. Mostrar los trainers responsables de campers con bajo rendimiento. 

```mysql
SELECT p2.first_name AS Trainer, p.first_name AS Camper, sub.Nota_total_Camper
FROM (
    SELECT c.id AS camper_id, m.id AS module_id,
        SUM(
          CASE 
              WHEN ec.component_type = 'Teorico' THEN ec.note * (m.theoretical_weight / 100)
              WHEN ec.component_type = 'Practico' THEN ec.note * (m.practical_weight / 100)
              WHEN ec.component_type = 'Quiz' THEN ec.note * (m.quizzes_weight / 100)
              ELSE 0 
           END
         ) AS Nota_total_Camper
    FROM camper c
    INNER JOIN evaluations e ON c.id = e.camper_id
    INNER JOIN evaluation_components ec ON e.id = ec.evaluation_id
    INNER JOIN modules m ON e.module_id = m.id
    GROUP BY c.id, m.id
) AS sub
INNER JOIN camper c ON sub.camper_id = c.id
INNER JOIN person p ON c.person_id = p.id
INNER JOIN route_modules rm ON sub.module_id = rm.module_id
INNER JOIN routes r ON rm.route_id = r.id
INNER JOIN route_assignments ra ON r.id = ra.route_id
INNER JOIN trainer t ON ra.trainer_id = t.id
INNER JOIN person p2 ON t.person_id = p2.id
WHERE sub.Nota_total_Camper < 60;
```



### 8. Comparar el promedio de rendimiento por trainer. 

```mysql
SELECT p2.first_name AS Trainer, AVG(sub.Nota_total_Camper) AS Promedio_Rendimiento
FROM (
    SELECT c.id AS camper_id, m.id AS module_id,
        SUM(
          CASE 
              WHEN ec.component_type = 'Teorico' THEN ec.note * (m.theoretical_weight / 100)
              WHEN ec.component_type = 'Practico' THEN ec.note * (m.practical_weight / 100)
              WHEN ec.component_type = 'Quiz' THEN ec.note * (m.quizzes_weight / 100)
              ELSE 0 
           END
         ) AS Nota_total_Camper
    FROM camper c
    INNER JOIN evaluations e ON c.id = e.camper_id
    INNER JOIN evaluation_components ec ON e.id = ec.evaluation_id
    INNER JOIN modules m ON e.module_id = m.id
    GROUP BY c.id, m.id
) AS sub
INNER JOIN camper c ON sub.camper_id = c.id
INNER JOIN person p ON c.person_id = p.id
INNER JOIN route_modules rm ON sub.module_id = rm.module_id
INNER JOIN routes r ON rm.route_id = r.id
INNER JOIN route_assignments ra ON r.id = ra.route_id
INNER JOIN trainer t ON ra.trainer_id = t.id
INNER JOIN person p2 ON t.person_id = p2.id
GROUP BY p2.first_name
ORDER BY Promedio_Rendimiento DESC;
```



### 9. Listar los mejores 5 campers por nota final en cada ruta. 

```mysql
SELECT r.route_name AS Ruta, c.id, p.first_name AS Nombre,
    SUM(
      CASE 
         WHEN ec.component_type = 'Teorico' THEN ec.note * (m.theoretical_weight / 100)
         WHEN ec.component_type = 'Practico' THEN ec.note * (m.practical_weight / 100)
         WHEN ec.component_type = 'Quiz' THEN ec.note * (m.quizzes_weight / 100)
         ELSE 0 
      END
    ) AS Nota_total
FROM camper c
INNER JOIN person p ON c.person_id = p.id
INNER JOIN evaluations e ON c.id = e.camper_id
INNER JOIN evaluation_components ec ON e.id = ec.evaluation_id
INNER JOIN modules m ON e.module_id = m.id
INNER JOIN route_modules rm ON m.id = rm.module_id
INNER JOIN routes r ON rm.route_id = r.id
GROUP BY r.route_name, c.id, p.first_name
ORDER BY Nota_total DESC
LIMIT 5;
```



### 10. Mostrar cuántos campers pasaron cada módulo por ruta.
