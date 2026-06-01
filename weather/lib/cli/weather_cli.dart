import 'package:args/command_runner.dart';
import 'package:weather/cli/commands/clear.dart';
import 'package:weather/cli/commands/forecast.dart';
import 'package:weather/cli/commands/get.dart';
import 'package:weather/cli/commands/history.dart';

class WeatherCli extends CommandRunner {
  WeatherCli() : super('weather', '') {
    addCommand(GetCommand());
    addCommand(ForecastCommand());
    addCommand(HistoryCommand());
    addCommand(ClearCommand());
  }
}
