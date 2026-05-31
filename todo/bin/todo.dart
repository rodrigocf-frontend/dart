import 'package:todo/todo_cli_model.dart';
import 'package:todo/todo_repository.dart';

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('''
Uso: todo <comando> [argumentos]

Comandos disponíveis:
  add <título>   Adiciona uma nova tarefa
  list           Lista todas as tarefas
  done <id>      Marca uma tarefa como concluída
  delete <id>    Remove uma tarefa

Dúvidas? Digite: todo -h
''');
    return;
  }
  final repository = await TodoRepository.init("./store/data.json");

  final todoCLI = TodoCLI.init(arguments, repository);

  await todoCLI.run();
}
