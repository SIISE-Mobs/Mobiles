// ignore_for_file: unused_import, depend_on_referenced_packages, prefer_const_declarations, avoid_print, unused_local_variable, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:sise/constants.dart';
import 'package:sise/controllers/SynchronizeController.dart';
import 'package:sise/helpers/Odoo_Helper.dart';
import 'package:sise/models/Communes.dart';
import 'package:sise/models/Infrastructures.dart';
import 'package:sise/models/Regions.dart';
import 'package:sise/models/Secteurs.dart';
import 'package:sise/models/SousProjet.dart';
import 'package:sise/models/SuiviBe.dart';
import 'package:sise/models/SuiviEse.dart';
import 'package:sise/models/SuiviPositionnement.dart';
import 'package:sise/models/SuiviTravaux.dart';
import 'package:sise/screens/public/Main.dart';
import 'package:sise/services/Odoo_Services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final String regionsTable = 'regions';
final String districtsTable = 'districts';
final String communesTable = 'communes';
final String sousprojetsTable = 'sous_projets';
final String infrastructureTable = 'infrastructures';
final String secteurTable = 'secteurs';
final String suivibeTable = 'suivi_be';
final String suivientrepriseTable = 'suivi_entreprise';
final String suivisousprojetTable = 'suivi_sous_projet';
final String sisepositionnementTable = 'sise_positionnement';

class DatabaseHelper {
  static final _databaseName = "asset/dbs/sisedb.db";
  static final _databaseVersion = 2;
  static final DatabaseHelper instance = DatabaseHelper._init();

  final _storage = const FlutterSecureStorage();

  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB();
    return _database!;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $regionsTable (
            id INTEGER PRIMARY KEY,
            name TEXT,
            code TEXT
          )
        ''');
    await db.execute('''
          CREATE TABLE $districtsTable (
            id INTEGER PRIMARY KEY,
            name TEXT,
            code TEXT,
            id_region INTEGER,
            FOREIGN KEY (id_region) REFERENCES $regionsTable(id)
          )
        ''');
    await db.execute('''
          CREATE TABLE $communesTable (
            id INTEGER PRIMARY KEY,
            name TEXT,
            code TEXT,
            password TEXT,
            id_district INTEGER,
            FOREIGN KEY (id_district) REFERENCES $districtsTable(id)
          )
        ''');
    await db.execute('''
          CREATE TABLE $infrastructureTable (
            id INTEGER PRIMARY KEY,
            name TEXT)
        ''');
    await db.execute('''
          CREATE TABLE $secteurTable (
            id INTEGER PRIMARY KEY,
            name TEXT)
        ''');
    await db.execute('''
          CREATE TABLE $sousprojetsTable (
            id INTEGER PRIMARY KEY,
            name TEXT,
            id_commune INTEGER,
            id_district INTEGER,
            id_region INTEGER,
            fokontany TEXT,
            type_travaux TEXT,
            id_infrastructure INTEGER,
            id_secteur INTEGER,
            categorie TEXT,
            composante TEXT,
            montant_prev NUMERIC,
            date_convention TEXT,
            date_virement TEXT,
            geolocalisation TEXT,
            numero_conv TEXT,
            suivi_commune TEXT,
            ami_date TEXT,
            ami_photo TEXT,
            be_date TEXT,
            be_photo TEXT,
            osbe_date TEXT,
            osbe_photo TEXT,
            nom_be TEXT,
            montant_becontrat TEXT,
            retenue TEXT,
            fes_date TEXT,
            fes_faisabilite TEXT,
            aps_date TEXT,
            aps_photo TEXT,
            apd_date TEXT,
            apd_photo TEXT,
            dao_date TEXT,
            dao_photo TEXT,
            lao_date TEXT,
            lao_photo TEXT,
            nom_entreprise TEXT,
            montant_entcontrat TEXT,
            ce_date TEXT,
            ce_photo TEXT,
            ose_date TEXT,
            ose_photo TEXT,
            dem_date TEXT,
            dem_date_prev TEXT,
            dem_photo TEXT,
            duree_travaux TEXT,
            recep_date TEXT,
            recep_prov_date TEXT,
            recep_date_prev TEXT,
            recep_prov_date_prev TEXT,
            recepdef_date_prev TEXT,
            recepdef_date TEXT,
            longitude TEXT,
            latitude TEXT,
            cpgu TEXT,
            situation TEXT,
            prochaine TEXT,
            FOREIGN KEY (id_commune) REFERENCES $communesTable(id),
            FOREIGN KEY (id_district) REFERENCES $districtsTable(id),
            FOREIGN KEY (id_region) REFERENCES $regionsTable(id),
            FOREIGN KEY (id_infrastructure) REFERENCES $infrastructureTable(id),
            FOREIGN KEY (id_secteur) REFERENCES $secteurTable(id)
          )
        ''');
    await db.execute('''
          CREATE TABLE $suivibeTable (
            id INTEGER PRIMARY KEY,
            name TEXT,
            montant TEXT,
            date_suivi TEXT,
            id_sousprojet INTEGER,
            libelle_be TEXT,
            photo TEXT,
            envoi INTEGER,
            FOREIGN KEY (id_sousprojet) REFERENCES $sousprojetsTable(id)
          )
        ''');
    await db.execute('''
          CREATE TABLE $suivientrepriseTable (
            id INTEGER PRIMARY KEY,
            name TEXT,
            montant TEXT,
            date_suivi TEXT,
            id_sousprojet INTEGER,
            libelle_ent TEXT,
            photo TEXT,
            envoi INTEGER,
            FOREIGN KEY (id_sousprojet) REFERENCES $sousprojetsTable(id)
          )
        ''');
    await db.execute('''
          CREATE TABLE $suivisousprojetTable (
            id INTEGER PRIMARY KEY,
            name TEXT,
            date_suivi TEXT,
            id_sousprojet INTEGER,
            libelle_projet TEXT,
            prctg TEXT,
            photo TEXT,
            envoi INTEGER,
            FOREIGN KEY (id_sousprojet) REFERENCES $sousprojetsTable(id)
          )
        ''');
    await db.execute('''
          CREATE TABLE $sisepositionnementTable (
            id INTEGER PRIMARY KEY,
            name TEXT,
            date_position TEXT,
            id_sousprojet INTEGER,
            montant TEXT,
            photo TEXT,
            envoi INTEGER,
            FOREIGN KEY (id_sousprojet) REFERENCES $sousprojetsTable(id)
          )
        ''');
  }

  _initDB() async {
    print('==== INIT DB ====');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    print('==== DB : ==== $path');
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<int> synchroniseData() async {
    bool connected = await SynchronizeController().checkInternetConnectivity();
    if (!connected) {
      return 0;
    }
    Database db = await instance.database;
    var oService = OdooServices.instance;

    List<Map> regions = await db.rawQuery('SELECT * FROM $regionsTable');
    List<Map> districts = await db.rawQuery('SELECT * FROM $districtsTable');
    List<Map> communes = await db.rawQuery('SELECT * FROM $communesTable');
    List<Map> secteurs = await db.rawQuery('SELECT * FROM $secteurTable');
    List<Map> infras = await db.rawQuery('SELECT * FROM $infrastructureTable');

    // if (secteurs.isEmpty) {
    var secteursOdoo = await oService.getSecteursList();
    for (int i = 0; i < secteursOdoo.length; i++) {
      var data = secteursOdoo[i].toJson();
      String idSecteur = data['id'].toString();
      List<Map> secteurLocal =
          await db.rawQuery("SELECT * FROM $secteurTable WHERE id=$idSecteur");
      if (secteurLocal.isEmpty) {
        int intIdSecteur =
            await db.insert(secteurTable, secteursOdoo[i].toJson());
      } else {
        /** TEST IF EXIST PASS IF NOT INSERT **/
        Secteur secteur = secteursOdoo[i];
        var existSecteur =
            await DatabaseHelper.instance.getSecteurExist(secteur.name);
        if (!existSecteur) {
          await db.insert(secteurTable, secteursOdoo[i].toJson());
        }
      }
    }
    // }

    // if (infras.isEmpty) {
    var infrasOdoo = await oService.getInfrastructuresList();
    for (int i = 0; i < infrasOdoo.length; i++) {
      var d = infrasOdoo[i].toJson();
      String idInfra = d['id'].toString();
      List<Map> infraLocal = await db
          .rawQuery("SELECT * FROM $infrastructureTable WHERE id=$idInfra");
      if (infraLocal.isEmpty) {
        int intIdInfra =
            await db.insert(infrastructureTable, infrasOdoo[i].toJson());
      } else {
        /** TEST IF EXIST PASS IF NOT INSERT **/
        Infrastructure infra = infrasOdoo[i];
        var existInfra =
            await DatabaseHelper.instance.getInfraExist(infra.name);
        if (!existInfra) {
          await db.insert(infrastructureTable, infrasOdoo[i].toJson());
        }
      }
    }
    // }

    if (regions.isEmpty) {
      var regions = await oService.getRegionsList();
      for (int i = 0; i < regions.length; i++) {
        int intIdRegion = await db.insert(regionsTable, regions[i].toJson());
      }
    }

    if (districts.isEmpty) {
      var districts = await oService.getDistrictsList();
      for (int i = 0; i < districts.length; i++) {
        int intIdDistrict =
            await db.insert(districtsTable, districts[i].toJson());
      }
    }

    if (communes.isEmpty) {
      var communes = await oService.getCommunesList();
      for (int i = 0; i < communes.length; i++) {
        int intIdcommune = await db.insert(communesTable, communes[i].toJson());
      }
    } else {
      var communes = await oService.getCommunesList();
      for (int i = 0; i < communes.length; i++) {
        Commune commune = communes[i];
        var existCommune =
            await DatabaseHelper.instance.getCommuneExist(commune.code);
        if (existCommune) {
          await DatabaseHelper.instance
              .updateCommuneOdoo(commune.code, commune.password);
        } else {
          await db.insert(communesTable, communes[i].toJson());
        }
      }
    }
    return communes.length;
  }

  Future<bool> getInfraExist(name) async {
    Database db = await instance.database;
    final result = await db.query(
      '$infrastructureTable',
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [name],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<bool> getSecteurExist(name) async {
    Database db = await instance.database;
    final result = await db.query(
      '$secteurTable',
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [name],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<bool> updateCommuneOdoo(String? code, String? password) async {
    Database db = await instance.database;
    if (code != null && password != null) {
      await db.update(
        '$communesTable',
        {'password': password},
        where: "code = ?",
        whereArgs: [code],
      );
    }
    return true;
  }

  Future<bool> getCommuneExist(code) async {
    Database db = await instance.database;
    final result = await db.query(
      '$communesTable',
      columns: ['id'],
      where: 'code = ?',
      whereArgs: [code],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<bool> synchroniseSps(String sp) async {
    Database db = await instance.database;
    var dataSp = SousProjet.fromJsonLocal(jsonDecode(sp));
    int intIdSp = await db.insert(sousprojetsTable, dataSp.toJsonSqlite());
    return true;
  }

  Future<bool> authenticate(String code) async {
    var codeSplit = code.split("-");
    if (codeSplit.isEmpty || codeSplit.length <= 1) {
      return false;
    }
    try {
      Database db = await instance.database;
      String cc = codeSplit[0].toString().toUpperCase();
      String cp = codeSplit[1].toString().toUpperCase();
      List<Map<String, dynamic>> commune = await db.rawQuery(
          "SELECT * FROM $communesTable WHERE code='$cc' AND password='$cp'");
      print(commune);
      if (commune.isNotEmpty) {
        var dataCommune = Commune.fromMap(commune.first);
        await _storage.write(key: "commune", value: dataCommune.toString());
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<List<SousProjet>> getSousProjets(idCommune) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> sps =
        await db.rawQuery("""SELECT sous_projets.id, sous_projets.name as name, 
        sous_projets.fokontany as fokontany, communes.id as id_commune, communes.name as commune, 
        districts.id as id_district, districts.name as district, 
        regions.id as id_region, regions.name as region, 
        infrastructures.id as id_infrastructure, infrastructures.name as infrastructure,
        secteurs.id as id_secteur, secteurs.name as secteur, 
        sous_projets.type_travaux, sous_projets.categorie, sous_projets.montant_prev, 
        sous_projets.date_convention, sous_projets.date_virement, sous_projets.geolocalisation, 
        sous_projets.numero_conv, sous_projets.suivi_commune, sous_projets.ami_date, 
        sous_projets.ami_photo, sous_projets.be_date, sous_projets.be_photo, 
        sous_projets.osbe_date, sous_projets.osbe_photo, sous_projets.nom_be, 
        sous_projets.montant_becontrat, sous_projets.fes_date, 
        sous_projets.fes_faisabilite, sous_projets.aps_date, 
        sous_projets.aps_photo, sous_projets.apd_date, sous_projets.apd_photo, 
        sous_projets.dao_date, sous_projets.dao_photo, sous_projets.lao_date, 
        sous_projets.lao_photo, sous_projets.nom_entreprise, sous_projets.montant_entcontrat, 
        sous_projets.ce_date, sous_projets.ce_photo, sous_projets.ose_date, 
        sous_projets.ose_photo, sous_projets.dem_date, sous_projets.dem_date_prev, 
        sous_projets.dem_photo, sous_projets.recep_date, sous_projets.recep_prov_date, 
        sous_projets.recep_date_prev, sous_projets.recep_prov_date_prev, 
        sous_projets.recepdef_date_prev, sous_projets.recepdef_date, 
        sous_projets.cpgu, sous_projets.situation, sous_projets.prochaine
        FROM sous_projets 
        LEFT JOIN communes ON sous_projets.id_commune = communes.id 
        LEFT JOIN districts ON sous_projets.id_district = districts.id 
        LEFT JOIN regions ON sous_projets.id_region = regions.id 
        LEFT JOIN infrastructures ON sous_projets.id_infrastructure = infrastructures.id
        LEFT JOIN secteurs ON sous_projets.id_secteur = secteurs.id
        WHERE sous_projets.id_commune = $idCommune""");

    return List.generate(
      sps.length,
      (i) => SousProjet.fromMapDatabase(sps[i]),
    );
  }

  Future<bool> getSousProjetExist(idSp) async {
    Database db = await instance.database;
    final result = await db.query(
      '$sousprojetsTable',
      columns: ['id'],
      where: 'id = ?',
      whereArgs: [idSp],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<SousProjet> getDetailsSousProjet(idSp) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> sps =
        await db.rawQuery("""SELECT sous_projets.id, sous_projets.name as name, 
        sous_projets.fokontany as fokontany, communes.id as id_commune, communes.name as commune, 
        districts.id as id_district, districts.name as district, 
        regions.id as id_region, regions.name as region, 
        infrastructures.id as id_infrastructure, infrastructures.name as infrastructure,
        secteurs.id as id_secteur, secteurs.name as secteur, 
        sous_projets.type_travaux, sous_projets.categorie, sous_projets.montant_prev, 
        sous_projets.date_convention, sous_projets.date_virement, sous_projets.geolocalisation, 
        sous_projets.numero_conv, sous_projets.suivi_commune, sous_projets.ami_date, 
        sous_projets.ami_photo, sous_projets.be_date, sous_projets.be_photo, 
        sous_projets.osbe_date, sous_projets.osbe_photo, sous_projets.nom_be, 
        sous_projets.montant_becontrat, sous_projets.retenue, sous_projets.fes_date, 
        sous_projets.fes_faisabilite, sous_projets.aps_date, 
        sous_projets.aps_photo, sous_projets.apd_date, sous_projets.apd_photo, 
        sous_projets.dao_date, sous_projets.dao_photo, sous_projets.lao_date, 
        sous_projets.lao_photo, sous_projets.nom_entreprise, sous_projets.montant_entcontrat, 
        sous_projets.ce_date, sous_projets.ce_photo, sous_projets.ose_date, 
        sous_projets.ose_photo, sous_projets.dem_date, sous_projets.dem_date_prev, 
        sous_projets.dem_photo, sous_projets.duree_travaux, sous_projets.recep_date, sous_projets.recep_prov_date, 
        sous_projets.recep_date_prev, sous_projets.recep_prov_date_prev, 
        sous_projets.recepdef_date_prev, sous_projets.recepdef_date, sous_projets.longitude, sous_projets.latitude,
        sous_projets.cpgu, sous_projets.situation, sous_projets.prochaine
        FROM sous_projets 
        LEFT JOIN communes ON sous_projets.id_commune = communes.id 
        LEFT JOIN districts ON sous_projets.id_district = districts.id 
        LEFT JOIN regions ON sous_projets.id_region = regions.id 
        LEFT JOIN infrastructures ON sous_projets.id_infrastructure = infrastructures.id
        LEFT JOIN secteurs ON sous_projets.id_secteur = secteurs.id
        WHERE sous_projets.id = $idSp""");

    return SousProjet.fromMapDatabase(sps.first);
  }

  Future<Map<String, dynamic>> getSousProjectDetails(int idSp) async {
    Database db = await instance.database;
    final spDetails =
        await db.rawQuery("""SELECT sous_projets.id, sous_projets.name as name, 
        sous_projets.fokontany as fokontany, communes.id as id_commune, communes.name as commune, 
        districts.id as id_district, districts.name as district, 
        regions.id as id_region, regions.name as region 
        FROM sous_projets LEFT JOIN communes 
        ON sous_projets.id_commune = communes.id 
        LEFT JOIN districts ON sous_projets.id_district = districts.id 
        LEFT JOIN regions ON sous_projets.id_region = regions.id 
        WHERE sous_projets.id = $idSp""");
    return spDetails.first;
  }

  Future<void> updateFesSousProjets(
      int spId, String? fesDate, String? fesFaisabiliteValue) async {
    Database db = await instance.database;
    if (fesDate != '' && fesDate!.isNotEmpty) {
      await db.update(
        '$sousprojetsTable',
        {
          'fes_date': fesDate,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (fesFaisabiliteValue != '' && fesFaisabiliteValue != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'fes_faisabilite': fesFaisabiliteValue,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }
  }

  Future<void> updateReceptionSousProjets(
      int spId,
      String? recepDatePrev,
      String? recepDate,
      String? recepProvDatePrev,
      String? recepProvDate,
      String? recepPrevDefDate,
      String? recepReelleDefDate,
      String? longitude,
      String? latitude,
      String? cpguValue) async {
    Database db = await instance.database;

    if (longitude != '' && longitude != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'longitude': longitude,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (latitude != '' && latitude != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'latitude': latitude,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (recepPrevDefDate != '' && recepPrevDefDate != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'recepdef_date_prev': recepPrevDefDate,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (recepReelleDefDate != '' && recepReelleDefDate != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'recepdef_date': recepReelleDefDate,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (recepDatePrev != '' && recepDatePrev != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'recep_date_prev': recepDatePrev,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (recepDate != '' && recepDate != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'recep_date': recepDate,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (recepProvDatePrev != '' && recepProvDatePrev != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'recep_prov_date_prev': recepProvDatePrev,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (recepProvDate != '' && recepProvDate != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'recep_prov_date': recepProvDate,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (cpguValue != '' && cpguValue != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'cpgu': cpguValue,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }
  }

  Future<void> updateBeSousProjets(
      int spId,
      String? amiDate,
      String? amiPhotoData,
      String? beDate,
      String? bePhotoData,
      String? notifDAte,
      String? notifPhotoData,
      String? nomBe,
      String? montantBe,
      String? retenue) async {
    Database db = await instance.database;

    if (retenue != '' && retenue != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'retenue': retenue,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (amiDate != '' && amiDate!.isNotEmpty) {
      await db.update(
        '$sousprojetsTable',
        {
          'ami_date': amiDate,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (amiPhotoData != '' && amiPhotoData != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'ami_photo': amiPhotoData,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (beDate != '' && beDate!.isNotEmpty) {
      await db.update(
        '$sousprojetsTable',
        {
          'be_date': beDate,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (bePhotoData != '' && bePhotoData != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'be_photo': bePhotoData,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (notifDAte != '' && notifDAte!.isNotEmpty) {
      await db.update(
        '$sousprojetsTable',
        {
          'osbe_date': notifDAte,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (notifPhotoData != '' && notifPhotoData != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'osbe_photo': notifPhotoData,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (nomBe != '' && nomBe!.isNotEmpty) {
      await db.update(
        '$sousprojetsTable',
        {
          'nom_be': nomBe,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (montantBe != '' && montantBe!.isNotEmpty) {
      await db.update(
        '$sousprojetsTable',
        {
          'montant_becontrat': montantBe.toString(),
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }
  }

  Future<void> updateDossierSousProjets(
      int spId,
      String? apsDate,
      String? apsPhotoData,
      String? apdDate,
      String? apdPhotoData,
      String? daoDate,
      String? daoPhotoData,
      String? laoDate,
      String? laoPhotoData) async {
    Database db = await instance.database;

    if (apsDate != '' && apsDate!.isNotEmpty) {
      await db.update(
        '$sousprojetsTable',
        {
          'aps_date': apsDate,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (apsPhotoData != '' && apsPhotoData != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'aps_photo': apsPhotoData,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (laoDate != '' && laoDate!.isNotEmpty) {
      await db.update(
        '$sousprojetsTable',
        {
          'lao_date': laoDate,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (laoPhotoData != '' && laoPhotoData != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'lao_photo': laoPhotoData,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (daoDate != '' && daoDate!.isNotEmpty) {
      await db.update(
        '$sousprojetsTable',
        {
          'dao_date': daoDate,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (daoPhotoData != '' && daoPhotoData != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'dao_photo': daoPhotoData,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (apdDate != '' && apdDate!.isNotEmpty) {
      await db.update(
        '$sousprojetsTable',
        {
          'apd_date': apdDate,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (apdPhotoData != '' && apdPhotoData != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'apd_photo': apdPhotoData,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }
  }

  Future<void> updateEseSousProjets(
      int spId,
      String? nomEntrepriseController,
      String? montantContratEntreprise,
      String? ceDate,
      String? cePhotoData,
      String? oseDate,
      String? osePhotoData,
      String? demDatePrev,
      String? demDate,
      String? demPhotoData,
      String? dureeTravaux) async {
    Database db = await instance.database;

    if (nomEntrepriseController != '' && nomEntrepriseController != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'nom_entreprise': nomEntrepriseController,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (dureeTravaux != '' && dureeTravaux != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'duree_travaux': dureeTravaux,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (montantContratEntreprise != '' && montantContratEntreprise != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'montant_entcontrat': montantContratEntreprise,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (ceDate != '' && ceDate != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'ce_date': ceDate,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (cePhotoData != '' && cePhotoData != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'ce_photo': cePhotoData,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (oseDate != '' && oseDate != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'ose_date': oseDate,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (osePhotoData != '' && osePhotoData != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'ose_photo': osePhotoData,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (demDate != '' && demDate != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'dem_date': demDate,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (demPhotoData != '' && demPhotoData != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'dem_photo': demPhotoData,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }

    if (demDatePrev != '' && demDatePrev != null) {
      await db.update(
        '$sousprojetsTable',
        {
          'dem_date_prev': demDatePrev,
        },
        where: "id = ?",
        whereArgs: [spId],
      );
    }
  }

  Future<int> insertSuiviEse(
    idsp,
    String? libelleEse,
    String? montant,
    String? dateSuivi,
    String? photo,
  ) async {
    Database db = await instance.database;
    var row = {
      'id_sousprojet': idsp,
      'name': '$dateSuivi - $montant',
      'libelle_ent': libelleEse,
      'montant': montant.toString(),
      'date_suivi': dateSuivi,
      'photo': photo
    };
    return await db.insert('$suivientrepriseTable', row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> insertSuiviBe(
    idsp,
    String? libelleBe,
    String? montant,
    String? dateSuivi,
    String? photo,
  ) async {
    Database db = await instance.database;
    var row = {
      'id_sousprojet': idsp,
      'name': '$dateSuivi - $montant',
      'libelle_be': libelleBe,
      'montant': montant.toString(),
      'date_suivi': dateSuivi,
      'photo': photo
    };
    return await db.insert('$suivibeTable', row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> insertSuiviTravaux(
    idsp,
    String? libelleProjet,
    String? prctg,
    String? dateSuivi,
    String? photo,
  ) async {
    Database db = await instance.database;
    var row = {
      'id_sousprojet': idsp,
      'name': '$dateSuivi - $prctg',
      'libelle_projet': libelleProjet,
      'prctg': prctg.toString(),
      'date_suivi': dateSuivi,
      'photo': photo
    };
    return await db.insert('$suivisousprojetTable', row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SuviBeData>> getAllSuivisBeSousProjet(int spId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> suiviBe = await db
        .rawQuery("SELECT * FROM '$suivibeTable' WHERE id_sousprojet=$spId");
    // List<Map<String, dynamic>> suiviBe = await db.rawQuery(
    //     "SELECT * FROM '$suivibeTable' WHERE id_sousprojet=$spId AND (envoi IS NULL OR envoi != 200)");
    return List.generate(
      suiviBe.length,
      (i) => SuviBeData.fromMap(suiviBe[i]),
    );
  }

  Future<List<SuviEseData>> getAllSuivisEseSousProjet(int spId) async {
    Database db = await instance.database;
    // List<Map<String, dynamic>> suiviBe = await db.rawQuery(
    //     "SELECT * FROM '$suivientrepriseTable' WHERE id_sousprojet=$spId AND (envoi IS NULL OR envoi != 200)");
    List<Map<String, dynamic>> suiviBe = await db.rawQuery(
        "SELECT * FROM '$suivientrepriseTable' WHERE id_sousprojet=$spId");
    return List.generate(
      suiviBe.length,
      (i) => SuviEseData.fromMap(suiviBe[i]),
    );
  }

  Future<List<SuviTravauxData>> getAllSuivisTravauxSousProjet(int spId) async {
    Database db = await instance.database;
    // List<Map<String, dynamic>> suiviBe = await db.rawQuery(
    //     "SELECT * FROM '$suivisousprojetTable' WHERE id_sousprojet=$spId AND (envoi IS NULL OR envoi != 200)");
    List<Map<String, dynamic>> suiviBe = await db.rawQuery(
        "SELECT * FROM '$suivisousprojetTable' WHERE id_sousprojet=$spId");
    return List.generate(
      suiviBe.length,
      (i) => SuviTravauxData.fromMap(suiviBe[i]),
    );
  }

  Future<List<SuviPositionnementData>> getAllSuivisPositionSousProjet(
      int spId) async {
    Database db = await instance.database;
    // List<Map<String, dynamic>> suiviPos = await db.rawQuery(
    //     "SELECT * FROM '$sisepositionnementTable' WHERE id_sousprojet=$spId AND (envoi IS NULL OR envoi != 200)");
    List<Map<String, dynamic>> suiviPos = await db.rawQuery(
        "SELECT * FROM '$sisepositionnementTable' WHERE id_sousprojet=$spId");
    return List.generate(
      suiviPos.length,
      (i) => SuviPositionnementData.fromMap(suiviPos[i]),
    );
  }

  Future<int> deleteSuiviBe(int id) async {
    Database db = await instance.database;
    return await db.delete('$suivibeTable', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteSuiviEse(int id) async {
    Database db = await instance.database;
    return await db
        .delete('$suivientrepriseTable', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteSuiviTravaux(int id) async {
    Database db = await instance.database;
    return await db
        .delete('$suivisousprojetTable', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> updateSousProjetOdoo(int id, SousProjet spCommuneData) async {
    Database db = await instance.database;
    await db.update(
      '$sousprojetsTable',
      {
        'id_infrastructure': spCommuneData.id_infrastructure,
        'id_secteur': spCommuneData.id_secteur,
        'categorie': spCommuneData.categorie,
        'fokontany': spCommuneData.fokontany,
        'composante': spCommuneData.composante,
        'type_travaux': spCommuneData.type_travaux,
        'montant_prev': spCommuneData.montant_prev,
        'date_convention': spCommuneData.date_convention,
        'date_virement': spCommuneData.date_virement,
        'numero_conv': spCommuneData.numero_conv
      },
      where: "id = ?",
      whereArgs: [id],
    );
    return true;
  }

  Future<int> insertSuiviPositionnement(int spId, String? montant,
      String? datePos, String? suiviPositionPhotoData) async {
    Database db = await instance.database;
    var row = {
      'id_sousprojet': spId,
      'name': '$datePos - $montant',
      'montant': montant.toString(),
      'date_position': datePos,
      'photo': suiviPositionPhotoData
    };
    return await db.insert('$sisepositionnementTable', row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> updateEnvoiSqlite(int suiviId, String? tableSuivi) async {
    Database db = await instance.database;
    if (suiviId != 0 && tableSuivi != '') {
      await db.update(
        tableSuivi!,
        {'envoi': 200},
        where: "id = ?",
        whereArgs: [suiviId],
      );
    }
    return true;
  }
}
