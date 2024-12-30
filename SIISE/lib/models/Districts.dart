// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:convert';

class District {
  int id;
  String name;
  String? code;
  int id_region;

  static const String model = 'a.sise.districts';
  static const List<String> fields = [
    'id',
    '__last_update',
    'name',
    'code',
    'id_region'
  ];

  District(
      {required this.id,
      required this.name,
      this.code,
      required this.id_region});

  District.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        code = json['code'],
        id_region = json['id_region'][0];

  static fromJsonArray(List json) {
    return json.map((e) => District.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'id_region': id_region,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
