class Todo {
  static const String TABLE_NAME = 'table_todo';

  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnDescription = 'description';
  static const String columnCreatedAt = 'createdAt';
  static const String columnColor = 'color';
  static const String columnPassword = 'password';

  int id;
  String title;
  String description;
  int createdAt;
  int color;
  String password;

  Todo(
      {this.id,
      this.title,
      this.description,
      this.createdAt,
      this.color,
      this.password});

  factory Todo.fromJson(Map<String, dynamic> json) => new Todo(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      createdAt: json["createdAt"],
      color: json["color"],
      password: json["password"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "createdAt": createdAt,
        "color": color
      };

  factory Todo.fromMap(Map<String, dynamic> json) => new Todo(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      createdAt: json["createdAt"],
      color: json["color"],
      password: json["password"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "createdAt": createdAt,
        "color": color
      };
}
