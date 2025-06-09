using System.ComponentModel.DataAnnotations;

namespace my_dotnet_api.Models.DTOs
{
    public class TaskResponseDto
    {
        public int TaskId { get; set; }
        public string TaskName { get; set; } = string.Empty;
        public string TaskDescription { get; set; } = string.Empty;
        public string TaskDate { get; set; } = string.Empty;
        public string TaskStatus { get; set; } = string.Empty;
        public int TaskUserId { get; set; }
        public string? UserName { get; set; }
        public string? UserEmail { get; set; }
    }

    public class CreateTaskDto
    {
        [Required(ErrorMessage = "El nombre de la tarea es requerido")]
        [MaxLength(30, ErrorMessage = "El nombre no puede exceder 30 caracteres")]
        public string TaskName { get; set; } = string.Empty;
        
        [MaxLength(100, ErrorMessage = "La descripción no puede exceder 100 caracteres")]
        public string TaskDescription { get; set; } = string.Empty;
        
        [Required(ErrorMessage = "La fecha de la tarea es requerida")]
        [MaxLength(10, ErrorMessage = "La fecha no puede exceder 10 caracteres")]
        public string TaskDate { get; set; } = string.Empty;
        
        [Required(ErrorMessage = "El estado de la tarea es requerido")]
        [MaxLength(1, ErrorMessage = "El estado no puede exceder 1 carácter")]
        public string TaskStatus { get; set; } = string.Empty;
        
        [Required(ErrorMessage = "El ID del usuario es requerido")]
        public int TaskUserId { get; set; }
    }

    public class UpdateTaskDto
    {
        [Required(ErrorMessage = "El nombre de la tarea es requerido")]
        [MaxLength(30, ErrorMessage = "El nombre no puede exceder 30 caracteres")]
        public string TaskName { get; set; } = string.Empty;
        
        [MaxLength(100, ErrorMessage = "La descripción no puede exceder 100 caracteres")]
        public string TaskDescription { get; set; } = string.Empty;
        
        [Required(ErrorMessage = "La fecha de la tarea es requerida")]
        [MaxLength(10, ErrorMessage = "La fecha no puede exceder 10 caracteres")]
        public string TaskDate { get; set; } = string.Empty;
        
        [Required(ErrorMessage = "El estado de la tarea es requerido")]
        [MaxLength(1, ErrorMessage = "El estado no puede exceder 1 carácter")]
        public string TaskStatus { get; set; } = string.Empty;
    }

    public class TaskDto
    {
        public int TaskId { get; set; }
        public string TaskName { get; set; } = string.Empty;
        public string TaskDescription { get; set; } = string.Empty;
        public string TaskDate { get; set; } = string.Empty;
        public string TaskStatus { get; set; } = string.Empty;
        public int TaskUserId { get; set; }
    }

    public class TaskSummaryDto
    {
        public int TaskId { get; set; }
        public string TaskName { get; set; } = string.Empty;
        public string TaskDescription { get; set; } = string.Empty;
        public string TaskStatus { get; set; } = string.Empty;
        public int TaskUserId { get; set; }
    }
}