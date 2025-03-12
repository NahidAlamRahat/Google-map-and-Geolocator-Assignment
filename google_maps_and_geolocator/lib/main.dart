import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'live_location_map_screen.dart';

void main(){
  runApp(const GoogleMapsApp());

}

class GoogleMapsApp extends StatefulWidget {
  const GoogleMapsApp({super.key});
  @override
  State<GoogleMapsApp> createState() => _GoogleMapsAppState();

}
class _GoogleMapsAppState extends State<GoogleMapsApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LiveLocationMapScreen() ,
    );
  }
}
