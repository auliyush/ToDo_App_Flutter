import 'package:flutter/material.dart';
import 'package:newtodo/apiServices/todo_api_service.dart';
import 'package:newtodo/screens/home_screen.dart';
import 'color.dart';
import '../dataClasses/todo_data.dart';

class ToDoItem extends StatelessWidget{
  final ToDo todo;
  final Function refreshList;

  const ToDoItem({super.key, required this.todo, required this.refreshList});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: ListTile(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                if(todo.isComplete){
                  return const AlertDialog(
                    title: Text("Information"),
                    content: Text(
                        "this is already Completed",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    actions: [],
                  );
                }else{
                  return AlertDialog(
                    title: const Text("Confirmation"),
                    content: Text("Is this complete ??"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          ToDoApiService todoApi = ToDoApiService();
                          todoApi.completeToDo(todo.userId, todo.todoId, context);
                          refreshList();
                          Navigator.of(context).pop(); // Closes the dialog
                        },
                        child: Text("YES"),
                        style: TextButton.styleFrom(
                          backgroundColor: bColour, // Background color
                          foregroundColor: Colors.white, // Text color
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Rounded corners
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: bColour, // Background color
                            foregroundColor: Colors.white, // Text color
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Rounded corners
                            ),
                          ),
                          child: Text('NO')
                      ),
                    ],
                  );
                }
              },
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
          tileColor: Colors.white,
          leading: buildCheckBox(),

          title: buildText(),

          trailing: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: tdRed,
              borderRadius: BorderRadius.circular(5),
            ),
            child: IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.white,
              iconSize: 20,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Text("Confirmation"),
                        content: const Text("Do you want to Delete ToDo ??"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              ToDoApiService todoApi = ToDoApiService();
                              final rex = todoApi.deleteToDo(todo.userId, todo.todoId, context);
                              print(rex);
                              refreshList();
                              Navigator.of(context).pop(); // Closes the dialog
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: bColour, // Background color
                              foregroundColor: Colors.white, // Text color
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15), // Rounded corners
                              ),
                            ),
                            child: Text("YES"),
                          ),
                          TextButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: bColour, // Background color
                                foregroundColor: Colors.white, // Text color
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15), // Rounded corners
                                ),
                              ),
                              child: Text('NO')
                          ),
                        ],
                      );
                  },
                );
              },
            ),
          ),
        )
    );
  }
  Widget buildCheckBox(){
    if(todo.isComplete){
      return const Icon(
        Icons.check_box,
        color: tdBlue,
      );
    }else{
      return const Icon(
        Icons.check_box_outline_blank ,
        color: tdBlue,
      );
    }

  }

  Widget buildText(){
    if(todo.isComplete){
      return Text(
          todo.todoText,
          style: const TextStyle(
            fontSize: 16,
            color: tdBlack,
            decoration: TextDecoration.lineThrough,
          )
      );
    }else{
      return Text(
          todo.todoText,
          style: TextStyle(
            fontSize: 16,
            color: tdBlack,
            decoration: null,
          )
      );
    }
  }

}


