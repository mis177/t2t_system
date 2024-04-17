import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t2t_system/models/path_model.dart';
import 'package:t2t_system/models/sensors_model.dart';
import 'package:t2t_system/views/map_view.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => PathModel(),
      ),
      ChangeNotifierProvider(
        create: (context) => SensorsModel(),
      ),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapView(),
    );
  }
}
