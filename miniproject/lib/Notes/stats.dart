import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lottie/lottie.dart';
import 'package:miniproject/Pages/account_page.dart';
import 'package:miniproject/Pages/status_page.dart';
import 'package:miniproject/Components/color.dart';

class Test1 extends StatefulWidget {
  const Test1({super.key});

  @override
  _Test1State createState() => _Test1State();
}

class _Test1State extends State<Test1> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('Device_3');

  List<Map<String, dynamic>> historyData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            icon: Icon(Icons.menu_open),
          );
        }),
        iconTheme: IconThemeData(color: AppColors.iconColor),
        centerTitle: true,
        title: Text(
          'Test1',
          style: TextStyle(color: AppColors.textColor),
        ),
        backgroundColor: AppColors.mainColor1,
      ),
      drawer: Drawer(
        surfaceTintColor: AppColors.lightTextColor,
        backgroundColor: AppColors.iconColor,
        child: ListView(
          padding: const EdgeInsets.only(top: 50),
          children: [
            ListTile(
              title: const Text('Account'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Status Page'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatusPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _databaseReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DataSnapshot data = snapshot.data!.snapshot;
            Map<dynamic, dynamic> values = data.value as Map<dynamic, dynamic>;

            // Get the device variable from the deviceReference variable.
            double suhu = values['avgt'].toDouble();
            double kelembapan = values['avgh'].toDouble();

            // Create a new data entry
            Map<String, dynamic> newData = {
              'suhu': suhu,
              'kelembapan': kelembapan,
              'timestamp': DateTime.now().toString(),
            };

            // Add the new data entry to the history
            historyData.insert(0, newData);

            // Ensure there are at most 5 history entries
            if (historyData.length > 5) {
              historyData.removeLast();
            }

            return ListView.builder(
              itemCount: historyData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> entry = historyData[index];
                double temperature = entry['suhu'];
                double humidity = entry['kelembapan'];
                String timestamp = entry['timestamp'];

                return ListTile(
                  title: Text('Suhu: $temperature °C'),
                  subtitle: Text('Kelembapan: $humidity %'),
                  trailing: Text('Waktu: $timestamp'),
                );
              },
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
    );
  }
}
