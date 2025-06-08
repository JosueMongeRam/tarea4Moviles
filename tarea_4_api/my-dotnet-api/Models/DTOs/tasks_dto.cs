using System.ComponentModel.DataAnnotations;

namespace my_dotnet_api.Models.DTOs
{
    // ===============================================
    // DTOs para: getTask(task_id)
    // ===============================================
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

    // ===============================================
    // DTOs para: postTask(task)
    // ===============================================
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

    // ===============================================
    // DTOs para: putTask(task_id)
    // ===============================================
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

    // ===============================================
    // DTOs para: deleteTask(task_id)
    // ===============================================
    // No necesita DTO específico - solo usa el ID del parámetro

    // ===============================================
    // DTO base para Tasks (usado en relaciones con Users)
    // ===============================================
    public class TaskDto
    {
        public int TaskId { get; set; }
        public string TaskName { get; set; } = string.Empty;
        public string TaskDescription { get; set; } = string.Empty;
        public string TaskDate { get; set; } = string.Empty;
        public string TaskStatus { get; set; } = string.Empty;
        public int TaskUserId { get; set; }
    }

    // ===============================================
    // DTO simplificado para mostrar tareas en respuestas de usuario
    // ===============================================
    public class TaskSummaryDto
    {
        public int TaskId { get; set; }
        public string TaskName { get; set; } = string.Empty;
        public string TaskDescription { get; set; } = string.Empty;
        public string TaskStatus { get; set; } = string.Empty;  // Corregido
        public int TaskUserId { get; set; }  // Agregado si es necesario
    }
}