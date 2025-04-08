namespace kia_concesionario.Models
{
    using System;

    namespace kia_concesionario.Models
    {
        public class Cita
        {
            public int Id_cita { get; set; }
            public string Cedula_cliente { get; set; }
            public DateTime Fecha_cita { get; set; }
            public string Hora_cita { get; set; }
            public string Estado { get; set; }
        }
    }
}
