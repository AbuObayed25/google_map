import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: GoogleMap(
        mapType: MapType.satellite,
        initialCameraPosition: CameraPosition(
          zoom: 16,
          target: LatLng(
            23.870992157514575,
            90.32124268086771,
          ),
        ),
        onTap: (LatLng? latLng) {
          print(latLng);
        },
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
        trafficEnabled: true,
        markers: <Marker>{
          const Marker(
            markerId: MarkerId('Initial_position'),
            position: LatLng(
              23.870992157514575,
              90.32124268086771,
            ),
          ),
          Marker(
            markerId: MarkerId('home'),
            position: LatLng(
              23.870992157514575,
              90.32124268086771,
            ),
            infoWindow: InfoWindow(title: 'Home'),
            onTap: () {
              print('On Tapped home');
            },
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta,
            ),
            draggable: true,
            onDragStart: (LatLng onStartLatLng) {
              print('On start drag $onStartLatLng');
            },
            onDragEnd: (LatLng onStopLatLng) {
              print('On end drag $onStopLatLng');
            },
          ),
        },
        circles: <Circle>{
          Circle(
            circleId: CircleId('dengue_circle'),
            fillColor: Colors.red.withOpacity(.2),
            center: LatLng(
              23.870992157514575,
              90.32124268086771,
            ),
            strokeColor: Colors.blue,
            strokeWidth: 1.3,
            radius: 350,
            visible: true,
          ),
          Circle(
            circleId: CircleId('Corona_circle'),
            fillColor: Colors.red.withOpacity(.2),
            center: LatLng(
              23.870992157514575, //need to change the LatLng address
              90.32124268086771,
            ),
            strokeColor: Colors.blue,
            strokeWidth: 1.3,
            radius: 750,
            visible: true,
          ),
        },
        polylines: <Polyline>{
          Polyline(
              polylineId: PolylineId('Random'),
              color: Colors.pinkAccent,
              width: 3,
              jointType: JointType.round,
              points: <LatLng>[
                //need to LatLng address
              ])
        },
        polygons: <Polygon>{
          Polygon(
              polygonId: PolygonId('poly'),
              fillColor: Colors.yellow.withOpacity(.2),
              strokeColor: Colors.orangeAccent,
              strokeWidth: 4,
              points: <LatLng>[
                //need to add LatLng address
              ])
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          googleMapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 16,
              target: LatLng(23.870992157514575,
                90.32124268086771,),
            ),
           ),
          ),
        },
        child: Icon(Icons.location_history),
      ),
    );
  }
}
