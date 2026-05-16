import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // Render'dan alınan canlı internet adresi
  static const String _apiUrl = 'https://ecolife-ai-backend.onrender.com/tahmin';

  Future<Map<String, dynamic>> kalpRiskiTahminEt(Map<String, dynamic> hastaVerileri) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(hastaVerileri),
      );

      if (response.statusCode == 200) {
        // Python'dan gelen başarı sonucunu çözümlüyoruz
        return jsonDecode(response.body);
      } else {
        return {"durum": "Hata", "mesaj": "Sunucu hatası: ${response.statusCode}"};
      }
    } catch (e) {
      return {"durum": "Hata", "mesaj": "Bağlantı hatası: $e"};
    }
  }
}
