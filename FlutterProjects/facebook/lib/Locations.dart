
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'Helper/Constants.dart';
import 'package:http/http.dart' as http;
import 'WeatherDetail.dart';

class Locations extends StatefulWidget {

  @override
  _LocationScreenState createState() => new _LocationScreenState();

}
class _LocationScreenState extends State<Locations> {

  List<Prediction> places = [];
  bool isLoading = false;
  String errorMessage = "Please Select a Location";
  bool activeSearch;
  @override
  void initState() {
    super.initState();
    activeSearch = false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }
  PreferredSizeWidget _appBar() {
    if (activeSearch) {
      return AppBar(
        leading: Icon(Icons.search),
        title: TextField(
          enabled: true,
          style: TextStyle(
              color: Colors.white
          ),
          cursorColor: Colors.white,
          onSubmitted: _search,
          decoration: InputDecoration(
            hintText: "here's a hint",
            hintStyle: TextStyle(
              color: Colors.white
            ),
            enabled: true,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              setState(() {
                activeSearch = false;
              });
            },
          )
        ],
      );
    } else {
      return AppBar(
        title: Text("My App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                activeSearch = true;
              });
            },
          ),
        ],
      );
    }
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
          child: Text(
            f.description,
          ),
        )
      ];

      return Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
        child: Card(
          child: InkWell(
            onTap: () {
              showWeatherDetailForPlace(f);
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

    return ListView(children: placesWidget);
  }
  void _search(String queryString) {
    _getAutoCompletePlaces(queryString);
    print(queryString);
  }
  void _getAutoCompletePlaces(String query) async {

    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });

    String key =  Constants.map_key;
    String api = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final url = "$api?input=$query&language=en-AU&types=(cities)&key=$key";

    http.Response response = await http.get(url);// as PlacesAutocompleteResponse;
    Map parsed = json.decode(response.body);
    String error = parsed['error_message'];
    List<Prediction> predictions_  = (parsed['predictions'] as List).map((i) => Prediction.fromJson(i)).toList();

    setState(() {
      this.errorMessage = error;
      this.isLoading = false;
      this.places = predictions_;
    });
  }
  Future<Null> showWeatherDetailForPlace(Prediction prediction) async {
    if (prediction != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WeatherDetail(prediction)),
      );
    }
  }
}