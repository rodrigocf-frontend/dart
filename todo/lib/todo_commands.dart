import 'package:todo/todo_repository.dart';

void runCommand(List<String> args, TodoRepository repository) {
  final String firstCommand = args.first;
  final List<String> secondArgument = args.sublist(1);

  switch (firstCommand) {
    case "add":
      //ADD REQUIRED ""
      if (secondArgument.isEmpty || args.length > 2) {
        print("ïnvalid arguments");
        return;
      }
      repository.add(secondArgument.single);
      return;
    case "list":
      if (secondArgument.isNotEmpty) {
        print("ïnvalid arguments");
        return;
      }
      repository.read();
      return;
    case "done":
      if (secondArgument.isEmpty || args.length > 2) {
        print("ïnvalid arguments");
        return;
      }
      //NEED ERROR CASE no number
      repository.done(int.parse(secondArgument.single));
    case "delete":
      if (secondArgument.isEmpty || args.length > 2) {
        print("ïnvalid arguments");
        return;
      }
      //NEED ERROR CASE no number
      repository.delete(int.parse(secondArgument.single));
    default:
      print("Uso: todo <comando> [argumentos]");
  }
}
