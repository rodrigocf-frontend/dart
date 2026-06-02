import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';

abstract interface class WeatherRepository {
  Future<
    ({
      CityLocation location,
      CityWeather weather,
      DateTime fetchedAt,
      bool fromCache,
    })
  >
  getCurrentWeather(String cityName, bool forceRefresh);
}
