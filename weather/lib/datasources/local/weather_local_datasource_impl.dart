import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:weather/datasources/local/weather_local_datasource.dart';
import 'package:weather/models/forecast.dart';
import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';

class WeatherLocalDatasourceImpl implements WeatherLocalDatasource {
  @override
  File configPathToFile(String path) {
    final File file = File(path);
    return file;
  }

  @override
  Future<File> createStore(String path) async {
    final File file = configPathToFile(path);
    file.createSync(recursive: true);
    return file;
  }

  @override
  Future<File> createForecastStore(String cityName) async {
    final String path = getForecastCachePath(cityName);
    File file = configPathToFile(path);
    file.createSync(recursive: true);
    return file;
  }

  @override
  Future<File> createCurrentStore(String cityName) async {
    final String path = getCurrentCachePath(cityName);
    File file = configPathToFile(path);
    file.createSync(recursive: true);
    return file;
  }

  @override
  Future<void> findAndUpdateCurrentFile(
    CityLocation location,
    CityWeather weather,
    DateTime lastCacheUpdated,
  ) async {
    final String path = getCurrentCachePath(location.name);
    File file = configPathToFile(path);

    final fileData = jsonEncode({
      ...location.toJSON(),
      ...weather.toJSON(),
      "cache_updated": lastCacheUpdated.toIso8601String(),
    });

    await file.writeAsString(fileData);
  }

  @override
  Future<
    ({CityLocation location, CityWeather weather, DateTime lastCacheUpdated})
  >
  loadCurrentWeatherFile(String cityName) async {
    final String path = getCurrentCachePath(cityName);
    File file = configPathToFile(path);

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

  @override
  Future<
    ({CityForecast forecast, CityLocation location, DateTime lastCacheUpdated})
  >
  loadForecastFile(String cityName) async {
    final String path = getForecastCachePath(cityName);
    File file = configPathToFile(path);

    final String fileData = await file.readAsString();
    final fileDataJSON = jsonDecode(fileData);

    final DateTime lastCacheUpdated = DateTime.parse(
      fileDataJSON['cache_updated'] as String,
    );

    final CityForecast forecast = CityForecast.fromJSON(fileDataJSON);
    final CityLocation location = CityLocation.fromJSON(fileDataJSON);

    return (
      forecast: forecast,
      location: location,
      lastCacheUpdated: lastCacheUpdated,
    );
  }

  @override
  Future<List<({DateTime fetchedAt, int id, String name})>>
  loadHistoryFile() async {
    try {
      final String path = getHistoryCachePath();
      File file = configPathToFile(path);
      final String fileData = await file.readAsString();
      final List<dynamic> fileDataJSON = jsonDecode(fileData);
      final fileDataCast = fileDataJSON
          .map(
            (item) => (
              fetchedAt: DateTime.parse(item['fetchedAt'] as String),
              id: item['id'] as int,
              name: item['name'] as String,
            ),
          )
          .toList();
      return fileDataCast;
    } on PathNotFoundException {
      return [];
    } catch (e) {
      print("Unexpected Error");
      rethrow;
    }
  }

  @override
  Future<void> findAndUpdateHistoryByLocation(
    CityLocation location,
    DateTime lastCacheUpdated,
  ) async {
    final String path = getHistoryCachePath();
    File file = configPathToFile(path);
    try {
      String fileData = await file.readAsString();
      List<dynamic> fileDataJSON = jsonDecode(fileData);
      final index = fileDataJSON.indexWhere(
        (element) => element['id'] == location.id,
      );

      if (index != -1) {
        fileDataJSON[index]['fetchedAt'] = lastCacheUpdated.toIso8601String();
      } else {
        fileDataJSON.add({
          "id": location.id,
          "name": location.name,
          "fetchedAt": lastCacheUpdated.toIso8601String(),
        });
      }
      final String newFileData = jsonEncode(fileDataJSON);
      await file.writeAsString(newFileData);
    } on PathNotFoundException {
      file = await createStore(path);
      final fileData = jsonEncode([
        {
          "id": location.id,
          "name": location.name,
          "fetchedAt": lastCacheUpdated.toIso8601String(),
        },
      ]);
      await file.writeAsString(fileData);
    } catch (e) {
      print("Unexpected Error");
      rethrow;
    }
  }

  @override
  Future<void> findAndUpdateForecastByLocation(
    CityLocation location,
    CityForecast forecast,
    DateTime lastCacheUpdated,
  ) async {
    final String path = getForecastCachePath(location.name);
    File file = configPathToFile(path);

    final fileData = jsonEncode({
      ...location.toJSON(),
      ...forecast.toJSON(),
      "cache_updated": lastCacheUpdated.toIso8601String(),
    });

    await file.writeAsString(fileData);
  }

  @override
  Future<int> deleteCache() async {
    try {
      String path = "store";
      final directory = Directory(path);
      final list = await directory
          .list(recursive: true)
          .where((item) => !item.path.endsWith("history.json"))
          .map(
            (file) => p
                .basenameWithoutExtension(file.path)
                .replaceAll(RegExp(r'_(current|forecast)$'), ''),
          )
          .toSet();

      final count = list.length;
      await directory.delete(recursive: true);
      return count;
    } on PathNotFoundException {
      return 0;
    } catch (e) {
      print("Unexpected Error");
      rethrow;
    }
  }

  @override
  String getCurrentCachePath(String cityName) {
    return 'store/${cityName.toLowerCase().replaceAll(RegExp(" "), "_")}_current.json';
  }

  @override
  String getForecastCachePath(String cityName) {
    return 'store/${cityName.toLowerCase().replaceAll(RegExp(" "), "_")}_forecast.json';
  }

  @override
  String getHistoryCachePath() {
    return 'store/history.json';
  }
}
