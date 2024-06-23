class ToDo{
  String? id;
  String? toDoText;
  bool isDone;

  ToDo({
   required this.id,
   required this.toDoText,
    this.isDone = false,
});

  static List<ToDo> todoList(){
    return[
      ToDo(id: '1', toDoText: 'Wake Up ?'),
      ToDo(id: '2', toDoText: 'Do you code something or not'),
      ToDo(id: '3', toDoText: 'Go Brush?'),
      ToDo(id: '4', toDoText: 'have you learn'),
    ];
  }
}