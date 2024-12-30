// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_constructors_in_immutables, file_names, non_constant_identifier_names, body_might_complete_normally_nullable, sort_child_properties_last, must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sise/services/database_helper.dart';
import 'package:sise/utils.dart';

class ReceptionSousProjetForm extends StatefulWidget {
  final int spId;
  String? recepDatePrev;
  String? recepDate;
  String? recepProvDatePrev;
  String? recepProvDate;
  String? recepPrevDefDate;
  String? recepReelleDefDate;
  String? longitude;
  String? latitude;
  String? cpgu;

  ReceptionSousProjetForm(
      {super.key,
      required this.spId,
      this.recepDatePrev,
      this.recepDate,
      this.recepProvDatePrev,
      this.recepProvDate,
      this.recepPrevDefDate,
      this.recepReelleDefDate,
      this.longitude,
      this.latitude,
      this.cpgu});

  @override
  State<ReceptionSousProjetForm> createState() =>
      _ReceptionSousProjetFormState();
}

class _ReceptionSousProjetFormState extends State<ReceptionSousProjetForm> {
  final formKey = GlobalKey<FormState>();
  final RecepDatePrevController = TextEditingController();
  final ReceptDateController = TextEditingController();
  final RecepProvDatePrevController = TextEditingController();
  final ReceptProvDateController = TextEditingController();
  final RecepPrevDefDateController = TextEditingController();
  final RecepReelleDefDateController = TextEditingController();
  String? cpguValue;
  String? cpgu;

  final longitudeController = TextEditingController();
  final latitudeController = TextEditingController();

  final List<String> boolItems = [
    'OUI',
    'NON',
  ];

  @override
  void dispose() {
    RecepDatePrevController.dispose();
    RecepProvDatePrevController.dispose();
    ReceptDateController.dispose();
    ReceptProvDateController.dispose();
    RecepPrevDefDateController.dispose();
    RecepReelleDefDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    RecepDatePrevController.text = widget.recepDatePrev!;
    ReceptDateController.text = widget.recepDate!;
    RecepProvDatePrevController.text = widget.recepProvDatePrev!;
    ReceptProvDateController.text = widget.recepProvDate!;
    RecepPrevDefDateController.text = widget.recepPrevDefDate!;
    RecepReelleDefDateController.text = widget.recepReelleDefDate!;
    longitudeController.text = widget.longitude!;
    latitudeController.text = widget.latitude!;
    cpgu = 'NON';
    if (widget.cpgu != '') {
      cpgu = 'OUI';
      if (widget.cpgu == 'NON') {
        cpgu = 'NON';
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
        'Mettre à jour les informations de Réception'.toUpperCase(),
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
                            controller: RecepDatePrevController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText:
                                  'Date prévisionnelle de réception technique',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  // locale: const Locale("fr", "FR"),
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2026));
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  RecepDatePrevController.text = formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Entrer la date prévisionnelle de réception technique';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: ReceptDateController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText: 'Date réelle de réception technique',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  // locale: const Locale("fr", "FR"),
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2026));
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  ReceptDateController.text = formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Entrer la date réelle de réception technique';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: RecepProvDatePrevController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText:
                                  'Date prévisionnelle de réception provisoire',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  // locale: const Locale("fr", "FR"),
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2026));
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  RecepProvDatePrevController.text =
                                      formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Entrer la Date prévisionnelle de réception provisoire';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: ReceptProvDateController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText: 'Date réelle de réception provisoire',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  // locale: const Locale("fr", "FR"),
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2026));
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  ReceptProvDateController.text = formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Entrer la Date réelle de réception provisoire';
                            //   }
                            //   return null;
                            // },
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          TextFormField(
                            controller: RecepPrevDefDateController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText:
                                  'Date prévisionnelle de réception definitive',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  // locale: const Locale("fr", "FR"),
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2026));
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  RecepPrevDefDateController.text =
                                      formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: RecepReelleDefDateController,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              icon: Icon(Icons.calendar_today),
                              labelText: 'Date réelle de réception definitive',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  // locale: const Locale("fr", "FR"),
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2026));
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  RecepReelleDefDateController.text =
                                      formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          TextFormField(
                            controller: longitudeController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              labelText: 'Longitude',
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
                          TextFormField(
                            controller: latitudeController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
                              labelText: 'Latitude',
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
                          const Text(
                            'Normes résiliences infrastructures',
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
                            isExpanded: true,
                            value: cpgu,
                            hint: const Text(
                              'Normes résiliences infrastructures',
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
                              // elevation: 2,
                            ),
                            items: boolItems
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            // validator: (value) {
                            //   if (value == null) {
                            //     return 'Selectionner OUI/NON.';
                            //   }
                            // },
                            onChanged: (value) {
                              cpguValue = value.toString();
                            },
                            onSaved: (value) {
                              cpguValue = value.toString();
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
                                        .updateReceptionSousProjets(
                                            widget.spId,
                                            RecepDatePrevController.text,
                                            ReceptDateController.text,
                                            RecepProvDatePrevController.text,
                                            ReceptProvDateController.text,
                                            RecepPrevDefDateController.text,
                                            RecepReelleDefDateController.text,
                                            longitudeController.text,
                                            latitudeController.text,
                                            cpguValue),
                                    UtilsBehavior.hideCircularIndocator(
                                        context),
                                    Navigator.of(context).pop()
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
