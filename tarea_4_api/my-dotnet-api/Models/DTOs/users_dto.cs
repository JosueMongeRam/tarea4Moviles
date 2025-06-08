using System.ComponentModel.DataAnnotations;

namespace my_dotnet_api.Models.DTOs
{
    // ===============================================
    // DTOs para: getUser(user_id) y getUsers()
    // ===============================================
    public class UserResponseDto
    {
        public int UserId { get; set; }
        public string UserName { get; set; } = string.Empty;
        public string UserEmail { get; set; } = string.Empty;
        // Sin contraseña por seguridad
        public List<TaskDto>? Tasks { get; set; }
    }

    // ===============================================
    // DTOs para: login(user_email, user_password)
    // ===============================================
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
        // Mensaje de éxito o token (opcional)
        public string Message { get; set; } = "Login exitoso";
    }

    // ===============================================
    // DTOs para: postUser(user)
    // ===============================================
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

    // ===============================================
    // DTOs para: putUser(user_id)
    // ===============================================
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

    // ===============================================
    // DTOs para: deleteUser(user_id)
    // ===============================================
    // No necesita DTO específico - solo usa el ID del parámetro

    // ===============================================
    // DTOs para: getUserTasks(user_id)
    // ===============================================
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