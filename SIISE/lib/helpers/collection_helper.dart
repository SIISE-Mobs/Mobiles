// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sise/models/Communes.dart';
import 'package:sise/models/SousProjet.dart';
import 'package:sise/models/SuiviBe.dart';
import 'package:sise/models/SuiviEse.dart';
import 'package:sise/models/SuiviPositionnement.dart';
import 'package:sise/models/SuiviTravaux.dart';
import 'package:sise/services/Odoo_Services.dart';
import 'package:sise/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';

abstract class CollectionHelper {
  static const _storage = FlutterSecureStorage();

  static List<SousProjet> spCollection = [];
  static List<SousProjet> spCollectionLocal = [];
  static String spCommune = '';
  static SousProjet? spDetailLocal;
  static List<SuviBeData> sBe = [];
  static List<SuviEseData> sEse = [];
  static List<SuviEseData> sEses = [];
  static List<SuviTravauxData> sTravaux = [];
  static List<SuviTravauxData> sTravauxOdoo = [];
  static List<SuviPositionnementData> sPos = [];
  static List<SuviPositionnementData> sPosOdoo = [];

  static Future<void> loadSousProjets() async {
    var commune = Commune.fromJsonLocal(
        jsonDecode(await _storage.read(key: 'commune') ?? ''));
    spCollection = await DatabaseHelper.instance.getSousProjets(commune.id);
    spCommune = commune.name;
  }

  static Future<void> initiSousProjets() async {
    var commune = Commune.fromJsonLocal(
        jsonDecode(await _storage.read(key: 'commune') ?? ''));

    spCollectionLocal =
        await DatabaseHelper.instance.getSousProjets(commune.id);

    if (spCollectionLocal.isEmpty) {
      var spCollectionOdoo =
          await OdooServices.instance.getSousProjetsList(commune.id);
      for (int i = 0; i < spCollectionOdoo.length; i++) {
        await DatabaseHelper.instance
            .synchroniseSps(spCollectionOdoo[i].toString());
      }
    } else {
      var spCollectionOdoo =
          await OdooServices.instance.getSousProjetsList(commune.id);
      for (int i = 0; i < spCollectionOdoo.length; i++) {
        var spCommuneData = SousProjet.fromJsonLocal(
            jsonDecode(spCollectionOdoo[i].toString()));
        var existSp =
            await DatabaseHelper.instance.getSousProjetExist(spCommuneData.id);
        if (existSp) {
          await DatabaseHelper.instance
              .updateSousProjetOdoo(spCommuneData.id, spCommuneData);
        } else {
          await DatabaseHelper.instance
              .synchroniseSps(spCollectionOdoo[i].toString());
        }
      }
    }
    spCollection = await DatabaseHelper.instance.getSousProjets(commune.id);
    spCommune = commune.name;
  }

  static Future<void> loadSousProjetsDetails(int id) async {
    spDetailLocal = await DatabaseHelper.instance.getDetailsSousProjet(id);
  }

  static Future<void> loadSuivisBe(spId) async {
    sBe = await DatabaseHelper.instance.getAllSuivisBeSousProjet(spId);
  }

  static Future<List<SuviBeData>> loadSuivisBeBySpId(spId) async {
    sBe = await DatabaseHelper.instance.getAllSuivisBeSousProjet(spId);
    return sBe;
  }

  static Future<List<SuviEseData>> loadSuivisEseBySpId(spId) async {
    sEses = await DatabaseHelper.instance.getAllSuivisEseSousProjet(spId);
    return sEses;
  }

  static Future<void> loadSuivisEse(int spId) async {
    sEse = await DatabaseHelper.instance.getAllSuivisEseSousProjet(spId);
  }

  static Future<void> loadSuivisTravaux(int spId) async {
    sTravaux =
        await DatabaseHelper.instance.getAllSuivisTravauxSousProjet(spId);
  }

  static Future<List<SuviTravauxData>> loadSuivisTravauxBySpId(int spId) async {
    sTravauxOdoo =
        await DatabaseHelper.instance.getAllSuivisTravauxSousProjet(spId);
    return sTravauxOdoo;
  }

  static Future<void> loadSuivisPositionnement(int spId) async {
    sPos = await DatabaseHelper.instance.getAllSuivisPositionSousProjet(spId);
  }

  static Future<List<SuviPositionnementData>> loadSuivisPositionBySpId(
      int spId) async {
    sPosOdoo =
        await DatabaseHelper.instance.getAllSuivisPositionSousProjet(spId);
    return sPosOdoo;
  }
}
