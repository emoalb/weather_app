class WeatherData {
  final String weather;
  final double temperature;
  final String icon;
  final String name;
  WeatherData(
      {required this.name,
      required this.weather,
      required this.temperature,
      required this.icon});
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
        name: json["name"],
        weather: json["weather"][0]["main"],
        temperature: json["main"]["temp"] - 273.15,
        icon: json["weather"][0]["icon"]);
  }
}
