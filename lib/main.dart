import 'package:flutter/material.dart';
import 'package:tpworld_admin/utils/colors.dart';

import 'routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Admin App',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: PRIMARY_COLOR),
          useMaterial3: true,
          fontFamily: 'Rubik'
      ),
      initialRoute: Routes.splash,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
