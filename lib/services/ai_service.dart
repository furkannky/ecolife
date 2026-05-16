import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // Mac emülatörü kullanıyorsan localhost için 'http://127.0.0.1:8000/tahmin' kullanılır.
  // Gerçek cihazla test ediyorsan Mac'inin lokal IP adresini yazmalısın.
  static const String _apiUrl = 'http://127.0.0.1:8000/tahmin';

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
