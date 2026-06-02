import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';

abstract interface class WeatherRemoteDatasource {
  Future<CityLocation> getLocation(String cityName);
  Future<CityWeather> getWeather(CityLocation location);
}
