import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:newtodo/apiServices/user_api_service.dart';
import 'package:newtodo/dataClasses/user_data.dart';
import 'package:newtodo/screens/home_screen.dart';
import 'package:newtodo/main.dart';
import 'package:newtodo/screens/login_screen.dart';
import 'package:provider/provider.dart';
import '../providerClass/login_provider_page.dart';
import '../dataClasses/login_response.dart';
import 'package:http/http.dart' as http;

class LoginApiService {

  final loginUrl = "${MyApp.mainUrl}/todo/signIn";
  final signUpUrl = "${MyApp.mainUrl}/todo/signUp";

  Future<LoginResponse?> loginApi(
      String phoneNumber, String password, BuildContext context) async {
    try {
      final response = await http.post(Uri.parse(loginUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "phoneNumber": phoneNumber,
            "password": password,
          }));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(jsonData);

        Provider.of<LoginProvider>(context, listen: false)
            .updateLoginResponse(loginResponse);
        print("login Id - ${loginResponse.loginId}");
        UserApiService obj = UserApiService();
        UserData user = await obj.getUserByUserIdApi(
            loginResponse.loginId, context) as UserData;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Loggin Successfully")));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage(user: user)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed')),
        );
        print(response.statusCode);
        return null;
      }
    } on http.ClientException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Network Error")));
      return null;
    } on FormatException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mobile number or password not match')),
      );
      return null;
    } catch (e) {
      print('Unknown Error in login screen : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unknown error occurred. Please try again.')),
      );
      return null;
    }
    return null;
  }

  Future<bool> signUpApi(String userName, String phoneNumber, String password,
      BuildContext context) async{
    try{
      final response = await http.post(Uri.parse(signUpUrl),
        headers: {
        "Content-Type" : "application/json"
        },
        body: jsonEncode({
          "userName" : userName,
          "phoneNumber" : phoneNumber,
          "password" : password,
        }));

      if(response.statusCode == 200){
        final jsonData = jsonDecode(response.body);
        if(jsonData){
          ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('Account created')));
          Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('SignUp failed')));
        }
        return jsonData;
      }
    }on http.ClientException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text("Network Error")));
    } on FormatException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Something Wrong try again')));
    } catch (e) {
      print('Unknown Error in SignUp screen : $e');
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('An unknown error occurred. Please try again.')),
      );
    }
    return false;
  }
}
