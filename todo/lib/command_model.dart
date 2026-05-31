class Command {
  final bool disabled;
  final Future<void> Function() action;
  Command({required this.disabled, required this.action});

  Future<void> run() async {
    if (disabled) {
      print("invalid arguments");
      return;
    }
    try {
      await action();
    } on FormatException {
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
  }
}
