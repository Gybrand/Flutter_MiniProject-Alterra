import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lottie/lottie.dart';
import 'package:miniproject/Components/color.dart';
import 'package:miniproject/Models/weather_model.dart';
import 'package:miniproject/Services/weather_service.dart';

const List<String> deviceSelected = <String>[
  'Device_3',
  'Device_4',
  'Device_5',
];

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

@override
class _DashboardState extends State<Dashboard> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  List<double> suhuData = [10];
  List<double> kelembapanData = [40];
  List<String> timestamps = [];

  String deviceSelectedValue = deviceSelected.first;

  //User
  final currentUser = FirebaseAuth.instance.currentUser!;

  //API Key
  final _weatherService = WeatherService('410463b3935acea56c8171825dbb4440');
  Weather? _weather;

  //Fetch Weather
  _fetchWeather() async {
    //Get the current city
    String cityName = await _weatherService.getCurrentCity();

    //Get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    //Any Errors
    catch (e) {
      print(e);
    }
  }

  //Weather Animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null)
      return 'lib/Assets/berawan.json'; //Default to Sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'lib/Assets/cerahberawan.json';
      case 'haze':
        return 'lib/Assets/haze.json';
      case 'rain':
        return 'lib/Assets/gerimis.json';
      case 'thunderstorm':
        return 'lib/Assets/hujanpetir.json';
      case 'clear':
        return 'lib/Assets/cerah.json';
      default:
        return 'lib/Assets/cerah.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();

    //Fetch Weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      /* appBar: AppBar(
           leading: Builder(builder: (BuildContext context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                icon: Icon(Icons.menu_open));
          }),
          iconTheme: IconThemeData(color: AppColors.iconColor),
          centerTitle: true,
          title: Text(
            'Dashboard',
            style: TextStyle(color: AppColors.textColor),
          ),
          backgroundColor: AppColors.mainColor1),
      drawer: Drawer(
        surfaceTintColor: AppColors.lightTextColor,
        backgroundColor: AppColors.iconColor,
        child: ListView(
          // Important: Remove any padding from the ListView.
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
      ), */
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
            DateTime currentTimestamp = DateTime.now();
            String formattedTimestamp =
                '${currentTimestamp.hour.toString().padLeft(2, '0')}:${currentTimestamp.minute.toString().padRight(2, '0')}';

            // Add the new formatted timestamp

            timestamps.insert(0, formattedTimestamp);

            // Add the new data to the lists
            suhuData.add(suhu);
            kelembapanData.add(kelembapan);

            // Ensure there are at most 5 timestamps
            if (timestamps.length > 6) {
              suhuData.removeAt(0);
              kelembapanData.removeAt(0);
              timestamps.removeAt(6);
            }

            return Column(
              children: [
                // Appbar
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Text(
                    'Dashboard',
                    style: TextStyle(
                        color: AppColors.mainColor1,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Animation
                    Lottie.asset(getWeatherAnimation(_weather?.mainCondition),
                        height: 150),
                    Column(
                      children: [
                        // City Name
                        Text(
                          _weather?.cityName ?? 'Loading city...',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),

                        // Temperature
                        Text(
                          '${_weather?.temperature.round()}°C',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),

                        // Weather Condition
                        Text(_weather?.mainCondition ?? ''),
                      ],
                    ),
                  ],
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      color: AppColors.backgroundColor,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Hardware: ",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              DropdownButton<String>(
                                value: deviceSelectedValue,
                                icon: const Icon(Icons.arrow_drop_down),
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
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 8.0, bottom: 2),
                                child: Text(
                                  "Suhu",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          /* Text(
                          'Suhu: $suhu°C',
                          style: const TextStyle(fontSize: 30),
                        ),
                        Text(
                          'Kelembapan: $kelembapan%',
                          style: const TextStyle(fontSize: 30),
                        ), */
                          Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                width: 380,
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: LineChart(
                                    LineChartData(
                                      gridData: FlGridData(
                                        show: true,
                                        verticalInterval: 1,
                                        horizontalInterval: 10,
                                        drawHorizontalLine: true,
                                        getDrawingHorizontalLine: (value) {
                                          return const FlLine(
                                            color: Color.fromARGB(
                                                255, 115, 115, 116),
                                            strokeWidth: 2,
                                          );
                                        },
                                        drawVerticalLine: true,
                                        getDrawingVerticalLine: (value) {
                                          return const FlLine(
                                            color: Color(0xff37434d),
                                            strokeWidth: 1,
                                          );
                                        },
                                      ),
                                      titlesData: FlTitlesData(
                                        topTitles: const AxisTitles(),
                                        rightTitles: const AxisTitles(),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            reservedSize: 30,
                                            showTitles: true,
                                            interval: 5,
                                            getTitlesWidget: (value, meta) =>
                                                Text(
                                              value.toInt().toString(),
                                            ),
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              int index = value.toInt();
                                              if (index > 0 &&
                                                  index < timestamps.length) {
                                                int displayedIndex =
                                                    timestamps.length - index;
                                                if (displayedIndex >= 0) {
                                                  return Text(timestamps[
                                                      displayedIndex]);
                                                }
                                              }

                                              return const Text('');
                                            },
                                            reservedSize: 20,
                                            interval: 1,
                                          ),
                                        ),
                                      ),
                                      borderData: FlBorderData(
                                          show: true,
                                          border: Border.all(
                                            color: const Color(0xff37434d),
                                          )),
                                      minX: 0,
                                      maxX: suhuData.length.toDouble() - 0.5,
                                      minY: 10,
                                      maxY: 40,
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: suhuData
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            return FlSpot(entry.key.toDouble(),
                                                entry.value);
                                          }).toList(),
                                          isCurved: true,
                                          color: AppColors.mainColor2,
                                          belowBarData:
                                              BarAreaData(show: false),
                                          barWidth: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, bottom: 2),
                                    child: Text(
                                      "Kelembapan",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                width: 380,
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: LineChart(
                                    LineChartData(
                                      gridData: FlGridData(
                                        show: true,
                                        verticalInterval: 1,
                                        horizontalInterval: 10,
                                        drawHorizontalLine: true,
                                        getDrawingHorizontalLine: (value) {
                                          return const FlLine(
                                            color: Color.fromARGB(
                                                255, 115, 115, 116),
                                            strokeWidth: 2,
                                          );
                                        },
                                        drawVerticalLine: true,
                                        getDrawingVerticalLine: (value) {
                                          return const FlLine(
                                            color: Color(0xff37434d),
                                            strokeWidth: 1,
                                          );
                                        },
                                      ),
                                      titlesData: FlTitlesData(
                                        topTitles: const AxisTitles(),
                                        rightTitles: const AxisTitles(),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            reservedSize: 30,
                                            showTitles: true,
                                            interval: 10,
                                            getTitlesWidget: (value, meta) =>
                                                Text(
                                              value.toInt().toString(),
                                            ),
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              int index = value.toInt();
                                              if (index > 0 &&
                                                  index < timestamps.length) {
                                                int displayedIndex =
                                                    timestamps.length - index;
                                                if (displayedIndex >= 0) {
                                                  return Text(timestamps[
                                                      displayedIndex]);
                                                }
                                              }

                                              return const Text('');
                                            },
                                            reservedSize: 20,
                                            interval: 1,
                                          ),
                                        ),
                                      ),
                                      borderData: FlBorderData(
                                          show: true,
                                          border: Border.all(
                                            color: const Color(0xff37434d),
                                          )),
                                      minX: 0,
                                      maxX: suhuData.length.toDouble() - 0.5,
                                      minY: 40,
                                      maxY: 100,
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: kelembapanData
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            return FlSpot(entry.key.toDouble(),
                                                entry.value);
                                          }).toList(),
                                          isCurved: true,
                                          color: AppColors.mainColor3,
                                          belowBarData:
                                              BarAreaData(show: false),
                                          barWidth: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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
    );
  }
}
