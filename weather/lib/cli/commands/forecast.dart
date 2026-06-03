import 'package:args/command_runner.dart';
import 'package:weather/cli/display/display.dart';
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

    final int days = int.parse(argResults!['days']);
    final String city = argResults!.rest.first;
    final bool forceRefresh = _isRefreshing();
    final data = await _repository.getForecast(city, days, forceRefresh);

    Display.logForecast(data.location, data.forecast);
  }

  bool _hasDays() {
    return argResults!['days'] != null;
  }

  bool _isRefreshing() {
    return argResults!.flag("refresh");
  }
}
