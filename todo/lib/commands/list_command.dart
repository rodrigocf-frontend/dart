import 'package:args/command_runner.dart';
import 'package:todo/service/todo_service.dart';

class ListCommand extends Command {
  @override
  final name = "list";
  @override
  final description = "List all todos in the storage.";

  final TodoService _service;

  ListCommand({required this._service});

  @override
  void run() {
    if (argResults!.arguments.isEmpty) {
      _service.log();
      return;
    } else {
      print(description);
      print("\nUsage: todo $name [arguments] \n");
      print("${argParser.usage} \n");
    }
    ;
  }
}
