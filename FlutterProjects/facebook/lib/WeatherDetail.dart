import 'dart:convert';
import 'dart:ffi';
import 'package:facebook/Data/weather.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'Data/weather.dart';

class WeatherDetail extends StatefulWidget {
  Prediction prediction;

  WeatherDetail(Prediction prediction) {
    this.prediction = prediction;
  }

  @override
  _WeatherDetailScreenState createState() => new _WeatherDetailScreenState();

}
class _WeatherDetailScreenState extends State<WeatherDetail> {


  static const baseUrl = 'https://www.metaweather.com';
  PlacesDetailsResponse place;
  bool isLoading = false;
  String errorLoading;
  Weather cityWeather;
  MaterialColor gradiantColor;
  @override
  void initState() {
    fetchPlaceDetail();
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
      title: Text("Weather detail"),
    );
  }
  Widget _body() {
    Widget body;
    if (errorLoading != null) {
      body = _errorView(errorLoading);
    } else if(cityWeather == null) {
      body = _loader();
    } else {

      body = Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.6, 0.8, 1.0],
            colors: [
              gradiantColor[700],
              gradiantColor[500],
              gradiantColor[300],
            ],
          ),
        ),
          child: ListView(
            children: <Widget>[
              _locationName(),
              _updatedAt(),
              _temperature(),
            ],
          )
      );
    }
    return body;
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
          child: Text(
            errorMessage,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal
            ),
          ),
        )
    );
  }
  _locationName() {
    return Padding(
      padding: EdgeInsets.only(top: 100.0),
      child: Center(
        child: Text(
          cityWeather.location,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
  _updatedAt() {
    return  Center(
      child: Text(
        'Updated: ${TimeOfDay.fromDateTime(cityWeather.lastUpdated).format(context)}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w200,
          color: Colors.white,
        ),
      ),
    );
  }
  _temperature() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50.0),
      child: Center(
        child: getTemperatureWidget(),
      ),
    );
  }
  Widget getTemperatureWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: cityWeather.getWeatherImage(),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  _currentTemperature(),
                  _minmaxTemperature()
                ],
              ),
            ),
          ],
        ),
        Center(
          child: Text(
            cityWeather.formattedCondition,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w200,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
  _minmaxTemperature() {
    return Column(
      children: [
        Text(
          'max: ${(cityWeather.maxTemp.round())}°',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w100,
            color: Colors.white,
          ),
        ),
        Text(
          'min: ${(cityWeather.minTemp.round())}°',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w100,
            color: Colors.white,
          ),
        )
      ],
    );
  }
  _currentTemperature() {
    return Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: Text(
        '${(cityWeather.temp.round())}°',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
  Future<int> getLocationId(String city) async {

    final cityString = city.split(',').first;

    final locationUrl = '$baseUrl/api/location/search/?query=$cityString';
    final locationResponse = await http.get(locationUrl);
    if (locationResponse.statusCode != 200) {
      throw Exception('error getting locationId for city');
    }

    final locationJson = jsonDecode(locationResponse.body) as List;
    print(locationJson);
    if(!locationJson.isEmpty) {
      fetchWeather((locationJson.first)['woeid']);
    } else {
      setState(() {
        errorLoading = "Sorry we couldn't fetch weather data for this city. Please try again later";
      });
    }
  }
  Future<Void> fetchWeather(int locationId) async {
    final weatherUrl = '$baseUrl/api/location/$locationId';
    final weatherResponse = await http.get(weatherUrl);

    if (weatherResponse.statusCode != 200) {
      throw Exception('error getting weather for location');
    }

    final weatherJson = jsonDecode(weatherResponse.body);


    if (weatherJson != null) {
      setState(() {
        errorLoading = null;
        cityWeather = Weather.fromJson(weatherJson);
        gradiantColor = cityWeather.colorForWeatherCondition();
      });
    } else {
      setState(() {
        errorLoading = "Sorry we couldn't fetch weather data. Please try again later";
      });
    }

  }
  void fetchPlaceDetail() async {
    getLocationId(widget.prediction.description);
  }

}