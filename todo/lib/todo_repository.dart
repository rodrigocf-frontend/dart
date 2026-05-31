import 'dart:convert';
import 'dart:io';
import 'package:todo/todo_model.dart';

class TodoRepository {
  List<Todo> _repository = [];
  late String _storePath;
  late int _lastIdCreated;

  TodoRepository(List<Todo> data, lastIdCreated, storePath) {
    _repository = data;
    _storePath = storePath;
    _lastIdCreated = lastIdCreated;
  }

  static Future<TodoRepository> init(String storePath) async {
    final fileData = File(storePath);
    final readFileData = await fileData.readAsString();
    final dataToJSON = jsonDecode(readFileData);
    final lastIdCreated = dataToJSON['lastIdCreated'];
    final list = TodoRepository.fromJSONList(dataToJSON['list']);
    return TodoRepository(list, lastIdCreated, storePath);
  }

  static List<Todo> fromJSONList(List<dynamic> todoList) {
    return todoList
        .map(
          (todoJSON) => Todo(
            id: todoJSON['id'],
            title: todoJSON['title'],
            status: todoJSON['status'],
            createdAt: todoJSON['createdAt'],
          ),
        )
        .toList();
  }

  List<dynamic> _toJSONList() {
    return _repository.map((todoJSON) => todoJSON.toJSON()).toList();
  }

  void read() {
    print(_repository);
  }

  void _save() async {
    final dataToString = jsonEncode({
      "list": _toJSONList(),
      "lastIdCreated": _lastIdCreated,
    });
    final fileData = File(_storePath);
    await fileData.writeAsString(dataToString);
  }

  void add(String title) async {
    _lastIdCreated += 1;
    _repository.add(Todo(id: _lastIdCreated, title: title.trim()));
    _save();
  }

  void delete(int id) async {
    _repository = _repository.where((todoItem) => todoItem.id != id).toList();
    _save();
  }

  void done(int id) {
    final indexWhere = _repository.indexWhere((todoItem) => todoItem.id == id);
    if (indexWhere != -1) {
      _repository[indexWhere].done();
    }
    _save();
  }
}
