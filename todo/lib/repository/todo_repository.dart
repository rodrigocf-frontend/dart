import 'dart:convert';
import 'dart:io';
import 'package:todo/models/todo_model.dart';

class TodoRepository {
  final List<Todo> _repository;
  final String _storePath;
  int _lastIdCreated;

  TodoRepository(List<Todo> data, int lastIdCreated, String storePath)
    : _repository = data,
      _storePath = storePath,
      _lastIdCreated = lastIdCreated;

  static Future<TodoRepository> init(String storePath) async {
    try {
      final fileData = File(storePath);
      final readFileData = await fileData.readAsString();
      final dataToJSON = jsonDecode(readFileData);
      final lastIdCreated = dataToJSON['lastIdCreated'] as int;
      final list = TodoRepository.fromJSONList(
        dataToJSON['list'] as List<dynamic>,
      );
      return TodoRepository(list, lastIdCreated, storePath);
    } on FileSystemException {
      final newFile = File(storePath);
      await newFile.create(recursive: true);
      final List<Todo> newTodoRepository = TodoRepository.fromJSONList([]);
      final lastIdCreated = 0;
      final newFileData = jsonEncode({
        "list": newTodoRepository,
        "lastIdCreated": 0,
      });
      await newFile.writeAsString(newFileData);
      return TodoRepository(newTodoRepository, lastIdCreated, storePath);
    } catch (e) {
      print("An unexpected error occurred: $e");
      rethrow;
    }
  }

  static List<Todo> fromJSONList(List<dynamic> todoList) {
    return todoList.map((todoJSON) => Todo.fromJSON(todoJSON)).toList();
  }

  List<Map<String, dynamic>> _toJSONList() {
    return _repository.map((todoJSON) => todoJSON.toJSON()).toList();
  }

  Future<void> _persist() async {
    final dataToString = jsonEncode({
      "list": _toJSONList(),
      "lastIdCreated": _lastIdCreated,
    });
    final fileData = File(_storePath);
    await fileData.writeAsString(dataToString);
  }

  Future<void> delete(int index) async {
    _repository.removeAt(index);
    await _persist();
  }

  Future<void> create(Todo todo) async {
    _repository.add(todo);
    await _persist();
  }

  int findIndexById(int id) {
    return _repository.indexWhere((todoItem) => todoItem.id == id);
  }

  Future<void> update(int index, Todo todo) async {
    _repository[index] = todo;
    await _persist();
  }

  int updateLastCreatedId() {
    _lastIdCreated += 1;
    return _lastIdCreated;
  }

  List<Todo> get data => List.unmodifiable(_repository);

  int get lastCreatedId => _lastIdCreated;
}
