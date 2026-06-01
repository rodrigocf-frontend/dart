import 'package:todo/models/todo_model.dart';
import 'package:todo/repository/todo_repository.dart';

class TodoService {
  final TodoRepository _repository;
  TodoService({required this._repository});

  static Future<TodoService> init({required String storagePath}) async {
    final repository = await TodoRepository.init(storagePath);
    return TodoService(repository: repository);
  }

  Future<void> addTodo({required String title}) async {
    final int currentId = _repository.updateLastCreatedId();
    final Todo newTodo = Todo(id: currentId, title: title);
    await _repository.create(newTodo);
  }

  Future<void> removeTodo({required int id}) async {
    final indexWhere = _repository.findIndexById(id);
    if (indexWhere != -1) {
      await _repository.delete(indexWhere);
    } else {
      print("Tarefa com id $id não encontrada.");
    }
  }

  Future<void> setTodoDone({required int id}) async {
    final indexWhere = _repository.findIndexById(id);
    if (indexWhere != -1) {
      final Todo todo = _repository.data[indexWhere];
      todo.done();
      await _repository.update(indexWhere, todo);
    } else {
      print("Tarefa com id $id não encontrada.");
    }
  }

  void log() {
    final pending = _repository.data
        .where((t) => t.status == TodoStatus.pending)
        .length;
    final done = _repository.data
        .where((t) => t.status == TodoStatus.done)
        .length;

    print(
      '|--------------------------------- TODO LIST ---------------------------------|\n',
    );
    print(
      '   Atividades pendentes: $pending | Atividades concluidas: $done | Atividades criadas: ${_repository.lastCreatedId} \n',
    );

    for (final todoItem in _repository.data) {
      todoItem.log();
    }

    print('\n\n');
  }
}
