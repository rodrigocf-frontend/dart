import 'package:test/test.dart';
import 'package:todo/models/todo_model.dart';

void main() {
  group('Running test Todo Model', () {
    test("Test Todo Model ID", () {
      final Todo todo = Todo(
        id: 1,
        title: "[title]",
        status: TodoStatus.pending,
        createdAt: "31-05-2026",
      );

      expect(todo.id, equals(1));
    });

    test("Test Todo Model Status", () {
      final Todo todo = Todo(
        id: 1,
        title: "[title]",
        status: TodoStatus.pending,
        createdAt: "31-05-2026",
      );

      expect(todo.status, TodoStatus.pending);
    });

    test("Test Todo change status", () {
      final Todo todo = Todo(
        id: 1,
        title: "[title]",
        status: TodoStatus.pending,
        createdAt: "31-05-2026",
      );

      todo.done();
      expect(todo.status, TodoStatus.done);
    });

    test("Test pass Todo to JSON", () {
      final Todo todo = Todo(
        id: 1,
        title: "[title]",
        status: TodoStatus.pending,
        createdAt: "31-05-2026",
      );

      final json = todo.toJSON();
      expect(json['id'], equals(1));
      expect(json['title'], equals("[title]"));
      expect(json['status'], equals("pending"));
      expect(json['createdAt'], equals("31-05-2026"));
    });

    test("Test pass JSON to Todo", () {
      final Map<String, dynamic> json = {
        "id": 1,
        "title": "[title]",
        "status": "pending",
        "createdAt": "31-05-2026",
      };

      final Todo todo = Todo.fromJSON(json);
      final jsonFromTodo = todo.toJSON();

      expect(jsonFromTodo['id'], equals(1));
      expect(jsonFromTodo['title'], equals("[title]"));
      expect(jsonFromTodo['status'], equals("pending"));
      expect(jsonFromTodo['createdAt'], equals("31-05-2026"));
    });

    test("Default status when status not informed", () {
      final todo = Todo(id: 1, title: "x");
      expect(todo.status, TodoStatus.pending);
    });

    test("fromJSON com status done", () {
      final json = {
        "id": 1,
        "title": "x",
        "status": "done",
        "createdAt": "31-05-2026",
      };
      final todo = Todo.fromJSON(json);
      expect(todo.status, TodoStatus.done);
    });
  });
}
