document.addEventListener('DOMContentLoaded', iniciar);

const POR_PAGINA = 9;

const panel = {
    libros: [],
    pagina: 1
};

async function iniciar() {
    const sesion = await API.request('/sesion');
    if (!sesion || sesion.status !== 'ok' || !sesion.data) {
        location.replace('login.html');
        return;
    }
    if (sesion.data.rol !== 'Administrador') {
        location.replace('index.html');
        return;
    }

    document.getElementById('nombre').textContent = sesion.data.nombre_completo;
    document.getElementById('rol').textContent = sesion.data.rol;
    document.body.hidden = false;
    document.getElementById('salir').addEventListener('click', salir);
    document.getElementById('buscar').addEventListener('input', alFiltrar);
    document.getElementById('filtro-tipo').addEventListener('change', alFiltrar);
    document.getElementById('filtro-origen').addEventListener('change', alFiltrar);
    document.getElementById('filtro-autor').addEventListener('change', alFiltrar);
    document.getElementById('filtro-categoria').addEventListener('change', alFiltrar);
    document.getElementById('limpiar').addEventListener('click', limpiar);
    document.getElementById('paginacion').addEventListener('click', (evento) => {
        const boton = evento.target.closest('button');
        if (!boton || boton.disabled) return;
        if (boton.dataset.pagina === 'anterior') panel.pagina -= 1;
        else if (boton.dataset.pagina === 'siguiente') panel.pagina += 1;
        else panel.pagina = Number(boton.dataset.pagina);
        pintarTabla();
    });
    document.getElementById('filtros').addEventListener('submit', (evento) => evento.preventDefault());
    await cargarLibros();
}

async function cargarLibros() {
    const respuesta = await API.request('/admin/libros');
    const cuerpo = document.getElementById('filas');
    if (!respuesta || respuesta.status !== 'ok' || !Array.isArray(respuesta.data)) {
        cuerpo.innerHTML = `<tr><td colspan="4">${esc(respuesta && respuesta.message ? respuesta.message : 'No se pudo leer el catálogo.')}</td></tr>`;
        document.getElementById('conteo').textContent = '';
        document.getElementById('paginacion').innerHTML = '';
        return;
    }

    panel.libros = respuesta.data;
    llenarSelect('filtro-autor', unicos(respuesta.data, 'id_autor', 'nombre_autor'), 'Todos');
    llenarSelect('filtro-categoria', unicos(respuesta.data, 'id_categoria', 'nombre_categoria'), 'Todas');
    pintarTabla();
}

function unicos(libros, id, nombre) {
    const mapa = new Map();
    libros.forEach((libro) => {
        if (libro[id] == null || !libro[nombre]) return;
        mapa.set(String(libro[id]), libro[nombre]);
    });
    return [...mapa.entries()].sort((a, b) => a[1].localeCompare(b[1], 'es'));
}

function llenarSelect(id, opciones, primera) {
    const select = document.getElementById(id);
    const valor = select.value;
    select.innerHTML = `<option value="">${esc(primera)}</option>` + opciones.map(([clave, texto]) => (
        `<option value="${esc(clave)}">${esc(texto)}</option>`
    )).join('');
    if ([...select.options].some((opcion) => opcion.value === valor)) select.value = valor;
}

function librosVisibles() {
    const texto = document.getElementById('buscar').value.trim().toLowerCase();
    const tipo = document.getElementById('filtro-tipo').value;
    const origen = document.getElementById('filtro-origen').value;
    const autor = document.getElementById('filtro-autor').value;
    const categoria = document.getElementById('filtro-categoria').value;

    return panel.libros.filter((libro) => {
        if (tipo && libro.tipo !== tipo) return false;
        if (origen && libro.origen !== origen) return false;
        if (autor && String(libro.id_autor) !== autor) return false;
        if (categoria && String(libro.id_categoria) !== categoria) return false;
        if (!texto) return true;
        const busqueda = (libro.titulo + ' ' + libro.nombre_autor).toLowerCase();
        return busqueda.includes(texto);
    });
}

function alFiltrar() {
    panel.pagina = 1;
    pintarTabla();
}

function pintarTabla() {
    const cuerpo = document.getElementById('filas');
    const visibles = librosVisibles();
    const total = panel.libros.length;
    const conteo = document.getElementById('conteo');
    const totalPaginas = Math.max(1, Math.ceil(visibles.length / POR_PAGINA));
    if (panel.pagina > totalPaginas) panel.pagina = totalPaginas;
    if (panel.pagina < 1) panel.pagina = 1;

    conteo.textContent = visibles.length === total
        ? total + (total === 1 ? ' libro' : ' libros')
        : visibles.length + ' de ' + total + ' libros';

    if (visibles.length === 0) {
        cuerpo.innerHTML = '<tr><td colspan="4">Ningún libro coincide con esos filtros.</td></tr>';
        pintarPaginacion(0);
        return;
    }

    const inicio = (panel.pagina - 1) * POR_PAGINA;
    cuerpo.innerHTML = visibles.slice(inicio, inicio + POR_PAGINA).map((libro) => `
        <tr>
            <td>${esc(libro.titulo)}</td>
            <td>${esc(libro.nombre_autor)}</td>
            <td>${esc(libro.nombre_categoria)}</td>
            <td>${precio(libro.precio)}</td>
        </tr>
    `).join('');
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
        const activa = numero === panel.pagina;
        return `<button type="button" data-pagina="${numero}" class="${activa ? 'is-activa' : ''}" ${activa ? 'aria-current="page"' : ''}>${numero}</button>`;
    }).join('');
    const anterior = panel.pagina <= 1 ? 'disabled' : '';
    const siguiente = panel.pagina >= totalPaginas ? 'disabled' : '';
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

function limpiar() {
    document.getElementById('filtros').reset();
    panel.pagina = 1;
    pintarTabla();
}

async function salir() {
    await API.request('/logout', 'POST');
    location.replace('login.html');
}

function precio(valor) {
    if (valor === null || valor === undefined || valor === '') return 'Consultar';
    return '$ ' + Number(valor).toLocaleString('es-UY', { maximumFractionDigits: 0 });
}

function esc(valor) {
    return String(valor ?? '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}
