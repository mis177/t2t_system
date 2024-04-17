import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:t2t_system/models/path_model.dart';
import 'package:t2t_system/models/user_location_marker.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomFlutterMap extends StatefulWidget {
  const CustomFlutterMap({
    super.key,
  });

  @override
  State<CustomFlutterMap> createState() => _CustomFlutterMapState();
}

class _CustomFlutterMapState extends State<CustomFlutterMap> {
  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final pathModel = context.read<PathModel>();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: const LatLng(52.20652, 21.06425),
          initialZoom: 18,
          onTap: (tapPosition, point) {
            pathModel.addPoint(point);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          PolylineLayer(polylines: context.watch<PathModel>().pathLines),
          MarkerLayer(markers: context.watch<PathModel>().markers),
          UserLocationMarker(mapController: mapController),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () =>
                    launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
              const TextSourceAttribution('Michał Jamroz')
            ],
          ),
        ],
      ),
    );
  }
}
