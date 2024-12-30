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
import 'package:flutter_localization/flutter_localization.dart';
import 'package:sise/utils.dart';

class BeSousProjetForm extends StatefulWidget {
  final int spId;
  String? amiDate;
  String? beDate;
  String? osbeDate;
  String? nomBe;
  String? montantBeContrat;
  String? retenue;

  BeSousProjetForm(
      {super.key,
      required this.spId,
      this.amiDate,
      this.beDate,
      this.osbeDate,
      this.nomBe,
      this.montantBeContrat,
      this.retenue});

  @override
  State<BeSousProjetForm> createState() => _BeSousProjetFormState();
}

class _BeSousProjetFormState extends State<BeSousProjetForm> {
  final formKey = GlobalKey<FormState>();
  final amiDateController = TextEditingController();
  final beDateController = TextEditingController();
  final notifDateController = TextEditingController();
  final nomBeController = TextEditingController();
  final montantBeController = TextEditingController();
  File? amiPhotoFile;
  String? amiPhotoData;
  File? bePhotoFile;
  String? bePhotoData;
  File? notifPhotoFile;
  String? notifPhotoData;
  String? retenueValue;
  String? retenue;

  final List<String> boolItems = [
    'OUI',
    'NON',
  ];
  final _picker = ImagePicker();

  @override
  void dispose() {
    amiDateController.dispose();
    beDateController.dispose();
    notifDateController.dispose();
    nomBeController.dispose();
    montantBeController.dispose();
    super.dispose();
  }

  _openImagePickerNotif() async {
    final XFile? pickedImageNotif =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImageNotif != null) {
      var pImage = await pickedImageNotif.readAsBytes();
      var fileSize = pImage.length;
      if (fileSize <= 1048576) {
        setState(() {
          notifPhotoFile = File(pickedImageNotif.path);
        });
        notifPhotoData = base64Encode(notifPhotoFile!.readAsBytesSync());
        return notifPhotoData;
      } else {
        // ignore: use_build_context_synchronously
        UtilsBehavior.showImageDialog(context);
        return null;
      }
    } else {
      return null;
    }
  }

  _openImagePickerCbe() async {
    final XFile? pickedImageCbe =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImageCbe != null) {
      var pImage = await pickedImageCbe.readAsBytes();
      var fileSize = pImage.length;
      if (fileSize <= 1048576) {
        setState(() {
          bePhotoFile = File(pickedImageCbe.path);
        });
        bePhotoData = base64Encode(bePhotoFile!.readAsBytesSync());
        return bePhotoData;
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
          amiPhotoFile = File(pickedImage.path);
        });
        amiPhotoData = base64Encode(amiPhotoFile!.readAsBytesSync());
        return amiPhotoData;
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
    amiDateController.text = widget.amiDate!;
    beDateController.text = widget.beDate!;
    notifDateController.text = widget.osbeDate!;
    nomBeController.text = widget.nomBe!;
    montantBeController.text = widget.montantBeContrat!;
    retenue = 'NON';
    if (widget.retenue != '') {
      retenue = 'OUI';
      if (widget.retenue == 'NON') {
        retenue = 'NON';
      }
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
        'Mettre à jour les informations du Bureau d\'Etudes'.toUpperCase(),
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
                            controller: amiDateController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText: 'Date AMI et Consultation BE',
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
                                  locale: const Locale("fr", "FR"),
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2026));
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  amiDateController.text = formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Entrer la date AMI et Consultation BE';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Photo Affichage AMI',
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
                                child: amiPhotoFile != null
                                    ? Image.file(amiPhotoFile!,
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
                            controller: beDateController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText: 'Date de contractualisation BE',
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
                                  beDateController.text = formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Entrer la date contractualisation BE';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Photo première page de la convention BE',
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
                                  onPressed: _openImagePickerCbe,
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
                                child: bePhotoFile != null
                                    ? Image.file(bePhotoFile!,
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
                            controller: notifDateController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText: 'Date de la notification OS BE',
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
                                  notifDateController.text = formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Entrer la date de notification OS';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Photo notification OS BE',
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
                                  onPressed: _openImagePickerNotif,
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
                                child: notifPhotoFile != null
                                    ? Image.file(notifPhotoFile!,
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
                            controller: nomBeController,
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 20, 20, 0),
                                labelText: 'Dénomition du Bureau d\'étude',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0)))),
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Veuillez entrer le nom du BE';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            controller: montantBeController,
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 20, 20, 0),
                                labelText: 'Montant du contrat BE',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0)))),
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Veuillez entrer le Montant du contrat BE';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          const Text(
                            'Sous-projet Retenue',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          DropdownButtonFormField2(
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            value: retenue,
                            isExpanded: true,
                            hint: const Text(
                              'Sous-projet Retenue',
                              style: TextStyle(fontSize: 14),
                            ),
                            buttonStyleData: ButtonStyleData(
                              height: 35,
                              width: 140,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.black26,
                                ),
                                color: Colors.white,
                              ),
                            ),
                            items: boolItems
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              retenueValue = value.toString();
                            },
                            onSaved: (value) {
                              retenueValue = value.toString();
                            },
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
                                        .updateBeSousProjets(
                                            widget.spId,
                                            amiDateController.text,
                                            amiPhotoData,
                                            beDateController.text,
                                            bePhotoData,
                                            notifDateController.text,
                                            notifPhotoData,
                                            nomBeController.text,
                                            montantBeController.text,
                                            retenueValue),
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
