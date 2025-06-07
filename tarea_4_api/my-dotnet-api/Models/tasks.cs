using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace my_dotnet_api.Models
{
    [Table("Tasks")]
    public class Task
    {
        [Key]
        [Column("task_id")]
        public int TaskId { get; set; }

        [Required]
        [MaxLength(30)]
        [Column("task_name")]
        public string TaskName { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        [Column("task_description")]
        public string TaskDescription { get; set; } = string.Empty;

        [Required]
        [MaxLength(10)]
        [Column("task_date")]
        public string TaskDate { get; set; } = string.Empty;

        [Required]
        [MaxLength(1)]
        [Column("task_status")]
        public string TaskStatus { get; set; } = string.Empty;

        [Required]
        [Column("task_user_id")]
        public int TaskUserId { get; set; }

        // Relación con User
        [ForeignKey("TaskUserId")]
        public virtual User User { get; set; } = null!;
    }
}