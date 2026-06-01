import 'dart:async';

import 'package:args/command_runner.dart';

class ClearCommand extends Command {
  @override
  String name = "clear";
  @override
  String description = "Clear cache";

  @override
  Future<void> run() async {
    if (argResults!.rest.isNotEmpty) {
      print("invalid command");
      return;
    }
    print("clear storage");
  }
}
