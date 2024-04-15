import 'package:flutter/material.dart';

class CustomMarker extends StatelessWidget {
  const CustomMarker({super.key, required this.icon, required this.count});
  final Icon icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Expanded(child: icon),
      ],
    );
  }
}
