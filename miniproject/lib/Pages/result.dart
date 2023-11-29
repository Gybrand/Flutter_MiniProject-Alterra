import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:miniproject/Components/color.dart';
import 'package:miniproject/Models/open_ai_model.dart';

class AiResultScreen extends StatelessWidget {
  final GptData gptResponseData;
  const AiResultScreen({super.key, required this.gptResponseData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Recommendation'),
        backgroundColor: AppColors.lightBackgroundColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppColors.lightBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              height: 280,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Animation
                      Center(
                        child:
                            Lottie.asset('lib/Assets/mushh.json', height: 200),
                      ),

                      Center(
                        child: Text(
                          "Berikut adalah rekomendasi dari kami",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),

                      Center(
                        child: Text(
                          "Jawaban di bawah adalah rekomendasi dari AI",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                width: 380,
                height: gptResponseData.choices.length * 610,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25),
                  child: Text(
                    gptResponseData.choices[0].text,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
