import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = 'AIzaSyCfFn-fTTreQCw9fSSBNcsr588Tva42z_s'; // kendi API key'in
  static const String _endpoint =
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent?key=$_apiKey';

  /// Malzemelere göre yemek tarifi öneren fonksiyon
  static Future<String> tarifOner(List<String> malzemeler) async {
    final prompt =
        "Elimde şu malzemeler var: ${malzemeler.join(", ")}. Bu malzemelerle hangi yemek tariflerini yapabilirim? Detaylı olarak 1-2 öneri ver. ve önerilerinde karbon ayak izine de önem ver.";

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return "API yanıt vermedi. Kod: ${response.statusCode}";
      }
    } catch (e) {
      return "Hata oluştu: $e";
    }
  }

  /// Yer araması için anahtar kelime önerisi döndüren fonksiyon
  static Future<String> extractKeywords(String query) async {
    final prompt =
        'Kullanıcının aşağıdaki sorgusunu, Google Haritalar Yerler API\'sinde yakındaki yerleri aramak için kullanılabilecek bir veya birden fazla anahtar kelimeye dönüştür. '
        'Sadece anahtar kelimeleri virgülle ayırarak döndür. Sorgu: "$query"';

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return query;
      }
    } catch (e) {
      return query;
    }
  }
}
