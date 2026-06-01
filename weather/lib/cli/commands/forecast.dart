import 'dart:async';

import 'package:args/command_runner.dart';

class ForecastCommand extends Command {
  @override
  String name = "forecast";
  @override
  String description = "See the forecast for the next few days.";

  ForecastCommand() {
    argParser.addFlag(
      "days",
      help: "The number of days in the weather forecast.",
    );
  }

  @override
  Future<void> run() async {
    if (argResults!.rest.isEmpty || !hasDays() || argResults!.rest.length > 2) {
      print("invalid command");
      return;
    }

    final int days = int.parse(argResults!.rest.last);
    final String city = argResults!.rest.first;

    print("$city $days");
  }

  bool hasDays() {
    return argResults!.flag("days");
  }
}
