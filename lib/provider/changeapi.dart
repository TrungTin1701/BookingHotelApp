// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChangeLocation with ChangeNotifier {
  CameraPosition kGooglePlex1 = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15.3,
  );
  void changeLocation(CameraPosition position) {
    kGooglePlex1 = position;
    print(" alooo => ${position.toString()}");
    notifyListeners();
  }
}
