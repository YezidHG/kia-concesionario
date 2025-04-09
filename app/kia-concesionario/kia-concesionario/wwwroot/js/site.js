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

            //Resaltar dia del mes
            if (dia === hoy.getDate() && mesActual === hoy.getMonth() && añoActual === hoy.getFullYear()) {
                diaElement.classList.add('bg-blue-100', 'font-bold'); // Día actual en azul
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
                        onclick="guardarHoraSeleccionada('${hora}', '${fecha}', this)"
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
});

function guardarHoraSeleccionada(hora, fecha, elemento) {
    // Remover selección previa
    document.querySelectorAll('.hora-btn').forEach(btn => {
        btn.classList.remove('seleccionada');
    });

    // Resaltar hora clickeada
    elemento.classList.add('seleccionada');

    // Guardar hora
    document.getElementById('horaSeleccionada').value = hora;
}

// Mostrar modal al hacer clic en "Cancelar Cita"
document.getElementById('btnCancelarCita').addEventListener('click', () => {
    document.getElementById('modalCancelar').classList.remove('hidden');
});

// Enviar formulario de cancelación (simulación)
document.getElementById('formCancelar').addEventListener('submit', (e) => {
    e.preventDefault();
    const cedula = e.target.cedula.value;
    const celular = e.target.celular.value;

    // Aquí iría la lógica para enviar al backend (simulamos con un alert)
    alert(`Solicitud de cancelación enviada para:\nCédula: ${cedula}\nCelular: ${celular}`);

    // Cierra el modal
    document.getElementById('modalCancelar').classList.add('hidden');
    e.target.reset(); // Limpia el formulario
});