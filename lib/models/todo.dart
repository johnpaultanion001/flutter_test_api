import 'dart:convert';

List<Todo> todoFromJson(String str) =>
    List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

String todoToJson(List<Todo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Todo {
  DateTime? createdAt;
  DateTime? updatedAt;
  int? id;
  String? user;
  String? value;
  String? status;

  Todo({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.user,
    this.value,
    this.status,
  });

  Todo.fromJson(Map<String, dynamic> json) {
    createdAt = DateTime.parse(json["created_at"] as String);
    updatedAt = DateTime.parse(json["updated_at"] as String);
    id = json["id"] as int;
    user = json["user"] as String;
    value = json["value"] as String;
    status = json["status"] as String;
  }

  Map<String, dynamic> toJson() => {
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "id": id,
        "user": user,
        "value": value,
        "status": status,
      };
}
