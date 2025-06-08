using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace my_dotnet_api.Models
{
    [Table("Users")]
    public class User
    {
        [Key]
        [Column("user_id")]
        public int UserId { get; set; }

        [Required]
        [MaxLength(30)]
        [Column("user_name")]
        public string UserName { get; set; } = string.Empty;

        [Required]
        [MaxLength(30)]
        [Column("user_email")]
        public string UserEmail { get; set; } = string.Empty;

        [Required]
        [MaxLength(30)]
        [Column("user_password")]
        public string UserPassword { get; set; } = string.Empty;

        // Relación uno a muchos con Tasks
        public virtual ICollection<Task> Tasks { get; set; } = new List<Task>();
    }
}