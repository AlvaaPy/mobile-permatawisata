class City {
  final int cityID;
  final String cityName;

  City({
    required this.cityID,
    required this.cityName,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityID: json['cityID'],
      cityName: json['cityName'],
    );
  }
}
