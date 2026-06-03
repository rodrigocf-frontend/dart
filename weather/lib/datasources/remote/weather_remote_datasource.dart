import 'package:weather/core/result.dart';
import 'package:weather/models/forecast.dart';
import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';

abstract interface class WeatherRemoteDatasource {
  Future<Result<CityLocation>> getLocation(String cityName);
  Future<Result<CityWeather>> getWeather(CityLocation location);
  Future<Result<CityForecast>> getForecast(CityLocation location, int days);
}
