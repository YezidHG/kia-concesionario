namespace kia_concesionario.Models
{
    using System;
    using System.ComponentModel.DataAnnotations.Schema;

    namespace kia_concesionario.Models
    {
        [Table("CITA")]
        public class Cita
        {
            [Column("ID_CITA")]
            public int Id_cita { get; set; }

            [Column("CEDULA_CLIENTE")]
            public string Cedula_cliente { get; set; }

            [Column("FECHA_CITA")]
            public DateTime Fecha_cita { get; set; }

            [Column("HORA_CITA")]
            public string Hora_cita { get; set; }

            [Column("ESTADO")]
            public string Estado { get; set; }
        }
    }
}
