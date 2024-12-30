// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, duplicate_ignore, depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sise/screens/auth/HomeScreen.dart';
import 'package:sise/screens/auth/ProjectScreen.dart';
import 'package:sise/screens/public/Main.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// void main() => runApp(App());

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(App());
}

class App extends StatelessWidget {
  static Map<String, StatefulWidget Function(dynamic)> routes = {
    MainScreen.route: (ctx) => const MainScreen(),
    HomeScreenAuth.route: (ctx) => const HomeScreenAuth(),
    ProjectScreenAuth.route: (ctx) => const ProjectScreenAuth(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIISE',
      // ignore: prefer_const_literals_to_create_immutables
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // ignore: prefer_const_literals_to_create_immutables
      supportedLocales: [
        const Locale('fr', 'FR'),
        const Locale('en', 'EN'),
      ],
      locale: const Locale('fr'),
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: MainScreen.route,
      routes: routes,
    );
  }
}
