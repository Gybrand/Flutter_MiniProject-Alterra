import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/Auth/auth_page.dart';
import 'package:miniproject/Components/function_button.dart';
import 'package:miniproject/Components/color.dart';
import 'package:miniproject/Components/auth_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  final Function()? onTap;
  const ForgotPasswordPage({super.key, required this.onTap});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future resetpassword() async {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Reset Password Email Sent!'),
            backgroundColor: Colors.green));
        Navigator.popUntil(context, (route) => route.isFirst);
      } on FirebaseAuthException {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Invalid Email'), backgroundColor: Colors.red));
        Navigator.pop(context);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 300),

            //Welcome Title
            Text(
              'Recieve an email to reset your password',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.mainColor1,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 15),

            //Email Textfield
            AuthField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                icon: Icons.email),
            const SizedBox(height: 15),

            //Sign In Button
            FunctionButton(
              color: AppColors.mainColor2,
              text: "Reset Password",
              onTap: resetpassword,
            ),
            const SizedBox(height: 15),

            //Have Account?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AuthPage())),
                  child: Text(
                    "Back",
                    style: TextStyle(
                        color: AppColors.mainColor1,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
