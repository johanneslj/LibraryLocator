import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController mapController;

  LatLng _initialCameraPosition = LatLng(62.4721, 6.2355);
  late GoogleMapController _controller;
  Map<String, LatLng> libraries = {"Trondheim": LatLng(63.417459290344574, 10.404071511864087), "Ålesund": LatLng(62.4721, 6.2355)};

  Location _location = Location();
  double _zoom = 10;

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _add();
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _add() {
    libraries.forEach((name, latLng) {
      var markerIdVal = name;
      final MarkerId markerId = MarkerId(markerIdVal);

      // creating a new MARKER
      final Marker marker = Marker(
        markerId: markerId,
        position: latLng,
        infoWindow: InfoWindow(title: markerIdVal, snippet: name),
        onTap: () {
          launchMap(latLng);
        },
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
        initialCameraPosition: CameraPosition(target: _initialCameraPosition, zoom: 10),
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        markers: Set<Marker>.of(markers.values),
        mapToolbarEnabled: false,
      ),
    );
  }
}

