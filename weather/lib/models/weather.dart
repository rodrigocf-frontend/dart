class CityWeather {
  final String time;
  final String timeUnits;
  final String temperature;
  final String temperatureUnits;
  final String relativeHumidity;
  final String relativeHumidityUnits;

  CityWeather._({
    required this.time,
    required this.timeUnits,
    required this.temperature,
    required this.temperatureUnits,
    required this.relativeHumidity,
    required this.relativeHumidityUnits,
  });

  static CityWeather fromJSON(Map<String, dynamic> data) {
    return CityWeather._(
      time: data['current']['time'],
      timeUnits: data['current_units']['time'],
      relativeHumidity: data['current']['relative_humidity_2m'].toString(),
      relativeHumidityUnits: data['current_units']['relative_humidity_2m'],
      temperature: data['current']['temperature_2m'].toString(),
      temperatureUnits: data['current_units']['temperature_2m'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "current_units": {
        "relative_humidity_2m": relativeHumidityUnits,
        "time": timeUnits,
        "temperature_2m": temperatureUnits,
      },
      "current": {
        "relative_humidity_2m": relativeHumidity,
        "time": time,
        "temperature_2m": temperature,
      },
    };
  }
}
