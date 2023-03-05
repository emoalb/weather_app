class WeatherForecastListItem {
  final String weather;
  final double temperature;
  final String icon;
  final String dt_txt;

  WeatherForecastListItem(
      {required this.weather,
      required this.temperature,
      required this.icon,
      required this.dt_txt});

  factory WeatherForecastListItem.fromJson(Map<String, dynamic> json) {
    return WeatherForecastListItem(
        weather: json["weather"][0]["main"],
        temperature: json["main"]["temp"] - 273.15,
        icon: json["weather"][0]["icon"],
        dt_txt: json["dt_txt"]);
  }
}
