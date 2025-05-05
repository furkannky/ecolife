import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://flavorai-backend-production.up.railway.app';

  /// ingredients = ["domates", "pirinç", "zeytinyağı"] gibi malzeme listesi
  static Future<List<String>> predictDish(List<String> ingredients) async {
    final url = Uri.parse('$baseUrl/predict_dish');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ingredients': ingredients}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['predicted_dishes']);
    } else {
      throw Exception('Yemek tahmini alınamadı: ${response.statusCode}');
    }
  }
}
