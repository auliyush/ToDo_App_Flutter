import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newtodo/screens/login_screen.dart';
import 'package:provider/provider.dart';

import 'providerClass/login_provider_page.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget{
  static const mainUrl =
      "https://d58b-2409-40e4-105b-c099-c972-5a26-1468-5a89.ngrok-free.app";
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      home: SignIn(),
    );
  }
}