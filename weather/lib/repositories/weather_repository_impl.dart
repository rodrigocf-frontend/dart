import 'dart:convert';
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
    final String path = _getCurrentStorePath(cityName);
    File file = await _localDatasource.getFile(path);

    try {
      final fileData = await _getFileData(file);
      final location = fileData.location;
      final lastCacheUpdated = fileData.lastCacheUpdated;
      final weather = fileData.weather;

      if (DateTime.now().difference(lastCacheUpdated).inHours > 1 ||
          forceRefresh) {
        final savedUpdate = await _save(file, location);
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
      CityLocation location = await _fetchLocationFromAPI(cityName);
      file = await _localDatasource.createStore(path);
      final savedNew = await _save(file, location);

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

  Future<
    ({CityLocation location, CityWeather weather, DateTime lastCacheUpdated})
  >
  _getFileData(File file) async {
    final String fileData = await file.readAsString();
    final fileDataJSON = jsonDecode(fileData);

    final DateTime lastCacheUpdated = DateTime.parse(
      fileDataJSON['cache_updated'] as String,
    );

    final CityLocation location = CityLocation.fromJSON(fileDataJSON);
    final CityWeather weather = CityWeather.fromJSON(fileDataJSON);

    return (
      lastCacheUpdated: lastCacheUpdated,
      location: location,
      weather: weather,
    );
  }

  Future<CityWeather> _fetchWeatherFromAPI(CityLocation location) async {
    var url = Uri.https('api.open-meteo.com', '/v1/forecast', {
      "latitude": location.latitude,
      "longitude": location.longitude,
      "current": "temperature_2m,windspeed_2m,relative_humidity_2m",
      "wind_speed_unit": "kmh",
      "timezone": location.timezone,
    });

    return _remoteDatasource.getWeather(url);
  }

  Future<CityLocation> _fetchLocationFromAPI(String cityName) async {
    final Uri url = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      "name": cityName,
      "count": "1",
    });

    return _remoteDatasource.getLocation(url);
  }

  Future<({CityWeather weather, DateTime lastCacheUpdated})> _save(
    File file,
    CityLocation location,
  ) async {
    final CityWeather weather = await _fetchWeatherFromAPI(location);
    final lastCacheUpdated = DateTime.now();

    final fileData = jsonEncode({
      ...location.toJSON(),
      ...weather.toJSON(),
      "cache_updated": lastCacheUpdated.toIso8601String(),
    });

    await _localDatasource.saveCurrentFile(file, fileData);

    return (lastCacheUpdated: lastCacheUpdated, weather: weather);
  }

  String _getCurrentStorePath(String cityName) {
    return 'store/${cityName.toLowerCase().replaceAll(RegExp(" "), "_")}_current.json';
  }
}
