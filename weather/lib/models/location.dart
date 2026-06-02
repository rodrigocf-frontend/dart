class CityLocation {
  final int id;
  final String name;
  final String latitude;
  final String longitude;
  final String countryCode;
  final String timezone;

  CityLocation._({
    required this.id,
    required this.name,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  static CityLocation fromJSON(Map<String, dynamic> data) {
    return CityLocation._(
      id: data['id'],
      name: data['name'],
      countryCode: data["country_code"],
      latitude: data["latitude"].toString(),
      longitude: data["longitude"].toString(),
      timezone: data['timezone'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "name": name,
      "country_code": countryCode,
      "latitude": latitude,
      "longitude": longitude,
      "timezone": timezone,
    };
  }
}
