import 'package:weather/core/result.dart';
import 'package:weather/models/forecast.dart';
import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';

abstract interface class WeatherRepository {
  Future<Result<({CityLocation location, CityWeather weather, DateTime fetchedAt, bool fromCache})>>
  getCurrentWeather(String cityName, bool forceRefresh);

  Future<Result<({CityForecast forecast, CityLocation location, DateTime fetchedAt})>>
  getForecast(String cityName, int days, bool forceRefresh);

  Future<List<({DateTime fetchedAt, int id, String name})>> getHistory();
  Future<int> clearCache();
}
