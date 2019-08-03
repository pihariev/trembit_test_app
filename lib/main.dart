import 'package:flutter/material.dart';
import 'package:trembit_test_app/route.dart' as AppRoute;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trembit Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(),
      initialRoute: AppRoute.Route.ROOT,
    );
  }
}
