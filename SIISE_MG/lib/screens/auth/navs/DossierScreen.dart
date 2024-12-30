// ignore_for_file: file_names, avoid_print, unused_local_variable, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sise/helpers/collection_helper.dart';
import 'package:sise/models/SousProjet.dart';
import 'package:sise/screens/auth/forms/DossierSousProjetForm.dart';
import 'package:sise/services/database_helper.dart';
import 'package:sise/utils.dart';

class NavDossierScreen extends StatefulWidget {
  const NavDossierScreen({super.key});

  // static List<SousProjet> spCollection = [];

  @override
  State<NavDossierScreen> createState() => _NavDossierScreenState();
}

class _NavDossierScreenState extends State<NavDossierScreen> {
  late SousProjet spdetail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSousProjectDatas(spdetail.id);
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final spArg = ModalRoute.of(context)!.settings.arguments as String;
    SousProjet spSession = SousProjet.fromJsonLocal(jsonDecode(spArg));
    spdetail = spSession;
    var sp = CollectionHelper.spDetailLocal ?? spdetail;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          40.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/icon.png',
              height: 50.0,
              width: 50.0,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              "Intitulé : ${sp.name}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            const Text(
              "Dossier APS/APD/DAO/Lancement",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 1, 187, 187),
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(1.0),
                ),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                  // defaultColumnWidth: (40, 40),
                  children: [
                    TableRow(
                      children: [
                        Text(
                          'Date Avant-Projet Sommaire',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${UtilsBehavior.formatDateFr(sp.aps_date)}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Photo PV Avant-Projet Sommaire',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        sp.aps_photo == null
                            ? Text('Pas d\'image')
                            : UtilsBehavior.showImageStr(sp.aps_photo),
                      ],
                    ),
                    TableRow(children: [
                      SizedBox(
                        height: 50.0,
                      ), //SizeBox Widget
                      SizedBox(
                        height: 50.0,
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                    ]),
                    TableRow(
                      children: [
                        Text(
                          'Date Avant-Projet Détaillé',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${UtilsBehavior.formatDateFr(sp.apd_date)}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Photo PV Avant-Projet Détaillé',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        sp.apd_photo == null
                            ? Text('Pas d\'image')
                            : UtilsBehavior.showImageStr(sp.apd_photo),
                      ],
                    ),
                    TableRow(children: [
                      SizedBox(
                        height: 50.0,
                      ), //SizeBox Widget
                      SizedBox(
                        height: 50.0,
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                    ]),
                    TableRow(
                      children: [
                        Text(
                          'Date Dossier d\'Appel d\'Offres',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${UtilsBehavior.formatDateFr(sp.dao_date)}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Photo première page Dossier d\'Appel d\'Offres',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        sp.dao_photo == null
                            ? Text('Pas d\'image')
                            : UtilsBehavior.showImageStr(sp.dao_photo),
                      ],
                    ),
                    TableRow(children: [
                      SizedBox(
                        height: 50.0,
                      ), //SizeBox Widget
                      SizedBox(
                        height: 50.0,
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                    ]),
                    TableRow(
                      children: [
                        Text(
                          'Date Affichage de l\'Appel d\'Offres',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${UtilsBehavior.formatDateFr(sp.lao_date)}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Photo Affichage Appel d\'Offres',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        sp.lao_photo == null
                            ? Text('Pas d\'image')
                            : UtilsBehavior.showImageStr(sp.lao_photo),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 30,
            width: 150,
            child: FloatingActionButton.extended(
              icon: Icon(Icons.edit),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (_) {
                    return DossierSousProjetForm(
                      spId: spSession.id,
                      apsDate: sp.aps_date,
                      apdDate: sp.apd_date,
                      daoDate: sp.dao_date,
                      laoDate: sp.lao_date,
                    );
                  },
                );
                await CollectionHelper.loadSousProjetsDetails(spSession.id);
                setState(() {});
              },
              heroTag: null,
              label: const Text("Editer"),
              backgroundColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  void loadSousProjectDatas(int id) async {
    UtilsBehavior.showCircularIndicator(context);
    await CollectionHelper.loadSousProjetsDetails(id);
    UtilsBehavior.hideCircularIndocator(context);
    setState(() {});
  }
}
