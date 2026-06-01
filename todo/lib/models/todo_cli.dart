import 'package:args/command_runner.dart';
import 'package:todo/commands/add_command.dart';
import 'package:todo/commands/done_command.dart';
import 'package:todo/commands/list_command.dart';
import 'package:todo/commands/remove_command.dart';
import 'package:todo/service/todo_service.dart';

class TodoCLI extends CommandRunner {
  final TodoService _service;
  TodoCLI({required this._service})
    : super(
        "todo",
        "A command-line task manager written in Dart. Tasks are persisted locally in a JSON file.",
      ) {
    addCommand(AddCommand(service: _service));
    addCommand(ListCommand(service: _service));
    addCommand(RemoveCommand(service: _service));
    addCommand(DoneCommand(service: _service));
  }

  static Future<TodoCLI> init({required String storagePath}) async {
    final service = await TodoService.init(storagePath: storagePath);
    return TodoCLI(service: service);
  }
}
