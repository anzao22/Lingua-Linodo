-- Crear tabla usuarios
CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    rol ENUM('estudiante','docente','admin') NOT NULL
);

-- Crear tabla planes
CREATE TABLE planes (
    id_plan INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL
);

-- Crear tabla cursos
CREATE TABLE cursos (
    id_curso INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    id_plan INT,
    FOREIGN KEY (id_plan) REFERENCES planes(id_plan)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- Crear tabla modulos
CREATE TABLE modulos (
    id_modulo INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2),
    id_curso INT,
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- Crear tabla prerrequisitos
CREATE TABLE prerrequisitos (
    id_modulo INT,
    id_modulo_requerido INT,
    PRIMARY KEY (id_modulo, id_modulo_requerido),
    FOREIGN KEY (id_modulo) REFERENCES modulos(id_modulo)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_modulo_requerido) REFERENCES modulos(id_modulo)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Crear tabla pruebas_ingreso
CREATE TABLE pruebas_ingreso (
    id_prueba INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(50),
    resultado_minimo DECIMAL(5,2),
    id_modulo INT UNIQUE,
    FOREIGN KEY (id_modulo) REFERENCES modulos(id_modulo)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Crear tabla compras
CREATE TABLE compras (
    id_compra INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    tipo ENUM('plan','modulo') NOT NULL,
    id_usuario INT NOT NULL,
    id_plan INT,
    id_modulo INT,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_plan) REFERENCES planes(id_plan)
        ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (id_modulo) REFERENCES modulos(id_modulo)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- Crear tabla reglas_desbloqueo
CREATE TABLE reglas_desbloqueo (
    id_regla INT PRIMARY KEY AUTO_INCREMENT,
    condicion VARCHAR(100) NOT NULL,
    id_modulo INT NOT NULL,
    FOREIGN KEY (id_modulo) REFERENCES modulos(id_modulo)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Crear tabla de avance_academico
CREATE TABLE avances (
    id_avance INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_modulo INT NOT NULL,
    progreso DECIMAL(5,2) CHECK (progreso >= 0 AND progreso <= 100), -- % de avance
    fecha_ultimo DATETIME DEFAULT CURRENT_TIMESTAMP,
    nota DECIMAL(5,2), -- opcional, si quieres registrar calificación
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_modulo) REFERENCES modulos(id_modulo)
        ON UPDATE CASCADE ON DELETE CASCADE
);




-- INiCIO INSERCIÓN DE DATOS PARA RELLENAR TABLAS!!!



-- Insertar usuarios
INSERT INTO usuarios (nombre, email, rol) VALUES
('Silvia Oviedo', 'silvia@example.com', 'estudiante'),
('Juan Pérez', 'juan.perez@example.com', 'docente'),
('Admin UMNG', 'admin@umng.edu.co', 'admin'),
('Laura Gómez', 'laura.gomez@example.com', 'estudiante'),
('Carlos Ruiz', 'carlos.ruiz@example.com', 'estudiante');

-- Insertar planes
INSERT INTO planes (nombre, precio) VALUES
('Plan Básico', 5.00),
('Plan Completo', 15.00),
('Plan Deluxe', 25.00);

-- Insertar cursos
INSERT INTO cursos (nombre, descripcion, id_plan) VALUES
('Inglés para Principiantes', 'Curso introductorio de inglés básico', 1),
('Inglés Intermedio', 'Curso de inglés de nivel medio', 2),
('Inglés Avanzado', 'Curso de inglés avanzado y académico', 3);

-- Insertar módulos
INSERT INTO modulos (nombre, descripcion, precio, id_curso) VALUES
('Saludos y Presentaciones', 'Aprender saludos y a presentarse en inglés', 2.00, 1),
('Vocabulario de Viajes', 'Palabras y frases útiles para viajar', 2.50, 1),
('Conversación Cotidiana', 'Práctica de inglés conversacional diario', 3.00, 2),
('Inglés para Negocios', 'Vocabulario y situaciones laborales en inglés', 4.00, 2),
('Preparación para Exámenes Internacionales', 'Entrenamiento TOEFL/IELTS', 5.00, 3);

-- Insertar prerrequisitos
INSERT INTO prerrequisitos (id_modulo, id_modulo_requerido) VALUES
(2, 1),  -- Viajes requiere Presentaciones
(3, 2),  -- Conversación requiere Viajes
(4, 3),  -- Negocios requiere Conversación
(5, 4);  -- Exámenes requiere Negocios

-- Insertar pruebas de ingreso
INSERT INTO pruebas_ingreso (tipo, resultado_minimo, id_modulo) VALUES
('Diagnóstico', 60.0, 3),   -- Conversación Cotidiana
('Nivelación', 70.0, 4),    -- Inglés para Negocios
('Avanzado', 80.0, 5);      -- Preparación para Exámenes

-- Insertar compras
INSERT INTO compras (tipo, id_usuario, id_plan, id_modulo, fecha) VALUES
('plan', 1, 1, NULL, '2024-05-10 10:00:00'),  -- Silvia compra en 2024
('plan', 4, 2, NULL, '2025-03-15 15:30:00'),  -- Laura compra en 2025
('modulo', 5, NULL, 1, '2025-06-01 09:00:00');-- Carlos compra en 2025


-- Insertar reglas de desbloqueo
INSERT INTO reglas_desbloqueo (condicion, id_modulo) VALUES
('Compra directa', 1),
('Prerrequisito aprobado', 2),
('Prerrequisito aprobado o prueba de diagnóstico', 3),
('Prerrequisito aprobado o prueba de nivelación', 4),
('Prerrequisito aprobado o prueba de nivel avanzado', 5);

-- insertar grado de avance
INSERT INTO avances (id_usuario, id_modulo, progreso, fecha_ultimo, nota) VALUES
(1, 1, 80.0, '2025-10-03', 4.5),  -- Silvia en Saludos y Presentaciones
(4, 2, 60.0, '2024-10-11', 3.8),  -- Laura en Vocabulario de Viajes
(5, 1, 20.0, '2025-06-06', 2.5);  -- Carlos en Saludos y Presentaciones



-- OPERACIONES ALGEBRAICAS

SELECT * 
FROM compras 
WHERE tipo = 'plan' AND id_plan = 2;

SELECT nombre, precio 
FROM modulos;


SELECT u.nombre, c.id_usuario, YEAR(c.fecha) AS anio
FROM compras c
JOIN usuarios u ON c.id_usuario = u.id_usuario
WHERE YEAR(c.fecha) = 2024

UNION

SELECT u.nombre, c.id_usuario, YEAR(c.fecha) AS anio
FROM compras c
JOIN usuarios u ON c.id_usuario = u.id_usuario
WHERE YEAR(c.fecha) = 2025;

SELECT p.id_plan, p.nombre
FROM planes p
LEFT JOIN compras co ON p.id_plan = co.id_plan
WHERE co.id_plan IS NULL;

SELECT * 
FROM cursos 
CROSS JOIN planes;

-- CÁLCULOS RELACIONALES
-- interseccion entre estudiantes con compras y avance
SELECT DISTINCT c.id_usuario
FROM compras c
INNER JOIN avances a ON c.id_usuario = a.id_usuario;

-- unión avances e información básica

SELECT u.nombre, a.id_modulo, a.progreso, a.nota
FROM usuarios u
INNER JOIN avances a ON u.id_usuario = a.id_usuario;

-- promedio superior según progreso
SELECT a.*
FROM avances a
JOIN (
  SELECT AVG(progreso) AS prom
  FROM avances
) x
ON a.progreso > x.prom;

-- Inserto un dato a Silvia para poder hacer consulta de División
-- Darle a Silvia un módulo también
INSERT INTO compras (tipo, id_usuario, id_plan, id_modulo, fecha) VALUES
('modulo', 1, NULL, 2, '2025-07-01 10:00:00');


-- División: compraron un plan y un módulo 

SELECT u.id_usuario, u.nombre
FROM usuarios u
WHERE EXISTS (
    SELECT 1 FROM compras c1 
    WHERE c1.id_usuario = u.id_usuario AND c1.tipo = 'plan'
)
AND EXISTS (
    SELECT 1 FROM compras c2
    WHERE c2.id_usuario = u.id_usuario AND c2.tipo = 'modulo'
);
-- Agregación: promedio nota por módulo

SELECT m.nombre AS modulo, ROUND(AVG(a.nota),2) AS promedio_nota
FROM avances a
JOIN modulos m ON a.id_modulo = m.id_modulo
GROUP BY m.nombre;

-- Consults DML Básicas

-- insertar fonética Básica
INSERT INTO modulos (nombre, descripcion, precio, id_curso)
VALUES ('A2 – Fonética básica', 'Módulo sobre pronunciación y fonética inicial', 5.00, 1);

SELECT * FROM modulos;

-- listar avances usuario módulo
SELECT u.nombre, m.nombre AS modulo, a.progreso, a.nota
FROM avances a
JOIN usuarios u ON a.id_usuario = u.id_usuario
JOIN modulos m ON a.id_modulo = m.id_modulo;

-- UPDATE (ajustar nota en un módulo específico)
UPDATE avances
SET nota = 4.0
WHERE id_usuario = 5 AND id_modulo = 1;

SELECT * FROM avances;

-- DELETE (eliminar registros antiguos de compras

DELETE FROM compras
WHERE YEAR(fecha) < 2025;

SELECT * FROM compras;

-- UPDATE con condición múltiple 
UPDATE avances a
JOIN modulos m ON a.id_modulo = m.id_modulo
SET a.progreso = a.progreso + 10
WHERE a.id_usuario = 1 AND m.id_curso = 1;


-- INSERT SELECT (registrar un avance inicia)

INSERT INTO avances (id_usuario, id_modulo, progreso, fecha_ultimo, nota)
SELECT c.id_usuario, c.id_modulo, 0, NOW(), NULL
FROM compras c
WHERE c.tipo = 'modulo'
  AND NOT EXISTS (
    SELECT 1 FROM avances a 
    WHERE a.id_usuario = c.id_usuario AND a.id_modulo = c.id_modulo
  );

SELECT * FROM avances;

-- FUNCIONES DE VENTANA
-- ¿Qué estudiante tiene mayor progreso en cada curso?

SELECT u.nombre, m.id_curso, a.progreso,
  RANK() OVER (PARTITION BY m.id_curso ORDER BY a.progreso DESC) AS ranking
FROM avances a
JOIN usuarios u ON u.id_usuario = a.id_usuario
JOIN modulos m ON m.id_modulo = a.id_modulo;

-- ¿Cómo cambió el progreso de un estudiante entre reportes de avance?

SELECT u.nombre, a.id_modulo, a.fecha_ultimo, a.progreso,
  LAG(a.progreso) OVER (PARTITION BY a.id_usuario, a.id_modulo ORDER BY a.fecha_ultimo) AS progreso_anterior,
  LEAD(a.progreso) OVER (PARTITION BY a.id_usuario, a.id_modulo ORDER BY a.fecha_ultimo) AS progreso_siguiente,
  (a.progreso - LAG(a.progreso) OVER (PARTITION BY a.id_usuario, a.id_modulo ORDER BY a.fecha_ultimo)) AS delta
FROM avances a
JOIN usuarios u ON u.id_usuario = a.id_usuario;

-- Cómo evoluciona el progreso promedio de un estudiante en un módulo?

SELECT u.nombre, a.id_modulo, a.fecha_ultimo, a.progreso,
  AVG(a.progreso) OVER (
    PARTITION BY a.id_usuario, a.id_modulo 
    ORDER BY a.fecha_ultimo
    ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
  ) AS prom_movil
FROM avances a
JOIN usuarios u ON u.id_usuario = a.id_usuario;

-- Reporte exportado JSON

SELECT JSON_OBJECT(
  'estudiante', u.nombre,
  'modulo', m.nombre,
  'curso', c.nombre,
  'progreso', a.progreso,
  'nota', a.nota,
  'retro', JSON_ARRAYAGG(rd.condicion)
) AS reporte_json
FROM avances a
JOIN usuarios u ON u.id_usuario = a.id_usuario
JOIN modulos m ON m.id_modulo = a.id_modulo
JOIN cursos c ON c.id_curso = m.id_curso
LEFT JOIN reglas_desbloqueo rd ON rd.id_modulo = m.id_modulo
GROUP BY u.id_usuario, m.id_modulo, c.id_curso, a.progreso, a.nota;

-- 1.	INNER JOIN múltiple → avances con usuarios y módulos.

SELECT u.nombre, m.nombre AS modulo, a.progreso, a.nota
FROM avances a
INNER JOIN usuarios u ON a.id_usuario = u.id_usuario
INNER JOIN modulos m ON a.id_modulo = m.id_modulo;

-- 2.	LEFT JOIN con subconsulta → cursos y número de est

SELECT c.nombre AS curso, IFNULL(x.total_estudiantes,0) AS inscritos
FROM cursos c
LEFT JOIN (
  SELECT m.id_curso, COUNT(DISTINCT a.id_usuario) AS total_estudiantes
  FROM avances a
  JOIN modulos m ON a.id_modulo = m.id_modulo
  GROUP BY m.id_curso
) x ON x.id_curso = c.id_curso;

-- SELF JOIN jerárquico → prerrequisitos entre módulos.

SELECT m1.nombre AS modulo, m2.nombre AS requiere
FROM prerrequisitos p
JOIN modulos m1 ON p.id_modulo = m1.id_modulo
JOIN modulos m2 ON p.id_modulo_requerido = m2.id_modulo;

-- 1. Vista de Seguridad con Restricciones (solo estudiantes activos)

CREATE VIEW estudiantes_activos AS
SELECT 
  u.id_usuario,
  u.nombre,
  u.email,
  u.rol,
  a.id_modulo,
  a.progreso,
  a.nota
FROM usuarios u
JOIN avances a ON u.id_usuario = a.id_usuario
WHERE u.rol = 'estudiante'
WITH CHECK OPTION;

SELECT * 
FROM estudiantes_activos;


-- 3.	Vista compleja de análisis académico (panel de cursos)

CREATE VIEW dashboard_cursos AS
SELECT 
  c.id_curso,
  c.nombre AS curso,
  COUNT(DISTINCT a.id_usuario) AS total_estudiantes,
  ROUND(AVG(a.progreso), 1) AS progreso_promedio,
  ROUND(AVG(a.nota), 2) AS nota_promedio,
  COUNT(DISTINCT m.id_modulo) AS modulos_totales
FROM cursos c
LEFT JOIN modulos m ON m.id_curso = c.id_curso
LEFT JOIN avances a ON a.id_modulo = m.id_modulo
GROUP BY c.id_curso, c.nombre
HAVING total_estudiantes > 0;

SELECT * 
FROM dashboard_cursos;

-- 3. Vista Materializada simulada (top estudiantes por rendimiento)


-- Crear tabla de rendimiento (como materializada)
CREATE TABLE mv_rendimiento_estudiantes AS
SELECT 
  u.id_usuario,
  u.nombre,
  COUNT(DISTINCT a.id_modulo) AS modulos_cursados,
  ROUND(AVG(a.progreso), 1) AS progreso_promedio,
  ROUND(AVG(a.nota), 2) AS nota_promedio,
  DATE(NOW()) AS fecha_calculo
FROM usuarios u
JOIN avances a ON u.id_usuario = a.id_usuario
WHERE u.rol = 'estudiante'
GROUP BY u.id_usuario, u.nombre;

-- Crear vista sobre la tabla
CREATE VIEW v_top_students AS
SELECT *,
CASE
  WHEN progreso_promedio >= 80 AND nota_promedio >= 4.0 THEN 'Sobresaliente'
  WHEN progreso_promedio >= 60 THEN 'En buen camino'
  ELSE 'Necesita refuerzo'
END AS categoria
FROM mv_rendimiento_estudiantes
ORDER BY progreso_promedio DESC, nota_promedio DESC;


-- ÌNDICES 

-- consultas frecuentes por usuario y módulo)
CREATE INDEX idx_compras_usuario_modulo
ON compras(id_usuario, id_modulo);
-- compruebo
EXPLAIN SELECT *
FROM compras
WHERE id_usuario = 1
  AND tipo = 'plan'
ORDER BY fecha DESC;

-- . Índice funcional (para búsqueda por correo)
CREATE INDEX idx_usuario_email_domain
ON usuarios((SUBSTRING_INDEX(email, '@', -1)));

EXPLAIN SELECT id_usuario, nombre, email
FROM usuarios
WHERE SUBSTRING_INDEX(email, '@', -1) = 'example.com';

-- Índice de texto completo (para búsquedas en nombres de módulos)

CREATE FULLTEXT INDEX idx_modulos_nombre_desc
ON modulos(nombre, descripcion);

EXPLAIN SELECT id_modulo, nombre, descripcion,
  MATCH(nombre, descripcion) AGAINST('viajes' IN NATURAL LANGUAGE MODE) AS relevancia
FROM modulos
WHERE MATCH(nombre, descripcion) AGAINST('viajes' IN NATURAL LANGUAGE MODE)
ORDER BY relevancia DESC;

-- buscar rápido módulos con palabras clave:

SELECT nombre, descripcion,
MATCH(nombre, descripcion) AGAINST('viajes inglés' IN BOOLEAN MODE) AS relevancia
FROM modulos
WHERE MATCH(nombre, descripcion) AGAINST('viajes inglés' IN BOOLEAN MODE)
ORDER BY relevancia DESC;

EXPLAIN SELECT id_modulo, nombre, descripcion,
  MATCH(nombre, descripcion) AGAINST('viajes inglés' IN BOOLEAN MODE) AS relevancia
FROM modulos
WHERE MATCH(nombre, descripcion) AGAINST('viajes inglés' IN BOOLEAN MODE)
ORDER BY relevancia DESC;

