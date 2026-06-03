sealed class WeatherError {}

class CityNotFound extends WeatherError {
  final String cityName;
  CityNotFound(this.cityName);
}
