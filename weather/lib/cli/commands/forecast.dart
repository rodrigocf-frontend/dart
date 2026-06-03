import 'package:args/command_runner.dart';
import 'package:weather/cli/display/display.dart';
import 'package:weather/core/result.dart';
import 'package:weather/exceptions/weather.dart';
import 'package:weather/repositories/weather_repository.dart';

class ForecastCommand extends Command {
  @override
  final String name = "forecast";
  @override
  final String description = "See the forecast for the next few days.";
  final WeatherRepository _repository;

  ForecastCommand({required this._repository}) {
    argParser.addOption("days", help: "Number of forecast days.");
    argParser.addFlag("refresh", help: "Force update (bypass cache)");
  }

  @override
  Future<void> run() async {
    if (argResults!.rest.isEmpty ||
        !_hasDays() ||
        argResults!.rest.length > 1) {
      print("invalid command");
      return;
    }

    final String city = argResults!.rest.first;
    final int days = int.parse(argResults!['days']);
    final bool forceRefresh = _isRefreshing();

    final result = await _repository.getForecast(city, days, forceRefresh);

    switch (result) {
      case Success(:final value):
        Display.logForecast(value.location, value.forecast);
      case Failure(:final error):
        switch (error) {
          case CityNotFound(:final cityName):
            print('Cidade "$cityName" não encontrada.');
          case NetworkError(:final message):
            print('Erro de rede: $message');
          case UnexpectedError(:final message):
            print('Erro inesperado: $message');
        }
    }
  }

  bool _hasDays() {
    return argResults!['days'] != null;
  }

  bool _isRefreshing() {
    return argResults!.flag("refresh");
  }
}
