import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t2t_system/models/path_model.dart';
import 'package:t2t_system/models/sensors_model.dart';
import 'package:t2t_system/widgets/custom_button.dart';
import 'package:t2t_system/widgets/custom_map.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  List<bool> switchValues = [true, false];
  @override
  void initState() {
    context.read<SensorsModel>().initSensors();
    super.initState();
  }

  @override
  void dispose() {
    context.read<SensorsModel>().dispose();
    super.dispose();
  }

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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Switch(
                      value: switchValues[0],
                      activeColor: Colors.red,
                      onChanged: (bool value) {
                        if (value == false && switchValues[1] == false) {
                        } else {
                          setState(() {
                            switchValues[0] = value;
                            if (value) {
                              context.read<PathModel>().gyroscopeMovement =
                                  true;
                              switchValues[1] = !value;
                            }
                          });
                        }
                      },
                    ),
                    const Text(
                      "Sterowanie żyroskopem",
                      softWrap: true,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Switch(
                      value: switchValues[1],
                      activeColor: Colors.red,
                      onChanged: (bool value) {
                        if (value == false && switchValues[0] == false) {
                        } else {
                          setState(() {
                            switchValues[1] = value;
                            if (value) {
                              context.read<PathModel>().gyroscopeMovement =
                                  false;
                              switchValues[0] = !value;
                            }
                          });
                        }
                      },
                    ),
                    const Text(
                      "Sterowanie żyroskopem (kierunek) + akcelerometrem (ruch)",
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
