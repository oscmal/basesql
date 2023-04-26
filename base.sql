-- 1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido. 

-- Eliminar la base de datos si ya existe
DROP DATABASE IF EXISTS "desafio3-oscar-maldonado-123";

-- Crear y conectarse a la base de datos
CREATE DATABASE "desafio3-oscar-maldonado-123";
\c "desafio3-oscar-maldonado-123";

-- Crear tabla Usuarios
CREATE TABLE usuarios (id SERIAL, email VARCHAR, nombre VARCHAR, apellido VARCHAR, rol VARCHAR);

-- insertar datos en tabla usuarios
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES ('damian@email.com', 'damian', 'valdes', 'administrador');
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES ('matias@email.com', 'matias', 'maldonado', 'usuario');
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES ('amanda@email.com', 'amanda', 'pino', 'usuario');
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES ('joaquin@email.com', 'joaquin', 'himmers', 'usuario');
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES ('emily@email.com', 'emily', 'rios', 'usuario');

-- Crear tabla Posts
CREATE TABLE posts (id SERIAL, titulo VARCHAR, contenido TEXT, fecha_creacion TIMESTAMP, fecha_actualizacion TIMESTAMP, destacado BOOLEAN DEFAULT FALSE, usuario_id BIGINT);

-- insertar datos en tabla posts
INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES ('historia', 'contenido historia', '01/01/2020 19:35:00', '01/01/2021 18:18:42', true, 1 );
INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES ('matematicas', 'contenido matematicas', '01/02/2021 20:05:23', '01/02/2022 16:35:12', true, 1 );
INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES ('ciencias', 'contenido ciencias', '01/04/2021 16:34:54', '01/05/2022 08:25:43', true, 2 );
INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES ('musica', 'contenido musica', '01/06/2021 23:15:17', '01/06/2022 11:35:15', false, 3 );
INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES ('ingles', 'contenido ingles', '01/08/2020 00:48:23', '01/08/2022 12:06:53', false, null );

-- Crear tabla Comentarios
CREATE TABLE comentarios (id SERIAL, contenido VARCHAR, fecha_creacion TIMESTAMP, usuario_id BIGINT, post_id BIGINT);

-- insertar datos en tabla comentarios
INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES ('comentario 1', '03/04/2020 02:05:23', 1, 1);
INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES ('comentario 2', '03/07/2021 11:15:15', 2, 1);
INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES ('comentario 3', '03/02/2022 08:25:56', 3, 1);
INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES ('comentario 4', '03/05/2022 20:35:32', 1, 2);
INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES ('comentario 5', '03/07/2022 17:45:43', 2, 2);

-- 2. Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas. nombre e email del usuario junto al título y contenido del post.
SELECT u.nombre, u.email, p.titulo, p.contenido from usuarios as u INNER JOIN posts as p ON u.id = p.usuario_id;

-- 3. Muestra el id, título y contenido de los posts de los administradores. El administrador puede ser cualquier id y debe ser seleccionado dinámicamente.
SELECT p.id, p.titulo, p.contenido  from posts as p INNER JOIN usuarios as u ON p.usuario_id = u.id WHERE u.rol = 'administrador';

-- 4. Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.
-- Hint importante: Aquí hay diferencia entre utilizar inner join, left join o right join, prueba con todas y con eso determina cual es la correcta. No da lo mismo desde
-- cual tabla partes.
SELECT u.id, u.email, count ( p. * ) FROM usuarios as u  LEFT JOIN posts as p ON u.id = p.usuario_id GROUP BY u.id, u.email ORDER BY count(p.*) DESC;

-- 5. Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene un único registro y muestra solo el email.
SELECT u.email, count ( p. * ) FROM usuarios as u INNER JOIN posts as p ON u.id = p.usuario_id GROUP BY email ORDER BY count(p.*) DESC LIMIT 1 ;

-- 6. Muestra la fecha del último post de cada usuario.
-- Hint: Utiliza la función de agregado MAX sobre la fecha de creación.
SELECT u.email,max( p.fecha_creacion ) FROM usuarios as u INNER JOIN posts as p ON u.id = p.usuario_id GROUP BY u.email;

-- 7. Muestra el título y contenido del post (artículo) con más comentarios. 
SELECT p.titulo, p.contenido, count(*) FROM posts as p INNER JOIN comentarios as c ON p.id = c.post_id GROUP BY p.titulo, p.contenido ORDER BY count(p.*) DESC LIMIT 1;

-- 8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario
-- que lo escribió. 
SELECT p.titulo, p.contenido, c.contenido, u.email FROM comentarios as c INNER JOIN posts as p ON c.post_id = p.id INNER JOIN usuarios AS u ON c.usuario_id = u.id;

-- 9. Muestra el contenido del último comentario de cada usuario. 
SELECT u.email, c.contenido, c.fecha_creacion FROM comentarios as c INNER JOIN usuarios as u ON c.usuario_id = u.id WHERE c.fecha_creacion = (select MAX(c1.fecha_creacion) from comentarios as c1 WHERE c1.usuario_id = u.id);

-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario. 
SELECT u.email,count( c.* ) FROM usuarios as u LEFT JOIN comentarios as c ON u.id = c.usuario_id  GROUP BY u.email HAVING count(c.*) <= 0;















