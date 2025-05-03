using System.ComponentModel.DataAnnotations.Schema;

namespace kia_concesionario.Models
{
    [Table("COTIZACION_VEHICULO")]
    public class CotizacionVehiculo
    {
        [ForeignKey("Cotizacion")]
        [Column("ID_COTIZACION")]
        public int IdCotizacion { get; set; }
        public Cotizacion Cotizacion { get; set; }

        [ForeignKey("Vehiculo")]
        [Column("ID_VEHICULO")]
        public int IdVehiculo { get; set; }
        public Vehiculo Vehiculo { get; set; }
    }
}
