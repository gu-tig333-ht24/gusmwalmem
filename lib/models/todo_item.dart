
List<TodoItem> fromListJson(List json) {
  return json.map((item) => TodoItem.fromJson(item)).toList();
}

class TodoItem {
  final String id;
  final String title;
  final bool done;

  const TodoItem({
    required this.id,
    required this.title,
    required this.done,
  });

  const TodoItem.undone({required this.id, required this.title}) : done = false;

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'title': String title,
        'done': bool done,
      } =>
        TodoItem(
          id: id,
          title: title,
          done: done,
        ),
      _ => throw const FormatException('Failed to load todo item.'),
    };
  }
}
