import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lottie/lottie.dart';

class MyDataScreen extends StatefulWidget {
  @override
  _MyDataScreenState createState() => _MyDataScreenState();
}

class _MyDataScreenState extends State<MyDataScreen> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Data'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: _databaseReference.child('Device_1/SetData').onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DataSnapshot data = snapshot.data!.snapshot;
              Map<dynamic, dynamic> values =
                  data.value as Map<dynamic, dynamic>;
              double suhu = values['avgt'].toDouble();
              double kelembapan = values['avgh'].toDouble();

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Suhu: $suhu°C',
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    'Kelembapan...: $kelembapan%',
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(
                child: Lottie.asset('lib/Assets/gearloading.json', height: 200),
              );
            }
          },
        ),
      ),
    );
  }
}
