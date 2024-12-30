// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_constructors_in_immutables, file_names, unused_import, body_might_complete_normally_nullable, sort_child_properties_last, must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sise/constants.dart';
import 'package:sise/helpers/collection_helper.dart';
import 'package:sise/screens/auth/ProjectScreen.dart';
import 'package:sise/services/database_helper.dart';
import 'package:sise/utils.dart';

class FesSousProjetForm extends StatefulWidget {
  final int spId;
  String? fesDate;
  String? fesFaisabilite;

  FesSousProjetForm(
      {super.key, required this.spId, this.fesDate, this.fesFaisabilite});

  @override
  State<FesSousProjetForm> createState() => _FesSousProjetFormState();
}

class _FesSousProjetFormState extends State<FesSousProjetForm> {
  final formKey = GlobalKey<FormState>();
  final fesDateController = TextEditingController();
  final fesFaisabiliteController = TextEditingController();
  String? fesFaisabiliteValue;
  String? fesFaisabilite;

  final List<String> boolItems = [
    'OUI',
    'NON',
  ];

  @override
  void initState() {
    super.initState();
    fesDateController.text = widget.fesDate!;
    fesFaisabilite = 'NON';
    if (widget.fesFaisabilite != '') {
      fesFaisabilite = 'OUI';
      if (widget.fesFaisabilite == 'NON') {
        fesFaisabilite = 'NON';
      }
    }
  }

  @override
  void dispose() {
    fesDateController.dispose();
    fesFaisabiliteController.dispose();
    super.dispose();
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
        'Mettre à jour les informations de Filtration Environnementale et Sociale'
            .toUpperCase(),
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
                            controller: fesDateController,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.calendar_today),
                              labelText: 'Date de Filtration E/S',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                                  fesDateController.text = formattedDate;
                                });
                              } else {
                                print("Date non sélectionnée");
                              }
                            },
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          const Text(
                            'Faisabilité du Sous-projet',
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
                            value: fesFaisabilite,
                            isExpanded: true,
                            hint: const Text(
                              'Faisabilité du Sous-projet',
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
                              fesFaisabiliteValue = value.toString();
                            },
                            onSaved: (value) {
                              fesFaisabiliteValue = value.toString();
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
                                        .updateFesSousProjets(
                                            widget.spId,
                                            fesDateController.text,
                                            fesFaisabiliteValue),
                                    setState(() {}),
                                    Navigator.of(context).pop(context),
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
                                  fontSize: 14,
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
