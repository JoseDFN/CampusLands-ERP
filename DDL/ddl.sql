CREATE DATABASE IF NOT EXISTS campuslands;

USE campuslands;

-- creacion tabla paises

CREATE TABLE IF NOT EXISTS countries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) CHARACTER SET utf8mb4 NOT NULL,
    iso_code_country VARCHAR(3) CHARACTER SET utf8mb4 NOT NULL
);

-- creacion tabla estados

CREATE TABLE IF NOT EXISTS regions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    region_name VARCHAR(100) CHARACTER SET utf8mb4 NOT NULL,
    country_id INT,
    FOREIGN KEY (country_id) REFERENCES countries(id)
);

-- creacion tabla ciudades

CREATE TABLE IF NOT EXISTS cities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(100) CHARACTER SET utf8mb4 NOT NULL,
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES regions(id)
);

-- creacion tabla direcciones

CREATE TABLE IF NOT EXISTS addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(255) CHARACTER SET utf8mb4 NOT NULL,
    building_number VARCHAR(20) NOT NULL,
    postal_code VARCHAR(20),
    city_id INT,
    additional_info TEXT CHARACTER SET utf8mb4,
    FOREIGN KEY (city_id) REFERENCES cities(id)
);

-- creacion tabla empresas

CREATE TABLE IF NOT EXISTS companies(
    id INT AUTO_INCREMENT PRIMARY KEY,
    register_number VARCHAR(25),
    legal_name VARCHAR(80),
    comercial_name VARCHAR(80),
    country_id INT,
    foundation_date DATE,
    juridical_form VARCHAR(30),
    FOREIGN KEY (country_id) REFERENCES countries(id)
);

-- creacion tabla sede

CREATE TABLE IF NOT EXISTS branches(
    id INT AUTO_INCREMENT PRIMARY KEY,
    branch_name VARCHAR(30) NOT NULL,
    address_id INT,
    company_id INT,
    FOREIGN KEY (address_id) REFERENCES addresses(id),
    FOREIGN KEY (company_id) REFERENCES companies(id)
);

-- creacion tabla tipo telefono

CREATE TABLE IF NOT EXISTS phone_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    phone_type VARCHAR(20) UNIQUE NOT NULL
);

-- creacion tabla numeros de telefono

CREATE TABLE IF NOT EXISTS phone_numbers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    extension VARCHAR(10),
    phone_type_id INT,
    FOREIGN KEY (phone_type_id) REFERENCES phone_types(id)
);

-- creacion tabla tipo de documento

CREATE TABLE IF NOT EXISTS document_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    document_type VARCHAR(20) UNIQUE NOT NULL
);

-- creacion tabla personas

CREATE TABLE IF NOT EXISTS person(
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_names VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    document_number VARCHAR(20) UNIQUE NOT NULL,
    document_type_id INT,
    address_id INT,
    FOREIGN KEY (document_type_id) REFERENCES document_types(id),
    FOREIGN KEY (address_id) REFERENCES addresses(id)
);

-- creacion tabla telefono persona

CREATE TABLE IF NOT EXISTS person_phones (
    person_id INT NOT NULL,
    phone_id INT NOT NULL,
    PRIMARY KEY (person_id, phone_id),
    FOREIGN KEY (person_id) REFERENCES person(id),
    FOREIGN KEY (phone_id) REFERENCES phone_numbers(id)
);

-- creacion tabla guardian o acudiente

CREATE TABLE IF NOT EXISTS guardian(
    id INT AUTO_INCREMENT PRIMARY KEY,
    person_id INT,
    FOREIGN KEY (person_id) REFERENCES person(id)
);

-- creacion tabla camper

CREATE TABLE IF NOT EXISTS camper(
    id INT AUTO_INCREMENT PRIMARY KEY,
    person_id INT,
    guardian_id INT,
    branch_id INT,
    enrollment_date DATE NOT NULL,
    status_camper ENUM('En proceso de ingreso', 'Inscrito', 'Aprobado', 'Cursando', 'Graduado', 'Expulsado', 'Retirado') NOT NULL DEFAULT 'En proceso de ingreso',
    risk_level ENUM('Bajo', 'Medio', 'Alto') NOT NULL DEFAULT 'Bajo',
    camper_performance ENUM('Bajo', 'Medio', 'Alto') DEFAULT 'Medio',
    FOREIGN KEY (person_id) REFERENCES person(id),
    FOREIGN KEY (guardian_id) REFERENCES guardian(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id)
);

-- creacion tabla historial de estado de camper

CREATE TABLE IF NOT EXISTS camper_state_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    camper_id INT NOT NULL,
    old_state ENUM('En proceso de ingreso', 'Inscrito', 'Aprobado', 'Cursando', 'Graduado', 'Expulsado', 'Retirado') NOT NULL,
    new_state ENUM('En proceso de ingreso', 'Inscrito', 'Aprobado', 'Cursando', 'Graduado', 'Expulsado', 'Retirado') NOT NULL,
    change_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    FOREIGN KEY (camper_id) REFERENCES camper(id)
);

-- creacion tabla trainer

CREATE TABLE IF NOT EXISTS trainer(
    id INT AUTO_INCREMENT PRIMARY KEY,
    person_id INT,
    branch_id INT,
    FOREIGN KEY (person_id) REFERENCES person(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id)
);

-- creacion tabla competencias

CREATE TABLE IF NOT EXISTS competencies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    competency_name VARCHAR(100) NOT NULL UNIQUE
);

-- creacion tabla puente que asocia trainers con competencias

CREATE TABLE IF NOT EXISTS trainer_competencies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trainer_id INT NOT NULL,
    competency_id INT NOT NULL,
    FOREIGN KEY (trainer_id) REFERENCES trainer(id),
    FOREIGN KEY (competency_id) REFERENCES competencies(id)
);

-- creacion tabla notificaciones

CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trainer_id INT NOT NULL,
    message TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trainer_id) REFERENCES trainer(id)
);

-- creacion tabla sgbd

CREATE TABLE IF NOT EXISTS sgbds(
    id INT AUTO_INCREMENT PRIMARY KEY,
    sgbd_name VARCHAR(80) UNIQUE NOT NULL
);

-- creacion tabla ruta

CREATE TABLE IF NOT EXISTS routes(
    id INT AUTO_INCREMENT PRIMARY KEY,
    route_name VARCHAR(30) NOT NULL,
    main_sgbd INT NOT NULL,
    alternative_sgbd INT NOT NULL,
    FOREIGN KEY (main_sgbd) REFERENCES sgbds(id),
    FOREIGN KEY (alternative_sgbd) REFERENCES sgbds(id)
);

-- creacion tabla grupos de campers

CREATE TABLE IF NOT EXISTS campers_group (
    id INT AUTO_INCREMENT PRIMARY KEY,
    group_name VARCHAR(50) NOT NULL,
    route_id INT NOT NULL,
    creation_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (route_id) REFERENCES routes(id)
);

-- creacion tabla puente que relaciona campers con un grupo

CREATE TABLE IF NOT EXISTS campers_group_members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    group_id INT NOT NULL,
    camper_id INT NOT NULL,
    FOREIGN KEY (group_id) REFERENCES campers_group(id),
    FOREIGN KEY (camper_id) REFERENCES camper(id)
);

-- creacion tabla skills (renamed from modules)

CREATE TABLE IF NOT EXISTS skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    skill_name VARCHAR(100) NOT NULL,
    skill_description TEXT,
    skill_state ENUM('Aprobado', 'Reprobado', 'En curso') NOT NULL DEFAULT 'En curso',
    theoretical_weight DECIMAL(2,0) CHECK (theoretical_weight = 30),
    practical_weight DECIMAL(2,0) CHECK (practical_weight = 60),
    quizzes_weight DECIMAL(2,0) CHECK (quizzes_weight = 10)
);

-- creacion tabla base_route_skills (renamed from base_route_modules)

CREATE TABLE IF NOT EXISTS base_route_skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    skill_id INT NOT NULL,
    base_route_description TEXT,
    FOREIGN KEY (skill_id) REFERENCES skills(id)
);

-- creacion tabla ruta skills (renamed from route_modules)

CREATE TABLE IF NOT EXISTS route_skills (
    route_id INT,
    skill_id INT,
    main_sgbd INT,
    alternative_sgbd INT,
    PRIMARY KEY (route_id, skill_id),
    FOREIGN KEY (route_id) REFERENCES routes(id),
    FOREIGN KEY (skill_id) REFERENCES skills(id),
    FOREIGN KEY (main_sgbd) REFERENCES sgbds(id),
    FOREIGN KEY (alternative_sgbd) REFERENCES sgbds(id)
);

CREATE TABLE IF NOT EXISTS modules(
    id INT AUTO_INCREMENT PRIMARY KEY,
    module_name VARCHAR(100) NOT NULL,
    module_description TEXT,
    main_sgbd INT,
    alternative_sgbd INT,
    module_status ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo',
    FOREIGN KEY (main_sgbd) REFERENCES sgbds(id),
    FOREIGN KEY (alternative_sgbd) REFERENCES sgbds(id)
);

CREATE TABLE IF NOT EXISTS module_skills(
    id INT AUTO_INCREMENT PRIMARY KEY,
    module_id INT NOT NULL,
    skill_id INT NOT NULL,
    FOREIGN KEY (module_id) REFERENCES modules(id),
    FOREIGN KEY (skill_id) REFERENCES skills(id)
);

CREATE TABLE IF NOT EXISTS module_competencies(
    id INT AUTO_INCREMENT PRIMARY KEY,
    module_id INT NOT NULL,
    competency_id INT NOT NULL,
    FOREIGN KEY (module_id) REFERENCES modules(id),
    FOREIGN KEY (competency_id) REFERENCES competencies(id)
);

CREATE TABLE IF NOT EXISTS sessions_class(
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_name VARCHAR(100) NOT NULL,
    session_description TEXT,
    session_date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS session_modules(
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    module_id INT NOT NULL,
    FOREIGN KEY (session_id) REFERENCES sessions_class(id),
    FOREIGN KEY (module_id) REFERENCES modules(id)
);

-- creacion tabla asignacion de modulos a trainers

CREATE TABLE IF NOT EXISTS trainer_module_assignments (
    trainer_id INT NOT NULL,
    module_id INT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (trainer_id, module_id),
    CONSTRAINT fk_trainer FOREIGN KEY (trainer_id) REFERENCES trainer(id),
    CONSTRAINT fk_module FOREIGN KEY (module_id) REFERENCES modules(id)
); 

-- creacion tabla egresados

CREATE TABLE IF NOT EXISTS alumni (
    id INT AUTO_INCREMENT PRIMARY KEY,
    camper_id INT NOT NULL,
    graduation_date DATE NOT NULL,
    route_id INT NOT NULL,
    additional_info TEXT,
    FOREIGN KEY (camper_id) REFERENCES camper(id),
    FOREIGN KEY (route_id) REFERENCES routes(id)
);

-- creacion tabla areas de entrenamiento

CREATE TABLE IF NOT EXISTS training_areas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    area_name VARCHAR(50) NOT NULL,
    capacity INT NOT NULL DEFAULT 33 CHECK (capacity <= 33),
    training_areas_status ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo'
);

-- creacion tabla horarios

CREATE TABLE IF NOT EXISTS schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
    start_time TIME,
    end_time TIME
);

-- creacion tabla asignacion de rutas

CREATE TABLE IF NOT EXISTS route_assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    route_id INT NOT NULL,
    area_id INT NOT NULL,
    trainer_id INT NOT NULL,
    campers_group_id INT NOT NULL,
    FOREIGN KEY (route_id) REFERENCES routes(id),
    FOREIGN KEY (area_id) REFERENCES training_areas(id),
    FOREIGN KEY (trainer_id) REFERENCES trainer(id),
    FOREIGN KEY (campers_group_id) REFERENCES campers_group(id)
);

-- creacion tabla asignacion de rutas a campers

CREATE TABLE IF NOT EXISTS camper_route_enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    camper_id INT NOT NULL,
    route_id INT NOT NULL,
    enrollment_date DATE,
    camper_route_enrollment_status ENUM('Active', 'Completed', 'Dropped') DEFAULT 'Active',
    FOREIGN KEY (camper_id) REFERENCES camper(id),
    FOREIGN KEY (route_id) REFERENCES routes(id),
    UNIQUE (camper_id, route_id)
);

-- creacion tabla horario trainer

CREATE TABLE IF NOT EXISTS trainer_schedule (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trainer_id INT NOT NULL,
    schedule_id INT NOT NULL,
    area_id INT NOT NULL,
    route_id INT NOT NULL,
    campers_group_id INT NOT NULL,
    FOREIGN KEY (trainer_id) REFERENCES trainer(id),
    FOREIGN KEY (schedule_id) REFERENCES schedules(id),
    FOREIGN KEY (area_id) REFERENCES training_areas(id),
    FOREIGN KEY (route_id) REFERENCES routes(id),
    FOREIGN KEY (campers_group_id) REFERENCES campers_group(id),
    UNIQUE (trainer_id, schedule_id)
);

-- creacion tabla horario general

CREATE TABLE IF NOT EXISTS general_schedule (
    id INT AUTO_INCREMENT PRIMARY KEY,
    route_id INT NOT NULL,
    skill_id INT NOT NULL,
    schedule_id INT NOT NULL,
    FOREIGN KEY (route_id) REFERENCES routes(id),
    FOREIGN KEY (skill_id) REFERENCES skills(id),
    FOREIGN KEY (schedule_id) REFERENCES schedules(id),
    CONSTRAINT unique_schedule UNIQUE (route_id, skill_id, schedule_id)
);

-- Tabla de evaluaciones generales
CREATE TABLE IF NOT EXISTS evaluations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    camper_id INT NOT NULL,
    skill_id INT NOT NULL,
    camper_state ENUM('Aprobado', 'Reprobado'),
    final_grade DECIMAL(3,0) DEFAULT 0.00,
    FOREIGN KEY (camper_id) REFERENCES camper(id),
    FOREIGN KEY (skill_id) REFERENCES skills(id)
);

-- Tabla de componentes de evaluación
CREATE TABLE IF NOT EXISTS evaluation_components (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evaluation_id INT NOT NULL,
    component_type ENUM('Teorico', 'Practico', 'Quiz') NOT NULL,
    note DECIMAL(3,0) CHECK (note >= 0 AND note <= 100),
    evaluation_date DATE NOT NULL,
    FOREIGN KEY (evaluation_id) REFERENCES evaluations(id)
);

-- creacion tabla asistencia

CREATE TABLE IF NOT EXISTS attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    camper_id INT NOT NULL,
    route_id INT NOT NULL,
    skill_id INT NOT NULL,
    schedule_id INT NOT NULL,
    attendance_date DATE,
    attendance_status ENUM('Present', 'Absent', 'Late') DEFAULT 'Absent',
    arrival_time TIME NULL,
    justification TEXT,
    evidence_url VARCHAR(255),
    FOREIGN KEY (camper_id) REFERENCES camper(id),
    FOREIGN KEY (route_id) REFERENCES routes(id),
    FOREIGN KEY (skill_id) REFERENCES skills(id),
    FOREIGN KEY (schedule_id) REFERENCES schedules(id)
);