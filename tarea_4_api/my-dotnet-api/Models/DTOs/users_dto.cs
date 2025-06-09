using System.ComponentModel.DataAnnotations;

namespace my_dotnet_api.Models.DTOs
{
    public class UserResponseDto
    {
        public int UserId { get; set; }
        public string UserName { get; set; } = string.Empty;
        public string UserEmail { get; set; } = string.Empty;
        public List<TaskDto>? Tasks { get; set; }
    }

    public class LoginRequestDto
    {
        [Required(ErrorMessage = "El email es requerido")]
        [EmailAddress(ErrorMessage = "Formato de email inválido")]
        public string UserEmail { get; set; } = string.Empty;

        [Required(ErrorMessage = "La contraseña es requerida")]
        [MinLength(6, ErrorMessage = "La contraseña debe tener al menos 6 caracteres")]
        public string UserPassword { get; set; } = string.Empty;
    }

    public class LoginResponseDto
    {
        public int UserId { get; set; }
        public string UserName { get; set; } = string.Empty;
        public string UserEmail { get; set; } = string.Empty;
        public List<TaskDto>? Tasks { get; set; }
        public string Message { get; set; } = "Login exitoso";
    }

    public class CreateUserDto
    {
        [Required(ErrorMessage = "El nombre de usuario es requerido")]
        [MaxLength(30, ErrorMessage = "El nombre no puede exceder 30 caracteres")]
        public string UserName { get; set; } = string.Empty;

        [Required(ErrorMessage = "El email es requerido")]
        [EmailAddress(ErrorMessage = "Formato de email inválido")]
        [MaxLength(30, ErrorMessage = "El email no puede exceder 30 caracteres")]
        public string UserEmail { get; set; } = string.Empty;

        [Required(ErrorMessage = "La contraseña es requerida")]
        [MinLength(6, ErrorMessage = "La contraseña debe tener al menos 6 caracteres")]
        [MaxLength(30, ErrorMessage = "La contraseña no puede exceder 30 caracteres")]
        public string UserPassword { get; set; } = string.Empty;
    }

    public class UpdateUserDto
    {
        [Required(ErrorMessage = "El nombre de usuario es requerido")]
        [MaxLength(30, ErrorMessage = "El nombre no puede exceder 30 caracteres")]
        public string UserName { get; set; } = string.Empty;

        [Required(ErrorMessage = "El email es requerido")]
        [EmailAddress(ErrorMessage = "Formato de email inválido")]
        [MaxLength(30, ErrorMessage = "El email no puede exceder 30 caracteres")]
        public string UserEmail { get; set; } = string.Empty;

        [MaxLength(30, ErrorMessage = "La contraseña no puede exceder 30 caracteres")]
        public string? UserPassword { get; set; } // Opcional para actualización
    }

    public class UserTasksResponseDto
    {
        public int UserId { get; set; }
        public string UserName { get; set; } = string.Empty;
        public string UserEmail { get; set; } = string.Empty;
        public List<TaskDto> Tasks { get; set; } = new List<TaskDto>();
        public int TotalTasks { get; set; }
        public int CompletedTasks { get; set; }
        public int PendingTasks { get; set; }
    }

}