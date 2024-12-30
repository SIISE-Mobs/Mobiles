// ignore_for_file: file_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:sise/constants.dart';
import 'package:sise/helpers/Odoo_Helper.dart';
import 'package:sise/models/Communes.dart';
import 'package:sise/models/Districts.dart';
import 'package:sise/models/Infrastructures.dart';
import 'package:sise/models/Regions.dart';
import 'package:sise/models/Secteurs.dart';
import 'package:sise/models/SousProjet.dart';

class OdooServices {
  static final OdooClient _orpc = OdooClient(ConstantSise.odooHost);
  static final OdooServices _instance = OdooServices._internal();
  static OdooServices get instance => _instance;

  factory OdooServices() {
    return _instance;
  }

  OdooServices._internal() {
    // is there nothing to do
  }

  Future<bool> checkSession() async {
    try {
      await _orpc.checkSession();
      debugPrint("Session OK");
      return true;
    } catch (e) {
      debugPrint("Session NOT OK");
      return false;
    }
  }

  Future<bool> login() async {
    try {
      var session = await _orpc.authenticate(ConstantSise.odooDb,
          ConstantSise.odooLogin, ConstantSise.odooPassword);
      debugPrint(session.toString());
      debugPrint('Authenticated');
      return true;
    } on OdooException catch (_) {
      _orpc.close();
      debugPrint(_.toString());
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<List<SousProjet>> getSousProjetsList(idCommune) async {
    try {
      final session = await _orpc.authenticate(ConstantSise.odooDb,
          ConstantSise.odooLogin, ConstantSise.odooPassword);
      var data = OdooHelper(
        model: SousProjet.model,
        method: 'search_read',
        fields: SousProjet.fields,
        domain: [
          ['id_commune', '=', idCommune],
          ['suivi_commune', '=', 'OUI']
        ],
      );
      var res = await _orpc.callKw(data.toJson());
      return SousProjet.fromJsonArray(res);
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  Future<List<Region>> getRegionsList() async {
    try {
      final session = await _orpc.authenticate(ConstantSise.odooDb,
          ConstantSise.odooLogin, ConstantSise.odooPassword);
      var data = OdooHelper(
        model: Region.model,
        method: 'search_read',
        fields: Region.fields,
      );
      var res = await _orpc.callKw(data.toJson());
      return Region.fromJsonArray(res);
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<Secteur>> getSecteursList() async {
    try {
      final session = await _orpc.authenticate(ConstantSise.odooDb,
          ConstantSise.odooLogin, ConstantSise.odooPassword);
      var data = OdooHelper(
        model: Secteur.model,
        method: 'search_read',
        fields: Secteur.fields,
      );
      var res = await _orpc.callKw(data.toJson());
      return Secteur.fromJsonArray(res);
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<Infrastructure>> getInfrastructuresList() async {
    try {
      final session = await _orpc.authenticate(ConstantSise.odooDb,
          ConstantSise.odooLogin, ConstantSise.odooPassword);
      var data = OdooHelper(
        model: Infrastructure.model,
        method: 'search_read',
        fields: Infrastructure.fields,
      );
      var res = await _orpc.callKw(data.toJson());
      return Infrastructure.fromJsonArray(res);
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<District>> getDistrictsList() async {
    try {
      final session = await _orpc.authenticate(ConstantSise.odooDb,
          ConstantSise.odooLogin, ConstantSise.odooPassword);
      var data = OdooHelper(
        model: District.model,
        method: 'search_read',
        fields: District.fields,
      );
      var res = await _orpc.callKw(data.toJson());
      return District.fromJsonArray(res);
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<Commune>> getCommunesList() async {
    try {
      final session = await _orpc.authenticate(ConstantSise.odooDb,
          ConstantSise.odooLogin, ConstantSise.odooPassword);
      var data = OdooHelper(
        model: Commune.model,
        method: 'search_read',
        fields: Commune.fields,
      );
      var res = await _orpc.callKw(data.toJson());
      return Commune.fromJsonArray(res);
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
