// ignore_for_file: file_names

import 'dart:convert';

class Secteur {
  int id;
  String name;

  static const String model = 'a.sise.secteur';
  static const List<String> fields = ['id', '__last_update', 'name'];

  Secteur({required this.id, required this.name});

  Secteur.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  static fromJsonArray(List json) {
    return json.map((e) => Secteur.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
