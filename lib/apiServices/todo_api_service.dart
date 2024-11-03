import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newtodo/main.dart';
import 'package:http/http.dart' as http;

import '../dataClasses/todo_data.dart';

class ToDoApiService {
  final String createToDoUrl = "${MyApp.mainUrl}/todo/create";
  final String getAllToDoUrl = "${MyApp.mainUrl}/todo/get/all/by/userId";
  final String completeToDoUrl = "${MyApp.mainUrl}/todo/complete";
  final String deleteToDoUrl = "${MyApp.mainUrl}/todo/remove";

  Future<bool> createToDo(
      String userId, String toDo, BuildContext context) async {
    try {
      final response = await http.post(Uri.parse(createToDoUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "userId": userId,
            "todo": toDo,
          }));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on http.ClientException catch (e) {
      return false;
    }
  }

  Future<List<ToDo>?> getAllToDo(String userId, BuildContext context) async {
    try {
      final uri = Uri.parse(getAllToDoUrl).replace(queryParameters: {
        "userId": userId,
      });
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData is List<dynamic>) {
          final todoList = jsonData.map((e) => ToDo.fromJson(e)).toList();
          return todoList.cast<ToDo>();
        }
      }
    } on http.ClientException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Network Error : $e")));
      return null;
    } on FormatException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid response from server')),
      );
      return null;
    } catch (e) {
      print('Unknown Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unknown error occurred. Please try again.')),
      );
      return null;
    }
    return null;
  }

  Future<bool> completeToDo(
      String userId, String toDoId, BuildContext context) async {
    try {
      final uri = Uri.parse(completeToDoUrl).replace(queryParameters: {
        "userId": userId,
        "todoId": toDoId,
      });
      final response = await http.put(uri);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData;
      } else {
        return false;
      }
    } on http.ClientException catch (e) {
      print("todo api service http.ClientException $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Network Error')));
    } on FormatException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid response from server')),
      );
    } catch (e) {
      print('Unknown Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unknown error occurred. Please try again.')),
      );
    }
    return false;
  }

  Future<bool> deleteToDo(String userId, String todoId, BuildContext context) async{
    try{
      final uri = Uri.parse(deleteToDoUrl).replace(
          queryParameters: {
            "userId": userId,
            "todoId": todoId,
      });
      final response = await http.put(uri);

      if(response.statusCode == 200){
        final jsonData = jsonDecode(response.body);
        return jsonData;
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something wrong')));
      }
    } on http.ClientException catch (e) {
      print("todo api service http.ClientException $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Network Error')));
    } on FormatException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid response from server')),
      );
    } catch (e) {
      print('Unknown Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unknown error occurred. Please try again.')),
      );
    }
    return false;
  }
}
