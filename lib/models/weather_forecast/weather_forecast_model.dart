import 'dart:convert';

import 'package:weather_app/models/weather_forecast/weather_forecast_list_item.dart';

class WeatherForecastModel {
  final String name;
  final List<WeatherForecastListItem> list;

  WeatherForecastModel({required this.name,required this.list});

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    var listObjsJson = json["list"] as List;
     List<WeatherForecastListItem> lst = listObjsJson.map((e) =>
         WeatherForecastListItem.fromJson(e)).toList();
     return WeatherForecastModel(
        name: json["city"]["name"],
          list: lst);
          }


}