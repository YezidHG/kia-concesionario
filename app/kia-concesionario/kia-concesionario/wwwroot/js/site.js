// Please see documentation at https://learn.microsoft.com/aspnet/core/client-side/bundling-and-minification
// for details on configuring this project to bundle and minify static web assets.

// Write your JavaScript code.
document.addEventListener('DOMContentLoaded', function () {
    // ========== Funciones para Agendar Cita ==========
    const calendar = document.getElementById('calendar');
    const selectedDateInput = document.getElementById('selectedDate');
    const fechaSeleccionadaText = document.getElementById('fechaSeleccionada');
    const hoy = new Date();
    let mesActual = hoy.getMonth();
    let añoActual = hoy.getFullYear();

    renderCalendario();

    function renderCalendario() {
        calendar.innerHTML = '';

        // Días de la semana
        ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'].forEach(dia => {
            const diaHeader = document.createElement('div');
            diaHeader.className = 'font-semibold py-1';
            diaHeader.textContent = dia;
            calendar.appendChild(diaHeader);
        });

        const primerDia = new Date(añoActual, mesActual, 1).getDay();
        const ultimoDia = new Date(añoActual, mesActual + 1, 0).getDate();

        // Espacios vacíos
        for (let i = 0; i < primerDia; i++) {
            calendar.appendChild(document.createElement('div'));
        }

        // Días del mes
        for (let dia = 1; dia <= ultimoDia; dia++) {
            const fechaActual = new Date(añoActual, mesActual, dia);
            const diaElement = document.createElement('div');
            diaElement.className = 'p-2 border rounded cursor-pointer dia';
            diaElement.textContent = dia;

            // Resaltar día actual
            if (dia === hoy.getDate() && mesActual === hoy.getMonth() && añoActual === hoy.getFullYear()) {
                diaElement.classList.add('bg-blue-100', 'font-bold');
            }

            // Bloquear días pasados
            if (fechaActual < new Date(hoy.getFullYear(), hoy.getMonth(), hoy.getDate())) {
                diaElement.classList.add('bg-gray-200', 'text-gray-400');
                diaElement.style.cursor = 'not-allowed';
            } else {
                diaElement.addEventListener('click', () => {
                    document.querySelectorAll('.dia').forEach(d => {
                        d.classList.remove('bg-black', 'text-white');
                    });
                    diaElement.classList.add('bg-black', 'text-white');

                    const fechaFormateada = `${añoActual}-${String(mesActual + 1).padStart(2, '0')}-${String(dia).padStart(2, '0')}`;
                    selectedDateInput.value = fechaFormateada;

                    fechaSeleccionadaText.textContent = `Fecha seleccionada: ${fechaActual.toLocaleDateString('es-ES', {
                        weekday: 'long',
                        day: 'numeric',
                        month: 'long'
                    })}`;

                    mostrarHorarios(fechaFormateada);
                });
            }
            calendar.appendChild(diaElement);
        }
    }

    function mostrarHorarios(fecha) {
        const horariosDiv = document.createElement('div');
        horariosDiv.id = 'horarios';
        horariosDiv.className = 'mt-4 space-y-2';

        const horarios = [];
        for (let hora = 8; hora <= 16; hora += 2) {
            horarios.push(`${String(hora).padStart(2, '0')}:00`);
        }

        horariosDiv.innerHTML = `
            <h3 class="font-bold mb-2">Horarios disponibles:</h3>
            <div class="grid grid-cols-2 gap-2">
                ${horarios.map(hora => `
                    <button 
                        type="button"
                        class="p-2 bg-gray-100 hover:bg-gray-200 rounded hora-btn"
                        data-hora="${hora}"
                        onclick="guardarHoraSeleccionada('${hora}', this)"
                    >
                        ${hora}
                    </button>
                `).join('')}
            </div>
        `;

        const horariosExistente = document.getElementById('horarios');
        if (horariosExistente) horariosExistente.remove();
        calendar.parentNode.appendChild(horariosDiv);
    }

    // ========== Funciones para Cancelar Cita ==========
    document.getElementById('btnCancelarCita')?.addEventListener('click', () => {
        document.getElementById('modalCancelar').classList.remove('hidden');
    });

    document.getElementById('formCancelar')?.addEventListener('submit', (e) => {
        e.preventDefault();
        const cedula = e.target.cedula.value.trim();

        if (!cedula) {
            alert("Por favor ingresa tu cédula");
            return;
        }

        alert(`✔️ Cita cancelada para la cédula: ${cedula}`);
        document.getElementById('modalCancelar').classList.add('hidden');
        e.target.reset();
    });

    // ========== Funciones para Aplazar Cita ==========
    document.getElementById('btnAplazarCita')?.addEventListener('click', () => {
        document.getElementById('modalAplazar').classList.remove('hidden');
        renderCalendarioAplazar();
    });

    function renderCalendarioAplazar() {
        const calendar = document.getElementById('calendarAplazar');
        calendar.innerHTML = '';

        const hoy = new Date();
        let mesActual = hoy.getMonth();
        let añoActual = hoy.getFullYear();

        // Encabezados de días
        ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'].forEach(dia => {
            const diaHeader = document.createElement('div');
            diaHeader.className = 'font-semibold py-1';
            diaHeader.textContent = dia;
            calendar.appendChild(diaHeader);
        });

        const primerDia = new Date(añoActual, mesActual, 1).getDay();
        const ultimoDia = new Date(añoActual, mesActual + 1, 0).getDate();

        // Días del mes
        for (let i = 0; i < primerDia; i++) {
            calendar.appendChild(document.createElement('div'));
        }

        for (let dia = 1; dia <= ultimoDia; dia++) {
            const fechaActual = new Date(añoActual, mesActual, dia);
            const diaElement = document.createElement('div');
            diaElement.className = 'p-2 border rounded cursor-pointer dia';
            diaElement.textContent = dia;

            if (fechaActual < new Date(hoy.getFullYear(), hoy.getMonth(), hoy.getDate())) {
                diaElement.classList.add('bg-gray-200', 'text-gray-400');
                diaElement.style.cursor = 'not-allowed';
            } else {
                diaElement.addEventListener('click', () => {
                    document.querySelectorAll('#calendarAplazar .dia').forEach(d => {
                        d.classList.remove('bg-black', 'text-white');
                    });
                    diaElement.classList.add('bg-black', 'text-white');

                    const fechaFormateada = `${añoActual}-${String(mesActual + 1).padStart(2, '0')}-${String(dia).padStart(2, '0')}`;
                    document.getElementById('nuevaFecha').value = fechaFormateada;
                    mostrarHorariosAplazar(fechaFormateada);
                });
            }
            calendar.appendChild(diaElement);
        }
    }

    function mostrarHorariosAplazar(fecha) {
        const contenedor = document.getElementById('horariosAplazar');
        const listaHorarios = document.getElementById('listaHorariosAplazar');

        listaHorarios.innerHTML = '';
        const horarios = [];

        for (let hora = 8; hora <= 16; hora += 2) {
            horarios.push(`${String(hora).padStart(2, '0')}:00`);
        }

        horarios.forEach(hora => {
            const botonHora = document.createElement('button');
            botonHora.type = 'button';
            botonHora.className = 'p-2 bg-gray-100 hover:bg-gray-200 rounded hora-btn';
            botonHora.textContent = hora;
            botonHora.onclick = function () {
                document.querySelectorAll('#listaHorariosAplazar .hora-btn').forEach(btn => {
                    btn.classList.remove('seleccionada');
                });
                this.classList.add('seleccionada');
                document.getElementById('horaSeleccionadaAplazar').value = hora;
            };
            listaHorarios.appendChild(botonHora);
        });

        contenedor.classList.remove('hidden');
    }

    document.getElementById('formAplazar')?.addEventListener('submit', (e) => {
        e.preventDefault();
        const cedula = e.target.cedula.value;
        const nuevaFecha = document.getElementById('nuevaFecha').value;
        const nuevaHora = document.getElementById('horaSeleccionadaAplazar')?.value;

        if (!nuevaHora) {
            alert("Por favor selecciona una hora");
            return;
        }

        alert(`✅ Cita aplazada para:\nCédula: ${cedula}\nNueva fecha: ${nuevaFecha}\nNueva hora: ${nuevaHora}`);
        document.getElementById('modalAplazar').classList.add('hidden');
        e.target.reset();
    });
});

// Función global para selección de horas (Agendar)
function guardarHoraSeleccionada(hora, elemento) {
    document.querySelectorAll('.hora-btn').forEach(btn => {
        btn.classList.remove('seleccionada');
    });
    elemento.classList.add('seleccionada');
    document.getElementById('horaSeleccionada').value = hora;
}