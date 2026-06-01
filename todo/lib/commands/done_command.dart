import 'package:args/command_runner.dart';
import 'package:todo/service/todo_service.dart';

class DoneCommand extends Command {
  @override
  final name = "done";
  @override
  final description = "Change todo status to done";

  final TodoService _service;

  DoneCommand({required this._service});

  @override
  Future<void> run() async {
    if (argResults!.arguments.isEmpty) {
      print("Invalid Arguments");
      return;
    }
    try {
      final int id = int.parse((argResults!.arguments.join(" ").trim()));
      await _service.setTodoDone(id: id);
    } on FormatException {
      print(description);
      print("\nUsage: todo $name [arguments] \n");
      print("${argParser.usage} \n");
    } catch (e) {
      print("An unexpected error occurred: $e");
    }
  }
}
