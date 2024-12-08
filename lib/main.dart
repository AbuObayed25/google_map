import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map/home_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(
    const GoogleMapsApp(),
  );
}

class GoogleMapsApp extends StatelessWidget {
  const GoogleMapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
