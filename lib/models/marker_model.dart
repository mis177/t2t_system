import 'package:flutter_map/flutter_map.dart';

class MyMarker extends Marker {
  final double distanceFromStart;
  const MyMarker({
    required super.point,
    required super.child,
    required this.distanceFromStart,
    markerAlignment,
    markerRotate,
  }) : super(alignment: markerAlignment, rotate: markerRotate);
}
