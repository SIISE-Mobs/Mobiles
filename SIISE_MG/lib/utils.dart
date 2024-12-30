// ignore_for_file: file_names, non_constant_identifier_names, sized_box_for_whitespace, unused_local_variable, deprecated_member_use

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

abstract class UtilsBehavior {
  static void showCircularIndicator(context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.blueGrey.withAlpha(100),
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      context: context,
    );
  }

  static void hideCircularIndocator(context) {
    Navigator.of(context).pop();
  }

  static formatCurrency(montant) {
    var formatter = NumberFormat('#,###');
    String amount = '0.0';
    if (montant != '') {
      amount = montant;
    }

    return (formatter
            .format(double.parse(amount.toString()))
            .replaceAll(',', ' '))
        .toString();
  }

  static formatDateFr(dateStr) {
    if (dateStr.toString() == '') {
      return '';
    }
    initializeDateFormatting();
    DateTime date = DateTime.parse(dateStr);
    var formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(date);
    return formattedDate;
  }

  static showImageStr(StringImage) {
    if (StringImage != null && StringImage != '') {
      return Container(
        height: 100,
        width: 100,
        child: Image.memory(
          base64Decode(StringImage),
        ),
      );
    }
    return Container(
      height: 100,
      width: 100,
      child: const Text(
        '',
      ),
    );
  }

  static showImageStrList(StringImage) {
    if (StringImage != null && StringImage != '') {
      return Container(
        height: 60,
        // width: 100,
        child: Image.memory(
          base64Decode(StringImage),
        ),
      );
    }
    return Container(
      height: 60,
      // width: 100,
      child: const Text(
        '',
      ),
    );
  }

  static int generateRandomInt(int max) {
    Random random = Random();
    return random.nextInt(max);
  }

  static void showImageDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(" - Taille image - "),
          content: const Text(
              "La taille de l'image est trop grande, veuillez reduire jusqu'à 1Mo."),
          actions: <Widget>[
            TextButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
