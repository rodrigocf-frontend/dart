# Weather CLI

A command-line application built in pure Dart that fetches weather data from the [Open-Meteo](https://open-meteo.com/) public API and caches it locally.

## Features

- Current weather for any city
- Multi-day forecast (up to 16 days)
- File-based local cache with TTL (1h for current, 6h for forecast)
- Search history
- Typed error handling with `sealed class` and `Result<T>`

## Commands

```bash
# Current weather
dart run weather get "Campina Grande"
dart run weather get "Campina Grande" --refresh

# Forecast
dart run weather forecast "Campina Grande" --days 5
dart run weather forecast "Campina Grande" --days 5 --refresh

# History
dart run weather history

# Clear cache
dart run weather clear
```

## Architecture

```
lib/
  cli/
    commands/       # get, forecast, history, clear
    display/        # output formatting
  core/
    result.dart     # Result<T>, Success<T>, Failure<T>
  datasources/
    remote/         # HTTP calls to Open-Meteo
    local/          # file-based JSON cache
  exceptions/
    weather.dart    # WeatherError sealed class
  models/           # CityLocation, CityWeather, CityForecast
  repositories/     # WeatherRepository interface + impl
```

**Stack:** `http`, `args`, `path`

## Error handling

Errors are represented as typed values using a `Result<T>` sealed class:

```dart
switch (result) {
  case Success(:final value):
    Display.logWeather(value.location, value.weather, ...);
  case Failure(:final error):
    switch (error) {
      case CityNotFound(:final cityName):
        print('City "$cityName" not found.');
      case NetworkError(:final message):
        print('Network error: $message');
      case UnexpectedError(:final message):
        print('Unexpected error: $message');
    }
}
```

## Running tests

```bash
dart test
```

To regenerate mocks after interface changes:

```bash
dart run build_runner build
```
