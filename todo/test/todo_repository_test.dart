import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/repository/todo_repository.dart';

void main() {
  group('TodoRepository', () {
    late TodoRepository repository;
    late File tempFile;

    setUp(() async {
      tempFile = File('./test/temp_repository_data.json');
      await tempFile.writeAsString(
        jsonEncode({"list": [], "lastIdCreated": 0}),
      );
      repository = await TodoRepository.init(tempFile.path);
    });

    tearDown(() async {
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    });

    group('init', () {
      test('loads existing data from file', () async {
        final existingFile = File('./test/temp_existing_data.json');
        await existingFile.writeAsString(jsonEncode({
          "list": [
            {
              "id": 1,
              "title": "tarefa existente",
              "status": "pending",
              "createdAt": "01-06-2026",
            },
          ],
          "lastIdCreated": 1,
        }));

        final repo = await TodoRepository.init(existingFile.path);
        expect(repo.data.length, equals(1));
        expect(repo.data[0].toJSON()['title'], equals("tarefa existente"));
        expect(repo.lastCreatedId, equals(1));

        await existingFile.delete();
      });

      test('creates file when it does not exist', () async {
        final newFile = File('./test/temp_new_data.json');
        if (await newFile.exists()) await newFile.delete();

        final repo = await TodoRepository.init(newFile.path);
        expect(repo.data.length, equals(0));
        expect(repo.lastCreatedId, equals(0));
        expect(await newFile.exists(), isTrue);

        await newFile.delete();
      });
    });

    group('create', () {
      test('adds a todo to the list', () async {
        final todo = Todo(id: 1, title: 'tarefa');
        await repository.create(todo);
        expect(repository.data.length, equals(1));
      });

      test('persists data to file after create', () async {
        final todo = Todo(id: 1, title: 'tarefa');
        await repository.create(todo);

        final reloaded = await TodoRepository.init(tempFile.path);
        expect(reloaded.data.length, equals(1));
        expect(reloaded.data[0].toJSON()['title'], equals('tarefa'));
      });
    });

    group('delete', () {
      test('removes todo at given index', () async {
        await repository.create(Todo(id: 1, title: 'tarefa'));
        await repository.delete(0);
        expect(repository.data.length, equals(0));
      });

      test('persists data to file after delete', () async {
        await repository.create(Todo(id: 1, title: 'tarefa'));
        await repository.delete(0);

        final reloaded = await TodoRepository.init(tempFile.path);
        expect(reloaded.data.length, equals(0));
      });
    });

    group('update', () {
      test('replaces todo at given index', () async {
        await repository.create(Todo(id: 1, title: 'original'));
        final updated = Todo(id: 1, title: 'atualizado');
        await repository.update(0, updated);
        expect(repository.data[0].toJSON()['title'], equals('atualizado'));
      });

      test('persists data to file after update', () async {
        await repository.create(Todo(id: 1, title: 'original'));
        final updated = Todo(id: 1, title: 'atualizado');
        await repository.update(0, updated);

        final reloaded = await TodoRepository.init(tempFile.path);
        expect(reloaded.data[0].toJSON()['title'], equals('atualizado'));
      });
    });

    group('findIndexById', () {
      test('returns correct index when id exists', () async {
        await repository.create(Todo(id: 1, title: 'primeira'));
        await repository.create(Todo(id: 2, title: 'segunda'));
        expect(repository.findIndexById(2), equals(1));
      });

      test('returns -1 when id does not exist', () {
        expect(repository.findIndexById(99), equals(-1));
      });
    });

    group('updateLastCreatedId', () {
      test('increments and returns new id', () {
        expect(repository.updateLastCreatedId(), equals(1));
        expect(repository.updateLastCreatedId(), equals(2));
      });

      test('lastCreatedId reflects updated value', () {
        repository.updateLastCreatedId();
        expect(repository.lastCreatedId, equals(1));
      });
    });
  });
}
