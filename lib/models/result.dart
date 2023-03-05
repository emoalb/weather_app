import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/location_model.dart';
import 'package:weather_app/models/weather_model.dart';

class Result {
  final Position currentPosition;
  final WeatherData currentWeatherData;
  final LocationData currentPlacemark;

  Result(this.currentPosition, this.currentWeatherData, this.currentPlacemark);
}
