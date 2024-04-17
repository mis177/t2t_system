import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

import 'package:t2t_system/models/marker_model.dart';

class PathModel extends ChangeNotifier {
  final List<MyMarker> _markers = [];
  final Map _userMarker = {"pos": const LatLng(0, 0), "distanceFromStart": 0};

  bool gyroscopeMovement = true;

  final List<Polyline> _pathLines = [];
  LatLng get userMarkerPos => _userMarker["pos"];
  List<Marker> get markers => _markers;

  List<Polyline> get pathLines => _pathLines;
  LatLng? userPosition;

  // dodanie nowego punktu trasy
  void addPoint(LatLng point) {
    Color polylineColor = Colors.brown;
    Color markerColor = Colors.black;
    if (_markers.isNotEmpty) {
      _pathLines.add(
        Polyline(
          strokeWidth: 5,
          isDotted: true,
          color: polylineColor,
          points: [_markers.last.point, point],
        ),
      );
    }

    if (_markers.isEmpty) {
      markerColor = Colors.green;
    }
    double distanceFromStart = 0;
    if (_markers.isNotEmpty) {
      distanceFromStart = _markers.last.distanceFromStart +
          sqrt(pow(point.latitude - _markers.last.point.latitude, 2) +
              pow(point.longitude - _markers.last.point.longitude, 2));
    }

    MyMarker newMarker = MyMarker(
      point: point,
      child: Center(
        child: Icon(
          color: markerColor,
          Icons.circle,
          size: 20,
        ),
      ),
      distanceFromStart: double.parse(distanceFromStart.toStringAsFixed(8)),
    );

    if (_markers.isEmpty) {
      _userMarker["pos"] = newMarker.point;
      _userMarker["distanceFromStart"] = newMarker.distanceFromStart;
    }

    _markers.add(newMarker);

    notifyListeners();
  }

  // reset trasy
  void clearMarkers() {
    _markers.clear();
    _pathLines.clear();
    _userMarker["pos"] = const LatLng(0, 0);
    _userMarker["distanceFromStart"] = 0;

    notifyListeners();
  }

  // przesunięcie wektora użytkownika
  void moveUser(double distance) {
    bool movingBackwards = distance < 0;
    LatLng startPoint = _userMarker["pos"];
    MyMarker? nextPoint;
    if (!movingBackwards) {
      for (var node in _markers) {
        if (node.distanceFromStart > _userMarker["distanceFromStart"]) {
          nextPoint = node;

          break;
        }
      }
    } else {
      for (var node in _markers.reversed) {
        if (node.distanceFromStart < _userMarker["distanceFromStart"]) {
          nextPoint = node;
          break;
        }
      }
    }

    // nie jesteśmy w ostatnim punkcie
    if (nextPoint != null) {
      LatLng endPoint = nextPoint.point;
      double startEndDistance = sqrt(
          pow(endPoint.latitude - startPoint.latitude, 2) +
              pow(endPoint.longitude - startPoint.longitude, 2));

      double previousDistance = _userMarker["distanceFromStart"];

      // dystans jest większy i musimy minąć jeden z punktów trasy, idziemy najpierw do niego, potem pozostałą trasę
      if (distance.abs() > startEndDistance) {
        _userMarker["pos"] = LatLng(endPoint.latitude, endPoint.longitude);
        _userMarker["distanceFromStart"] = nextPoint.distanceFromStart;

        // użytkownik dotarł do końca trasy lub do początku
        if (_markers.last.point == nextPoint.point ||
            _markers[0].point == nextPoint.point) {
          notifyListeners();
        }
        // przechodzimy pozostały dystans od nowego punktu
        else {
          if (!movingBackwards) {
            moveUser(distance - startEndDistance);
          } else {
            moveUser(distance + startEndDistance);
          }
        }
      } else {
        double t = distance / startEndDistance;
        if (movingBackwards) {
          t = -distance / startEndDistance;
        }

        double x = (1 - t) * startPoint.latitude + t * endPoint.latitude;
        double y = (1 - t) * startPoint.longitude + t * endPoint.longitude;
        _userMarker["pos"] = LatLng(x, y);
        _userMarker["distanceFromStart"] =
            previousDistance + double.parse(distance.toStringAsFixed(8));
        notifyListeners();
      }
    }
  }
}
