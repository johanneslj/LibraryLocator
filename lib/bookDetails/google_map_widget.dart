import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:location/location.dart';
import 'dart:math' show cos, sqrt, asin;

class MapWidget extends StatefulWidget {
  final String selectedLibrary;

  const MapWidget({Key? key, required this.selectedLibrary}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LatLng _cameraPosition = LatLng(62.4721, 6.2355);
  Location _location = Location();
  late GoogleMapController _controller;
  Map<String, LatLng> libraries = {
    "Trondheim": LatLng(63.417459290344574, 10.404071511864087),
    "Ålesund": LatLng(62.4721, 6.2355),
    "Gjøvik": LatLng(60.788900481979894, 10.681104191626043)
  };

  Future<void> _onMapCreated(GoogleMapController _controller) async {
    _controller = _controller;
    _add();
    libraries.forEach((key, value) {
      if (widget.selectedLibrary.contains(key)) {
        _cameraPosition = value;
      }
    });
    double zoom = 12;
    var currentLocation = await _location.getLocation();
    LatLng currentLatLng = LatLng(currentLocation.latitude!, currentLocation.longitude!);
    double distance = calculateDistance(_cameraPosition, currentLatLng);
    LatLng positionToMoveTo = calculateMidpoint(currentLatLng, _cameraPosition);
    if (distance < 1) {
      zoom = 15;
    } else if (distance < 270) {
      zoom = 5.5;
    } else if (distance < 500) {
      zoom = 5;
    } else if (distance > 500) {
      zoom = 1;
    }

    _controller.animateCamera(CameraUpdate.newLatLngZoom(positionToMoveTo, zoom));
  }

  LatLng calculateMidpoint(LatLng latLng1, LatLng latLng2) {
    LatLng midpoint = LatLng(0, 0);
    double latitude;
    double longitude;
    latitude = latLng1.latitude - (latLng1.latitude - latLng2.latitude) / 2;
    longitude = latLng1.longitude - (latLng1.longitude - latLng2.longitude) / 2;

    midpoint = LatLng(latitude, longitude);

    return midpoint;
  }

  double calculateDistance(LatLng latLng1, LatLng latLng2) {
    dynamic lat1 = latLng1.latitude;
    dynamic lat2 = latLng2.latitude;
    dynamic lon1 = latLng1.longitude;
    dynamic lon2 = latLng2.longitude;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _add() {
    libraries.forEach((name, latLng) {
      var markerIdVal = name;
      final MarkerId markerId = MarkerId(markerIdVal);

      final Marker marker = new Marker(
        markerId: markerId,
        position: latLng,
        infoWindow: InfoWindow(title: markerIdVal, snippet: name, onTap: (){
          launchMap(latLng);
        }),
      );

      setState(() {
        // adding a new marker to map
        markers[markerId] = marker;
      });
    });
  }
  void launchMap(LatLng latLng) {
    MapsLauncher.launchCoordinates(latLng.latitude, latLng.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: _cameraPosition, zoom: 10),
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        markers: Set<Marker>.of(markers.values),
        mapToolbarEnabled: false,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
      ),
    );
  }
}
