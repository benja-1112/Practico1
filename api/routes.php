<?php
// api/routes.php
// Acá se anota: "cuando pidan ESTA url, ejecutá ESTE controlador@método"

$router->get('/estado', 'EstadoController@ver');
$router->get('/autores', 'AutorController@listar');
$router->get('/categorias', 'CategoriaController@listar');
$router->get('/libros', 'LibroController@listar');
$router->post('/login', 'AuthController@login');
$router->get('/sesion', 'AuthController@ver');
$router->post('/logout', 'AuthController@logout');
$router->get('/admin/libros', 'LibroController@listarAdmin');

// Próxima clase: favoritos y carrito
// $router->post('/favoritos', 'FavoritoController@guardar');
// $router->post('/carrito', 'CarritoController@agregar');
