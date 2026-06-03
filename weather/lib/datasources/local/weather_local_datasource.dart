import 'dart:io';

import 'package:weather/models/forecast.dart';
import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';

abstract interface class WeatherLocalDatasource {
  File configPathToFile(String path);
  Future<File> createStore(String path);
  Future<File> createCurrentStore(String cityName);
  Future<void> findAndUpdateCurrentFile(
    CityLocation location,
    CityWeather weather,
    DateTime lastCacheUpdated,
  );
  String getHistoryCachePath();
  String getCurrentCachePath(String cityName);
  Future<
    ({CityLocation location, CityWeather weather, DateTime lastCacheUpdated})
  >
  loadCurrentWeatherFile(String cityName);
  Future<List<({DateTime fetchedAt, int id, String name})>> loadHistoryFile();
  Future<void> findAndUpdateHistoryByLocation(
    CityLocation location,
    DateTime lastCacheUpdated,
  );
  Future<int> deleteCache();
  Future<
    ({CityForecast forecast, CityLocation location, DateTime lastCacheUpdated})
  >
  loadForecastFile(String cityName);
  String getForecastCachePath(String cityName);
  Future<void> findAndUpdateForecastByLocation(
    CityLocation location,
    CityForecast forecast,
    DateTime lastCacheUpdated,
  );
  Future<File> createForecastStore(String cityName);
}
