import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:untitled/todoapp/todo.dart';
import 'package:untitled/todoapp/todo_item.dart';

import 'colors.dart';

class HomePage extends StatefulWidget{
  HomePage({Key? key}) : super(key : key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final todoList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    _foundToDo = todoList;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppbar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50,bottom: 20),
                        child: Text(
                          'All ToDos',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      for(ToDo todo in _foundToDo)
                      ToDoItem(todo: todo,
                      onTodoChanged: _handleToChangeTodo,
                        onDeleteTodo: _handleToDeleteTodo,
                      ),
                    ],
                  ),

                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: 20,
                          right: 20,
                          left: 20
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _todoController,
                        decoration: InputDecoration(
                          hintText: 'Add a new ToDo',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    child: Text(
                      '+',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),),
                    onPressed: (){
                      _addTodo(_todoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      elevation: 10,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _handleToChangeTodo(ToDo todo){
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _handleToDeleteTodo(String id){
    setState(() {
      todoList.removeWhere((item) => item.id == id);
    });
  }

  void _addTodo(String toDo){
    setState(() {
      todoList.add(
        ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          toDoText: toDo
        ),
      );
    });
    _todoController.clear();
  }

  void _findToDo(String entereToDO){
    List<ToDo> results = [];
    if(entereToDO.isEmpty){
      results = todoList;
    }else{
      results = todoList
          .where((item) => item.toDoText!
          .toLowerCase()
          .contains(entereToDO.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

Widget searchBox(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ),
      child: TextField(
        onChanged: (value) => _findToDo(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,),
          prefixIconConstraints: BoxConstraints(
              maxHeight: 20,minWidth: 25
          ),
          border: InputBorder.none,
          hintText: 'Search here..',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
}
 // Search box
  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: tdBGColor,
      title:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu,
            color: Colors.black,
            size: 30,
          ),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/image/ayush.jpg'),
            ),
          ),
        ],
      ),
    );
  }  }