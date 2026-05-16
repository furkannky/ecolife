import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get _endpoint =>
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=$_apiKey';

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
                {"text": prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Yanıtın içeriğini kontrol edelim
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        } else {
          return "API'den beklenen veri alınamadı.";
        }
      } else {
        return "API HATA (${response.statusCode}): ${response.body}";
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
                {"text": prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Yanıtın içeriğini kontrol edelim
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        } else {
          return "API'den beklenen veri alınamadı.";
        }
      } else {
        return "API HATA (${response.statusCode}): ${response.body}";
      }
    } catch (e) {
      return "Hata oluştu: $e";
    }
  }

  /// QR koddan gelen ürünle karbon ayak izi ve sürdürülebilirlik bilgisi alma
  static Future<String> urunBilgisiAl(String urunAdi) async {
    final prompt = '''
Ürün: $urunAdi

Bu ürünün içeriği nedir? zararlı madde bulunduruyor mu ? kodlarını yazar mısın ?   karbon ayak izi ve sürdürülebilirlik açısından bilgi verir misin? Hangi malzemelerden oluşuyor? Kullanıcılar bu ürün hakkında neler düşünüyor? (Varsa olumlu ve olumsuz yorumlardan örnekler verilebilir.) Karbon ayak izi nedir ve üretimi çevreye nasıl etki eder? Sürdürülebilirlik açısından bilgi verir misin? Kısa ve öz bir şekilde anlat.
''';

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        } else {
          return "API'den beklenen veri alınamadı.";
        }
      } else {
        return "GOOGLE API HATASI [${response.statusCode}]: ${response.body}";
      }
    } catch (e) {
      return "Bir hata oluştu: $e";
    }
  }
}
