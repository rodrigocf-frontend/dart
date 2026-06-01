import 'package:intl/intl.dart';

enum TodoStatus { pending, done }

class Todo {
  final int _id;
  final String _title;
  TodoStatus _status;
  final String _createdAt;

  Todo({
    required this._id,
    required this._title,
    TodoStatus? status,
    String? createdAt,
  }) : _status = status ?? TodoStatus.pending,
       _createdAt =
           createdAt ?? DateFormat("dd-MM-yyyy").format(DateTime.now());

  static Todo fromJSON(Map<String, dynamic> data) {
    final status = TodoStatus.values.byName(data['status']);

    return Todo(
      id: data['id'],
      title: data['title'],
      status: status,
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": _id,
      "title": _title,
      "status": _status.name,
      "createdAt": _createdAt,
    };
  }

  void done() {
    _status = TodoStatus.done;
  }

  int get id => _id;

  TodoStatus get status => _status;

  void log() {
    print(
      "[@ID]:$_id  [@TITLE]:$_title [@STATUS]:${_status.name} [@DATE]:$_createdAt",
    );
  }
}
