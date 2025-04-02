# CampusLands-ERP
# Sistema de Gestión Académica CampusLands

## Descripción del Proyecto

CampusLands-ERP es un sistema integral de gestión académica diseñado específicamente para CampusLands, un centro de formación en tecnologías de la información. El sistema permite administrar de manera eficiente todos los aspectos relacionados con la formación de campers (estudiantes), desde su proceso de inscripción hasta su graduación.

Este proyecto implementa una base de datos relacional que gestiona:
- Información personal de campers y trainers
- Rutas de aprendizaje y módulos formativos
- Evaluaciones y seguimiento del rendimiento académico
- Asistencia y programación de clases
- Historial académico y estados de los campers
- Relaciones con acudientes y contactos

## Estructura de la Base de Datos

El sistema está compuesto por las siguientes categorías de tablas que interactúan entre sí:

### Gestión de Personas
- **person**: Contiene información personal básica (nombres, apellidos, email, número de documento).
- **document_types**: Catálogo de tipos de documentos de identidad.
- **camper**: Registro de estudiantes con datos específicos como fecha de inscripción, estado (En proceso de ingreso, Inscrito, Aprobado, Cursando, Graduado, Expulsado, Retirado), nivel de riesgo (Bajo, Medio, Alto) y rendimiento.
- **trainer**: Información de los formadores vinculados a una sede específica.
- **guardian**: Datos de los acudientes responsables de los campers.
- **camper_state_history**: Registro histórico de cambios de estado de los campers, incluyendo razones del cambio.

### Habilidades y Competencias
- **competencies**: Catálogo de competencias técnicas disponibles.
- **skills**: Habilidades específicas con distribución de pesos para evaluación (30% teórico, 60% práctico, 10% quizzes).
- **base_route_skills**: Configuración base de habilidades para rutas formativas.
- **trainer_competencies**: Relación entre trainers y las competencias que dominan.

### Rutas y Módulos Formativos
- **routes**: Rutas de formación con sus SGBDs principal y alternativo.
- **sgbds**: Sistemas de gestión de bases de datos utilizados en las rutas.
- **modules**: Módulos formativos independientes que pueden estar asociados a múltiples habilidades.
- **module_skills**: Relación entre módulos y habilidades.
- **module_competencies**: Competencias desarrolladas en cada módulo.
- **route_skills**: Asociación de habilidades específicas a cada ruta de formación.

### Grupos y Asignaciones
- **campers_group**: Grupos de campers organizados por ruta de formación.
- **campers_group_members**: Asignación de campers a grupos específicos.
- **camper_route_enrollments**: Inscripción de campers en rutas específicas con su estado (Active, Completed, Dropped).
- **route_assignments**: Asignación de rutas a áreas, trainers y grupos.
- **trainer_module_assignments**: Asignación de módulos específicos a trainers.

### Programación y Espacios
- **training_areas**: Espacios físicos de formación con su capacidad (máx. 33 personas).
- **schedules**: Definición de horarios con día de la semana, hora de inicio y fin.
- **sessions_class**: Sesiones de clase programadas con fecha específica.
- **session_modules**: Módulos impartidos en cada sesión de clase.
- **trainer_schedule**: Horarios asignados a cada trainer con área, ruta y grupo.
- **general_schedule**: Horario general por ruta y habilidad.

### Evaluación y Seguimiento
- **evaluations**: Evaluaciones generales de los campers por habilidad, con estado (Aprobado/Reprobado) y nota final.
- **evaluation_components**: Componentes específicos de cada evaluación (Teórico, Práctico, Quiz) con su respectiva nota y fecha.
- **attendance**: Control detallado de asistencia incluyendo estado (Present, Absent, Late), hora de llegada y justificaciones.
- **alumni**: Registro de campers graduados con fecha de graduación y ruta completada.

### Organización Empresarial
- **companies**: Datos de empresas vinculadas al sistema educativo.
- **branches**: Sedes operativas asociadas a empresas específicas.
- **notifications**: Sistema de notificaciones para trainers.

### Información Geográfica y de Contacto
- **countries**: Catálogo de países con código ISO.
- **regions**: Regiones o estados/departamentos vinculados a un país.
- **cities**: Ciudades vinculadas a una región.
- **addresses**: Direcciones físicas detalladas.
- **phone_types**: Tipos de teléfono (móvil, fijo, etc.).
- **phone_numbers**: Números telefónicos con extensión y tipo.
- **person_phones**: Relación entre personas y sus números telefónicos.

Las tablas se relacionan entre sí mediante un sistema de claves foráneas que garantiza la integridad referencial y permite un seguimiento completo del progreso académico. Esta estructura facilita la gestión eficiente de los procesos formativos, desde la inscripción inicial del camper hasta su graduación, incluyendo evaluaciones, asistencia y asignación de recursos.

Visualiza el diagrama aquí [Diagrama](Diagrama.png)

## Documentación Detallada

Para visualizar todas las consultas, procedimientos almacenados, funciones y triggers implementados en este proyecto, consulte el archivo [CampusLands-ERP.md](CampusLands-ERP.md).
