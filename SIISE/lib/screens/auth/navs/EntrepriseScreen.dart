// ignore_for_file: file_names, avoid_print, unused_local_variable, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sise/helpers/collection_helper.dart';
import 'package:sise/models/SousProjet.dart';
import 'package:sise/screens/auth/forms/EseSousProjetForm.dart';
import 'package:sise/services/database_helper.dart';
import 'package:sise/utils.dart';

class NavEntrepriseScreen extends StatefulWidget {
  const NavEntrepriseScreen({super.key});

  // static List<SousProjet> spCollection = [];

  @override
  State<NavEntrepriseScreen> createState() => _NavEntrepriseScreenState();
}

class _NavEntrepriseScreenState extends State<NavEntrepriseScreen> {
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
              "Entreprise",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 1, 187, 187),
                fontSize: 18,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                  // defaultColumnWidth: (40, 40),
                  children: [
                    TableRow(
                      children: [
                        Text(
                          'Dénomition de l\'entreprise',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${sp.nom_entreprise}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Montant Contrat Entreprise',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${UtilsBehavior.formatCurrency(sp.montant_entcontrat)} Ariary',
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
                          'Date contractualisation entreprise',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${UtilsBehavior.formatDateFr(sp.ce_date)}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Photo première page contrat Entreprise',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        sp.ce_photo == null
                            ? Text('Pas d\'image')
                            : UtilsBehavior.showImageStr(sp.ce_photo),
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
                          'Date Ordre de Service Entreprise',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${UtilsBehavior.formatDateFr(sp.ose_date)}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Photo Ordre de Service Entreprise',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        sp.ose_photo == null
                            ? Text('Pas d\'image')
                            : UtilsBehavior.showImageStr(sp.ose_photo),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 50.0,
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
                          'Date prévisionnelle du démarrage des travaux',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${UtilsBehavior.formatDateFr(sp.dem_date_prev)}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Date du démarrage des travaux',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${UtilsBehavior.formatDateFr(sp.dem_date)}',
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
                          'Durée travaux (Mois)',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${sp.duree_travaux}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Photo du démarrage des travaux',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        sp.dem_photo == null
                            ? Text('Pas d\'image')
                            : UtilsBehavior.showImageStr(sp.dem_photo),
                      ],
                    ),
                  ],
                ),
              ],
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
                    return EseSousProjetForm(
                        spId: spSession.id,
                        nomEntreprise: sp.nom_entreprise,
                        montantEntContrat: sp.montant_entcontrat,
                        ceDate: sp.ce_date,
                        oseDate: sp.ose_date,
                        demDatePrev: sp.dem_date_prev,
                        demDate: sp.dem_date,
                        dureeTravaux: sp.duree_travaux);
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
