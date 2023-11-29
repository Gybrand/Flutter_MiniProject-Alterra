import 'package:flutter/material.dart';
import 'package:miniproject/Auth/page_forgotpw.dart';
import 'package:miniproject/Components/function_button.dart';
import 'package:miniproject/Components/color.dart';
import 'package:miniproject/Components/auth_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatefulWidget {
  final Function()? onTap;
  const LoginForm({super.key, required this.onTap});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign user in method
  void signUserIn() async {
    //Show Loading Circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    //Try Sign In
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      //Pop The Loading Circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //Pop The Loading Circle
      Navigator.pop(context);
      //Show Error Message
      showErrorMessage(e.code);
    }
  }

  //Error Message Popup
  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.blueAccent,
            title: Center(
                child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              decoration: BoxDecoration(
                  color: AppColors.lightBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              height: 180,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Animation
                      Center(
                        child: Row(
                          children: [
                            Image(
                              height: 200,
                              image: AssetImage(
                                'lib/Assets/splash.png',
                              ),
                            ),
                            Text(
                              "Mushnitor",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Logo
            //const MagsisLogo(imagePath: 'lib/Asset/image/magsislogo.png'),

            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                width: 380,
                height: 330,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Welcome Title
                    Text(
                      'Welcome, Sign into your Account',
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

                    const SizedBox(height: 10),

                    //Password
                    AuthField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                        icon: Icons.key),
                    const SizedBox(height: 10),
                    //Forgot Password
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage(
                                onTap: widget.onTap,
                              ),
                            )),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: AppColors.mainColor1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    //Sign In Button
                    FunctionButton(
                      color: AppColors.mainColor2,
                      text: "Sign In",
                      onTap: signUserIn,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            //or Continue With
            /* 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child:
                        Divider(thickness: 1.0, color: AppColors.darkTextColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'or Continue With',
                      style: TextStyle(color: AppColors.darkTextColor),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Expanded(
                    child:
                        Divider(thickness: 1.0, color: AppColors.darkTextColor),
                  ),
                ],
              ),
            ), */

            // Google Sign in Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                //Google Button
                //SquareTile(imagePath: 'lib/Asset/image/google.png'),
              ],
            ),
            const SizedBox(height: 10),

            //Have Account?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a Member?",
                  style:
                      TextStyle(color: AppColors.darkTextColor, fontSize: 15),
                ),
                const SizedBox(
                  width: 4,
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    " Register Now!",
                    style: TextStyle(
                        color: AppColors.mainColor2,
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
