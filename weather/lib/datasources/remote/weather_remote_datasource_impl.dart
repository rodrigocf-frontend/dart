import 'dart:convert';
import 'dart:io';
import "package:http/http.dart" as http;
import 'package:weather/core/result.dart';
import 'package:weather/datasources/remote/weather_remote_datasource.dart';
import 'package:weather/exceptions/weather.dart';
import 'package:weather/models/forecast.dart';
import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';

class WeatherRemoteDatasourceImpl implements WeatherRemoteDatasource {
  WeatherRemoteDatasourceImpl();

  @override
  Future<Result<CityLocation>> getLocation(String cityName) async {
    try {
      final Uri url = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
        "name": cityName,
        "count": "1",
      });

      final response = await http.get(url);
      final Map<String, dynamic> json = jsonDecode(response.body);
      final results = json['results'];

      if (results == null || (results as List).isEmpty) {
        return Failure(CityNotFound(cityName));
      }

      return Success(CityLocation.fromJSON(results.first));
    } on SocketException {
      return Failure(NetworkError('Sem conexão com a internet.'));
    } catch (e) {
      return Failure(UnexpectedError(e.toString()));
    }
  }

  @override
  Future<Result<CityWeather>> getWeather(CityLocation location) async {
    try {
      final url = Uri.https('api.open-meteo.com', '/v1/forecast', {
        "latitude": location.latitude,
        "longitude": location.longitude,
        "current": "temperature_2m,windspeed_2m,relative_humidity_2m",
        "wind_speed_unit": "kmh",
        "timezone": location.timezone,
      });

      final response = await http.get(url);
      final Map<String, dynamic> json = jsonDecode(response.body);

      return Success(CityWeather.fromJSON(json));
    } on SocketException {
      return Failure(NetworkError('Sem conexão com a internet.'));
    } catch (e) {
      return Failure(UnexpectedError(e.toString()));
    }
  }

  @override
  Future<Result<CityForecast>> getForecast(String cityName, int days) async {
    final locationResult = await getLocation(cityName);
    if (locationResult case Failure(:final error)) return Failure(error);
    final location = (locationResult as Success<CityLocation>).value;

    try {
      final url = Uri.https('api.open-meteo.com', '/v1/forecast', {
        "latitude": location.latitude,
        "longitude": location.longitude,
        "daily": "temperature_2m_max,temperature_2m_min",
        "forecast_days": days.toString(),
        "timezone": location.timezone,
      });

      final response = await http.get(url);
      final json = jsonDecode(response.body);

      return Success(CityForecast.fromJSON(json));
    } on SocketException {
      return Failure(NetworkError('Sem conexão com a internet.'));
    } catch (e) {
      return Failure(UnexpectedError(e.toString()));
    }
  }
}
