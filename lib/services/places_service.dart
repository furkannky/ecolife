import 'dart:convert';
import 'package:ecolife/models/place_model.dart';
import 'package:http/http.dart' as http;

class PlacesService {
  static const String _apiKey = 'YOUR_GOOGLE_API_KEY';

  static Future<List<Place>> getNearbyPlaces({
    required String keyword,
    required double lat,
    required double lng,
    int radius = 5000,
  }) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=$lat,$lng'
        '&radius=$radius'
        '&keyword=$keyword'
        '&key=$_apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        return (data['results'] as List)
            .map((place) => Place.fromJson(place))
            .toList();
      } else {
        return [];
      }
    } else {
      return [];
    }
  }
}
