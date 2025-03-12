import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  final Rxn<Position> position = Rxn<Position>();
  final Rx<LatLng> myLocationMarker = LatLng(23.7216771, 90.4165835).obs;
  final RxList<LatLng> routeCoords = <LatLng>[].obs;
  final RxSet<Polyline> polyLines = <Polyline>{}.obs;
  final RxSet<Marker> markers = <Marker>{}.obs;
  GoogleMapController? mapController;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    listenCurrentLocation();
  }

  /// Retrieves the current location of the user.
  Future<void> getCurrentLocation() async {
    if (await _checkPermission()) {
      if (await _checkGpsServiceEnable()) {
        position.value = await Geolocator.getCurrentPosition();
        updateLocation(position.value!);
        moveToCurrentLocation();

      } else {
        _requestGpsServiceEnable();
      }
    } else {
      _requestPermission();
    }
  }

  /// Continuously listens for changes in the user's location.
  Future<void> listenCurrentLocation() async {
    if (await _checkPermission()) {
      if (await _checkGpsServiceEnable()) {
         Geolocator.getPositionStream(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 10)),
        ).listen((Position newPos) {
          position.value = newPos;
          updateLocation(newPos);
          moveToCurrentLocation();
        }) ;

        moveToCurrentLocation();

      } else {
        _requestGpsServiceEnable();
      }
    } else {
      _requestPermission();
    }
  }

  /// Updates the user's location and stores it in markers and route coordinates.
  void updateLocation(Position newPosition) {
    LatLng newLatLng = LatLng(newPosition.latitude, newPosition.longitude);
    if (routeCoords.isNotEmpty) {
      routeCoords.add(newLatLng);
    } else {
      routeCoords.assignAll([newLatLng]);
    }
    myLocationMarker.value = newLatLng;
    _updatePolyline();
    _updateMarker();
  }

  /// Updates the polyline on the map with new location points.
  void _updatePolyline() {
    polyLines.value = {
      Polyline(
        polylineId: const PolylineId("route"),
        points: routeCoords,
        color: Colors.blue,
        width: 5,
      )
    };
  }

  /// Updates the marker position on the map to reflect the user's latest location.
  void _updateMarker() {
    markers.value = {
      Marker(
        markerId: const MarkerId("currentLocation"),
        position: myLocationMarker.value,
        infoWindow: InfoWindow(title: "My Current Location", snippet: "${myLocationMarker.value.latitude},${myLocationMarker.value.longitude}"),
      )
    };
  }

  /// Moves the camera to the user's current location.
  void moveToCurrentLocation() {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: myLocationMarker.value, zoom: 17)),
      );
    }
  }

  /// Checks if the app has location permission.
  Future<bool> _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  /// Requests location permission from the user if not granted.
  Future<bool> _requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  /// Checks if GPS service is enabled on the device.
  Future<bool> _checkGpsServiceEnable() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Opens the location settings if GPS is disabled.
  Future<void> _requestGpsServiceEnable() async {
    await Geolocator.openLocationSettings();
  }

}



