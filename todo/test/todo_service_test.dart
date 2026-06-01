import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/repository/todo_repository.dart';
import 'package:todo/service/todo_service.dart';

void main() {
  group('TodoService', () {
    late TodoRepository repository;
    late TodoService service;
    late File tempFile;

    setUp(() async {
      tempFile = File('./test/temp_data.json');
      await tempFile.writeAsString(
        jsonEncode({"list": [], "lastIdCreated": 0}),
      );
      repository = await TodoRepository.init(tempFile.path);
      service = TodoService(repository: repository);
    });

    tearDown(() async {
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    });

    test('addTodo adds a todo to the list', () async {
      await service.addTodo(title: 'comprar pão');
      expect(repository.data.length, equals(1));
      expect(repository.data[0].toJSON()['title'], equals('comprar pão'));
    });

    test('addTodo increments id correctly', () async {
      await service.addTodo(title: 'primeira');
      await service.addTodo(title: 'segunda');
      expect(repository.data[0].id, equals(1));
      expect(repository.data[1].id, equals(2));
    });

    test('addTodo sets status as pending', () async {
      await service.addTodo(title: 'tarefa');
      expect(repository.data[0].status, equals(TodoStatus.pending));
    });

    test('removeTodo removes todo by id', () async {
      await service.addTodo(title: 'tarefa');
      await service.removeTodo(id: 1);
      expect(repository.data.length, equals(0));
    });

    test('removeTodo with non-existing id does nothing', () async {
      await service.addTodo(title: 'tarefa');
      await service.removeTodo(id: 99);
      expect(repository.data.length, equals(1));
    });

    test('setTodoDone changes status to done', () async {
      await service.addTodo(title: 'tarefa');
      await service.setTodoDone(id: 1);
      expect(repository.data[0].status, equals(TodoStatus.done));
    });

    test('setTodoDone with non-existing id does nothing', () async {
      await service.addTodo(title: 'tarefa');
      await service.setTodoDone(id: 99);
      expect(repository.data[0].status, equals(TodoStatus.pending));
    });
  });
}
