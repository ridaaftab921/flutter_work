
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'Helper/Constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;
import 'ResturantDetail.dart';


class NearByResturants extends StatefulWidget {

  @override
  NearByResturantsState createState() => new NearByResturantsState();

}
class NearByResturantsState extends State<NearByResturants> {

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Constants.map_key);

  List<PlacesSearchResult> places = [];
  bool isLoading = false;
  String errorMessage;

  @override
  void initState() {
    getResturants();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }
  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text("Resturants"),
    );
  }
  _body() {
    if (isLoading) {
      return _loader();
    } else if (errorMessage != null) {
       return _errorView(errorMessage);
    } else {
      return buildPlacesList();
    }
  }
  _loader() {
    return Center(
        child: CircularProgressIndicator(value: null)
    );
  }
  _errorView(String errorMessage) {
    return Center(
        child: Padding(
          padding: EdgeInsets.all(28.0),
          child: Text(errorMessage),
        )
    );
  }
  ListView buildPlacesList() {
    final placesWidget = places.map((f) {
      List<Widget> list = [
        Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Text(f.name,),
        )
      ];

      if (f.vicinity != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text( f.vicinity,),
        ));
      }

      return Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
        child: Card(
          child: InkWell(
            onTap: () {
              showDetailPlace(f.placeId);
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: list,
              ),
            ),
          ),
        ),
      );
    }).toList();

//    return ListView(shrinkWrap: true, children: placesWidget);
    return ListView(children: placesWidget);
  }
  Future<Null> showDetailPlace(String placeId) async {
    if (placeId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResturantDetail(placeId) ),
      );
    }
  }
  void getResturants() async {
//    final center = await getUserLocation();
    final center = LatLng(31.454771,74.287727);
    if (center == null) {
      setStateForErrorMessage( "Unable to fetch Resturants for this Location");

    } else {
      getNearbyPlaces(center);
    }
  }
  Future<LatLng> getUserLocation() async {
    var currentLocation = <String, double>{};

    final location = LocationManager.Location();
    if(location.hasPermission() != null) {
      try {
        currentLocation = await location.getLocation();
        final lat = currentLocation["latitude"];
        final lng = currentLocation["longitude"];
        return LatLng(lat, lng);
      } on Exception {
        currentLocation = null;
        return null;
      }
    } else {
      setStateForErrorMessage( "App does not have the permission for current Location. Please check in settings");
    }
  }
  void setStateForErrorMessage(String errorMessage) {
    setState(() {
      this.isLoading = false;
      this.errorMessage = errorMessage;
    });
  }
  void getNearbyPlaces(LatLng center) async {
    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });

    final location = Location(center.latitude, center.longitude);
    final result = await _places.searchNearbyWithRadius(location, 25000, type: "restaurant");
    setState(() {
      this.isLoading = false;
      if (result.status == "OK") {
        this.places = result.results;
      } else {
        this.errorMessage = result.errorMessage;
      }
    });
  }
}