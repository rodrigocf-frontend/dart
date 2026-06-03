import 'dart:io';
import 'package:weather/core/result.dart';
import 'package:weather/datasources/local/weather_local_datasource.dart';
import 'package:weather/datasources/local/weather_local_datasource_impl.dart';
import 'package:weather/datasources/remote/weather_remote_datasource.dart';
import 'package:weather/datasources/remote/weather_remote_datasource_impl.dart';
import 'package:weather/exceptions/weather.dart';
import 'package:weather/models/forecast.dart';
import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDatasource _remoteDatasource;
  final WeatherLocalDatasource _localDatasource;

  WeatherRepositoryImpl()
    : _remoteDatasource = WeatherRemoteDatasourceImpl(),
      _localDatasource = WeatherLocalDatasourceImpl();

  WeatherRepositoryImpl.withDatasources(
    WeatherRemoteDatasource remote,
    WeatherLocalDatasource local,
  )   : _remoteDatasource = remote,
        _localDatasource = local;

  @override
  Future<Result<({CityLocation location, CityWeather weather, DateTime fetchedAt, bool fromCache})>>
  getCurrentWeather(String cityName, bool forceRefresh) async {
    try {
      final fileData = await _localDatasource.loadCurrentWeatherFile(cityName);
      final location = fileData.location;
      final lastCacheUpdated = fileData.lastCacheUpdated;
      final weather = fileData.weather;

      if (DateTime.now().difference(lastCacheUpdated).inHours >= 1 || forceRefresh) {
        final saveResult = await _save(location);
        if (saveResult case Failure(:final error)) return Failure(error);
        final saved = (saveResult as Success).value;
        return Success((
          location: location,
          weather: saved.weather,
          fromCache: false,
          fetchedAt: saved.lastCacheUpdated,
        ));
      } else {
        return Success((
          location: location,
          weather: weather,
          fromCache: true,
          fetchedAt: lastCacheUpdated,
        ));
      }
    } on PathNotFoundException {
      final locationResult = await _remoteDatasource.getLocation(cityName);
      if (locationResult case Failure(:final error)) return Failure(error);
      final location = (locationResult as Success<CityLocation>).value;

      await _localDatasource.createCurrentStore(cityName);
      final saveResult = await _save(location);
      if (saveResult case Failure(:final error)) return Failure(error);
      final saved = (saveResult as Success).value;

      return Success((
        location: location,
        weather: saved.weather,
        fromCache: false,
        fetchedAt: saved.lastCacheUpdated,
      ));
    } catch (e) {
      return Failure(UnexpectedError(e.toString()));
    }
  }

  @override
  Future<Result<({CityForecast forecast, CityLocation location, DateTime fetchedAt})>>
  getForecast(String cityName, int days, bool forceRefresh) async {
    try {
      final fileData = await _localDatasource.loadForecastFile(cityName);
      final forecast = fileData.forecast;
      final location = fileData.location;
      final lastCacheUpdated = fileData.lastCacheUpdated;

      if (DateTime.now().difference(lastCacheUpdated).inHours >= 6 ||
          forecast.days.length != days ||
          forceRefresh) {
        final saveResult = await _saveForecast(cityName, days);
        if (saveResult case Failure(:final error)) return Failure(error);
        final saved = (saveResult as Success).value;
        return Success((
          forecast: saved.forecast,
          location: saved.location,
          fetchedAt: saved.lastCacheUpdated,
        ));
      } else {
        return Success((
          forecast: forecast,
          location: location,
          fetchedAt: lastCacheUpdated,
        ));
      }
    } on PathNotFoundException {
      await _localDatasource.createForecastStore(cityName);
      final saveResult = await _saveForecast(cityName, days);
      if (saveResult case Failure(:final error)) return Failure(error);
      final saved = (saveResult as Success).value;
      return Success((
        forecast: saved.forecast,
        location: saved.location,
        fetchedAt: saved.lastCacheUpdated,
      ));
    } catch (e) {
      return Failure(UnexpectedError(e.toString()));
    }
  }

  Future<Result<({CityWeather weather, DateTime lastCacheUpdated})>> _save(
    CityLocation location,
  ) async {
    final weatherResult = await _remoteDatasource.getWeather(location);
    if (weatherResult case Failure(:final error)) return Failure(error);
    final weather = (weatherResult as Success<CityWeather>).value;

    final lastCacheUpdated = DateTime.now();
    await _localDatasource.findAndUpdateCurrentFile(location, weather, lastCacheUpdated);
    await _localDatasource.findAndUpdateHistoryByLocation(location, lastCacheUpdated);

    return Success((lastCacheUpdated: lastCacheUpdated, weather: weather));
  }

  Future<Result<({CityForecast forecast, CityLocation location, DateTime lastCacheUpdated})>>
  _saveForecast(String cityName, int days) async {
    final forecastResult = await _remoteDatasource.getForecast(cityName, days);
    if (forecastResult case Failure(:final error)) return Failure(error);
    final forecast = (forecastResult as Success<CityForecast>).value;

    final locationResult = await _remoteDatasource.getLocation(cityName);
    if (locationResult case Failure(:final error)) return Failure(error);
    final location = (locationResult as Success<CityLocation>).value;

    final lastCacheUpdated = DateTime.now();
    await _localDatasource.findAndUpdateForecastByLocation(location, forecast, lastCacheUpdated);

    return Success((
      forecast: forecast,
      location: location,
      lastCacheUpdated: lastCacheUpdated,
    ));
  }

  @override
  Future<List<({DateTime fetchedAt, int id, String name})>> getHistory() async {
    return _localDatasource.loadHistoryFile();
  }

  @override
  Future<int> clearCache() async {
    return _localDatasource.deleteCache();
  }
}
