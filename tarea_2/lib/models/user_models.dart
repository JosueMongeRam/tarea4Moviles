class LoginRequest {
  final String userEmail;
  final String userPassword;

  LoginRequest({
    required this.userEmail,
    required this.userPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
      'userPassword': userPassword,
    };
  }
}

class LoginResponse {
  final int userId;
  final String userName;
  final String userEmail;
  final String message;

  LoginResponse({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      message: json['message'] ?? 'Login exitoso',
    );
  }
}

class CreateUserRequest {
  final String userName;
  final String userEmail;
  final String userPassword;

  CreateUserRequest({
    required this.userName,
    required this.userEmail,
    required this.userPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userEmail': userEmail,
      'userPassword': userPassword,
    };
  }
}

class UserResponse {
  final int userId;
  final String userName;
  final String userEmail;

  UserResponse({
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      userId: json['userId'],
      userName: json['userName'],
      userEmail: json['userEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
    };
  }
}

class User {
  final int userId;
  final String userName;
  final String userEmail;

  User({
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  factory User.fromUserResponse(UserResponse response) {
    return User(
      userId: response.userId,
      userName: response.userName,
      userEmail: response.userEmail,
    );
  }

  factory User.fromLoginResponse(LoginResponse response) {
    return User(
      userId: response.userId,
      userName: response.userName,
      userEmail: response.userEmail,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      userName: json['userName'],
      userEmail: json['userEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
    };
  }
}