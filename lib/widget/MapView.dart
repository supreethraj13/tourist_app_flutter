import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Mapview extends StatefulWidget {
  const Mapview({Key? key}) : super(key: key);

  @override
  State<Mapview> createState() => _MapviewState();
}

class _MapviewState extends State<Mapview> {
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();
  StreamSubscription<Position>? _positionStreamSubscription;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(12.9716, 77.5946),
    zoom: 12.0,
  );

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _startListeningToLocation();
  }

  void _startListeningToLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permissions are denied. Cannot show live location.',
            ),
          ),
        );
      }
      return;
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            if (mounted) {
              setState(() {
                _markers.clear();
                _markers.add(
                  Marker(
                    markerId: const MarkerId('currentLocation'),
                    position: LatLng(position.latitude, position.longitude),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure,
                    ),
                    infoWindow: const InfoWindow(title: 'My Current Location'),
                  ),
                );
              });
              _animateCameraToPosition(position);
            }
          },
        );
  }

  void _animateCameraToPosition(Position position) async {
    final GoogleMapController controller = await _mapControllerCompleter.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16.0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // **FIX:** Return the map inside a sized container, NOT a Scaffold.
    return SizedBox(
      height: 250, // Give the map a fixed height
      child: ClipRRect(
        // Ensures the map respects the Card's rounded corners
        borderRadius: BorderRadius.circular(15.0),
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: (GoogleMapController controller) {
            if (!_mapControllerCompleter.isCompleted) {
              _mapControllerCompleter.complete(controller);
            }
          },
          markers: _markers,
          myLocationButtonEnabled: false,
          zoomControlsEnabled:
              false, // Turned off for a cleaner look in the card
        ),
      ),
    );
  }
}
