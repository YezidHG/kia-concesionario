namespace kia_concesionario.Models
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    namespace kia_concesionario.Models
    {
        [Table("CLIENTE")]
        public class Cliente
        {
            [Key]
            [Column("CEDULA")]
            public string Cedula { get; set; }

            [Column("NOMBRE")]
            public string Nombre { get; set; }

            [Column("APELLIDO")]
            public string Apellido { get; set; }

            [Column("CORREO")]
            public string Correo { get; set; }

            [Column("CELULAR")]
            public string Celular { get; set; }
        }
    }

}
