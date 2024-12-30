// ignore_for_file: file_names, avoid_print, unused_local_variable, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sise/constants.dart';
import 'package:sise/controllers/SynchronizeController.dart';
import 'package:sise/helpers/collection_helper.dart';
import 'package:sise/models/SousProjet.dart';
import 'package:sise/screens/auth/ProjectScreen.dart';
import 'package:sise/screens/auth/forms/FesSousProjetForm.dart';
import 'package:sise/services/database_helper.dart';
import 'package:sise/utils.dart';

class NavProjectScreen extends StatefulWidget {
  const NavProjectScreen({super.key});

  @override
  State<NavProjectScreen> createState() => _NavProjectScreenState();
}

class _NavProjectScreenState extends State<NavProjectScreen> {
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
    var montant_prev = UtilsBehavior.formatCurrency(sp.montant_prev);
    var dateConventionFr = UtilsBehavior.formatDateFr(sp.date_convention);
    var dateVirementFr = UtilsBehavior.formatDateFr(sp.date_virement);
    var spTtravaux = sp.type_travaux ?? '';
    var fesDate = UtilsBehavior.formatDateFr(sp.fes_date);

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
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            const Text(
              "Localisation et identification de la Commune",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 1, 187, 187),
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    Text(
                      "Région : ",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${sp.region}",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    Text(
                      "District : ",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${sp.district}",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    Text(
                      "Commune : ",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${sp.commune}",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
            const Text(
              "Sous-Projet",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 1, 187, 187),
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 1.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                  children: [
                    TableRow(
                      children: [
                        Text(
                          'Composante',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '2A',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Localité (Fokontany)',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${sp.fokontany}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
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
                          'Type de travaux',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          spTtravaux,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Type d\'infrastructure',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${sp.infrastructure}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
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
                          'Secteur',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${sp.secteur}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Montant prévisionnel',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '$montant_prev Ariary',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
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
                          'Catégorie',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${sp.categorie}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'N° convention',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${sp.numero_conv}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
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
                          'Date de signature',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '$dateConventionFr',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Date de virement (FDL - Commune)',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '$dateVirementFr',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
            const Text(
              "Filtration Environnementale et Sociale",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 1, 187, 187),
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 1.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                  children: [
                    TableRow(
                      children: [
                        Text(
                          'Date de filtration E/S',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '$fesDate',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Faisabilité du sous projet',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${sp.fes_faisabilite}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
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
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 30,
              width: 300,
              child: FloatingActionButton.extended(
                icon: const Icon(Icons.sync),
                onPressed: () async {
                  UtilsBehavior.showCircularIndicator(context);
                  var returnSync = await SynchronizeController()
                      .sendSynchroniseData(spSession.id);
                  UtilsBehavior.hideCircularIndocator(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      padding: const EdgeInsets.all(30.0),
                      content: Text(
                        returnSync == 1
                            ? "Synchronisation au serveur central terminée ..."
                                .toUpperCase()
                            : "Données non synchonisées ...".toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
                heroTag: null,
                backgroundColor: Color.fromARGB(255, 1, 187, 187),
                label: const Text("Envoyer au serveur central"),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(child: Container()),
            SizedBox(
              height: 30,
              width: 150,
              child: FloatingActionButton.extended(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (_) {
                      return FesSousProjetForm(
                        spId: spSession.id,
                        fesDate: sp.fes_date,
                        fesFaisabilite: sp.fes_faisabilite,
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
            SizedBox(
              height: 100,
            ),
          ],
        ),
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
