// ignore_for_file: file_names, avoid_print, unused_local_variable, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sise/helpers/collection_helper.dart';
import 'package:sise/models/SousProjet.dart';
import 'package:sise/screens/auth/forms/ReceptionSousProjetForm.dart';
import 'package:sise/services/database_helper.dart';
import 'package:sise/utils.dart';

class NavReceptionScreen extends StatefulWidget {
  const NavReceptionScreen({super.key});

  @override
  State<NavReceptionScreen> createState() => _NavReceptionScreenState();
}

class _NavReceptionScreenState extends State<NavReceptionScreen> {
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
    var recepDatePrev = UtilsBehavior.formatDateFr(sp.recep_date_prev);
    var recepDate = UtilsBehavior.formatDateFr(sp.recep_date);
    var recepProvDatePrev = UtilsBehavior.formatDateFr(sp.recep_prov_date_prev);
    var recepProvDate = UtilsBehavior.formatDateFr(sp.recep_prov_date);
    var recepDefDatePrev = UtilsBehavior.formatDateFr(sp.recepdef_date_prev);
    var recepDefDate = UtilsBehavior.formatDateFr(sp.recepdef_date);

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
              "Réception",
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
                          'Date prévisionnelle de réception technique',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '$recepDatePrev',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Date réelle de réception technique',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '$recepDate',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
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
                          'Date prévisionnelle de réception provisoire',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '$recepProvDatePrev',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Date réelle de réception provisoire',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '$recepProvDate',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
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
                          'Date prévisionnelle de réception définitive',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '$recepDefDatePrev',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Date réelle de réception définitive',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '$recepDefDate',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
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
                          'Longitude',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${sp.longitude}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Latitude',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${sp.latitude}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
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
                          'Normes résiliences infrastructures',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${sp.cpgu}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
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
                    return ReceptionSousProjetForm(
                      spId: sp.id,
                      recepDatePrev: sp.recep_date_prev,
                      recepDate: sp.recep_date,
                      recepProvDatePrev: sp.recep_prov_date_prev,
                      recepProvDate: sp.recep_prov_date,
                      recepPrevDefDate: sp.recepdef_date_prev,
                      recepReelleDefDate: sp.recepdef_date,
                      longitude: sp.longitude,
                      latitude: sp.latitude,
                      cpgu: sp.cpgu,
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
