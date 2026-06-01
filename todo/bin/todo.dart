import 'package:todo/models/todo_cli.dart';

void main(List<String> arguments) async {
  final runner = await TodoCLI.init(storagePath: "./store/data.json");
  await runner.run(arguments);
}
