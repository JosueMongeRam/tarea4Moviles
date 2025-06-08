// ===============================================
// Modelo para Task Response (GET task)
// ===============================================
class TaskResponse {
  final int taskId;
  final String taskName;
  final String taskDescription;
  final String taskDate;
  final String taskStatus;
  final int taskUserId;
  final String? userName;
  final String? userEmail;

  TaskResponse({
    required this.taskId,
    required this.taskName,
    required this.taskDescription,
    required this.taskDate,
    required this.taskStatus,
    required this.taskUserId,
    this.userName,
    this.userEmail,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      taskId: json['taskId'],
      taskName: json['taskName'],
      taskDescription: json['taskDescription'],
      taskDate: json['taskDate'],
      taskStatus: json['taskStatus'],
      taskUserId: json['taskUserId'],
      userName: json['userName'],
      userEmail: json['userEmail'],
    );
  }

  // AGREGAR este método que faltaba
  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'taskName': taskName,
      'taskDescription': taskDescription,
      'taskDate': taskDate,
      'taskStatus': taskStatus,
      'taskUserId': taskUserId,
      'userName': userName,
      'userEmail': userEmail,
    };
  }

}

// ===============================================
// Modelo para Create Task Request (POST)
// ===============================================
class CreateTaskRequest {
  final String taskName;
  final String taskDescription;
  final String taskDate;
  final String taskStatus;
  final int taskUserId;

  CreateTaskRequest({
    required this.taskName,
    required this.taskDescription,
    required this.taskDate,
    required this.taskStatus,
    required this.taskUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      'taskName': taskName,
      'taskDescription': taskDescription,
      'taskDate': taskDate,
      'taskStatus': taskStatus,
      'taskUserId': taskUserId,
    };
  }
}

// ===============================================
// Modelo para Update Task Request (PUT)
// ===============================================
class UpdateTaskRequest {
  final String taskName;
  final String taskDescription;
  final String taskDate;
  final String taskStatus;

  UpdateTaskRequest({
    required this.taskName,
    required this.taskDescription,
    required this.taskDate,
    required this.taskStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'taskName': taskName,
      'taskDescription': taskDescription,
      'taskDate': taskDate,
      'taskStatus': taskStatus,
    };
  }
}

// ===============================================
// Modelo Task local (para la app)
// ===============================================
class Task {
  final int? taskId;
  final String taskTitle;
  final String taskDescription;
  final String taskDate;
  final bool taskCompleted;
  final int taskUserId;

  Task({
    this.taskId,
    required this.taskTitle,
    required this.taskDescription,
    required this.taskDate,
    required this.taskCompleted,
    required this.taskUserId,
  });

  // Convertir desde TaskResponse de la API
  factory Task.fromTaskResponse(TaskResponse response) {
    return Task(
      taskId: response.taskId,
      taskTitle: response.taskName,
      taskDescription: response.taskDescription,
      taskDate: response.taskDate,
      taskCompleted: response.taskStatus == '1', // '1' = completada, '0' = pendiente
      taskUserId: response.taskUserId,
    );
  }

  // Convertir a CreateTaskRequest para la API
  CreateTaskRequest toCreateRequest() {
    return CreateTaskRequest(
      taskName: taskTitle,
      taskDescription: taskDescription,
      taskDate: taskDate,
      taskStatus: taskCompleted ? '1' : '0',
      taskUserId: taskUserId,
    );
  }

  // Convertir a UpdateTaskRequest para la API
  UpdateTaskRequest toUpdateRequest() {
    return UpdateTaskRequest(
      taskName: taskTitle,
      taskDescription: taskDescription,
      taskDate: taskDate,
      taskStatus: taskCompleted ? '1' : '0',
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      taskTitle: json['taskTitle'],
      taskDescription: json['taskDescription'],
      taskDate: json['taskDate'],
      taskCompleted: json['taskCompleted'],
      taskUserId: json['taskUserId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'taskTitle': taskTitle,
      'taskDescription': taskDescription,
      'taskDate': taskDate,
      'taskCompleted': taskCompleted,
      'taskUserId': taskUserId,
    };
  }

  // Para SQLite local (mantener compatibilidad)
  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'taskTitle': taskTitle,
      'taskDescription': taskDescription,
      'taskDate': taskDate,
      'taskCompleted': taskCompleted ? 1 : 0, // SQLite usa INTEGER para boolean
      'taskUserId': taskUserId,
    };
  }

  // Crear Task desde SQLite Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      taskId: map['taskId'],
      taskTitle: map['taskTitle'],
      taskDescription: map['taskDescription'],
      taskDate: map['taskDate'],
      taskCompleted: map['taskCompleted'] == 1, // Convertir INTEGER a boolean
      taskUserId: map['taskUserId'],
    );
  }

  // Crear copia con cambios
  Task copyWith({
    int? taskId,
    String? taskTitle,
    String? taskDescription,
    String? taskDate,
    bool? taskCompleted,
    int? taskUserId,
  }) {
    return Task(
      taskId: taskId ?? this.taskId,
      taskTitle: taskTitle ?? this.taskTitle,
      taskDescription: taskDescription ?? this.taskDescription,
      taskDate: taskDate ?? this.taskDate,
      taskCompleted: taskCompleted ?? this.taskCompleted,
      taskUserId: taskUserId ?? this.taskUserId,
    );
  }
}