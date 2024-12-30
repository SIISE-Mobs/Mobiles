// ignore_for_file: use_build_context_synchronously, file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:sise/controllers/AuthController.dart';
import 'package:sise/screens/auth/navs/BureauEtudesScreen.dart';
import 'package:sise/screens/auth/navs/DossierScreen.dart';
import 'package:sise/screens/auth/navs/EntrepriseScreen.dart';
import 'package:sise/screens/auth/navs/ProjectScreen.dart';
import 'package:sise/screens/auth/navs/ReceptionScreen.dart';
import 'package:sise/screens/auth/navs/SuiviBeScreen.dart';
import 'package:sise/screens/auth/navs/SuiviEntrepriseScreen.dart';
import 'package:sise/screens/auth/navs/SuiviPositionnementScreen.dart';
import 'package:sise/screens/auth/navs/SuiviTravauxScreen.dart';

class ProjectScreenAuth extends StatefulWidget {
  static const String route = "/project";

  const ProjectScreenAuth({super.key});

  @override
  State<ProjectScreenAuth> createState() => _ProjectScreenAuthState();
}

class _ProjectScreenAuthState extends State<ProjectScreenAuth> {
  int _navIndex = 0;
  final List<Widget> _navOptions = const <Widget>[
    NavPositionnementScreen(),
    NavProjectScreen(),
    NavBeScreen(),
    NavDossierScreen(),
    NavSuiviBeScreen(),
    NavEntrepriseScreen(),
    NavSuiviEntrepriseScreen(),
    NavSuiviTravauxScreen(),
    NavReceptionScreen(),
  ];

  void _onNavigate(int index) {
    setState(() {
      _navIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
          titleSpacing: 0.0,
          elevation: 5,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Système Informatique Intégré de Suivi Evaluation'.toUpperCase(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 0),
              child: PopupMenuButton<String>(
                offset: const Offset(0, 40),
                elevation: 2,
                child: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                onSelected: (value) async {
                  switch (value) {
                    case 'Déconnexion':
                      await AuthController().processLogout(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Déconnexion ...".toUpperCase(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Déconnexion'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(
            1.0,
          ),
          child: _navOptions.elementAt(_navIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.work_history),
              label: 'Positionnement',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Projet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: 'Bureau d\'Etudes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder),
              label: 'APS/APD/DAO/Lancement',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.follow_the_signs),
              label: 'Suivi BE',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_work),
              label: 'Entreprise',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes),
              label: 'Suivi E/se',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance),
              label: 'Suivi travaux',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Réception',
            ),
          ],
          currentIndex: _navIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.grey[600],
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          onTap: _onNavigate,
        ),
      ),
    );
  }
}
