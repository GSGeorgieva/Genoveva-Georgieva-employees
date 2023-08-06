// ignore_for_file: avoid_print
// ignore: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'home.dart';

void main() {
  initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Employees',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Employees')git init
    );
  }
}
