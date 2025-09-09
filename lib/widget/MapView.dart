import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Create a new StatefulWidget for your map
class MapView extends StatefulWidget {
  final double lat;
  final double lng;

  const MapView({Key? key, required this.lat, required this.lng})
    : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  late LatLng _center;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Use the passed lat/lng for the initial position
    _center = LatLng(widget.lat, widget.lng);
    // Add a marker for the initial position
    _markers.add(
      Marker(
        markerId: const MarkerId('initial-position'),
        position: _center,
        infoWindow: const InfoWindow(
          title: 'Selected Location',
          snippet: 'This is the spot!',
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    // Use a Card for elevation and rounded corners, just like your original design
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      // ClipRRect ensures the map respects the card's rounded corners
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          height: 300, // You must give the map a defined height
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0, // Adjust zoom level as needed
            ),
            markers: _markers, // Display the marker on the map
            // Optional: Customize map UI
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
        ),
      ),
    );
  }
}
