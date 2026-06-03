import 'package:args/command_runner.dart';
import 'package:weather/cli/display/display.dart';
import 'package:weather/repositories/weather_repository.dart';

class HistoryCommand extends Command {
  @override
  final String name = "history";
  @override
  final String description =
      "List cities that have already been searched (cache)";
  final WeatherRepository _repository;

  HistoryCommand({required this._repository});

  @override
  Future<void> run() async {
    if (argResults!.rest.isNotEmpty) {
      print("invalid command");
      return;
    }
    final history = await _repository.getHistory();
    Display.logHistory(history);
  }
}
