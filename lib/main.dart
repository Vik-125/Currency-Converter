import 'package:currency_convertor/currency_convertor_material_page.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the window manager
  await windowManager.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 400),          // Starting size
      minimumSize: Size(800, 400),   // Fixed minimum width & height
      center: true,
      title: "Currency Converter",
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
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
