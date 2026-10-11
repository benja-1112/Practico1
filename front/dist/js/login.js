document.addEventListener('DOMContentLoaded', iniciar);

async function iniciar() {
    const sesion = await API.request('/sesion');
    if (sesion.status === 'ok' && sesion.data) {
        irSegunRol(sesion.data.rol);
        return;
    }

    document.getElementById('form-login').addEventListener('submit', entrar);
}

async function entrar(evento) {
    evento.preventDefault();
    const error = document.getElementById('error');
    error.hidden = true;

    const respuesta = await API.request('/login', 'POST', {
        email: document.getElementById('email').value.trim(),
        clave: document.getElementById('clave').value
    });

    if (!respuesta || respuesta.status !== 'ok' || !respuesta.data) {
        error.hidden = false;
        error.textContent = respuesta && respuesta.message ? respuesta.message : 'No se pudo iniciar sesión.';
        return;
    }

    irSegunRol(respuesta.data.rol);
}

function irSegunRol(rol) {
    if (rol === 'Administrador') {
        location.replace('admin.html');
        return;
    }
    location.replace('index.html');
}
