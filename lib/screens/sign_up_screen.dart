import 'package:flutter/material.dart';
import 'package:newtodo/screens/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../apiServices/login_api.dart';

class SignUp extends StatefulWidget{

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final Uri _urlFB = Uri.parse("https://www.facebook.com/login/");
  final Uri _urlGoogle = Uri.parse(
      "https://accounts.google.com/v3/signin/identifier?continue=https%3A%2F%2"
          "Faccounts.google.com%2F&followup=https%3A%2F%2Faccounts.google.com%2F&ifk"
          "v=Ab5oB3rLC82jZdK_Rn9ZIGx-Y0m6xw-E3pasF0vtI1ZmtvWmEVG1RQ82oqfe7teAXkQvmV7FiF0Ibw&passive"
          "=1209600&flowName=GlifWebSignIn&flowEntry=ServiceLogin&dsh=S287277681%3A1723466158471857&ddm=0");

  final _userPhoneController = TextEditingController();
  final _userNameController = TextEditingController();
  final _userPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/bg2.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7), BlendMode.darken),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double screenWidth = constraints.maxWidth;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                          child: Column(
                            children: [
                              // create account to-do text
                              const Text(
                                'Create Account on ToDo',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              const SizedBox(height: 40),
                              // userName TextFormField
                              SizedBox(
                                width: screenWidth < 300 ? screenWidth * 0.8 : 320,
                                child: TextFormField(
                                  controller: _userNameController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null) {
                                      return "please Enter your Name";
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        Icons.account_circle, color: Colors.white),
                                    hintText: 'Name',
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    fillColor: Colors.white.withOpacity(0.2),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // userPhone Text Form Field
                              SizedBox(
                                width: screenWidth < 300 ? screenWidth * 0.8 : 320,
                                child: TextFormField(
                                  controller: _userPhoneController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                    RegExp regExp = RegExp(pattern);
                                    if (value!.isEmpty) {
                                      return "Enter Phone Number";
                                    } else if(!regExp.hasMatch(value)){
                                        return "Please enter valid number";
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        Icons.phone, color: Colors.white),
                                    hintText: 'Phone',
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    fillColor: Colors.white.withOpacity(0.2),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  obscureText: true,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // user Password TextFormField
                              SizedBox(
                                width: screenWidth < 300 ? screenWidth * 0.8 : 320,
                                child: TextFormField(
                                  controller: _userPasswordController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Your Password';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        Icons.lock, color: Colors.white),
                                    hintText: 'Password',
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    fillColor: Colors.white.withOpacity(0.2),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  obscureText: true,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // SignUp button
                              SizedBox(
                                width: screenWidth < 300 ? screenWidth * 0.8 : 300,
                                child: ElevatedButton(
                                  onPressed: () {
                                    LoginApiService object = LoginApiService();
                                    final response = object.signUpApi(
                                        _userNameController.text,
                                        _userPhoneController.text,
                                        _userPasswordController.text,
                                        context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    backgroundColor: Colors.deepPurple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70),
                                    'Sign Up',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignIn(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'i have an account? Log In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.15,
                                    child: IconButton(
                                        icon: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Image.asset(
                                              'assets/images/google.png'),
                                        ),
                                        onPressed: () {
                                          launchUrl(_urlGoogle);
                                        }
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.15,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.facebook, color: Colors.blue, size: 30,),
                                      onPressed: () {
                                        launchUrl(_urlFB);
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool phoneControllerValidator(TextEditingController phoneController,
      BuildContext context){
    String phone = phoneController.text;
    if(phone.isNotEmpty){
      if(phone.length == 10){
        return true;
      }
    }
    return false;
  }

  bool passwordControllerValidator(TextEditingController passwordController,
      BuildContext context){
    String password = passwordController.text;
    if(password.length >= 5 || password.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  bool userNameControllerValidator(TextEditingController userNameController,
      BuildContext context){
    String userName = userNameController.text;
    if(userName.isNotEmpty){
      if(userName.length >= 5){
        return true;
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please Enter proper Name')));
        return false;
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Enter Name')));
      return false;
    }
  }
}