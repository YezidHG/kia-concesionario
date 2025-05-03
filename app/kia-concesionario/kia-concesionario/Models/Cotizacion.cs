using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace kia_concesionario.Models
{
    [Table("COTIZACION")]
    public class Cotizacion
    {
        [Key]
        [Column("ID_COTIZACION")]
        public int IdCotizacion { get; set; }

        [Required]
        [Column("ESTADO_COTIZACION")]
        public string EstadoCotizacion { get; set; }

        [Required]
        [Column("FECHA_CREACION")]
        public DateTime FechaCreacion { get; set; }

        [Required]
        [Column("DESCRIPCION")]
        public string Descripcion { get; set; }

        // Relación con Cliente (clave foránea)
        [ForeignKey("Cliente")]
        [Column("CEDULA_CLIENTE")]
        public int CedulaCliente { get; set; }
        public Cliente Cliente { get; set; }

        // Relación muchos a muchos con Vehiculo a través de CotizacionVehiculo
        public ICollection<CotizacionVehiculo> CotizacionVehiculos { get; set; }
    }
}
