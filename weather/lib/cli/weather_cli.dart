import 'package:args/command_runner.dart';
import 'package:weather/cli/commands/clear.dart';
import 'package:weather/cli/commands/forecast.dart';
import 'package:weather/cli/commands/get.dart';
import 'package:weather/cli/commands/history.dart';
import 'package:weather/repositories/weather_repository.dart';
import 'package:weather/repositories/weather_repository_impl.dart';

class WeatherCli extends CommandRunner {
  WeatherCli()
    : super(
        'weather',
        'Check the current weather and forecast by city using Open-Meteo.',
      ) {
    final WeatherRepository repository = WeatherRepositoryImpl();

    addCommand(GetCommand(repository: repository));
    addCommand(ForecastCommand());
    addCommand(HistoryCommand(repository: repository));
    addCommand(ClearCommand(repository: repository));
  }
}
