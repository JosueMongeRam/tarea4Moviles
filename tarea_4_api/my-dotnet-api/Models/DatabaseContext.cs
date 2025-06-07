using Microsoft.EntityFrameworkCore;

namespace my_dotnet_api.Models
{
    public class DatabaseContext : DbContext
    {
        public DatabaseContext(DbContextOptions<DatabaseContext> options) : base(options)
        {
        }

        public DbSet<User> Users { get; set; } = null!;
        public DbSet<Models.Task> Tasks { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Configuración de User - usar tabla existente
            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("Users");
                entity.HasKey(e => e.UserId);
                entity.Property(e => e.UserId).HasColumnName("user_id");
                entity.Property(e => e.UserName).HasColumnName("user_name").HasMaxLength(30);
                entity.Property(e => e.UserEmail).HasColumnName("user_email").HasMaxLength(30);
                entity.Property(e => e.UserPassword).HasColumnName("user_password").HasMaxLength(30);
            });

            // Configuración de Task - usar tabla existente
            modelBuilder.Entity<Models.Task>(entity =>
            {
                entity.ToTable("Tasks");
                entity.HasKey(e => e.TaskId);
                entity.Property(e => e.TaskId).HasColumnName("task_id");
                entity.Property(e => e.TaskName).HasColumnName("task_name").HasMaxLength(30);
                entity.Property(e => e.TaskDescription).HasColumnName("task_description").HasMaxLength(100);
                entity.Property(e => e.TaskDate).HasColumnName("task_date").HasMaxLength(10);
                entity.Property(e => e.TaskStatus).HasColumnName("task_status").HasMaxLength(1);
                entity.Property(e => e.TaskUserId).HasColumnName("task_user_id");

                // Configurar relación
                entity.HasOne(t => t.User)
                      .WithMany(u => u.Tasks)
                      .HasForeignKey(t => t.TaskUserId)
                      .OnDelete(DeleteBehavior.Restrict);
            });
        }
    }
}