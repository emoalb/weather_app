import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/models/location_model.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

const API_KEY = "***";

Future<LocationData> getAddressFromLatLng(Position position) async {
  String url =
      "http://api.openweathermap.org/geo/1.0/reverse?lat=${position.latitude}&lon=${position.longitude}&limit=1&appid=$API_KEY";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return LocationData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

void fetchWeatherForecast(Position position) async {
  String url =
      "https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=$API_KEY";
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    //return LocationData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

Future<WeatherData> fetchWeatherData(Position position) async {
  String url =
      "https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$API_KEY";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return WeatherData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

Future<Position> getCurrentPosition() async {
  await _getLocationPermission();
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true);
  print("Position: ${position.longitude} ${position.latitude}");
  return position;
}

_getLocationPermission() async {
  await Permission.location.request();
}
