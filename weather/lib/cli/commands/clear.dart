import 'dart:async';
import 'package:args/command_runner.dart';
import 'package:weather/cli/display/display.dart';
import 'package:weather/repositories/weather_repository.dart';

class ClearCommand extends Command {
  @override
  final String name = "clear";
  @override
  final String description = "Clear cache";

  final WeatherRepository _repository;

  ClearCommand({required this._repository});

  @override
  Future<void> run() async {
    if (argResults!.rest.isNotEmpty) {
      print("invalid command");
      return;
    }
    final int count = await _repository.clearCache();

    Display.logClear(count);
  }
}
