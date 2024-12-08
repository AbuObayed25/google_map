import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _mapController;
  Marker? _userMarker;
  List<LatLng> _polylinePoints = [];
  Polyline? _polyline;
  LatLng? _lastLatLng;

  @override
  void initState() {
    super.initState();
    listenCurrentLocation();
  }

  void listenCurrentLocation() async {
    final isGranted = await isLocationPermissionGranted();
    if (isGranted) {
      final isServiceEnable = await checkGPSServiceEnable();
      if (isServiceEnable) {
        Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
          timeLimit: Duration(seconds: 10),
          //distanceFilter: 10,
          accuracy: LocationAccuracy.bestForNavigation,
        )).listen((Position pos) {
          updateLocationOnMap(pos);
        });
      } else {
        Geolocator.openLocationSettings();
      }
    } else {
      final result = await requestLocationPermission();
      if (result) {
        getCurrentLocation();
      } else {
        Geolocator.openAppSettings();
      }
    }
  }

  void updateLocationOnMap(Position pos) {
    LatLng currentLatLng = LatLng(pos.latitude, pos.longitude);

    setState(() {
      _userMarker = Marker(
        markerId: MarkerId('currentLocation'),
        position: currentLatLng,
        infoWindow: InfoWindow(
          title: 'My Current Location',
          snippet: '${pos.latitude}, ${pos.longitude}',
        ),
      );

      if (_lastLatLng != null) {
        _polylinePoints.add(currentLatLng);
        _polyline = Polyline(
          polylineId: PolylineId('trackingPolyline'),
          color: Colors.blue,
          width: 2,
          points: _polylinePoints,
        );
      }

      _lastLatLng = currentLatLng;
      // _mapController?.animateCamera(
      //   CameraUpdate.newLatLng(currentLatLng),
      // );
    });
  }

  Future<void> getCurrentLocation() async {
    final isGranted = await isLocationPermissionGranted();
    if (isGranted) {
      final isServiceEnable = await checkGPSServiceEnable();
      if (isServiceEnable) {
        Position pos = await Geolocator.getCurrentPosition();
        updateLocationOnMap(pos);
      } else {
        Geolocator.openLocationSettings();
      }
    } else {
      final result = await requestLocationPermission();
      if (result) {
        getCurrentLocation();
      } else {
        Geolocator.openAppSettings();
      }
    }
  }

  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<bool> isLocationPermissionGranted() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<bool> checkGPSServiceEnable() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Location Tracker'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            23.870990, 90.321230,
          ),
          zoom: 50,
        ),
        markers: _userMarker != null ? {_userMarker!} : {},
        polylines: _polyline != null ? {_polyline!} : {},
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        trafficEnabled: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  23.870990, 90.321230,
                ),
                zoom: 17,
              ),
            ),
          );
        },
        child: Icon(Icons.location_history),
      ),
    );
  }
}
