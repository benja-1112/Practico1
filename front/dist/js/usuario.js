document.addEventListener('DOMContentLoaded', iniciar);

async function iniciar() {
    const sesion = await API.request('/sesion');
    if (!sesion || sesion.status !== 'ok' || !sesion.data) {
        location.replace('login.html');
        return;
    }
    if (sesion.data.rol === 'Administrador') {
        location.replace('admin.html');
        return;
    }

    location.replace('index.html');
}
