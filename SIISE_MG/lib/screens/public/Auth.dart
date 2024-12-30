// ignore_for_file: prefer_const_constructors, sort_child_properties_last, file_names, avoid_print, unused_field

import 'package:flutter/material.dart';
import 'package:sise/controllers/AuthController.dart';

class AuthScreen extends StatefulWidget {
  static const String route = "/login";
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _codeComune = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 50.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/icon.png',
                  height: 100.0,
                  width: 100.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                RichText(
                  text: TextSpan(
                    text: '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    children: [
                      TextSpan(
                        text: 'SIISE',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // RichText(
                      //   text: TextSpan(
                      //     text: 'Entrer votre Code',
                      //     style: const TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 14.0,
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //   ),
                      //   textAlign: TextAlign.start,
                      // ),
                      // const SizedBox(
                      //   height: 10.0,
                      // ),
                      TextFormField(
                        onChanged: (value) => setState(
                          () => _codeComune = value,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez renseigner le Code';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Entrer votre Code : XXXXXX-XXXXXX',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        ),
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ElevatedButton(
                        onPressed: () async => {
                          if (_formKey.currentState!.validate())
                            {
                              await AuthController()
                                  .processAuthentication(context, _codeComune)
                            },
                          // print(_codeComune),
                        },
                        child: Text(
                          'Valider'.toUpperCase(),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 10,
                          ),
                          minimumSize: Size(
                            150,
                            30,
                          ),
                          elevation: 0,
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
