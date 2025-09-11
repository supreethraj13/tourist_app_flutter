import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_tourist/services/api_service.dart';

class LocationService extends ChangeNotifier {
  Position? _currentPosition;
  bool _isTracking = false;
  Timer? _locationTimer;
  String _locationStatus = 'Location not available';
  
  Position? get currentPosition => _currentPosition;
  bool get isTracking => _isTracking;
  String get locationStatus => _locationStatus;
  
  // Check and request permissions
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _locationStatus = 'Location services are disabled';
      notifyListeners();
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _locationStatus = 'Location permissions are denied';
        notifyListeners();
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      _locationStatus = 'Location permissions are permanently denied';
      notifyListeners();
      return false;
    }

    return true;
  }

  // Get current location
  Future<void> getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );
      
      _currentPosition = position;
      _locationStatus = 'Location updated successfully';
      notifyListeners();
      
      // Send to backend
      await ApiService.updateLocation(
        position.latitude, 
        position.longitude, 
        'Auto-detected location'
      );
      
    } catch (e) {
      _locationStatus = 'Failed to get location: $e';
      notifyListeners();
    }
  }

  // Start automatic tracking (every 2 minutes)
  void startLocationTracking() {
    if (_isTracking) return;
    
    _isTracking = true;
    notifyListeners();
    
    _locationTimer = Timer.periodic(Duration(minutes: 2), (timer) {
      getCurrentLocation();
    });
  }

  // Stop tracking
  void stopLocationTracking() {
    _locationTimer?.cancel();
    _isTracking = false;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }
}
