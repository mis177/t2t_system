import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t2t_system/models/path_model.dart';
import 'package:t2t_system/widgets/custom_button.dart';
import 'package:t2t_system/widgets/custom_map.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Expanded(
            flex: 4,
            child: CustomFlutterMap(),
          ),
          CustomButton(
            color: Colors.green,
            onTap: () {
              final pathModel = context.read<PathModel>();
              pathModel.clearMarkers();
            },
            child: const Text("Draw new path"),
          )
        ],
      ),
    );
  }
}
