import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  MapPage({Key? key,required this.lat, required this.lng}) : super(key: key);
  double lat;
  double lng;

  @override
  _MapPageState createState() => _MapPageState(lat:this.lat,lng:this.lng);
}

class _MapPageState extends State<MapPage> {
  double lat;
  double lng;
  _MapPageState({required this.lat,required this.lng});
  late GoogleMapController mapController;

  LatLng _center = LatLng(25.152788, 122.5);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('地圖',
            style: TextStyle(fontSize: 30),
          ),
          backgroundColor: Colors.orange[100],
          centerTitle: true,
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(lat,lng),
            zoom: 14.0,
          ),
          markers: {
            Marker(
              markerId: MarkerId('陽明山'),
              position: LatLng(lat, lng),
            )
          },
        ),
      ),
    );
  }
}