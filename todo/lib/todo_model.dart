class Todo {
  final int _id;
  final String _title;
  late String _status;
  late String _createdAt;

  Todo({
    required this._id,
    required this._title,
    String? status,
    String? createdAt,
  }) {
    _status = status ?? "Pending";
    _createdAt = createdAt ?? DateTime.now().toIso8601String();
  }

  dynamic toJSON() {
    return {
      "id": _id,
      "title": _title,
      "status": _status,
      "createdAt": _createdAt,
    };
  }

  void done() {
    _status = "PRONTO";
  }

  int get id => _id;
}
