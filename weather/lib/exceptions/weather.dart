sealed class WeatherError {}

class CityNotFound extends WeatherError {
  final String cityName;
  CityNotFound(this.cityName);
}

class NetworkError extends WeatherError {
  final String message;
  NetworkError(this.message);
}

class UnexpectedError extends WeatherError {
  final String message;
  UnexpectedError(this.message);
}
