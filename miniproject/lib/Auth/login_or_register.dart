import 'package:flutter/material.dart';
import 'package:miniproject/Auth/page_login.dart';
import 'package:miniproject/Auth/page_register.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //Initially show login page
  bool showLoginForm = true;

  //Toggle Between Login and Register Page
  void togglePages() {
    setState(() {
      showLoginForm = !showLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginForm) {
      return LoginForm(
        onTap: togglePages,
      );
    } else {
      return SignUpPage(
        onTap: togglePages,
      );
    }
  }
}
