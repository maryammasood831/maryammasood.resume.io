import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/weather_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveSearch(String city, WeatherResponse weatherData) async {
    try {
      await _db.collection('search_history').add({
        'city_name': city,
        'search_time': FieldValue.serverTimestamp(),
        'temperature': weatherData.currentConditions?.temp,
        'condition': weatherData.currentConditions?.conditions,
        'humidity': weatherData.currentConditions?.humidity,
        'wind_speed': weatherData.currentConditions?.windspeed,
        'description': weatherData.description,
      });
      print("Search saved to Firestore");
    } catch (e) {
      print("Error saving to Firestore: $e");
    }
  }
}
