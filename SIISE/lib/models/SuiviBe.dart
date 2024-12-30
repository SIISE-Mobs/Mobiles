// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:convert';

class SuviBeData {
  int id;
  int id_sousprojet;
  String name;
  String? libelle_be;
  String montant;
  String date_suivi;
  String? photo;
  int? envoi;

  SuviBeData(
      {required this.id,
      required this.id_sousprojet,
      required this.name,
      this.libelle_be,
      required this.montant,
      required this.date_suivi,
      this.photo,
      this.envoi});

  SuviBeData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        id_sousprojet = json['id_sousprojet'],
        libelle_be = json['libelle_be'],
        montant = json['montant'],
        date_suivi = json['date_suivi'],
        photo = json['photo'],
        envoi = json['envoi'];

  static fromJsonArray(List json) {
    return json.map((e) => SuviBeData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_sousprojet': id_sousprojet,
      'libelle_be': libelle_be,
      'name': name,
      'montant': montant,
      'date_suivi': date_suivi,
      'photo': photo,
      'envoi': envoi
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory SuviBeData.fromMap(Map<String, dynamic> data) => SuviBeData(
      id: data['id'],
      name: data['name'],
      libelle_be: data['libelle_be'],
      montant: data['montant'],
      date_suivi: data['date_suivi'],
      photo: data['photo'],
      envoi: data['envoi'],
      id_sousprojet: data['id_sousprojet']);
}
