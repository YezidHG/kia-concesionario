namespace kia_concesionario.Data
{
    using Microsoft.EntityFrameworkCore;
    using kia_concesionario.Models;
    using kia_concesionario.Models.kia_concesionario.Models;

    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

        public DbSet<Cliente> Clientes { get; set; }
        public DbSet<Vehiculo> Vehiculos { get; set; }
        public DbSet<Cita> Citas { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("KIA"); // Nombre del usuario de Oracle

            modelBuilder.Entity<Cliente>().ToTable("CLIENTE").HasKey(c => c.Cedula);
            modelBuilder.Entity<Vehiculo>().ToTable("VEHICULO").HasKey(v => v.Id_vehiculo);
            modelBuilder.Entity<Cita>().ToTable("CITA").HasKey(c => c.Id_cita);
        }
    }


}
