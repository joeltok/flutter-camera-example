import 'package:flutter/material.dart';

import 'camera.dart';
import 'gallery.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/camera',
      routes: {
        '/camera': (BuildContext ctx) => Camera(),
        '/gallery': (BuildContext ctx) => Gallery(),
      },
    );
  }
}

