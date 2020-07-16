import 'dart:async';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart' as LocationManager;
//import 'place_detail.dart';

const kGoogleApiKey = "AIzaSyBcCunNNGvUN5WcHVS-2NkANxQzgGtP7v0";

void main() {
  runApp(MaterialApp(
    title: "PlaceZ",
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

  final homeScaffoldKey = GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _controller = Completer();
  LatLng _center = const LatLng(31.454771, 74.287727);
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  final Set<Marker> _markers = {};
  MapType _currentMapType;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: homeScaffoldKey,
        appBar: AppBar(
          title: const Text("PlaceZ"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _handlePressButton();
              },
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
//            GoogleMap(
//                onMapCreated: _onMapCreated,
//                myLocationEnabled: true,
//                initialCameraPosition:const CameraPosition(target: LatLng(0.0, 0.0)) ,
//                ),
          ],
        ));
  }

  Future<void> _handlePressButton() async {
    try {
      //final center = await getUserLocation();
      Prediction p = await PlacesAutocomplete.show(
          context: context,
          strictbounds: _center == null ? false : true,
          apiKey: kGoogleApiKey,
          onError: onError,
          mode: Mode.overlay,
          language: "en",
          types: ["cities"],
          location: _center == null
              ? null
              : Location(_center.latitude, _center.longitude),
          radius: _center == null ? null : 10000);

      print(p);

      //showDetailPlace(p.placeId);
    } catch (e) {
      return;
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }


}
