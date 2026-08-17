-- Taller 2 — SELECT y NULL
-- Integrantes: Juan Molina, Jesus Chaves
-- Fecha: 2026-08-09
-- Docente: Hermes A. Acevedo Castellanos
-- Instituto Universitario de la Paz — UNIPAZ 
--  Escuela de Ciencias  Ingeniería Informática


-- Punto:1

SELECT id_ejemplar, codigo_barras, estado
FROM ejemplar
WHERE estado <> 'prestado'
   OR estado IS NULL;

-- Explicación:
-- Aquí muestro los ejemplares que no están prestados.
-- También pongo los que tienen NULL, porque NULL no funciona con <>.
--
-- Comprobación:
SELECT COUNT(*) FROM ejemplar;
SELECT COUNT(*) FROM ejemplar WHERE estado = 'prestado';
SELECT COUNT(*) FROM ejemplar WHERE estado <> 'prestado';

-- Hay 20 ejemplares en total.
-- Hay 7 prestados y 11 diferentes de 'prestado'.
-- 7 + 11 = 18, así que faltan 2.
-- Son BU-0019 y BU-0020, que tienen estado NULL.
-- PostgreSQL no los toma con <> porque NULL no se compara como un valor normal.


-- Punto:2

SELECT nombre || ' (' || COALESCE(nacionalidad, 'sin nacionalidad') || ')' AS ficha
FROM autor;

-- Explicación:
-- El autor que se pierde es Ricardo Socas Gutiérrez.
-- Su nacionalidad está en NULL.
-- Al unir un texto con NULL, toda la expresión queda en NULL.
-- COALESCE cambia el NULL por 'sin nacionalidad' y así aparecen los 10.


-- Punto:3

SELECT id_prestamo,
       fecha_devolucion_esperada,
       DATE '2026-08-05' - fecha_devolucion_esperada AS dias_retraso
FROM prestamo
WHERE fecha_devolucion_real IS NULL
  AND fecha_devolucion_esperada < DATE '2026-08-05';

-- Explicación:
-- IS NULL sirve para buscar los préstamos que todavía no se han devuelto.
-- También reviso que la fecha esperada sea menor al 5 de agosto.
-- Uso < porque si vence exactamente hoy, todavía no tiene días de retraso.
-- Los préstamos que aparecen son el 15 y el 19.


-- Punto:4

SELECT titulo,
       2026 - anio_publicacion AS antiguedad
FROM libro
WHERE (2026 - anio_publicacion) > 10
ORDER BY antiguedad DESC;

-- Explicación de los errores:
-- No puedo usar antiguedad directamente en WHERE porque WHERE se ejecuta
-- antes que SELECT. Por eso vuelvo a escribir la operación en WHERE.
-- ORDER BY sí puede usar antiguedad porque se ejecuta después del SELECT.
-- El orden simplificado es FROM, WHERE, SELECT y ORDER BY.
-- El libro que tiene el año NULL no aparece porque no se puede calcular
-- su antigüedad.


-- Punto:5


SELECT titulo,
       anio_publicacion,
       COALESCE(editorial, 'Editorial no registrada') AS editorial
FROM libro
ORDER BY anio_publicacion DESC NULLS LAST;

-- Explicación:
-- Muestro todos los libros ordenados del más nuevo al más viejo.
-- NULLS LAST deja el libro sin año al final.
-- COALESCE cambia la editorial NULL por 'Editorial no registrada'.
-- Si no pongo NULL LAST, al ordenar de forma descendente el NULL puede
-- quedar al principio y eso dañaría el orden de las novedades.


-- Punto:6

SELECT DISTINCT estado
FROM ejemplar;

SELECT COUNT(*)
FROM ejemplar
WHERE estado IS NULL;

-- Explicación:
-- DISTINCT muestra los NULL repetidos como una sola opción.
-- Por eso aparecen disponible, prestado, deteriorado y NULL.
-- En cambio, COUNT con IS NULL muestra que hay 2 ejemplares con estado NULL.
-- Aunque DISTINCT los agrupe, eso no significa que NULL = NULL sea verdadero.


-- Punto:7

SELECT COUNT(*) AS total_prestamos
FROM prestamo;

SELECT COUNT(dias_mora) AS prestamos_con_dias_mora
FROM prestamo;

SELECT AVG(dias_mora) AS promedio_dias_mora
FROM prestamo;

-- Explicación:
-- COUNT(*) cuenta los 20 préstamos.
-- COUNT(dias_mora) cuenta solamente los que tienen un valor en dias_mora,
-- que son 8.
-- AVG también ignora los NULL, por eso 7,25 se calcula sobre 8 préstamos.
-- En este caso NULL significa que no hubo mora.
-- Si quiero que esos casos cuenten como 0 para sacar un promedio general,
-- puedo usar COALESCE.

SELECT AVG(COALESCE(dias_mora, 0)) AS promedio_general_dias_mora
FROM prestamo;

-- La decisión de usar 0 depende de qué significa NULL en el sistema.


-- Punto:8

-- Primera forma:
SELECT nombre, tipo
FROM usuario
WHERE tipo <> 'estudiante'
   OR tipo IS NULL;

-- Segunda forma:
SELECT nombre, tipo
FROM usuario
-- WHERE tipo IS DISTINCT FROM 'estudiante';

-- Explicación:
-- Sandra Milena Ávila queda por fuera de la consulta original porque
-- su tipo es NULL.
-- Las dos consultas anteriores incluyen el NULL.
-- IS DISTINCT FROM es una forma más directa de decir que quiero todo
-- lo que sea diferente de estudiante, incluyendo NULL.
--
-- En un sistema real usaría IS DISTINCT FROM porque es más sencillo
-- de leer para este caso y compara los valores teniendo en cuenta NULL.
-- Sobre Sandra, depende de la regla de la biblioteca. Si NULL significa
-- que no sabemos su tipo, no necesariamente debería recibir el carnet.
-- Si la regla dice que todo el que no sea estudiante lo recibe, entonces sí.
