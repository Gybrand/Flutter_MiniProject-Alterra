import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:miniproject/Components/color.dart';
import 'package:firebase_database/firebase_database.dart';

const List<String> deviceSelected = <String>[
  'Device_3',
  'Device_4',
  'Device_5',
];

bool areDataEqual(Map<String, dynamic> data1, Map<String, dynamic> data2) {
  // Implement your comparison logic here based on your data structure.
  // For example, compare 'suhu' and 'kelembapan' fields.
  return data1['suhu'] == data2['suhu'];
}

bool aareDataEqual(Map<String, dynamic> data1, Map<String, dynamic> data2) {
  // Implement your comparison logic here based on your data structure.
  // For example, compare 'suhu' and 'kelembapan' fields.
  return data1['kelembapan'] == data2['kelembapan'];
}

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  List<double> suhuData = [10];
  List<double> kelembapanData = [40];
  List<String> timestamps = [];
  List<Map<String, dynamic>> historyData = [];

  String deviceSelectedValue = deviceSelected.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      /* appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Status Page',
            style: TextStyle(
                color: AppColors.textColor, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.mainColor1), */
      body: StreamBuilder(
        stream: _databaseReference
            .child(deviceSelectedValue) /*.child('SetData')*/
            .onValue, //Device_1
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DataSnapshot data = snapshot.data!.snapshot;
            Map<dynamic, dynamic> values = data.value as Map<dynamic, dynamic>;

            // Get the device variable from the deviceReference variable.
            double suhu = values['avgt'].toDouble();
            double kelembapan = values['avgh'].toDouble();

            // Get the current timestamp and add it to the timestamps list
            DateTime now = DateTime.now();
            String formattedTimestamp = DateFormat('HH:mm').format(now);

            // Add the new formatted timestamp

            timestamps.insert(0, formattedTimestamp);

            // Add the new data to the lists
            suhuData.add(suhu);
            kelembapanData.add(kelembapan);

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        Text("Status  ",
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        DropdownButton<String>(
                          value: deviceSelectedValue,
                          icon: Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style: TextStyle(color: AppColors.mainColor2),
                          underline: Container(
                            height: 2,
                            color: AppColors.mainColor2,
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              deviceSelectedValue = value!;
                            });
                          },
                          items: deviceSelected
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.lightBackgroundColor,
                          borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.only(
                          bottom: 20, top: 0, left: 15, right: 15),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: ListTile(
                              title: const Text(
                                'Suhu: ',
                                style: TextStyle(fontSize: 18),
                              ),
                              trailing: Text(
                                suhu < 26
                                    ? 'Terlalu Dingin'
                                    : (suhu >= 26 && suhu <= 28)
                                        ? 'Cukup'
                                        : 'Terlalu Panas',
                                style: TextStyle(fontSize: 18),
                              ),
                              subtitle: Text(
                                '$suhu°C',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: (suhu >= 26 && suhu <= 28)
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: ListTile(
                              title: const Text(
                                'Kelembapan: ',
                                style: TextStyle(fontSize: 18),
                              ),
                              trailing: Text(
                                kelembapan < 80
                                    ? 'Kurang Lembab'
                                    : (kelembapan >= 80 && kelembapan <= 90)
                                        ? 'Cukup'
                                        : 'Terlalu Lembab',
                                style: TextStyle(fontSize: 18),
                              ),
                              subtitle: Text(
                                '$kelembapan%',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: (kelembapan >= 80 && kelembapan <= 90)
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Riwayat",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.lightBackgroundColor,
                          borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.only(
                          bottom: 0, top: 10, left: 15, right: 15),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Suhu', style: TextStyle(fontSize: 20)),
                                Text('Waktu', style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          ),
                          Container(
                            height: 200,
                            child: StreamBuilder(
                              stream: _databaseReference.onValue,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  // Create a new data entry
                                  Map<String, dynamic> newData = {
                                    'suhu': suhu,
                                    'kelembapan': kelembapan,
                                    'timestamp': formattedTimestamp,
                                  };

                                  if (historyData.isEmpty ||
                                      !areDataEqual(
                                          historyData.first, newData)) {
                                    // Add the new data entry to the history if it's different
                                    historyData.insert(0, newData);

                                    // Ensure there are at most 5 history entries
                                    if (historyData.length > 5) {
                                      historyData.removeLast();
                                    }
                                  }

                                  return ListView.builder(
                                    itemCount: historyData.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> entry =
                                          historyData[index];
                                      double temperature = entry['suhu'];
                                      String timestamp = entry['timestamp'];

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 45.0, right: 45),
                                        child: ListTile(
                                          title: Text(
                                            '$temperature °C',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          trailing: Text(
                                            '$timestamp',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Center(
                                    child: Lottie.asset(
                                        'lib/Assets/gearloading.json',
                                        height: 200),
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.lightBackgroundColor,
                          borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.only(
                          bottom: 30, top: 0, left: 10, right: 10),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Kelembapan',
                                    style: TextStyle(fontSize: 20)),
                                Text('Waktu', style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          ),
                          Container(
                            height: 200,
                            child: StreamBuilder(
                              stream: _databaseReference.onValue,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  // Create a new data entry
                                  Map<String, dynamic> newData = {
                                    'suhu': suhu,
                                    'kelembapan': kelembapan,
                                    'timestamp': formattedTimestamp,
                                  };

                                  if (historyData.isEmpty ||
                                      !aareDataEqual(
                                          historyData.first, newData)) {
                                    // Add the new data entry to the history if it's different
                                    historyData.insert(0, newData);

                                    // Ensure there are at most 5 history entries
                                    if (historyData.length > 5) {
                                      historyData.removeLast();
                                    }
                                  }

                                  return ListView.builder(
                                    itemCount: historyData.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> entry =
                                          historyData[index];
                                      double humidity = entry['kelembapan'];
                                      String timestamp = entry['timestamp'];

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50.0, right: 45),
                                        child: ListTile(
                                          title: Text(
                                            '$humidity %',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          trailing: Text(
                                            '$timestamp',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Center(
                                    child: Lottie.asset(
                                        'lib/Assets/gearloading.json',
                                        height: 200),
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Container(
              color: AppColors.lightBackgroundColor,
              child: Center(
                child: Lottie.asset('lib/Assets/gearloading.json', height: 200),
              ),
            );
          }
        },
      ),
    );
  }
}
