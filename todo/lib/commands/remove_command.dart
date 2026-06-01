import 'package:args/command_runner.dart';
import 'package:todo/service/todo_service.dart';

class RemoveCommand extends Command {
  @override
  final name = "remove";
  @override
  final description = "Remove todo from list.";

  final TodoService _service;

  RemoveCommand({required this._service});

  @override
  Future<void> run() async {
    if (argResults!.arguments.isEmpty) {
      print("Invalid Arguments");
      return;
    }
    try {
      final int id = int.parse((argResults!.arguments.join(" ").trim()));
      await _service.removeTodo(id: id);
    } on FormatException {
      print(description);
      print("\nUsage: todo $name [arguments] \n");
      print("${argParser.usage} \n");
    } catch (e) {
      print("An unexpected error occurred: $e");
    }
  }
}
