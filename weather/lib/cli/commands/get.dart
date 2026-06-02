import 'package:args/command_runner.dart';
import 'package:weather/cli/display/display.dart';
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

    final currentData = await _repository.getCurrentWeather(
      cityName,
      forceRefresh,
    );

    Display.logWeather(
      currentData.location,
      currentData.weather,
      fromCache: currentData.fromCache,
      fetchedAt: currentData.fetchedAt,
    );
  }

  bool _isRefreshing() {
    return argResults!.flag("refresh");
  }
}
