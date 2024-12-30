// ignore_for_file: file_names, prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:sise/screens/public/Auth.dart';
import 'package:sise/screens/public/Terms.dart';
import 'package:sise/services/database_helper.dart';
import 'package:sise/utils.dart';

class MainScreen extends StatefulWidget {
  static const String route = "/main";
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = const <Widget>[
    AuthScreen(),
    TermsScreen(),
    // Text('Index 3: Synchro'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0.0,
            elevation: 5,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Text(
                'Système Informatique Intégré de Suivi Evaluation'
                    .toUpperCase(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20, top: 0),
                child: PopupMenuButton<String>(
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                  onSelected: (value) async {
                    switch (value) {
                      case 'Synchroniser les données':
                        UtilsBehavior.showCircularIndicator(context);
                        DatabaseHelper _dataBaseHelper =
                            DatabaseHelper.instance;
                        int dCommunes = await _dataBaseHelper.synchroniseData();
                        String dSynchros = dCommunes.toString();
                        UtilsBehavior.hideCircularIndocator(context);
                        if (dCommunes != 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Données Système Synchronisées : $dSynchros - Communes"
                                    .toUpperCase(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Problème de connexion au serveur central"
                                    .toUpperCase(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Synchroniser les données'}.map((String choice) {
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
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Se connecter',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.read_more),
                label: 'Lire CGU',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.orange,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 14,
            onTap: _onItemTapped,
          ),
        ),
        onWillPop: () async {
          MoveToBackground.moveTaskToBack();
          return false;
        },
      ),
    );
  }
}
