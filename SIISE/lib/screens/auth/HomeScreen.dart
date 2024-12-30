// ignore_for_file: implementation_imports, use_build_context_synchronously, file_names, unused_import, sort_child_properties_last, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:sise/controllers/AuthController.dart';
import 'package:sise/controllers/SynchronizeController.dart';
import 'package:sise/helpers/collection_helper.dart';
import 'package:sise/models/SousProjet.dart';
import 'package:sise/screens/auth/ProjectScreen.dart';
import 'package:sise/screens/auth/navs/ProjectScreen.dart';
import 'package:sise/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreenAuth extends StatefulWidget {
  static const String route = "/home";

  const HomeScreenAuth({super.key});

  @override
  State<HomeScreenAuth> createState() => _HomeScreenAuthState();
}

class _HomeScreenAuthState extends State<HomeScreenAuth> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadDatas();
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  void _onRefresh() async {
    loadDatas();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    loadDatas();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: WillPopScope(
          onWillPop: () async {
            MoveToBackground.moveTaskToBack();
            return false;
          },
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
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(
                40.0,
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/icon.png',
                      height: 50.0,
                      width: 50.0,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "SOUS PROJETS COMMUNE : ${CollectionHelper.spCommune}",
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CollectionHelper.spCollection.isNotEmpty
                        ? ListView.builder(
                            itemCount: CollectionHelper.spCollection.length,
                            prototypeItem: ListTile(
                              title: Text(
                                  CollectionHelper.spCollection.first.name),
                            ),
                            itemBuilder: (context, index) {
                              return ListTile(
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                ),
                                visualDensity: const VisualDensity(vertical: 4),
                                dense: true,
                                title: Text(
                                  '${CollectionHelper.spCollection[index].fokontany} - ${CollectionHelper.spCollection[index].name}',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    ProjectScreenAuth.route,
                                    arguments: CollectionHelper
                                        .spCollection[index]
                                        .toString(),
                                  );
                                },
                                focusColor: Colors.orange,
                              );
                            },
                            shrinkWrap: true,
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 100.0,
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: SizedBox(
              height: 30,
              width: 150,
              child: FloatingActionButton.extended(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () async {
                  UtilsBehavior.showCircularIndicator(context);
                  bool connected =
                      await SynchronizeController().checkInternetConnectivity();
                  if (connected) {
                    debugPrint('Device connected');
                    _initDatas();
                    UtilsBehavior.hideCircularIndocator(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        padding: const EdgeInsets.all(30.0),
                        content: Text(
                          "Vous êtes connecté(e) au serveur central ..."
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    debugPrint('Device not connected');
                    UtilsBehavior.hideCircularIndocator(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        padding: const EdgeInsets.all(30.0),
                        content: Text(
                          "Vous n'êtes pas connecté(e) au serveur central ..."
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
                label: const Text(
                  'Synchroniser',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                icon: const Icon(Icons.sync),
                backgroundColor: Colors.orange,
                elevation: 0,
                tooltip: 'Synchroniser vers le serveur',
                extendedPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              ),
            ),
            bottomSheet: const Padding(
              padding: EdgeInsets.only(
                bottom: 60.0,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        ),
      ),
    );
  }

  void _initDatas() async {
    setState(() {});
    UtilsBehavior.showCircularIndicator(context);
    await CollectionHelper.initiSousProjets();
    UtilsBehavior.hideCircularIndocator(context);
    setState(() {});
  }

  void loadDatas() async {
    setState(() {});
    UtilsBehavior.showCircularIndicator(context);
    await CollectionHelper.loadSousProjets();
    UtilsBehavior.hideCircularIndocator(context);
    setState(() {});
  }
}
