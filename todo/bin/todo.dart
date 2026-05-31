import 'package:todo/todo_commands.dart';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print("Uso: todo <comando> [argumentos]");
  }

  if (arguments.isNotEmpty) {
    runCommand(arguments);
  }
}
