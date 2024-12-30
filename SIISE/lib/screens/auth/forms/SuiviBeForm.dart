// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_constructors_in_immutables, file_names, unused_import, body_might_complete_normally_nullable, sort_child_properties_last

import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sise/constants.dart';
import 'package:sise/helpers/collection_helper.dart';
import 'package:sise/screens/auth/ProjectScreen.dart';
import 'package:sise/services/database_helper.dart';
import 'package:sise/utils.dart';

class SuiviBeProjetForm extends StatefulWidget {
  final int spId;

  SuiviBeProjetForm({super.key, required this.spId});

  @override
  State<SuiviBeProjetForm> createState() => _SuiviBeProjetFormState();
}

class _SuiviBeProjetFormState extends State<SuiviBeProjetForm> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final dateSuiviController = TextEditingController();
  final montantController = TextEditingController();
  final libelleBeController = TextEditingController();
  File? suiviBePhotoFile;
  String? suiviBePhotoData;

  final _picker = ImagePicker();

  @override
  void dispose() {
    nameController.dispose();
    dateSuiviController.dispose();
    montantController.dispose();
    libelleBeController.dispose();
    super.dispose();
  }

  _openImagePickerSuiviBe() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      var pImage = await pickedImage.readAsBytes();
      var fileSize = pImage.length;
      if (fileSize <= 1048576) {
        setState(() {
          suiviBePhotoFile = File(pickedImage.path);
        });
        suiviBePhotoData = base64Encode(suiviBePhotoFile!.readAsBytesSync());
        return suiviBePhotoData;
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
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(20),
      contentPadding: const EdgeInsets.all(20),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      actionsAlignment: MainAxisAlignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      title: Text(
        'Suivi financier Bureau d\'Etudes'.toUpperCase(),
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
                        children: [
                          TextFormField(
                            controller: libelleBeController,
                            // maxLines: 2,
                            // minLines: 2,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              labelText: 'Libellé Suivi',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Entrer la description du suivi';
                              }
                              return null;
                            },
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
                            controller: montantController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              labelText: 'Montant décaissé',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                            ),
                            validator: (value) {
                              // ignore: unrelated_type_equality_checks
                              if (value!.isEmpty || value == 0) {
                                return 'Entrer un montant valide';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: dateSuiviController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText: 'Date de décaissement',
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
                                  dateSuiviController.text = formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Entrer la date de suivi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Photo PJ (Facture)',
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
                                  onPressed: _openImagePickerSuiviBe,
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
                              SizedBox(
                                width: 30,
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 200,
                                height: 200,
                                color: Colors.grey[200],
                                child: suiviBePhotoFile != null
                                    ? Image.file(suiviBePhotoFile!,
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
                                    await DatabaseHelper.instance.insertSuiviBe(
                                        widget.spId,
                                        libelleBeController.text,
                                        montantController.text,
                                        dateSuiviController.text,
                                        suiviBePhotoData),
                                    Navigator.of(context).pop(),
                                    UtilsBehavior.hideCircularIndocator(
                                        context),
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
