import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:miniproject/Components/function_button.dart';
import 'package:miniproject/Components/color.dart';
import 'package:miniproject/Components/edit_profile_textbox.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  //User
  final currentUser = FirebaseAuth.instance.currentUser!;

  //All users
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  //Edit Field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.lightBackgroundColor,
        title: Text(
          "Edit $field",
          style: TextStyle(color: AppColors.mainColor1),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: AppColors.mainColor1),
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.mainColor2)),
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey[600]),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          //Cancel Button
          TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.mainColor1),
              ),
              onPressed: () {
                print('Cancel button pressed');
                Navigator.pop(context);
              }),

          //Save Button
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(color: AppColors.mainColor1),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    //Update in Firestore
    if (newValue.trim().isNotEmpty) {
      //Only Update if there is something in the field
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          //Get User Data
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(
                  height: 50,
                ),

                // User Detail
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Details',
                    style: TextStyle(color: AppColors.mainColor1, fontSize: 25),
                  ),
                ),

                //Username
                ProfileTextBox(
                  text: currentUser.email!,
                  sectionName: 'Email',
                  onPressed: () {},
                ),

                //Username
                ProfileTextBox(
                  text: userData['username'],
                  sectionName: 'Username',
                  onPressed: () => editField('username'),
                ),

                //Bio
                ProfileTextBox(
                  text: userData['bio'],
                  sectionName: 'Bio',
                  onPressed: () => editField('bio'),
                ),

                const SizedBox(
                  height: 30,
                ),

                //Exit Button
                FunctionButton(
                  color: AppColors.mainColor2,
                  onTap: (signUserOut),
                  text: 'Log Out',
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }
          return Container(
            color: AppColors.lightBackgroundColor,
            child: Center(
              child: Lottie.asset('lib/Assets/gearloading.json', height: 200),
            ),
          );
        },
      ),
    );
  }
}
