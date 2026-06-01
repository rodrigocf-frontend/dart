import 'dart:async';

import 'package:args/command_runner.dart';

class HistoryCommand extends Command {
  @override
  String name = "history";
  @override
  String description = "List cities that have already been searched (cache)";

  @override
  Future<void> run() async {
    if (argResults!.rest.isNotEmpty) {
      print("invalid command");
      return;
    }
    print("get history");
  }
}
