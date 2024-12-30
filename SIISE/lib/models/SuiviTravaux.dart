// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:convert';

class SuviTravauxData {
  int id;
  int id_sousprojet;
  String name;
  String? libelle_projet;
  String prctg;
  String date_suivi;
  String? photo;
  int? envoi;

  SuviTravauxData(
      {required this.id,
      required this.id_sousprojet,
      required this.name,
      this.libelle_projet,
      required this.prctg,
      required this.date_suivi,
      this.photo,
      this.envoi});

  SuviTravauxData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        id_sousprojet = json['id_sousprojet'],
        libelle_projet = json['libelle_projet'],
        prctg = json['prctg'],
        date_suivi = json['date_suivi'],
        envoi = json['envoi'],
        photo = json['photo'];

  static fromJsonArray(List json) {
    return json.map((e) => SuviTravauxData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_sousprojet': id_sousprojet,
      'libelle_projet': libelle_projet,
      'name': name,
      'prctg': prctg,
      'date_suivi': date_suivi,
      'envoi': envoi,
      'photo': photo,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory SuviTravauxData.fromMap(Map<String, dynamic> data) => SuviTravauxData(
      id: data['id'],
      name: data['name'],
      libelle_projet: data['libelle_projet'],
      prctg: data['prctg'],
      date_suivi: data['date_suivi'],
      photo: data['photo'],
      envoi: data['envoi'],
      id_sousprojet: data['id_sousprojet']);
}
