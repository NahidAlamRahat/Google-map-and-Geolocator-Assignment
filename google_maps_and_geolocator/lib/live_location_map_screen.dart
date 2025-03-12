import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_controller.dart';


class LiveLocationMapScreen extends StatelessWidget {

  final LocationController controller = Get.put(LocationController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Real Time Location Tracker")),

floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: controller.getCurrentLocation,
        child: Icon(Icons.my_location),
        mini: true,
      ),

      body: Obx(
            () => GoogleMap(
          initialCameraPosition: CameraPosition(target: controller.myLocationMarker.value, zoom: 17),
          onMapCreated: (GoogleMapController mapCtrl) {
            controller.mapController = mapCtrl;
            controller.moveToCurrentLocation();
          },
          polylines: controller.polyLines.value,
          markers: controller.markers.value,
          myLocationEnabled: true,
        ),
      ),
    );
  }
}

