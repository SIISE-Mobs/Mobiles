// ignore_for_file: file_names, avoid_print, unused_local_variable, unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sise/helpers/collection_helper.dart';
import 'package:sise/models/SousProjet.dart';
import 'package:sise/screens/auth/forms/SuiviTravauxForm.dart';
import 'package:sise/services/database_helper.dart';
import 'package:sise/utils.dart';

class NavSuiviTravauxScreen extends StatefulWidget {
  const NavSuiviTravauxScreen({super.key});

  @override
  State<NavSuiviTravauxScreen> createState() => _NavSuiviTravauxScreenState();
}

class _NavSuiviTravauxScreenState extends State<NavSuiviTravauxScreen> {
  late SousProjet spdetail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSuiviTravauxDatas(spdetail.id);
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
              "Suivi Avancement Travaux",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 1, 187, 187),
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CollectionHelper.sTravaux.isNotEmpty
                ? ListView.builder(
                    itemCount: CollectionHelper.sTravaux.length,
                    itemBuilder: (context, index) => getRow(index),
                    shrinkWrap: true,
                  )
                : const SizedBox.shrink(),
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
              icon: Icon(Icons.add),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (_) {
                    return SuiviTravauxProjetForm(
                      spId: spSession.id,
                    );
                  },
                );
                await CollectionHelper.loadSuivisTravaux(spSession.id);
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
                  CollectionHelper.sTravaux[index].photo == null
                      ? Text('Pas d\'image')
                      : UtilsBehavior.showImageStrList(
                          CollectionHelper.sTravaux[index].photo),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${CollectionHelper.sTravaux[index].libelle_projet}',
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
                        .deleteSuiviEse(CollectionHelper.sTravaux[index].id);
                    setState(() => {
                          CollectionHelper.sTravaux.removeWhere((item) =>
                              item.id == CollectionHelper.sTravaux[index].id)
                        });
                  }),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Pourcentage : ${UtilsBehavior.formatCurrency(CollectionHelper.sTravaux[index].prctg)} % | Date: ${UtilsBehavior.formatDateFr(CollectionHelper.sTravaux[index].date_suivi)}",
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

  void loadSuiviTravauxDatas(int spId) async {
    UtilsBehavior.showCircularIndicator(context);
    await CollectionHelper.loadSuivisTravaux(spId);
    UtilsBehavior.hideCircularIndocator(context);
    setState(() {});
  }
}
