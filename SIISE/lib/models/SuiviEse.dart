// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:convert';

class SuviEseData {
  int id;
  int id_sousprojet;
  String name;
  String? libelle_ent;
  String montant;
  String date_suivi;
  String? photo;
  int? envoi;

  SuviEseData(
      {required this.id,
      required this.id_sousprojet,
      required this.name,
      this.libelle_ent,
      required this.montant,
      required this.date_suivi,
      this.photo,
      this.envoi});

  SuviEseData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        id_sousprojet = json['id_sousprojet'],
        libelle_ent = json['libelle_ent'],
        montant = json['montant'],
        date_suivi = json['date_suivi'],
        envoi = json['envoi'],
        photo = json['photo'];

  static fromJsonArray(List json) {
    return json.map((e) => SuviEseData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_sousprojet': id_sousprojet,
      'libelle_ent': libelle_ent,
      'name': name,
      'montant': montant,
      'date_suivi': date_suivi,
      'envoi': envoi,
      'photo': photo,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory SuviEseData.fromMap(Map<String, dynamic> data) => SuviEseData(
      id: data['id'],
      name: data['name'],
      libelle_ent: data['libelle_ent'],
      montant: data['montant'],
      date_suivi: data['date_suivi'],
      photo: data['photo'],
      envoi: data['envoi'],
      id_sousprojet: data['id_sousprojet']);
}
