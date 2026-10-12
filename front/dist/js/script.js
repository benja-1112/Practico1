// Lógica de la landing: pide autores, categorías y libros a la API y los pinta.

const POR_PAGINA = 9;
const MAX_PAGINAS = 6;

const catalogo = {
    libros: [],
    filtros: {},
    orden: '',
    texto: '',
    pagina: 1
};

let sesionAbierta = false;

document.addEventListener('DOMContentLoaded', iniciar);

async function iniciar() {
    document.getElementById('buscador').addEventListener('input', (evento) => {
        catalogo.texto = evento.target.value.trim().toLowerCase();
        catalogo.pagina = 1;
        pintarGrilla();
    });

    document.getElementById('filtros').addEventListener('click', (evento) => {
        const boton = evento.target.closest('button');
        if (!boton) return;
        const clave = boton.dataset.filtro;
        const valor = boton.dataset.valor;
        const yaEstaba = catalogo.filtros[clave] === valor;

        if (clave === 'tipo') delete catalogo.filtros.tipo;
        if (clave === 'origen') delete catalogo.filtros.origen;
        document.querySelectorAll('#filtros button').forEach((otro) => {
            if (otro.dataset.filtro === clave) otro.classList.remove('is-activo');
        });

        if (!yaEstaba) {
            catalogo.filtros[clave] = valor;
            boton.classList.add('is-activo');
        } else {
            delete catalogo.filtros[clave];
        }
        catalogo.pagina = 1;
        cargarLibros();
    });

    document.getElementById('filtro-autor').addEventListener('change', (evento) => {
        aplicarSelect('id_autor', evento.target.value);
    });
    document.getElementById('filtro-anio').addEventListener('change', (evento) => {
        aplicarSelect('anio', evento.target.value);
    });
    document.getElementById('filtro-categoria').addEventListener('change', (evento) => {
        aplicarSelect('id_categoria', evento.target.value);
    });
    document.getElementById('limpiar-filtros').addEventListener('click', limpiarFiltros);

    document.getElementById('orden').addEventListener('change', (evento) => {
        catalogo.orden = evento.target.value;
        catalogo.pagina = 1;
        cargarLibros();
    });

    document.getElementById('form-news').addEventListener('submit', (evento) => {
        evento.preventDefault();
        const aviso = document.getElementById('aviso-news');
        aviso.hidden = false;
        aviso.textContent = 'Pronto vas a poder suscribirte desde acá.';
    });

    document.getElementById('productos').addEventListener('click', comprar);
    armarMenuCarrito();

    document.getElementById('paginacion').addEventListener('click', (evento) => {
        const boton = evento.target.closest('button');
        if (!boton || boton.disabled) return;
        if (boton.dataset.pagina === 'anterior') catalogo.pagina -= 1;
        else if (boton.dataset.pagina === 'siguiente') catalogo.pagina += 1;
        else catalogo.pagina = Number(boton.dataset.pagina);
        pintarGrilla();
    });

    armarDesplegables();
    armarCarrusel();
    await Promise.all([cargarAutores(), cargarCategorias(), cargarDestacado(), cargarLibros(), pintarCuenta()]);
    llenarAnios();
}

async function pintarCuenta() {
    const menu = document.getElementById('cuenta-menu');
    const enlace = document.getElementById('cuenta');
    const nombre = document.getElementById('cuenta-nombre');
    const rol = document.getElementById('cuenta-rol');
    const panel = document.getElementById('cuenta-panel');
    const panelAdmin = document.getElementById('cuenta-panel-admin');
    const salir = document.getElementById('cuenta-salir');
    const sesion = await API.request('/sesion');
    if (!sesion || sesion.status !== 'ok' || !sesion.data) return;

    sesionAbierta = true;

    nombre.textContent = sesion.data.nombre_completo;
    rol.textContent = sesion.data.rol;
    rol.hidden = false;
    enlace.classList.add('cuenta--sesion');
    enlace.setAttribute('aria-haspopup', 'menu');
    enlace.setAttribute('aria-expanded', 'false');
    enlace.setAttribute('aria-label', sesion.data.nombre_completo + ', ' + sesion.data.rol);
    if (sesion.data.rol === 'Administrador') panelAdmin.hidden = false;

    function cerrarMenu() {
        panel.hidden = true;
        enlace.setAttribute('aria-expanded', 'false');
    }

    enlace.addEventListener('click', (evento) => {
        evento.preventDefault();
        cerrarPanelCarrito();
        const abrir = panel.hidden;
        panel.hidden = !abrir;
        enlace.setAttribute('aria-expanded', String(abrir));
    });

    document.addEventListener('click', (evento) => {
        if (menu.contains(evento.target)) return;
        cerrarMenu();
    });
    document.addEventListener('keydown', (evento) => {
        if (evento.key === 'Escape') cerrarMenu();
    });

    salir.addEventListener('click', async () => {
        await API.request('/logout', 'POST');
        sessionStorage.removeItem('booke-carrito');
        location.reload();
    });
    pintarCarrito();
}

function limpiarFiltros() {
    catalogo.filtros = {};
    catalogo.pagina = 1;
    document.querySelectorAll('#filtros button').forEach((boton) => {
        boton.classList.remove('is-activo');
    });
    document.querySelectorAll('aside .selector select').forEach((select) => {
        select.value = '';
        const desplegable = select.nextElementSibling;
        if (!desplegable) return;
        const rotulo = desplegable.querySelector('.desplegable__boton');
        const primera = select.options[0];
        if (rotulo && primera) rotulo.textContent = primera.textContent;
        desplegable.querySelectorAll('.desplegable__lista button').forEach((opcion) => {
            opcion.classList.toggle('is-elegida', opcion.dataset.valor === '');
        });
    });
    cerrarDesplegables();
    cargarLibros();
}

function aplicarSelect(clave, valor) {
    if (valor) catalogo.filtros[clave] = valor;
    else delete catalogo.filtros[clave];
    catalogo.pagina = 1;
    cargarLibros();
}

async function cargarAutores() {
    const respuesta = await API.request('/autores');
    if (respuesta.status !== 'ok' || !Array.isArray(respuesta.data)) return;

    const select = document.getElementById('filtro-autor');
    respuesta.data.forEach((autor) => {
        const option = document.createElement('option');
        option.value = String(autor.id_autor);
        option.textContent = autor.nombre;
        select.appendChild(option);
    });
}

async function cargarCategorias() {
    const respuesta = await API.request('/categorias');
    if (respuesta.status !== 'ok' || !Array.isArray(respuesta.data)) return;

    const select = document.getElementById('filtro-categoria');
    respuesta.data.forEach((categoria) => {
        const option = document.createElement('option');
        option.value = String(categoria.id_categoria);
        option.textContent = categoria.nombre;
        select.appendChild(option);
    });
}

async function cargarDestacado() {
    const caja = document.getElementById('libro-destacado');
    const respuesta = await API.request('/libros?mas_vendido=1');
    if (!respuesta || respuesta.status !== 'ok' || !Array.isArray(respuesta.data) || respuesta.data.length === 0) {
        caja.innerHTML = '<p>No hay un más vendido cargado.</p>';
        return;
    }
    const libro = respuesta.data[0];
    caja.innerHTML = `
        <div class="tapa-marco">
            ${tapa(libro, true)}
            <span class="insignia" aria-hidden="true"></span>
        </div>
        <p class="libro-destacado__titulo">${esc(libro.titulo)}</p>
        <p class="libro-destacado__autor">${esc(libro.nombre_autor || '')}</p>
        <p class="estrellas" aria-label="${libro.rating} de 5">${estrellas(libro.rating)}</p>
    `;
}

async function cargarLibros() {
    const params = new URLSearchParams();
    Object.entries(catalogo.filtros).forEach(([clave, valor]) => {
        if (valor) params.set(clave, valor);
    });
    if (catalogo.orden) params.set('orden', catalogo.orden);

    const consulta = params.toString();
    const respuesta = await API.request('/libros' + (consulta ? '?' + consulta : ''));
    if (!respuesta || respuesta.status !== 'ok' || !Array.isArray(respuesta.data)) {
        catalogo.libros = [];
        const grilla = document.getElementById('productos');
        grilla.innerHTML = `<p class="catalogo__estado">${esc(respuesta && respuesta.message ? respuesta.message : 'No se pudo conectar con la API')}</p>`;
        document.getElementById('contador').textContent = '0 Artículos';
        document.getElementById('paginacion').innerHTML = '';
        return;
    }

    catalogo.libros = respuesta.data;
    pintarGrilla();
}

function llenarAnios() {
    const anios = [...new Set(catalogo.libros.map((libro) => libro.anio).filter(Boolean))];
    anios.sort((a, b) => b - a);
    const select = document.getElementById('filtro-anio');
    anios.forEach((anio) => {
        const option = document.createElement('option');
        option.value = String(anio);
        option.textContent = String(anio);
        select.appendChild(option);
    });
}

function pintarGrilla() {
    const grilla = document.getElementById('productos');
    const visibles = catalogo.libros.filter((libro) => {
        if (!catalogo.texto) return true;
        const texto = (libro.titulo + ' ' + (libro.nombre_autor || '')).toLowerCase();
        return texto.includes(catalogo.texto);
    });

    const tope = visibles.slice(0, POR_PAGINA * MAX_PAGINAS);
    const totalPaginas = Math.max(1, Math.ceil(tope.length / POR_PAGINA));
    if (catalogo.pagina > totalPaginas) catalogo.pagina = totalPaginas;

    document.getElementById('contador').textContent = tope.length + (tope.length === 1 ? ' Artículo' : ' Artículos');

    if (tope.length === 0) {
        grilla.innerHTML = '<p class="catalogo__estado">No hay libros con esos filtros.</p>';
        document.getElementById('paginacion').innerHTML = '';
        return;
    }

    const inicio = (catalogo.pagina - 1) * POR_PAGINA;
    grilla.innerHTML = tope.slice(inicio, inicio + POR_PAGINA).map(cardLibro).join('');
    pintarPaginacion(totalPaginas);
}

function pintarPaginacion(totalPaginas) {
    const nav = document.getElementById('paginacion');
    if (totalPaginas <= 1) {
        nav.innerHTML = '';
        return;
    }

    const numeros = Array.from({ length: totalPaginas }, (_, indice) => {
        const numero = indice + 1;
        const activa = numero === catalogo.pagina;
        return `<button type="button" data-pagina="${numero}" class="${activa ? 'is-activa' : ''}" ${activa ? 'aria-current="page"' : ''}>${numero}</button>`;
    }).join('');
    const anterior = catalogo.pagina <= 1 ? 'disabled' : '';
    const siguiente = catalogo.pagina >= totalPaginas ? 'disabled' : '';
    nav.innerHTML = `
        <button type="button" class="paginacion__flecha" data-pagina="anterior" aria-label="Página anterior" ${anterior}>
            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M14.5 6.5L9 12l5.5 5.5"></path></svg>
        </button>
        ${numeros}
        <button type="button" class="paginacion__flecha" data-pagina="siguiente" aria-label="Página siguiente" ${siguiente}>
            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M9.5 6.5L15 12l-5.5 5.5"></path></svg>
        </button>
    `;
}

function cardLibro(libro) {
    return `
        <article class="card">
            <button type="button" class="corazon" aria-label="Favorito">
                <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 19s-7-4.4-7-9a4 4 0 0 1 7-2 4 4 0 0 1 7 2c0 4.6-7 9-7 9z"></path></svg>
            </button>
            ${tapa(libro)}
            <h3 class="card__titulo">${esc(libro.titulo)}</h3>
            <p class="card__autor">${esc(libro.nombre_autor || 'Autor sin cargar')}</p>
            <p class="card__precio">${precio(libro.precio)}</p>
            <button type="button" class="btn-comprar" data-id="${esc(libro.id_libro)}">Comprar</button>
        </article>
    `;
}

async function comprar(evento) {
    const boton = evento.target.closest('.btn-comprar');
    if (!boton) return;

    const sesion = await API.request('/sesion');
    if (!sesion || sesion.status !== 'ok' || !sesion.data) {
        location.href = 'login.html';
        return;
    }

    const libro = catalogo.libros.find((item) => String(item.id_libro) === boton.dataset.id);
    if (libro) guardarEnCarrito(libro);
    pintarCarrito();
}

function guardarEnCarrito(libro) {
    const items = leerCarrito();
    const id = String(libro.id_libro);
    const ya = items.find((item) => item.id === id);
    if (ya) {
        ya.cantidad += 1;
    } else {
        items.push({
            id,
            titulo: libro.titulo,
            autor: libro.nombre_autor || '',
            precio: libro.precio,
            imagen: libro.imagen || '',
            cantidad: 1
        });
    }
    sessionStorage.setItem('booke-carrito', JSON.stringify(items));
}

function quitarDelCarrito(id) {
    const items = leerCarrito().filter((item) => item.id !== id);
    sessionStorage.setItem('booke-carrito', JSON.stringify(items));
    pintarCarrito();
}

function leerCarrito() {
    try {
        const datos = JSON.parse(sessionStorage.getItem('booke-carrito'));
        return Array.isArray(datos) ? datos : [];
    } catch (error) {
        return [];
    }
}

function armarMenuCarrito() {
    const menu = document.getElementById('carrito-menu');
    const boton = document.getElementById('carrito');
    const panel = document.getElementById('carrito-panel');

    boton.addEventListener('click', () => {
        if (!sesionAbierta) {
            location.href = 'login.html';
            return;
        }
        const abrir = panel.hidden;
        const cuenta = document.getElementById('cuenta-panel');
        const enlace = document.getElementById('cuenta');
        if (cuenta) cuenta.hidden = true;
        if (enlace && enlace.getAttribute('aria-expanded') === 'true') {
            enlace.setAttribute('aria-expanded', 'false');
        }
        panel.hidden = !abrir;
        boton.setAttribute('aria-expanded', String(abrir));
    });

    panel.addEventListener('click', (evento) => {
        const quitar = evento.target.closest('[data-quitar]');
        if (!quitar) return;
        evento.stopPropagation();
        quitarDelCarrito(quitar.dataset.quitar);
    });

    document.addEventListener('click', (evento) => {
        if (menu.contains(evento.target)) return;
        cerrarPanelCarrito();
    });
    document.addEventListener('keydown', (evento) => {
        if (evento.key === 'Escape') cerrarPanelCarrito();
    });
}

function cerrarPanelCarrito() {
    const panel = document.getElementById('carrito-panel');
    const boton = document.getElementById('carrito');
    if (!panel || !boton) return;
    panel.hidden = true;
    boton.setAttribute('aria-expanded', 'false');
}

function pintarCarrito() {
    const aviso = document.getElementById('carrito-cantidad');
    const boton = document.getElementById('carrito');
    const panel = document.getElementById('carrito-panel');
    const items = leerCarrito();
    const total = items.reduce((suma, item) => suma + Number(item.cantidad || 0), 0);
    aviso.textContent = String(total);
    aviso.hidden = total === 0;
    boton.setAttribute('aria-label', total === 0 ? 'Carrito' : 'Carrito, ' + total + (total === 1 ? ' libro' : ' libros'));

    if (items.length === 0) {
        panel.innerHTML = '<p class="carrito__vacio">El carrito está vacío.</p>';
        return;
    }

    panel.innerHTML = `<ul class="carrito__lista">${items.map((item) => `
        <li class="carrito__item">
            ${tapaCarrito(item)}
            <div>
                <strong>${esc(item.titulo)}</strong>
                <span>${esc(item.autor)}${item.cantidad > 1 ? ' · ' + item.cantidad : ''} · ${precio(item.precio)}</span>
            </div>
            <button type="button" class="carrito__quitar" data-quitar="${esc(item.id)}">Quitar</button>
        </li>
    `).join('')}</ul>`;
}

function tapaCarrito(item) {
    if (!item.imagen) {
        const letra = String(item.titulo || '?').trim().slice(0, 1).toUpperCase();
        return `<div class="carrito__tapa" aria-hidden="true">${esc(letra)}</div>`;
    }
    return `<img src="${esc(item.imagen)}" alt="">`;
}

function tapa(libro, destacada) {
    const letras = iniciales(libro.titulo);
    let contenido;
    if (!libro.imagen) {
        contenido = `<div class="tapa-vacia" aria-label="${esc(libro.titulo)}"><span>${esc(letras)}</span></div>`;
    } else {
        contenido = `<img src="${esc(libro.imagen)}" alt="Tapa de ${esc(libro.titulo)}" data-letras="${esc(letras)}" onerror="var caja=document.createElement('div'); caja.className='tapa-vacia'; caja.innerHTML='<span>'+this.dataset.letras+'</span>'; this.replaceWith(caja);">`;
    }
    if (destacada) return contenido;
    return `<div class="escenario">${contenido}</div>`;
}

function iniciales(titulo) {
    return String(titulo || '')
        .split(/\s+/)
        .filter((parte) => parte && parte.toLowerCase() !== 'de' && parte.toLowerCase() !== 'el' && parte.toLowerCase() !== 'la' && parte.toLowerCase() !== 'los')
        .slice(0, 2)
        .map((parte) => parte[0])
        .join('')
        .toUpperCase();
}

function precio(valor) {
    if (valor === null || valor === undefined || valor === '') return 'Consultar';
    const numero = Number(valor).toLocaleString('es-UY', { maximumFractionDigits: 0 });
    return '$ ' + numero;
}

function estrellas(rating) {
    const llenas = Math.max(0, Math.min(5, Number(rating) || 0));
    return '★★★★★'.slice(0, llenas) + '☆☆☆☆☆'.slice(0, 5 - llenas);
}

function esc(valor) {
    return String(valor ?? '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}

function armarCarrusel() {
    const raiz = document.getElementById('carrusel');
    const fotos = [...raiz.querySelectorAll('.carrusel__ventana figure')];
    const puntos = [...raiz.querySelectorAll('.carrusel__puntos button')];
    let actual = 0;

    function mostrar(indice) {
        actual = (indice + fotos.length) % fotos.length;
        fotos.forEach((foto, i) => foto.classList.toggle('is-activa', i === actual));
        puntos.forEach((punto, i) => punto.classList.toggle('is-activa', i === actual));
    }

    raiz.querySelector('.carrusel__flecha--izq').addEventListener('click', () => mostrar(actual - 1));
    raiz.querySelector('.carrusel__flecha--der').addEventListener('click', () => mostrar(actual + 1));
    puntos.forEach((punto, i) => punto.addEventListener('click', () => mostrar(i)));
    mostrar(0);
}

function armarDesplegables() {
    document.querySelectorAll('aside .selector select').forEach(prepararDesplegable);
    document.addEventListener('click', (evento) => {
        if (evento.target.closest('.desplegable')) return;
        cerrarDesplegables();
    });
    document.addEventListener('keydown', (evento) => {
        if (evento.key === 'Escape') cerrarDesplegables();
    });
}

function prepararDesplegable(select) {
    const caja = document.createElement('div');
    caja.className = 'desplegable';
    const boton = document.createElement('button');
    boton.type = 'button';
    boton.className = 'desplegable__boton';
    boton.setAttribute('aria-expanded', 'false');
    const lista = document.createElement('ul');
    lista.className = 'desplegable__lista';
    lista.hidden = true;
    caja.append(boton, lista);
    select.after(caja);
    select.classList.add('selector__nativo');

    function pintar() {
        const elegida = select.options[select.selectedIndex];
        boton.textContent = elegida ? elegida.textContent : '';
        lista.replaceChildren(...[...select.options].map((opcion) => {
            const item = document.createElement('li');
            const opcionBoton = document.createElement('button');
            opcionBoton.type = 'button';
            opcionBoton.dataset.valor = opcion.value;
            opcionBoton.textContent = opcion.textContent;
            if (opcion.value === select.value) opcionBoton.classList.add('is-elegida');
            item.append(opcionBoton);
            return item;
        }));
    }

    new MutationObserver(pintar).observe(select, { childList: true });
    pintar();

    boton.addEventListener('click', () => {
        const abrir = lista.hidden;
        cerrarDesplegables();
        lista.hidden = !abrir;
        boton.setAttribute('aria-expanded', String(abrir));
    });

    lista.addEventListener('click', (evento) => {
        const opcionBoton = evento.target.closest('button');
        if (!opcionBoton) return;
        select.value = opcionBoton.dataset.valor;
        select.dispatchEvent(new Event('change'));
        pintar();
        lista.hidden = true;
        boton.setAttribute('aria-expanded', 'false');
    });
}

function cerrarDesplegables() {
    document.querySelectorAll('.desplegable__lista').forEach((lista) => {
        lista.hidden = true;
    });
    document.querySelectorAll('.desplegable__boton').forEach((boton) => {
        boton.setAttribute('aria-expanded', 'false');
    });
}
