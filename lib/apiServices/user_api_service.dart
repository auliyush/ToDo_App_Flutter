import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:newtodo/dataClasses/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:newtodo/main.dart';

class UserApiService {
  final String getUserUrl = "${MyApp.mainUrl}/user/get/byId";

  Future<UserData?> getUserByUserIdApi(
      String userId, BuildContext context) async {
    try {
      final uri = Uri.parse(getUserUrl).replace(queryParameters: {
        "userId": userId,
      });
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final userDataResponse = UserData.fromJson(jsonData);
        UserData user = userDataResponse;
        return user;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something Went Wrong')));
        return null;
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
      print('Unknown Error in home screen : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unknown error occurred. Please try again.')),
      );
      return null;
    }
  }
}
