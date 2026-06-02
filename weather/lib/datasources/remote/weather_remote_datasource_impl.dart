import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:weather/datasources/remote/weather_remote_datasource.dart';
import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';

class WeatherRemoteDatasourceImpl implements WeatherRemoteDatasource {
  WeatherRemoteDatasourceImpl();

  @override
  Future<CityLocation> getLocation(String cityName) async {
    final Uri url = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      "name": cityName,
      "count": "1",
    });

    var response = await http.get(url);

    final Map<String, dynamic> locationFromJson = jsonDecode(response.body);

    return CityLocation.fromJSON(locationFromJson['results'].first);
  }

  @override
  Future<CityWeather> getWeather(CityLocation location) async {
    var url = Uri.https('api.open-meteo.com', '/v1/forecast', {
      "latitude": location.latitude,
      "longitude": location.longitude,
      "current": "temperature_2m,windspeed_2m,relative_humidity_2m",
      "wind_speed_unit": "kmh",
      "timezone": location.timezone,
    });

    var weatherResponse = await http.get(url);
    final Map<String, dynamic> weatherFromJson = jsonDecode(
      weatherResponse.body,
    );

    return CityWeather.fromJSON(weatherFromJson);
  }
}
