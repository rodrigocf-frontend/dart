import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:weather/datasources/remote/weather_remote_datasource.dart';
import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';

class WeatherRemoteDatasourceImpl implements WeatherRemoteDatasource {
  WeatherRemoteDatasourceImpl();

  @override
  Future<CityLocation> getLocation(Uri url) async {
    var locationResponse = await http.get(url);

    final Map<String, dynamic> locationFromJson = jsonDecode(
      locationResponse.body,
    );

    return CityLocation.fromJSON(locationFromJson['results'].first);
  }

  @override
  Future<CityWeather> getWeather(Uri url) async {
    var weatherResponse = await http.get(url);
    final Map<String, dynamic> weatherFromJson = jsonDecode(
      weatherResponse.body,
    );

    return CityWeather.fromJSON(weatherFromJson);
  }
}
