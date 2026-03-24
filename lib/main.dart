import 'package:currency_convertor/currency_convertor_material_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Types of widgets
// 1. Stateless Widget
// 2. Stateful widget
// 3. inherited widget  ( this is not for UI )

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurrencyConvertorMaterialPage(),
    );
  }
}
