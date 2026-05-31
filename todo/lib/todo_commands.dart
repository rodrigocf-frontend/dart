void runCommand(List<String> args) {
  final String firstCommand = args.first;
  final List<String> secondArgument = args.sublist(1);

  switch (firstCommand) {
    case "add":
      if (secondArgument.isEmpty) {
        return;
      }
      print("add case");
    case "list":
      if (secondArgument.isNotEmpty) {
        return;
      }
      print("list case");
    case "done":
      if (secondArgument.isEmpty) {
        return;
      }
      print("done case");
    case "delete":
      if (secondArgument.isEmpty) {
        return;
      }
      print("delete case");
    default:
      print("Uso: todo <comando> [argumentos]");
  }
}
