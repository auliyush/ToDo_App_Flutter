
class ToDo {
  String todoId;
  String todoText;
  String userId;
  bool isComplete;

  ToDo({
    required this.todoId,
    required this.todoText,
    required this.userId,
    required this.isComplete,
  });

  factory ToDo.fromJson(Map<String, dynamic> json){
    return ToDo(
        todoId: json["todoId"] as String,
        todoText: json["todo"] as String,
        userId: json["userId"] as String,
        isComplete: json["complete"] as bool,
    );
  }
}
