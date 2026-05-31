import 'dart:convert';
import 'dart:io';
import 'package:todo/todo_model.dart';

class TodoRepository {
  List<Todo> _repository;
  final String _storePath;
  int _lastIdCreated;

  TodoRepository(List<Todo> data, int lastIdCreated, String storePath)
    : _repository = data,
      _storePath = storePath,
      _lastIdCreated = lastIdCreated;

  static Future<TodoRepository> init(String storePath) async {
    final fileData = File(storePath);
    final readFileData = await fileData.readAsString();
    final dataToJSON = jsonDecode(readFileData);
    final lastIdCreated = dataToJSON['lastIdCreated'] as int;
    final list = TodoRepository.fromJSONList(
      dataToJSON['list'] as List<dynamic>,
    );
    return TodoRepository(list, lastIdCreated, storePath);
  }

  static List<Todo> fromJSONList(List<dynamic> todoList) {
    return todoList.map((todoJSON) => Todo.fromJSON(todoJSON)).toList();
  }

  List<Map<String, dynamic>> _toJSONList() {
    return _repository.map((todoJSON) => todoJSON.toJSON()).toList();
  }

  void read() {
    final pending = _repository
        .where((t) => t.status == TodoStatus.pending)
        .length;
    final done = _repository.where((t) => t.status == TodoStatus.done).length;

    print(
      '|--------------------------------- TODO LIST ---------------------------------|\n',
    );
    print(
      '   Atividades pendentes: $pending | Atividades concluidas: $done | Atividades criadas: $_lastIdCreated \n',
    );

    for (final todoItem in _repository) {
      todoItem.log();
    }

    print('\n\n');
  }

  Future<void> _save() async {
    final dataToString = jsonEncode({
      "list": _toJSONList(),
      "lastIdCreated": _lastIdCreated,
    });
    final fileData = File(_storePath);
    await fileData.writeAsString(dataToString);
  }

  Future<void> add(String title) async {
    _lastIdCreated += 1;
    _repository.add(Todo(id: _lastIdCreated, title: title.trim()));
    await _save();
  }

  Future<void> delete(int id) async {
    final indexWhere = _repository.indexWhere((todoItem) => todoItem.id == id);
    if (indexWhere != -1) {
      _repository.removeAt(indexWhere);
      await _save();
      return;
    }
    print("Tarefa com id $id não encontrada.");
  }

  Future<void> done(int id) async {
    final indexWhere = _repository.indexWhere((todoItem) => todoItem.id == id);
    if (indexWhere != -1) {
      _repository[indexWhere].done();
      await _save();
      return;
    }
    print("Tarefa com id $id não encontrada.");
  }
}
