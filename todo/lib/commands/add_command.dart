import 'package:args/command_runner.dart';
import 'package:todo/service/todo_service.dart';

class AddCommand extends Command {
  @override
  final name = "add";
  @override
  final description = "Add a task to the list.";

  final TodoService _service;

  AddCommand({required this._service});

  @override
  Future<void> run() async {
    if (argResults!.arguments.isEmpty) {
      print("Invalid Arguments");
      return;
    }
    final String formattedTitle = argResults!.arguments.join(" ").trim();
    await _service.addTodo(title: formattedTitle);
  }
}
