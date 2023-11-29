import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:miniproject/Components/color.dart';
import 'package:miniproject/Pages/result.dart';
import 'package:miniproject/Services/recommendation.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerSuhu = TextEditingController();
  final TextEditingController _controllerKelembapan = TextEditingController();
  bool isLoading = false;

  void _getRecommendations() async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await RecommendationService.getRecommendations(
        temperature: _controllerSuhu.value.text,
        humidity: _controllerKelembapan.value.text,
      );

      if (mounted) {
        setState(() {
          isLoading = false;
        });

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return AiResultScreen(gptResponseData: result);
            },
          ),
        );
      }
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('Something went wrong'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: AppColors.lightBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                height: 370,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Animation
                        Center(
                          child: Lottie.asset('lib/Assets/mushrooms.json',
                              height: 300),
                        ),

                        Center(
                          child: Text(
                            "Solusi direkomendasikan oleh AI",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),

                        Center(
                          child: Text(
                            "Bagaimana kondisi rumah jamur anda?",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 20),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  width: 380,
                  height: 350,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Suhu",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Suhu
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _controllerSuhu,
                              decoration: InputDecoration(
                                hintText: "Besaran Suhu",
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                      width: 3, color: AppColors.mainColor1),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: AppColors.mainColor2),
                                ),
                              ),
                              validator: (String? value) {
                                bool isInvalid = value == null ||
                                    value.isEmpty ||
                                    int.tryParse(value) == null;
                                if (isInvalid) {
                                  return 'Silahkan masukkan angka';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Kelembapan",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //Budget
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _controllerKelembapan,
                              decoration: InputDecoration(
                                hintText: "Tingkat Kelembapan",
                                enabledBorder: UnderlineInputBorder(
                                  //<-- SEE HERE
                                  borderSide: BorderSide(
                                      width: 3, color: AppColors.mainColor1),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: AppColors.mainColor2),
                                ),
                              ),
                              validator: (String? value) {
                                bool isInvalid = value == null ||
                                    value.isEmpty ||
                                    int.tryParse(value) == null;
                                if (isInvalid) {
                                  return 'Silahkan masukkan angka';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: 30, left: 15, right: 15),
                            child: isLoading &&
                                    _formKey.currentState!.validate() != false
                                ? Center(
                                    child: Lottie.asset(
                                        'lib/Assets/ailoading.json',
                                        height: 100),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: AppColors
                                          .mainColor2, // Background color
                                    ),
                                    onPressed: _getRecommendations,
                                    child: Center(
                                      child: Text(
                                        "Tanyakan Ahli nya",
                                        style: TextStyle(
                                            color:
                                                AppColors.lightBackgroundColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
