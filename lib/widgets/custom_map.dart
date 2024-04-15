import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:t2t_system/models/path_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomFlutterMap extends StatelessWidget {
  const CustomFlutterMap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pathModel = context.read<PathModel>();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(51.509364, -0.128928),
          initialZoom: 9.2,
          onTap: (tapPosition, point) {
            pathModel.addPoint(point);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(markers: context.watch<PathModel>().markers),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () =>
                    launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
