// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_constructors_in_immutables, file_names, unused_import, body_might_complete_normally_nullable, sort_child_properties_last, must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sise/helpers/collection_helper.dart';
import 'package:sise/screens/auth/ProjectScreen.dart';
import 'package:sise/services/database_helper.dart';
import 'package:sise/utils.dart';

class EseSousProjetForm extends StatefulWidget {
  final int spId;
  String? nomEntreprise;
  String? montantEntContrat;
  String? ceDate;
  String? oseDate;
  String? demDatePrev;
  String? demDate;
  String? dureeTravaux;

  EseSousProjetForm(
      {super.key,
      required this.spId,
      this.nomEntreprise,
      this.montantEntContrat,
      this.ceDate,
      this.oseDate,
      this.demDatePrev,
      this.demDate,
      this.dureeTravaux});

  @override
  State<EseSousProjetForm> createState() => _EseSousProjetFormState();
}

class _EseSousProjetFormState extends State<EseSousProjetForm> {
  final formKey = GlobalKey<FormState>();
  final nomEntrepriseController = TextEditingController();
  final montantContratEntrepriseController = TextEditingController();
  final ceDateController = TextEditingController();
  File? cePhotoFile;
  String? cePhotoData;
  final oseDateController = TextEditingController();
  File? osePhotoFile;
  String? osePhotoData;
  final demDatePrevController = TextEditingController();
  final demDateController = TextEditingController();
  File? demPhotoFile;
  String? demPhotoData;
  final dureeTravauxController = TextEditingController();

  final _picker = ImagePicker();

  @override
  void dispose() {
    nomEntrepriseController.dispose();
    montantContratEntrepriseController.dispose();
    ceDateController.dispose();
    oseDateController.dispose();
    demDatePrevController.dispose();
    demDateController.dispose();
    super.dispose();
  }

  _openImagePickerDem() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      var pImage = await pickedImage.readAsBytes();
      var fileSize = pImage.length;
      if (fileSize <= 1048576) {
        setState(() {
          demPhotoFile = File(pickedImage.path);
        });
        demPhotoData = base64Encode(demPhotoFile!.readAsBytesSync());
        return demPhotoData;
      } else {
        // ignore: use_build_context_synchronously
        UtilsBehavior.showImageDialog(context);
        return null;
      }
    } else {
      return null;
    }
  }

  _openImagePickerOse() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      var pImage = await pickedImage.readAsBytes();
      var fileSize = pImage.length;
      if (fileSize <= 1048576) {
        setState(() {
          osePhotoFile = File(pickedImage.path);
        });
        osePhotoData = base64Encode(osePhotoFile!.readAsBytesSync());
        return osePhotoData;
      } else {
        // ignore: use_build_context_synchronously
        UtilsBehavior.showImageDialog(context);
        return null;
      }
    } else {
      return null;
    }
  }

  _openImagePickerCe() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      var pImage = await pickedImage.readAsBytes();
      var fileSize = pImage.length;
      if (fileSize <= 1048576) {
        setState(() {
          cePhotoFile = File(pickedImage.path);
        });
        cePhotoData = base64Encode(cePhotoFile!.readAsBytesSync());
        return cePhotoData;
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
    nomEntrepriseController.text = widget.nomEntreprise!;
    montantContratEntrepriseController.text = widget.montantEntContrat!;
    ceDateController.text = widget.ceDate!;
    oseDateController.text = widget.oseDate!;
    demDatePrevController.text = widget.demDatePrev!;
    demDateController.text = widget.demDate!;
    dureeTravauxController.text = widget.dureeTravaux!;
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
        'Mettre à jour les informations Entreprise'.toUpperCase(),
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
                            controller: nomEntrepriseController,
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 20, 20, 0),
                                labelText: 'Dénomition de l\'entreprise',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0)))),
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Veuillez entrer le nom de l\'entreprise';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            controller: montantContratEntrepriseController,
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 20, 20, 0),
                                labelText: 'Montant contrat Entreprise',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0)))),
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Veuillez entrer le montant';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: ceDateController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText: 'Date contractualisation entreprise',
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
                                  ceDateController.text = formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Entrer la date contractualisation entreprise';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Photo première page contrat Entreprise',
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
                                  onPressed: _openImagePickerCe,
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
                                child: cePhotoFile != null
                                    ? Image.file(cePhotoFile!,
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
                            controller: oseDateController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText: 'Date Ordre de Service Entreprise',
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
                                  oseDateController.text = formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Entrer la date Ordre de Service Entreprise';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Photo Ordre de Service Entreprise',
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
                                  onPressed: _openImagePickerOse,
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
                                child: osePhotoFile != null
                                    ? Image.file(osePhotoFile!,
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
                            controller: demDatePrevController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText:
                                  'Date prévisionnelle du démarrage des travaux',
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
                                  demDatePrevController.text = formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Entrer la date prévisionnelle du démarrage des travaux';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          TextFormField(
                            controller: demDateController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText: 'Date du démarrage des travaux',
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
                                  demDateController.text = formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Entrer la date du démarrage des travaux';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            controller: dureeTravauxController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              labelText: 'Durée travaux (Mois)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Photo du démarrage des travaux',
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
                                  onPressed: _openImagePickerDem,
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
                                child: demPhotoFile != null
                                    ? Image.file(demPhotoFile!,
                                        fit: BoxFit.cover)
                                    : const Text(
                                        'Veuillez sélectionner une image',
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async => {
                                if (formKey.currentState!.validate())
                                  {
                                    UtilsBehavior.showCircularIndicator(
                                        context),
                                    await DatabaseHelper.instance
                                        .updateEseSousProjets(
                                            widget.spId,
                                            nomEntrepriseController.text,
                                            montantContratEntrepriseController
                                                .text,
                                            ceDateController.text,
                                            cePhotoData,
                                            oseDateController.text,
                                            osePhotoData,
                                            demDatePrevController.text,
                                            demDateController.text,
                                            demPhotoData,
                                            dureeTravauxController.text),
                                    UtilsBehavior.hideCircularIndocator(
                                        context),
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
                          )
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
