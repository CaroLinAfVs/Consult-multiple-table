
-- creando base de datos
CREATE DATABASE desafio_carolina_venegas;

--creando tabla usuarios
CREATE TABLE usuarios (
    id SERIAL,
    email VARCHAR ,
    nombre VARCHAR (75),
    apellido VARCHAR (75),
    rol VARCHAR );
--adjuntando valores
INSERT INTO usuarios (id,email, nombre, apellido, rol) 
VALUES (DEFAULT ,'elena@gmail.com', 'elena', 'kripke', 'usuario'),
       (DEFAULT ,'bill@gmail.com', 'bill', 'hoster', 'administrador'),
       (DEFAULT ,'amy@gmail.com', 'amy', 'cooper', 'usuario'),
       (DEFAULT ,'peter@gmail.com', 'peter', 'brown', 'usuario'),
       (DEFAULT ,'storm@gmail.com', 'storm', 'giron', 'usuario');

-- creando tabla post
CREATE TABLE post (
    id SERIAL,
    titulo VARCHAR,
    contenido  TEXT,
    fecha_creacion TIMESTAMP ,
    fecha_actualizacion TIMESTAMP,
    destacado BOOLEAN ,
    usuario_id BIGINT 
 );
 
 -- ingresando valores a post 
 INSERT INTO post (id, titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) 
 VALUES (DEFAULT ,'titulo 1', 'contenido 1', '02/11/22 13:00:00', '02/11/22 13:00:00', true, 1),
        (DEFAULT ,'titulo 2', 'contenido 2', '05/11/22 13:10:00','02/11/22 13:00:00',false ,3),
        (DEFAULT ,'titulo 3', 'contenido 3', '10/06/22 13:21:05','02/11/22 13:00:00',true , 2),
        (DEFAULT ,'titulo 4', 'contenido 4', '10/01/22 15:00:30','02/11/22 13:00:00', true , 1),
        (DEFAULT ,'titulo 5', 'contenido 5', '12/04/22 19:20:00','02/11/22 13:00:00', false, null)
        ;

-- creando tabla comentarios
CREATE TABLE comentarios (
    id SERIAL,
    contenido VARCHAR,
    fecha_creacion TIMESTAMP,
    usuario_id BIGINT,
    post_id BIGINT
);

-- ingresando valores a comentarios
INSERT INTO comentarios (id, contenido, fecha_creacion, usuario_id, post_id) 
VALUES (DEFAULT, 'comment 1','02/11/22 13:00:00', 1, 1),
       (DEFAULT, 'comment 2','02/01/22 19:00:00', 2, 1),
       (DEFAULT, 'comment 3','11/10/22 12:20:00', 3, 1),
       (DEFAULT, 'comment 4','02/11/22 15:30:10', 2, 2),
       (DEFAULT, 'comment 5','09/03/22 10:05:30', 1, 2)
       ;

-- Cruza los datos de la tabla usuarios y posts mostrando nombre e email del usuario junto al título y contenido del post
SELECT u.nombre ,u.email, p.titulo, p.contenido 
FROM usuarios AS u JOIN post p ON u.id = p.usuario_id;

--Muestra el id, título y contenido de los posts de los administradores. El administrador puede ser cualquier id y debe ser seleccionado dinámicamente.
SELECT u.nombre, u.id, p.titulo, p.contenido FROM post p 
JOIN usuarios u ON p.usuario_id = u.id 
WHERE u.rol =  'administrador' ;

--Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario
SELECT u.id, u.email, COUNT(p.id) FROM usuarios u  LEFT JOIN post p  ON u.id = p.usuario_id GROUP BY u.id, u.email;

--Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene un único registro y muestra solo el email.
SELECT u.email, count(p.id) FROM post p  JOIN usuarios u  ON p.usuario_id = u.id GROUP BY u.email;

--Muestra la fecha del último post de cada usuario.
SELECT nombre, MAX(fecha_creacion) FROM (SELECT p.contenido,p.fecha_creacion, u.nombre FROM usuarios u JOIN post p ON u.id = p.usuario_id) AS po GROUP BY po.nombre;

--Muestra el título y contenido del post (artículo) con más comentarios
SELECT titulo, contenido FROM post p JOIN (SELECT post_id, COUNT(post_id) FROM comentarios GROUP BY post_id ORDER BY count DESC LIMIT 1) AS c ON p.id = c.post_id;

/*Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
  de cada comentario asociado a los posts mostrados, junto con el email del usuario
  que lo escribió*/
SELECT p.titulo as titulo_post, p.contenido as contenido_post, c.contenido as contenido_comentario, u.email FROM post p JOIN comentarios c ON p.id = c.post_id JOIN usuarios u ON c.usuario_id = u.id;

--Muestra el contenido del último comentario de cada usuario
SELECT fecha_creacion, contenido, usuario_id, u.nombre FROM comentarios c JOIN usuarios u ON c.usuario_id = u.id WHERE c.fecha_creacion = (SELECT MAX(fecha_creacion) FROM comentarios WHERE usuario_id = u.id);

--Muestra los emails de los usuarios que no han escrito ningún comentario
SELECT u.email FROM usuarios u LEFT JOIN comentarios c ON u.id = c.usuario_id GROUP BY u.email HAVING COUNT(c.id) = 0;



