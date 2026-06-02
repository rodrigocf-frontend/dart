import 'dart:io';
import 'package:weather/datasources/local/weather_local_datasource.dart';
import 'package:weather/datasources/local/weather_local_datasource_impl.dart';
import 'package:weather/datasources/remote/weather_remote_datasource.dart';
import 'package:weather/datasources/remote/weather_remote_datasource_impl.dart';
import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDatasource _remoteDatasource;
  final WeatherLocalDatasource _localDatasource;

  WeatherRepositoryImpl()
    : _remoteDatasource = WeatherRemoteDatasourceImpl(),
      _localDatasource = WeatherLocalDatasourceImpl();

  @override
  Future<
    ({
      CityLocation location,
      CityWeather weather,
      DateTime fetchedAt,
      bool fromCache,
    })
  >
  getCurrentWeather(String cityName, bool forceRefresh) async {
    try {
      final fileData = await _localDatasource.loadCurrentWeatherFile(cityName);
      final location = fileData.location;
      final lastCacheUpdated = fileData.lastCacheUpdated;
      final weather = fileData.weather;

      if (DateTime.now().difference(lastCacheUpdated).inHours > 1 ||
          forceRefresh) {
        final savedUpdate = await _save(location);
        return (
          location: location,
          weather: savedUpdate.weather,
          fromCache: false,
          fetchedAt: savedUpdate.lastCacheUpdated,
        );
      } else {
        return (
          location: location,
          weather: weather,
          fromCache: true,
          fetchedAt: lastCacheUpdated,
        );
      }
    } on PathNotFoundException {
      CityLocation location = await _remoteDatasource.getLocation(cityName);
      await _localDatasource.createCurrentStore(cityName);
      final savedNew = await _save(location);

      return (
        location: location,
        weather: savedNew.weather,
        fromCache: false,
        fetchedAt: savedNew.lastCacheUpdated,
      );
    } catch (e) {
      print("Unexpected Error");
      rethrow;
    }
  }

  @override
  Future<List<({DateTime fetchedAt, int id, String name})>> getHistory() async {
    return _localDatasource.loadHistoryFile();
  }

  Future<({CityWeather weather, DateTime lastCacheUpdated})> _save(
    CityLocation location,
  ) async {
    final CityWeather weather = await _remoteDatasource.getWeather(location);
    final lastCacheUpdated = DateTime.now();

    await _localDatasource.findAndUpdateCurrentFile(
      location,
      weather,
      lastCacheUpdated,
    );
    await _localDatasource.findAndUpdateHistoryByLocation(
      location,
      lastCacheUpdated,
    );

    return (lastCacheUpdated: lastCacheUpdated, weather: weather);
  }
}
