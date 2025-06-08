using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using my_dotnet_api.Models;
using my_dotnet_api.Models.DTOs;

namespace my_dotnet_api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsersController : ControllerBase
    {
        private readonly DatabaseContext _context;

        public UsersController(DatabaseContext context)
        {
            _context = context;
        }

        // 1. GET: api/Users - getUsers()
        [HttpGet]
        public async Task<ActionResult<IEnumerable<UserResponseDto>>> GetUsers()
        {
            var users = await _context.Users.Include(u => u.Tasks).ToListAsync();
            
            var userDtos = users.Select(user => new UserResponseDto
            {
                UserId = user.UserId,
                UserName = user.UserName,
                UserEmail = user.UserEmail,
                Tasks = user.Tasks?.Select(t => new TaskDto
                {
                    TaskId = t.TaskId,
                    TaskName = t.TaskName,
                    TaskDescription = t.TaskDescription,
                    TaskDate = t.TaskDate,
                    TaskStatus = t.TaskStatus,
                    TaskUserId = t.TaskUserId  // Corregido de UserId
                }).ToList()
            }).ToList();

            return Ok(userDtos);
        }

        // 2. GET: api/Users/{id} - getUser(user_id)
        [HttpGet("{id}")]
        public async Task<ActionResult<UserResponseDto>> GetUser(int id)
        {
            var user = await _context.Users.Include(u => u.Tasks).FirstOrDefaultAsync(u => u.UserId == id);
            
            if (user == null)
            {
                return NotFound($"Usuario con ID {id} no encontrado");
            }

            var userDto = new UserResponseDto
            {
                UserId = user.UserId,
                UserName = user.UserName,
                UserEmail = user.UserEmail,
                Tasks = user.Tasks?.Select(t => new TaskDto
                {
                    TaskId = t.TaskId,
                    TaskName = t.TaskName,
                    TaskDescription = t.TaskDescription,
                    TaskDate = t.TaskDate,
                    TaskStatus = t.TaskStatus,
                    TaskUserId = t.TaskUserId
                }).ToList()
            };

            return Ok(userDto);
        }

        // 3. POST: api/Users/login - login(user_email, user_password)
        [HttpPost("login")]
        public async Task<ActionResult<LoginResponseDto>> Login(LoginRequestDto loginRequest)
        {
            var user = await _context.Users
                .Include(u => u.Tasks)
                .FirstOrDefaultAsync(u => u.UserEmail == loginRequest.UserEmail && u.UserPassword == loginRequest.UserPassword);

            if (user == null)
            {
                return Unauthorized("Credenciales inválidas");
            }

            var loginResponse = new LoginResponseDto
            {
                UserId = user.UserId,
                UserName = user.UserName,
                UserEmail = user.UserEmail,
                Message = "Login exitoso",
                Tasks = user.Tasks?.Select(t => new TaskDto
                {
                    TaskId = t.TaskId,
                    TaskName = t.TaskName,
                    TaskDescription = t.TaskDescription,
                    TaskDate = t.TaskDate,
                    TaskStatus = t.TaskStatus,
                    TaskUserId = t.TaskUserId  // Corregido de UserId
                }).ToList()
            };

            return Ok(loginResponse);
        }

        // 4. POST: api/Users - postUser(user)
        [HttpPost]
        public async Task<ActionResult<UserResponseDto>> PostUser(CreateUserDto createUserDto)
        {
            // Convertir DTO a modelo de base de datos
            var user = new User
            {
                UserName = createUserDto.UserName,
                UserEmail = createUserDto.UserEmail,
                UserPassword = createUserDto.UserPassword
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            // Convertir modelo a DTO de respuesta
            var userResponse = new UserResponseDto
            {
                UserId = user.UserId,
                UserName = user.UserName,
                UserEmail = user.UserEmail,
                Tasks = new List<TaskDto>()
            };

            return CreatedAtAction("GetUser", new { id = user.UserId }, userResponse);
        }

        // 5. PUT: api/Users/{id} - putUser(user_id)
        [HttpPut("{id}")]
        public async Task<ActionResult<UserResponseDto>> PutUser(int id, UpdateUserDto updateUserDto)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
            {
                return NotFound($"Usuario con ID {id} no encontrado");
            }

            // Actualizar propiedades del modelo
            user.UserName = updateUserDto.UserName;
            user.UserEmail = updateUserDto.UserEmail;
            
            if (!string.IsNullOrEmpty(updateUserDto.UserPassword))
            {
                user.UserPassword = updateUserDto.UserPassword;
            }

            _context.Entry(user).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            // Retornar DTO de respuesta
            var userResponse = new UserResponseDto
            {
                UserId = user.UserId,
                UserName = user.UserName,
                UserEmail = user.UserEmail,
                Tasks = new List<TaskDto>()
            };

            return Ok(userResponse);
        }

        // 6. DELETE: api/Users/{id} - deleteUser(user_id)
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
            {
                return NotFound($"Usuario con ID {id} no encontrado");
            }

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // 7. GET: api/Users/{id}/tasks - getUserTasks(user_id)
        [HttpGet("{id}/tasks")]
        public async Task<ActionResult<UserTasksResponseDto>> GetUserTasks(int id)
        {
            var user = await _context.Users.Include(u => u.Tasks)
                .FirstOrDefaultAsync(u => u.UserId == id);
            
                if (user == null)
                {
                    return NotFound($"Usuario con ID {id} no encontrado");
                }

                var tasks = user.Tasks?.Select(t => new TaskDto
                {
                    TaskId = t.TaskId,
                    TaskName = t.TaskName,
                    TaskDescription = t.TaskDescription,
                    TaskDate = t.TaskDate,
                    TaskStatus = t.TaskStatus,
                    TaskUserId = t.TaskUserId
                }).ToList() ?? new List<TaskDto>();

                return Ok(tasks);
            }

        private bool UserExists(int id)
        {
            return _context.Users.Any(e => e.UserId == id);
        }
    }
}