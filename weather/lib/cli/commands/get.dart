import 'package:args/command_runner.dart';
import 'package:weather/cli/display/display.dart';
import 'package:weather/core/result.dart';
import 'package:weather/exceptions/weather.dart';
import 'package:weather/repositories/weather_repository.dart';

class GetCommand extends Command {
  @override
  final String name = "get";
  @override
  final String description = "Find out the current climate of a city.";
  final WeatherRepository _repository;

  GetCommand({required this._repository}) {
    argParser.addFlag("refresh", help: "Force update (bypass cache)");
  }

  @override
  Future<void> run() async {
    if (argResults!.rest.isEmpty || argResults!.rest.length > 1) {
      print("invalid command");
      return;
    }

    final String cityName = argResults!.rest.first;
    final bool forceRefresh = _isRefreshing();

    final result = await _repository.getCurrentWeather(cityName, forceRefresh);

    switch (result) {
      case Success(:final value):
        Display.logWeather(
          value.location,
          value.weather,
          fromCache: value.fromCache,
          fetchedAt: value.fetchedAt,
        );
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

  bool _isRefreshing() {
    return argResults!.flag("refresh");
  }
}
