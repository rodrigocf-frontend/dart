import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';

abstract interface class WeatherRemoteDatasource {
  Future<CityLocation> getLocation(Uri url);
  Future<CityWeather> getWeather(Uri url);
}
