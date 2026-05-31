import 'package:todo/command_model.dart';
import 'package:todo/todo_repository.dart';

class TodoCLI {
  final Command _addCommand;
  final Command _listCommand;
  final Command _doneCommand;
  final Command _deleteCommand;
  final String _userCommand;

  TodoCLI(String userCommand, String secondArgument, TodoRepository repository)
    : _userCommand = userCommand,
      _addCommand = Command(
        disabled: secondArgument.isEmpty,
        action: () => repository.add(secondArgument),
      ),
      _listCommand = Command(
        disabled: secondArgument.isNotEmpty,
        action: () async => repository.read(),
      ),
      _doneCommand = Command(
        disabled: secondArgument.isEmpty,
        action: () => repository.done(int.parse(secondArgument)),
      ),
      _deleteCommand = Command(
        disabled: secondArgument.isEmpty,
        action: () => repository.delete(int.parse(secondArgument)),
      );

  static TodoCLI init(List<String> args, TodoRepository repository) {
    final String firstCommand = args.first;
    final String secondArgument = args.sublist(1).join(" ");

    return TodoCLI(firstCommand, secondArgument, repository);
  }

  Future<void> run() async {
    switch (_userCommand) {
      case "add":
        await _addCommand.run();
      case "list":
        await _listCommand.run();
        return;
      case "done":
        await _doneCommand.run();
      case "delete":
        await _deleteCommand.run();
      default:
        print("Uso: todo <comando> [argumentos]");
    }
  }
}
