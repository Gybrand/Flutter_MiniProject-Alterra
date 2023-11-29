import 'dart:convert';
import 'package:miniproject/Models/open_ai_model.dart';
import 'package:miniproject/constant/open_ai.dart';
import 'package:http/http.dart' as http;

class RecommendationService {
  static Future<GptData> getRecommendations({
    required String temperature,
    required String humidity,
  }) async {
    late GptData gptData = GptData(
      id: "",
      object: "",
      created: 0,
      model: "",
      choices: [],
      usage: Usage(promptTokens: 0, completionTokens: 0, totalTokens: 0),
    );
    try {
      var url = Uri.parse('https://api.openai.com/v1/completions');

      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=utf-8',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $apiKey'
      };

      String promptData =
          "Kamu adalah seorang expert petani jamur tiram. Pertumbuhan jamur optimal adalah dengan kondisi suhu 26 hingga 28 derajat Celsius serta kondisi kelembapan 80% hingga 90%. Jika saat ini kondisi rumah jamur berada di suhu ${temperature.toLowerCase()} dan kelembapan ${humidity.toLowerCase()}, apa yang harus dilakukan?"; //${temperature.toLowerCase()} ${humidity.toLowerCase()}
      //"You are a phone expert. Please give me a 5 phone recommendation from internal storages ${phoneCapacity.toLowerCase()} manufacturers with budget equals to $phoneBudget rupiah and camera $camera";

      final data = jsonEncode({
        "model": "text-davinci-003",
        "prompt": promptData,
        "temperature": 1,
        "max_tokens": 1000,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0,
      });
      var response = await http.post(url, headers: headers, body: data);
      if (response.statusCode == 200) {
        gptData = gptDataFromJson(response.body);
      }
    } catch (e) {
      throw Exception('Error occured when sending request');
    }
    return gptData;
  }
}
