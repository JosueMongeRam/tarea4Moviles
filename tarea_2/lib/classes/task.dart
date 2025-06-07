class Task{
  int? id;
  String? name;
  String? description;
  String? status;
  String? date;

  Task({
    this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.status,
  });

  void setStatus(String status){
    this.status = status;
  }

  String getStatus(){
    return this.status!;
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'description': description,
      'date': date,
      'status': status,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      date: map['date'] as String,
      status: map['status'] as String,
    );
  }
}