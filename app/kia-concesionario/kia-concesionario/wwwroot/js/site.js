// Please see documentation at https://learn.microsoft.com/aspnet/core/client-side/bundling-and-minification
// for details on configuring this project to bundle and minify static web assets.

// Write your JavaScript code.
document.addEventListener('DOMContentLoaded', function () {
    const calendar = document.getElementById('calendar');
    const selectedDateInput = document.getElementById('selectedDate');
    const fechaSeleccionadaText = document.getElementById('fechaSeleccionada');
    const hoy = new Date();
    let mesActual = hoy.getMonth();
    let añoActual = hoy.getFullYear();

    function renderCalendario() {
        calendar.innerHTML = '';

        // Días de la semana (encabezados)
        ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'].forEach(dia => {
            const diaHeader = document.createElement('div');
            diaHeader.className = 'font-semibold py-1';
            diaHeader.textContent = dia;
            calendar.appendChild(diaHeader);
        });

        // Primer día del mes
        const primerDia = new Date(añoActual, mesActual, 1).getDay();
        const ultimoDia = new Date(añoActual, mesActual + 1, 0).getDate();

        // Espacios vacíos antes del primer día
        for (let i = 0; i < primerDia; i++) {
            calendar.appendChild(document.createElement('div'));
        }

        // Días del mes
        for (let dia = 1; dia <= ultimoDia; dia++) {
            const diaElement = document.createElement('div');
            diaElement.className = 'p-2 border rounded cursor-pointer hover:bg-gray-100 dia';
            diaElement.textContent = dia;

            // Resaltar día actual
            if (dia === hoy.getDate() && mesActual === hoy.getMonth() && añoActual === hoy.getFullYear()) {
                diaElement.classList.add('bg-blue-100', 'font-bold');
            }

            // Selección de fecha
            diaElement.addEventListener('click', () => {
                document.querySelectorAll('.dia').forEach(d =>
                    d.classList.remove('bg-black', 'text-white')
                );
                diaElement.classList.add('bg-black', 'text-white');

                const fecha = new Date(añoActual, mesActual, dia);
                selectedDateInput.value = fecha.toISOString().split('T')[0]; // Formato YYYY-MM-DD
                fechaSeleccionadaText.textContent = `Fecha seleccionada: ${fecha.toLocaleDateString('es-ES', {
                    weekday: 'long',
                    day: 'numeric',
                    month: 'long'
                })}`;
            });

            calendar.appendChild(diaElement);
        }
    }

    renderCalendario();
});