import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:t2t_system/widgets/custom_marker.dart';

class PathModel extends ChangeNotifier {
  final List<Marker> _markers = [];

  List<Marker> get markers => _markers;

  void addPoint(LatLng point) {
    _markers.add(
      Marker(
        point: point,
        child: CustomMarker(
          icon: const Icon(
            Icons.location_on_sharp,
            size: 40,
          ),
          count: _markers.length + 1,
        ),
      ),
    );
    notifyListeners();
  }

  void clearMarkers() {
    _markers.clear();
    notifyListeners();
  }
}
