// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_constructors_in_immutables, file_names, unused_import, body_might_complete_normally_nullable, sort_child_properties_last, must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sise/helpers/collection_helper.dart';
import 'package:sise/screens/auth/ProjectScreen.dart';
import 'package:sise/services/database_helper.dart';
import 'package:sise/utils.dart';

class DossierSousProjetForm extends StatefulWidget {
  final int spId;
  String? apsDate;
  String? apdDate;
  String? daoDate;
  String? laoDate;

  DossierSousProjetForm(
      {super.key,
      required this.spId,
      this.apsDate,
      this.apdDate,
      this.daoDate,
      this.laoDate});

  @override
  State<DossierSousProjetForm> createState() => _DossierSousProjetFormState();
}

class _DossierSousProjetFormState extends State<DossierSousProjetForm> {
  final formKey = GlobalKey<FormState>();
  final apsDateController = TextEditingController();
  File? apsPhotoFile;
  String? apsPhotoData;
  final apdDateController = TextEditingController();
  File? apdPhotoFile;
  String? apdPhotoData;

  final daoDateController = TextEditingController();
  File? daoPhotoFile;
  String? daoPhotoData;
  final laoDateController = TextEditingController();
  File? laoPhotoFile;
  String? laoPhotoData;

  final _picker = ImagePicker();

  @override
  void dispose() {
    apsDateController.dispose();
    apdDateController.dispose();
    daoDateController.dispose();
    laoDateController.dispose();
    super.dispose();
  }

  _openImagePickerDao() async {
    final XFile? pickedImageDao =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImageDao != null) {
      var pImage = await pickedImageDao.readAsBytes();
      var fileSize = pImage.length;
      if (fileSize <= 1048576) {
        setState(() {
          daoPhotoFile = File(pickedImageDao.path);
        });
        daoPhotoData = base64Encode(daoPhotoFile!.readAsBytesSync());
        return daoPhotoData;
      } else {
        // ignore: use_build_context_synchronously
        UtilsBehavior.showImageDialog(context);
        return null;
      }
    } else {
      return null;
    }
  }

  _openImagePickerlao() async {
    final XFile? pickedImagelao =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImagelao != null) {
      var pImage = await pickedImagelao.readAsBytes();
      var fileSize = pImage.length;
      if (fileSize <= 1048576) {
        setState(() {
          laoPhotoFile = File(pickedImagelao.path);
        });
        laoPhotoData = base64Encode(laoPhotoFile!.readAsBytesSync());
        return laoPhotoData;
      } else {
        // ignore: use_build_context_synchronously
        UtilsBehavior.showImageDialog(context);
        return null;
      }
    } else {
      return null;
    }
  }

  _openImagePickerApd() async {
    final XFile? pickedImageApd =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImageApd != null) {
      var pImage = await pickedImageApd.readAsBytes();
      var fileSize = pImage.length;
      if (fileSize <= 1048576) {
        setState(() {
          apdPhotoFile = File(pickedImageApd.path);
        });
        apdPhotoData = base64Encode(apdPhotoFile!.readAsBytesSync());
        return apdPhotoData;
      } else {
        // ignore: use_build_context_synchronously
        UtilsBehavior.showImageDialog(context);
        return null;
      }
    } else {
      return null;
    }
  }

  _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      var pImage = await pickedImage.readAsBytes();
      var fileSize = pImage.length;
      if (fileSize <= 1048576) {
        setState(() {
          apsPhotoFile = File(pickedImage.path);
        });
        apsPhotoData = base64Encode(apsPhotoFile!.readAsBytesSync());
        return apsPhotoData;
      } else {
        // ignore: use_build_context_synchronously
        UtilsBehavior.showImageDialog(context);
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    apsDateController.text = widget.apsDate!;
    apdDateController.text = widget.apdDate!;
    daoDateController.text = widget.daoDate!;
    laoDateController.text = widget.laoDate!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(20),
      contentPadding: const EdgeInsets.all(20),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      actionsAlignment: MainAxisAlignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      title: Text(
        'Mettre à jour les Dossiers APS/APD/DAO/Lancement'.toUpperCase(),
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Color.fromARGB(255, 1, 187, 187),
          fontSize: 18,
        ),
      ),
      content: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scrollbar(
          thumbVisibility: true,
          thickness: 3,
          radius: const Radius.circular(3),
          scrollbarOrientation: ScrollbarOrientation.right,
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 26.0,
                        left: 26.0,
                        right: 26.0,
                        bottom: 26.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: apsDateController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText: 'Date Avant-Projet Sommaire',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2026));
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  apsDateController.text = formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Entrer la Date Avant-Projet Sommaire';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Photo PV Avant-Projet Sommaire',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: ElevatedButton(
                                  onPressed: _openImagePicker,
                                  child: const Text('Sélectionner une image'),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    backgroundColor:
                                        const Color.fromARGB(255, 1, 187, 187),
                                  ),
                                ),
                              ),
                              SizedBox(width: 30),
                              Container(
                                alignment: Alignment.center,
                                width: 200,
                                height: 200,
                                color: Colors.grey[200],
                                child: apsPhotoFile != null
                                    ? Image.file(apsPhotoFile!,
                                        fit: BoxFit.cover)
                                    : const Text(
                                        'Veuillez sélectionner une image',
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          TextFormField(
                            controller: apdDateController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText: 'Date Avant-Projet Détaillé',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2026));
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  apdDateController.text = formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Entrer la Date Avant-Projet Détaillé/Définitif';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Photo PV Avant-Projet Détaillé',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: ElevatedButton(
                                  onPressed: _openImagePickerApd,
                                  child: const Text('Sélectionner une image'),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    backgroundColor:
                                        const Color.fromARGB(255, 1, 187, 187),
                                  ),
                                ),
                              ),
                              SizedBox(width: 30),
                              Container(
                                alignment: Alignment.center,
                                width: 200,
                                height: 200,
                                color: Colors.grey[200],
                                child: apdPhotoFile != null
                                    ? Image.file(apdPhotoFile!,
                                        fit: BoxFit.cover)
                                    : const Text(
                                        'Veuillez sélectionner une image',
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: daoDateController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText: 'Date Dossier d\'Appel d\'Offres',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2026));
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  daoDateController.text = formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Entrer la Date Dossier d\'Appel d\'Offres';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Photo première page Dossier d\'Appel d\'Offres',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: ElevatedButton(
                                  onPressed: _openImagePickerDao,
                                  child: const Text('Sélectionner une image'),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    backgroundColor:
                                        const Color.fromARGB(255, 1, 187, 187),
                                  ),
                                ),
                              ),
                              SizedBox(width: 30),
                              Container(
                                alignment: Alignment.center,
                                width: 200,
                                height: 200,
                                color: Colors.grey[200],
                                child: daoPhotoFile != null
                                    ? Image.file(daoPhotoFile!,
                                        fit: BoxFit.cover)
                                    : const Text(
                                        'Veuillez sélectionner une image',
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: laoDateController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText: 'Date Affichage de l\'Appel d\'Offres',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2026));
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  laoDateController.text = formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Entrer la Date Lancement d\'Appel d\'Offres';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Photo Affichage Appel d\'Offres',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: ElevatedButton(
                                  onPressed: _openImagePickerlao,
                                  child: const Text('Sélectionner une image'),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    backgroundColor:
                                        const Color.fromARGB(255, 1, 187, 187),
                                  ),
                                ),
                              ),
                              SizedBox(width: 30),
                              Container(
                                alignment: Alignment.center,
                                width: 200,
                                height: 200,
                                color: Colors.grey[200],
                                child: laoPhotoFile != null
                                    ? Image.file(laoPhotoFile!,
                                        fit: BoxFit.cover)
                                    : const Text(
                                        'Veuillez sélectionner une image',
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async => {
                                if (formKey.currentState!.validate())
                                  {
                                    UtilsBehavior.showCircularIndicator(
                                        context),
                                    await DatabaseHelper.instance
                                        .updateDossierSousProjets(
                                            widget.spId,
                                            apsDateController.text,
                                            apsPhotoData,
                                            apdDateController.text,
                                            apdPhotoData,
                                            daoDateController.text,
                                            daoPhotoData,
                                            laoDateController.text,
                                            laoPhotoData),
                                    UtilsBehavior.hideCircularIndocator(
                                        // ignore: use_build_context_synchronously
                                        context),
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pop(),
                                    setState(() {}),
                                  }
                              },
                              child: const Text('Enregister'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 10,
                                ),
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 1, 187, 187),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
