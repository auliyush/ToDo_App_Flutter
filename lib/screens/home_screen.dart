import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newtodo/apiServices/todo_api_service.dart';
import 'package:newtodo/dataClasses/user_data.dart';
import 'package:newtodo/models/todo_item_page.dart';
import 'package:provider/provider.dart';

import '../models/color.dart';
import '../dataClasses/todo_data.dart';
import 'login_screen.dart';
import '../providerClass/login_provider_page.dart';

class HomePage extends StatefulWidget{
  final UserData user;

  const HomePage({
    super.key,
    required this.user,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   bool refreshButtonStatus = false;
  final _todoController = TextEditingController();
  late Future<List<ToDo>?> _toDoList;
  ToDoApiService toDoApiService = ToDoApiService();

  @override
  void initState() {
    super.initState();
    _toDoList = toDoApiService.getAllToDo(widget.user.userId, context);
  }
  void refreshToDosList(){
    setState(() {
      _toDoList = toDoApiService.getAllToDo(widget.user.userId, context);
      refreshButtonStatus = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppbar(),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                widget.user.userName,
              ),
              accountEmail: Text(
                 widget.user.userPhoneNumber,
              ),
              currentAccountPicture:  CircleAvatar(
               backgroundColor: bColour,
                child: Text(
                  widget.user.userName[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home), title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings), title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text("Contact Us"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: (){
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              },
            )
            // ListTile(
            //   leading: const Icon(Icons.checklist_outlined),
            //   title: const Text("Completed ToDO"),
            //   onTap: (){
            //
            //   },
            // ),
          ],
        ),
      ),
      body: Stack(
        children: [
           Column(
            children: [
              // stack header (SearchBox, image, todos text)
              SizedBox(
                height: 160,
                child: Stack(
                  children: [
                    // header image
                    Container(
                      height: 160,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/bg2.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // searchBox
                    Container(
                      padding: EdgeInsets.only(top: 15, bottom: 10, right: 7,left: 7),
                        child: searchBox(widget.user.userId, context)
                    ),
                    // ALL ToDos Text
                    Container(
                      margin: const EdgeInsets.only(top: 90,bottom: 25,left: 10),
                      child: Text(
                        'Your ToDos',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              offset: const Offset(4.0, 4.0), // X and Y offset for the shadow
                              blurRadius: 4.0, // Blur effect for the shadow
                              color: Colors.grey.withOpacity(0.7), // Shadow color and opacity
                            ),
                          ],
                        ),
                      ),
                    ),
                    // refresh button
                    Align(
                     alignment: Alignment(0.95, 1),
                      child: _buildRefreshButton(refreshButtonStatus),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // ToDos List Api call block
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: FutureBuilder<List<ToDo>?>(
                        future: _toDoList,
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const Center(child: CircularProgressIndicator());
                          }else if(snapshot.hasError){
                            return Center(child: Text('Something Error: ${snapshot.error}'));
                          }else if(!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No ToDo available'));
                          }else{
                            List<ToDo> toDos = snapshot.data!;
                            return ListView.builder(
                                itemCount: toDos.length,
                                itemBuilder: (context, index){
                                  return ToDoItem(
                                      todo: toDos[index],
                                    refreshList: refreshToDosList,
                                  );
                                }
                            );
                          }
                        }
                    ),
                  )
              ),
              // Extra bottom space
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: const Text(
                  '',
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                      left: 20,
                    ),
                    padding: const EdgeInsets.symmetric(
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
                      decoration: const InputDecoration(
                        hintText: 'Add a new ToDo',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: (){
                      if(_todoController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('please enter your ToDo')));
                      }else{
                        ToDoApiService todoApiService = ToDoApiService();
                        String? loggedId = Provider.of<LoginProvider>
                          (context, listen: false).loginResponse?.loginId;
                        String todo = _todoController.text;
                        final returnVal = todoApiService.createToDo(loggedId!, todo, context);
                        print(returnVal.toString());
                        _todoController.clear();
                        refreshToDosList();
                        refreshButtonStatus = true;
                        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      elevation: 10,
                    ),
                    child: const Text(
                      '+',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                      ),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // find todos method
  void _findToDo(String enterToDO, String userId, BuildContext context) async {
    // Await the Future to get the actual from database
    List<ToDo>? todoList = await toDoApiService.getAllToDo(userId, context);
    List<ToDo>? results;  // Declare results without initializing

    if (enterToDO.isEmpty) {
      results = todoList;  // Show the full list
    } else {
      // Filter the list based on the search query
      results = todoList
          ?.where((item) => item.todoText
          .toLowerCase()
          .contains(enterToDO.toLowerCase()))
          .toList();
    }

    // Update the state with the new results
    setState(() {
      // You may want to keep this as Future<List<ToDo>?>
      _toDoList = Future.value(results);
    });
  }
// Search box
  Widget searchBox(String userId, BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ),
      child: TextField(
        onChanged: (value){
          _findToDo(value, userId, context);
        },
        decoration: const InputDecoration(
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
  // appbar
  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: tdBGColor,
      title: const Text('Todo App'),
    );
  }
  // refresh button
  Widget _buildRefreshButton(bool buttonStatus){
    if(buttonStatus){
      return  ElevatedButton(
        onPressed: () {
          refreshToDosList();
          refreshButtonStatus = false;
        },
        child: const Text(
          "Refresh",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      );
    }
    else{
      return TextButton(
          onPressed: () {
            print("Port button pressed");
          },
          child: const Text(""),
      );
    }
  }
}



