import 'dart:developer';

// import 'package:flutter_application_1/constants/constants.dart';
// import 'package:flutter_application_1/model/weather_model.dart';
// import 'package:flutter_application_1/services/geo_location_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../constants/constants.dart';
import '../model/weather_model.dart';
import 'geo_location_services.dart';

class WeatherService {
  static Future<WeatherResponse?> getWeather({String? city}) async {
    try {
      final locationName = city ?? await _getLocationName();
      log("location name is $locationName");
      if (locationName == null) {
        log("Failed to get location name.");
        return null;
      }

      final encodedLocation = Uri.encodeComponent(locationName);
      log("encode loc is $encodedLocation");
      final url =
          "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$encodedLocation?unitGroup=us&key=P65SGZQVMHJZMMNVT2R24C3DN";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final weatherResponse = WeatherResponse.fromJson(body);
        log("Weather data: $body");
        if (city != null) {
          citiesList.add(weatherResponse);
        }
        return weatherResponse;
      } else {
        print("HTTP error: ${response.statusCode}");
        return null;
      }
    } catch (e, stackTrace) {
      log("Error: $e");
      log("Stack trace: $stackTrace");
      return null;
    }
  }

  static Future<String?> _getLocationName() async {
    try {
      final position = await LocationService().getCurrentPosition();
      print("Coordinates: ${position.latitude}, ${position.longitude}");

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      print("placemark data is $placemarks");
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final locationString =
            "${place.locality ?? place.subAdministrativeArea ?? ""},${place.administrativeArea ?? ""}";

        print("Reverse geocoded location: $locationString");

        return locationString;
      } else {
        print("No placemarks found");
        return null;
      }
    } catch (e) {
      print("Error in reverse geocoding: $e");
      return null;
    }
  }

  // static Future<WeatherResponse?> getCityWeather(String city) async {
  //   try {
  //     final locationName = city;

  //     final encodedLocation = Uri.encodeComponent(locationName);
  //     print("encode loc is $encodedLocation");
  //     final url =
  //         "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$encodedLocation?unitGroup=us&key=P65SGZQVMHJZMMNVT2R24C3DN";

  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final body = jsonDecode(response.body);
  //       final weatherResponse = WeatherResponse.fromJson(body);
  //       print("Weather data: $body");
  //       log("Weather data:$body");
  //       return weatherResponse;
  //     } else {
  //       print("HTTP error: ${response.statusCode}");
  //       return null;
  //     }
  //   } catch (e, stackTrace) {
  //     print("Error: $e");
  //     print("Stack trace: $stackTrace");
  //     return null;
  //   }
  // }
}
