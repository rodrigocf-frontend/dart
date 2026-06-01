import 'dart:async';

import 'package:args/command_runner.dart';

class GetCommand extends Command {
  @override
  String name = "get";
  @override
  String description = "Find out the current climate of a city.";

  GetCommand() {
    argParser.addFlag("refresh", help: "Force update (bypass cache)");
  }

  @override
  Future<void> run() async {
    if (argResults!.rest.isEmpty || argResults!.rest.length > 1) {
      print("invalid command");
      return;
    }
    if (isRefreshing()) {
      print("OK! force refreshing cache");
    } else {
      print("Consult remote/locale");
    }
  }

  bool isRefreshing() {
    return argResults!.flag("refresh");
  }
}
