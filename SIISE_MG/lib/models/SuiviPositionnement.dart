// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:convert';

class SuviPositionnementData {
  int id;
  int id_sousprojet;
  String name;
  String montant;
  String date_position;
  String? photo;
  int? envoi;

  SuviPositionnementData(
      {required this.id,
      required this.id_sousprojet,
      required this.name,
      required this.montant,
      required this.date_position,
      this.photo,
      this.envoi});

  SuviPositionnementData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        id_sousprojet = json['id_sousprojet'],
        montant = json['montant'],
        date_position = json['date_position'],
        envoi = json['envoi'],
        photo = json['photo'];

  static fromJsonArray(List json) {
    return json.map((e) => SuviPositionnementData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_sousprojet': id_sousprojet,
      'name': name,
      'montant': montant,
      'date_position': date_position,
      'envoi': envoi,
      'photo': photo,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory SuviPositionnementData.fromMap(Map<String, dynamic> data) =>
      SuviPositionnementData(
          id: data['id'],
          name: data['name'],
          montant: data['montant'],
          date_position: data['date_position'],
          photo: data['photo'],
          envoi: data['envoi'],
          id_sousprojet: data['id_sousprojet']);
}
