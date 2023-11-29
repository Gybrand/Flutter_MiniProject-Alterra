import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miniproject/Auth/login_or_register.dart';
import 'package:miniproject/Pages/menu_navigator.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //User is Logged in
          if (snapshot.hasData) {
            return const MenuNav();
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
