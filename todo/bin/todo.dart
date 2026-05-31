import 'package:todo/todo_commands.dart';
import 'package:todo/todo_repository.dart';

void main(List<String> arguments) async {
  final repository = await TodoRepository.init("./store/data.json");

  runCommand(arguments, repository);
}
