import 'package:weather/exceptions/weather.dart';

sealed class Result<T> {}

class Success<T> extends Result<T> {
  final T value;
  Success(this.value);
}

class Failure<T> extends Result<T> {
  final WeatherError error;
  Failure(this.error);
}
