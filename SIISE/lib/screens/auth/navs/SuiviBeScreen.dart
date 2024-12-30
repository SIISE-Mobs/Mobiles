// ignore_for_file: file_names, avoid_print, unused_local_variable, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sise/helpers/collection_helper.dart';
import 'package:sise/models/SousProjet.dart';
import 'package:sise/models/SuiviBe.dart';
import 'package:sise/screens/auth/forms/SuiviBeForm.dart';
import 'package:sise/services/database_helper.dart';
import 'package:sise/utils.dart';

class NavSuiviBeScreen extends StatefulWidget {
  const NavSuiviBeScreen({super.key});

  @override
  State<NavSuiviBeScreen> createState() => _NavSuiviBeScreenState();
}

class _NavSuiviBeScreenState extends State<NavSuiviBeScreen> {
  late SousProjet spdetail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSuiviBeDatas(spdetail.id);
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
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(
            40.0,
          ),
          physics: ScrollPhysics(),
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
                "Suivi Bureau d'Etudes",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 1, 187, 187),
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CollectionHelper.sBe.isNotEmpty
                  ? ListView.builder(
                      itemCount: CollectionHelper.sBe.length,
                      itemBuilder: (context, index) => getRow(index),
                      shrinkWrap: true,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
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
              icon: Icon(Icons.add),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (_) {
                    return SuiviBeProjetForm(
                      spId: spSession.id,
                    );
                  },
                );
                await CollectionHelper.loadSuivisBe(spSession.id);
                setState(() {});
              },
              heroTag: null,
              label: const Text("Ajouter"),
              backgroundColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget getRow(int index) {
    return Card(
      color: Colors.white,
      elevation: 8,
      child: Container(
        height: 130,
        padding: EdgeInsets.all(15),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  CollectionHelper.sBe[index].photo == null
                      ? Text('Pas d\'image')
                      : UtilsBehavior.showImageStrList(
                          CollectionHelper.sBe[index].photo),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${CollectionHelper.sBe[index].libelle_be}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    DatabaseHelper.instance
                        .deleteSuiviBe(CollectionHelper.sBe[index].id);
                    setState(() => {
                          CollectionHelper.sBe.removeWhere((item) =>
                              item.id == CollectionHelper.sBe[index].id)
                        });
                  }),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Montant : ${UtilsBehavior.formatCurrency(CollectionHelper.sBe[index].montant)} Ariary | Date: ${UtilsBehavior.formatDateFr(CollectionHelper.sBe[index].date_suivi)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadSuiviBeDatas(int spId) async {
    setState(() {});
    UtilsBehavior.showCircularIndicator(context);
    await CollectionHelper.loadSuivisBe(spId);
    UtilsBehavior.hideCircularIndocator(context);
    setState(() {});
  }
}
