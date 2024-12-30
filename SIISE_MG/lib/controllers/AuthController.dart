// ignore_for_file: file_names, prefer_final_fields, use_build_context_synchronously, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sise/screens/auth/HomeScreen.dart';
import 'package:sise/screens/public/Main.dart';
import 'package:sise/services/database_helper.dart';
import 'package:sise/utils.dart';

class AuthController {
  DatabaseHelper _dataBaseHelper = DatabaseHelper.instance;

  final _storage = const FlutterSecureStorage();

  Future<void> processAuthentication(BuildContext context, String code) async {
    UtilsBehavior.showCircularIndicator(context);
    if (await _dataBaseHelper.authenticate(code)) {
      debugPrint("Authentifié");
      Navigator.of(context).pushReplacementNamed(HomeScreenAuth.route);
    } else {
      UtilsBehavior.hideCircularIndocator(context);
      debugPrint("Erreur d'Authentification ...");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Erreur d'Authentification ...".toUpperCase(),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  Future<void> processLogout(BuildContext context) async {
    await _storage.delete(key: "commune");
    await _storage.delete(key: "commune");
    Navigator.of(context).pushReplacementNamed(MainScreen.route);
  }
}
