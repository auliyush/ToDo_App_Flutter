import 'package:flutter/material.dart';
import 'package:untitled/todoapp/colors.dart';
import 'package:untitled/todoapp/todo.dart';

class ToDoItem extends StatelessWidget{
  final ToDo todo;
  final onTodoChanged;
  final onDeleteTodo;

  const ToDoItem({Key? key, required this.todo, required this.onTodoChanged,
  required this.onDeleteTodo,}) : super(key : key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: (){
          // print('Clicked on Tod Item.');
          onTodoChanged(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
        color: tdBlue,
        ),
        title: Text(
            todo.toDoText!,
          style: TextStyle(
            fontSize: 16,
          color: tdBlack,decoration: todo.isDone? TextDecoration.lineThrough : null,
          )
        ),
        trailing: Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: tdRed,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            icon: Icon(Icons.delete),
            color: Colors.white,
            iconSize: 18,
            onPressed: (){
              // print('Clicked on Delte Icon');
              onDeleteTodo(todo.id);
            },
          ),
        ),
      )
    );
  }

}