class LocationData {
  final String name;
  LocationData({required this.name});
  factory LocationData.fromJson(List<dynamic> json) {
    return LocationData(name:json[0]["name"]);
  }
}