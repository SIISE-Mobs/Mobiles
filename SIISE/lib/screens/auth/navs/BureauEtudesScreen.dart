// ignore_for_file: file_names, avoid_print, unused_local_variable, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sise/helpers/collection_helper.dart';
import 'package:sise/models/SousProjet.dart';
import 'package:sise/screens/auth/forms/BeSousProjetForm.dart';
import 'package:sise/services/database_helper.dart';
import 'package:sise/utils.dart';

class NavBeScreen extends StatefulWidget {
  const NavBeScreen({super.key});

  // static List<SousProjet> spCollection = [];

  @override
  State<NavBeScreen> createState() => _NavBeScreenState();
}

class _NavBeScreenState extends State<NavBeScreen> {
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
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            const Text(
              "Bureau d'Etudes",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 1, 187, 187),
                fontSize: 18.0,
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
                          'Date AMI et Consultation Bureau d\'Etude',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${UtilsBehavior.formatDateFr(sp.ami_date)}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Photo Affichage AMI',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        sp.ami_photo == null
                            ? Text('Pas d\'image')
                            : UtilsBehavior.showImageStr(sp.ami_photo),
                      ],
                    ),
                    TableRow(
                      children: [
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
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(
                          'Date de contractualisation BE',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${UtilsBehavior.formatDateFr(sp.be_date)}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Photo première page de la convention BE',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        sp.be_photo == null
                            ? Text('Pas d\'image')
                            : UtilsBehavior.showImageStr(sp.be_photo),
                      ],
                    ),
                    TableRow(
                      children: [
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
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(
                          'Date de la notification OS BE',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${UtilsBehavior.formatDateFr(sp.osbe_date)}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Photo notification OS BE',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        sp.osbe_photo == null
                            ? Text('Pas d\'image')
                            : UtilsBehavior.showImageStr(sp.osbe_photo),
                      ],
                    ),
                    TableRow(
                      children: [
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
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(
                          'Dénomition du \nbureau d\'étude',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${sp.nom_be}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Montant du \ncontrat BE',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${UtilsBehavior.formatCurrency(sp.montant_becontrat)} Ariary',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
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
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(
                          'Sous-projet Retenue',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '${sp.retenue}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '',
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
                    return BeSousProjetForm(
                      spId: spSession.id,
                      amiDate: sp.ami_date,
                      beDate: sp.be_date,
                      osbeDate: sp.osbe_date,
                      nomBe: sp.nom_be,
                      montantBeContrat: sp.montant_becontrat,
                      retenue: sp.retenue,
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
