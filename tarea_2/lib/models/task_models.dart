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
  factory Task.fromTaskResponse(TaskResponse response) {
    return Task(
      taskId: response.taskId,
      taskTitle: response.taskName,
      taskDescription: response.taskDescription,
      taskDate: response.taskDate,
      taskCompleted: response.taskStatus == '1',
      taskUserId: response.taskUserId,
    );
  }
  CreateTaskRequest toCreateRequest() {
    return CreateTaskRequest(
      taskName: taskTitle,
      taskDescription: taskDescription,
      taskDate: taskDate,
      taskStatus: taskCompleted ? '1' : '0',
      taskUserId: taskUserId,
    );
  }
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
  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'taskTitle': taskTitle,
      'taskDescription': taskDescription,
      'taskDate': taskDate,
      'taskCompleted': taskCompleted ? 1 : 0,
      'taskUserId': taskUserId,
    };
  }
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      taskId: map['taskId'],
      taskTitle: map['taskTitle'],
      taskDescription: map['taskDescription'],
      taskDate: map['taskDate'],
      taskCompleted: map['taskCompleted'] == 1,
      taskUserId: map['taskUserId'],
    );
  }
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