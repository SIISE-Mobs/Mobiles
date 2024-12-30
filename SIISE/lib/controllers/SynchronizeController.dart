// ignore_for_file: file_names, avoid_print, await_only_futures, equal_keys_in_map, unused_local_variable

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:sise/constants.dart';
import 'package:sise/helpers/collection_helper.dart';
import 'package:sise/services/database_helper.dart';

// import 'package:connectivity/connectivity.dart';

class SynchronizeController {
  static final OdooClient _orpc = OdooClient(ConstantSise.odooHost);

  Future<bool> checkInternetConnectivity() async {
    String url = ConstantSise.odooHost;
    String cleanedUrl = url.replaceFirst(RegExp('^https?://'), '');
    var clearUrl = Uri.http(cleanedUrl);
    bool connected = false;
    try {
      final response = await http
          .get(
            clearUrl,
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        connected = true;
      } else {
        connected = false;
      }
    } catch (e) {
      connected = false;
    }

    return connected;
  }

  Future<int> removeOneToManySousProjet(
      int idRecord, String modelStr, String columnStr) async {
    var res = 0;
    try {
      await _orpc.authenticate(ConstantSise.odooDb, ConstantSise.odooLogin,
          ConstantSise.odooPassword);
      await _orpc.callKw({
        'model': modelStr,
        'method': 'write',
        'args': [
          [idRecord],
          {
            columnStr: 1,
          },
        ],
        'kwargs': {},
      });
      res = 1;
    } catch (e) {
      debugPrint("ERROR: $e");
    }
    return res;
  }

  Future<int> sendSynchroniseData(int spId) async {
    bool connected = await checkInternetConnectivity();
    if (connected) {
      debugPrint('Device connected');
      var spDetail = await CollectionHelper.spDetailLocal;

      await _orpc.authenticate(ConstantSise.odooDb, ConstantSise.odooLogin,
          ConstantSise.odooPassword);
      /** SUIVI BE **/
      var lSbe = await CollectionHelper.loadSuivisBeBySpId(spId);
      if (lSbe.isNotEmpty) {
        /** Insert new suivis BE to Odoo **/
        for (int ii = 0; ii < lSbe.length; ii++) {
          if (lSbe[ii].envoi != 200 || lSbe[ii].envoi == null) {
            var suiviBeOdooId = await _orpc.callKw({
              'model': 'a.sise.suivi.be',
              'method': 'create',
              'args': [
                {
                  'name': lSbe[ii].name,
                  'montant': lSbe[ii].montant,
                  'photo': lSbe[ii].photo,
                  'date_suivi': lSbe[ii].date_suivi.toString(),
                  'libelle_be': lSbe[ii].libelle_be.toString(),
                  'id_sousprojet': spId
                },
              ],
              'kwargs': {},
            });

            if (suiviBeOdooId > 0) {
              await DatabaseHelper.instance
                  .updateEnvoiSqlite(lSbe[ii].id, 'suivi_be');
            }
          }
        }
      }

      /** SUIVI ESE **/
      var lSese = await CollectionHelper.loadSuivisEseBySpId(spId);
      if (lSese.isNotEmpty) {
        /** Insert new suivis Ese to Odoo **/
        for (int ii = 0; ii < lSese.length; ii++) {
          if (lSese[ii].envoi != 200 || lSese[ii].envoi == null) {
            var suiviEseOdooId = await _orpc.callKw({
              'model': 'a.sise.suivi.entreprise',
              'method': 'create',
              'args': [
                {
                  'name': lSese[ii].name,
                  'montant': lSese[ii].montant,
                  'photo': lSese[ii].photo,
                  'date_suivi': lSese[ii].date_suivi.toString(),
                  'libelle_ent': lSese[ii].libelle_ent.toString(),
                  'id_sousprojet': spId
                },
              ],
              'kwargs': {},
            });

            if (suiviEseOdooId > 0) {
              await DatabaseHelper.instance
                  .updateEnvoiSqlite(lSese[ii].id, 'suivi_entreprise');
            }
          }
        }
      }

      /** SUIVI Travaux **/
      var lSTravaux = await CollectionHelper.loadSuivisTravauxBySpId(spId);
      if (lSTravaux.isNotEmpty) {
        /** Insert new suivis Travaux to Odoo **/
        for (int ii = 0; ii < lSTravaux.length; ii++) {
          if (lSTravaux[ii].envoi != 200 || lSTravaux[ii].envoi == null) {
            var suiviTravauxOdooId = await _orpc.callKw({
              'model': 'a.sise.suivi.sousprojet',
              'method': 'create',
              'args': [
                {
                  'name': lSTravaux[ii].name,
                  'prctg': lSTravaux[ii].prctg,
                  'photo': lSTravaux[ii].photo,
                  'date_suivi': lSTravaux[ii].date_suivi.toString(),
                  'id_sousprojet': spId
                },
              ],
              'kwargs': {},
            });

            if (suiviTravauxOdooId > 0) {
              await DatabaseHelper.instance
                  .updateEnvoiSqlite(lSTravaux[ii].id, 'suivi_sous_projet');
            }
          }
        }
      }

      /** SUIVI Position **/
      var lSPosition = await CollectionHelper.loadSuivisPositionBySpId(spId);
      if (lSPosition.isNotEmpty) {
        /** Insert new suivis Position to Odoo **/
        for (int ii = 0; ii < lSPosition.length; ii++) {
          if (lSPosition[ii].envoi != 200 || lSPosition[ii].envoi == null) {
            var suiviPositionOdooId = await _orpc.callKw({
              'model': 'a.sise.positionnement',
              'method': 'create',
              'args': [
                {
                  'name': lSPosition[ii].name,
                  'montant': lSPosition[ii].montant.toString(),
                  'photo': lSPosition[ii].photo,
                  'date_position': lSPosition[ii].date_position.toString(),
                  'id_sousprojet': spId
                },
              ],
              'kwargs': {},
            });

            if (suiviPositionOdooId > 0) {
              await DatabaseHelper.instance
                  .updateEnvoiSqlite(lSPosition[ii].id, 'sise_positionnement');
            }
          }
        }
      }

      try {
        await _orpc.authenticate(ConstantSise.odooDb, ConstantSise.odooLogin,
            ConstantSise.odooPassword);
        var res = await _orpc.callKw({
          'model': 'a.sise.sousprojet',
          'method': 'write',
          'args': [
            spId,
            {
              'fes_faisabilite': spDetail?.fes_faisabilite,
              'fes_date': spDetail?.fes_date,
              'ami_date': spDetail?.ami_date,
              'ami_photo': spDetail?.ami_photo,
              'be_date': spDetail?.be_date,
              'be_photo': spDetail?.be_photo,
              'osbe_date': spDetail?.osbe_date,
              'osbe_photo': spDetail?.osbe_photo,
              'nom_be': spDetail?.nom_be,
              'montant_becontrat': spDetail?.montant_becontrat,
              'retenue': spDetail?.retenue,
              'aps_date': spDetail?.aps_date,
              'aps_photo': spDetail?.aps_photo,
              'apd_date': spDetail?.apd_date,
              'apd_photo': spDetail?.apd_photo,
              'dao_date': spDetail?.dao_date,
              'dao_photo': spDetail?.dao_photo,
              'lao_date': spDetail?.lao_date,
              'lao_photo': spDetail?.lao_photo,
              'nom_entreprise': spDetail?.nom_entreprise,
              'montant_entcontrat': spDetail?.montant_entcontrat,
              'ce_date': spDetail?.ce_date,
              'ce_photo': spDetail?.ce_photo,
              'ose_date': spDetail?.ose_date,
              'duree_travaux': spDetail?.duree_travaux,
              'ose_photo': spDetail?.ose_photo,
              'dem_date_prev': spDetail?.dem_date_prev,
              'dem_date': spDetail?.dem_date,
              'dem_photo': spDetail?.dem_photo,
              'recep_date_prev': spDetail?.recep_date_prev,
              'recep_date': spDetail?.recep_date,
              'recep_prov_date_prev': spDetail?.recep_prov_date_prev,
              'recep_prov_date': spDetail?.recep_prov_date,
              'recepdef_date_prev': spDetail?.recepdef_date_prev,
              'recepdef_date': spDetail?.recepdef_date,
              'recepdef_date_prev': spDetail?.recepdef_date_prev,
              'recepdef_date': spDetail?.recepdef_date,
              'longitude': spDetail?.longitude,
              'latitude': spDetail?.latitude,
              'cpgu': spDetail?.cpgu,
            },
          ],
          'kwargs': {},
        });
      } catch (e) {
        debugPrint("ERROR: $e");
      }
      return 1;
    } else {
      debugPrint('Device not connected');
      return 0;
    }
  }
}
