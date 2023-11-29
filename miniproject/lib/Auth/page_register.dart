import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/Components/function_button.dart';
import 'package:miniproject/Components/color.dart';
import 'package:miniproject/Components/auth_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  final Function()? onTap;
  const SignUpPage({super.key, required this.onTap});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //sign User Up method
  void signUserUp() async {
    //Show Loading Circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    //Try Creating The User
    try {
      if (passwordController.text == confirmPasswordController.text) {
        // Create The User
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // After Creating The User, Create a aNew Document in Cloud Firestore called Users
        FirebaseFirestore.instance
            .collection("Users")
            .doc(userCredential.user!.email)
            .set({
          'username': emailController.text.split('@')[0], //Initial Username
          'bio': 'Empty bio..', //Initially empty bio
          //add any additional fields as needed
        });
      } else {
        //Show Error Message, Password dont match
        showErrorMessage("Password dont't Match!");
      }
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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

                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    width: 380,
                    height: 330,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'Register New Account',
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

                        //Confirm Password
                        AuthField(
                            controller: confirmPasswordController,
                            hintText: 'Confirm Password',
                            obscureText: true,
                            icon: Icons.key),

                        const SizedBox(height: 20),

                        //Have Account?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Have an account already?",
                              style: TextStyle(
                                  color: AppColors.darkTextColor, fontSize: 15),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: AppColors.mainColor2,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Welcome Back

                const SizedBox(height: 20),

                // Sign Up Button
                FunctionButton(
                  color: AppColors.mainColor1,
                  text: "Sign Up",
                  onTap: signUserUp,
                ),

                // or Register With
                /* Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                            thickness: 0.5, color: AppColors.darkTextColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          'Or Register With',
                          style: TextStyle(color: AppColors.darkTextColor),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Expanded(
                        child: Divider(
                            thickness: 0.5, color: AppColors.darkTextColor),
                      )
                    ],
                  ),
                ), */

                // Google + Apple Sign in Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    //google button
                    //SquareTile(imagePath: 'lib/Asset/image/google.png'),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }
}
