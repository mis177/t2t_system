import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:t2t_system/models/marker_model.dart';
import 'package:t2t_system/models/path_model.dart';
import 'package:t2t_system/models/sensors_model.dart';

class UserLocationMarker extends StatefulWidget {
  const UserLocationMarker({super.key, required this.mapController});

  final MapController mapController;
  @override
  State<UserLocationMarker> createState() => _UserLocationMarkerState();
}

class _UserLocationMarkerState extends State<UserLocationMarker> {
  @override
  Widget build(BuildContext context) {
    final pathModel = context.read<PathModel>();
    double phonePitch = 0;
    double phoneSpeed = 0;
    if (pathModel.gyroscopeMovement) {
      phonePitch = context.watch<SensorsModel>().phonePitch;
    } else {
      phonePitch = context.read<SensorsModel>().phonePitch;
      phoneSpeed = context.watch<SensorsModel>().movementSpeed;
    }
    // poczekaj na ukończenie poprzedniego ruchu użytkownika przed kolejnym
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // im większa skala mapy tym większa prędkość poruszania się
      var moveSpeedFactor = 0.05 /
          widget.mapController.camera.zoom /
          widget.mapController.camera.zoom;
      if (pathModel.gyroscopeMovement) {
        if (phonePitch.abs() > 2) {
          moveSpeedFactor = moveSpeedFactor / 30;

          pathModel.moveUser(moveSpeedFactor * phonePitch);
        }
      } else {
        if (phoneSpeed.abs() > 0.08) {
          double distance = moveSpeedFactor * phoneSpeed;
          if (phonePitch > 0) {
            distance = -distance;
          }
          pathModel.moveUser(distance);
        }
      }
    });

    return MarkerLayer(markers: [
      MyMarker(
          point: context.read<PathModel>().userMarkerPos,
          child: Transform.rotate(
            angle: degToRadian(context.watch<SensorsModel>().azimuth - 90),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.amber,
              ),
            ),
          ),
          distanceFromStart: 0)
    ]);
  }
}
