// filepath: Controllers/TasksController.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using my_dotnet_api.Models;
using my_dotnet_api.Models.DTOs;

namespace my_dotnet_api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TasksController : ControllerBase
    {
        private readonly DatabaseContext _context;

        public TasksController(DatabaseContext context)
        {
            _context = context;
        }

        // 1. GET: api/Tasks/{id} - getTask(task_id)
        [HttpGet("{id}")]
        public async Task<ActionResult<TaskResponseDto>> GetTask(int id)
        {
            var task = await _context.Tasks
                .Include(t => t.User)
                .FirstOrDefaultAsync(t => t.TaskId == id);

            if (task == null)
            {
                return NotFound($"Tarea con ID {id} no encontrada");
            }

            var taskResponse = new TaskResponseDto
            {
                TaskId = task.TaskId,
                TaskName = task.TaskName,
                TaskDescription = task.TaskDescription,
                TaskDate = task.TaskDate,
                TaskStatus = task.TaskStatus,
                TaskUserId = task.TaskUserId,
                UserName = task.User?.UserName,
                UserEmail = task.User?.UserEmail
            };

            return Ok(taskResponse);
        }

        // 2. POST: api/Tasks - postTask(task)
        [HttpPost]
        public async Task<ActionResult<TaskResponseDto>> PostTask(CreateTaskDto createTaskDto)
        {
            // Verificar que el usuario existe
            var userExists = await _context.Users.AnyAsync(u => u.UserId == createTaskDto.TaskUserId);
            if (!userExists)
            {
                return BadRequest($"Usuario con ID {createTaskDto.TaskUserId} no existe");
            }

            // Convertir DTO a modelo
            var task = new Models.Task
            {
                TaskName = createTaskDto.TaskName,
                TaskDescription = createTaskDto.TaskDescription,
                TaskDate = createTaskDto.TaskDate,
                TaskStatus = createTaskDto.TaskStatus,
                TaskUserId = createTaskDto.TaskUserId
            };

            _context.Tasks.Add(task);
            await _context.SaveChangesAsync();

            // Obtener la tarea con información del usuario
            var createdTask = await _context.Tasks
                .Include(t => t.User)
                .FirstOrDefaultAsync(t => t.TaskId == task.TaskId);

            if (createdTask == null)
            {
                return StatusCode(500, "Error al crear la tarea");
            }

            // Convertir a DTO de respuesta
            var taskResponse = new TaskResponseDto
            {
                TaskId = createdTask.TaskId,
                TaskName = createdTask.TaskName,
                TaskDescription = createdTask.TaskDescription,
                TaskDate = createdTask.TaskDate,
                TaskStatus = createdTask.TaskStatus,
                TaskUserId = createdTask.TaskUserId,
                UserName = createdTask.User?.UserName,
                UserEmail = createdTask.User?.UserEmail
            };

            return CreatedAtAction("GetTask", new { id = task.TaskId }, taskResponse);
        }

        // 3. PUT: api/Tasks/{id} - putTask(task_id)
        [HttpPut("{id}")]
        public async Task<ActionResult<TaskResponseDto>> PutTask(int id, UpdateTaskDto updateTaskDto)
        {
            var task = await _context.Tasks.Include(t => t.User)
                .FirstOrDefaultAsync(t => t.TaskId == id);
            
            if (task == null)
            {
                return NotFound($"Tarea con ID {id} no encontrada");
            }

            // Actualizar propiedades
            task.TaskName = updateTaskDto.TaskName;
            task.TaskDescription = updateTaskDto.TaskDescription;
            task.TaskDate = updateTaskDto.TaskDate;
            task.TaskStatus = updateTaskDto.TaskStatus;

            _context.Entry(task).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            // Retornar DTO de respuesta
            var taskResponse = new TaskResponseDto
            {
                TaskId = task.TaskId,
                TaskName = task.TaskName,
                TaskDescription = task.TaskDescription,
                TaskDate = task.TaskDate,
                TaskStatus = task.TaskStatus,
                TaskUserId = task.TaskUserId,
                UserName = task.User?.UserName,
                UserEmail = task.User?.UserEmail
            };

            return Ok(taskResponse);
        }

        // 4. DELETE: api/Tasks/{id} - deleteTask(task_id)
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTask(int id)
        {
            var task = await _context.Tasks.FindAsync(id);
            if (task == null)
            {
                return NotFound($"Tarea con ID {id} no encontrada");
            }

            _context.Tasks.Remove(task);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool TaskExists(int id)
        {
            return _context.Tasks.Any(e => e.TaskId == id);
        }
    }
}