import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'Helper/Constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class ResturantDetail extends StatefulWidget {
  String placeId;

  ResturantDetail(String placeId) {
    this.placeId = placeId;
  }

  @override
  _ResturantDetailScreenState createState() => new _ResturantDetailScreenState();

}
class _ResturantDetailScreenState extends State<ResturantDetail> {

  PlacesDetailsResponse place;
  bool isLoading = false;
  String errorMessage;

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Constants.map_key);

  @override
  void initState() {
    fetchPlaceDetail();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: _body()
    );
  }
  _appBar() {
    final placeDetail = place.result;
    String title = placeDetail.name;

    return AppBar(
      title: Text(title),
    );
  }
  _body() {
    if (isLoading) {
      return _loader();
    } else if (errorMessage != null) {
      return _errorView(errorMessage);
    } else {
      return _resturantDetail();
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
  _resturantDetail() {
    final placeDetail = place.result;
    final location = place.result.geometry.location;
    final lat = location.lat;
    final lng = location.lng;
    final center = LatLng(lat, lng);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
            child: SizedBox(
              height: 200.0,
//                child: GoogleMap(
//                  onMapCreated: _onMapCreated,
//                  options: GoogleMapOptions(
//                      myLocationEnabled: true,
//                      cameraPosition: CameraPosition(target: center, zoom: 15.0)),
//                ),
            )),
        Expanded(
          child: buildPlaceDetailList(placeDetail),
        )
      ],
    );
  }
  void fetchPlaceDetail() async {
    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });

    PlacesDetailsResponse place =
    await _places.getDetailsByPlaceId(widget.placeId);
    setState(() {
      this.isLoading = false;
      if (place.status == "OK") {
        this.place = place;
      } else {
        this.errorMessage = place.errorMessage;
      }
    });
  }

  ListView buildPlaceDetailList(PlaceDetails placeDetail) {
    List<Widget> list = [];
    if (placeDetail.photos != null) {
      final photos = placeDetail.photos;
      list.add(SizedBox(
          height: 100.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.only(right: 1.0),
                    child: SizedBox(
                        height: 100
                    ));
              })));
    }

    list.add(
      Padding(
          padding:
          EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
          child: Text(
            placeDetail.name,
            style: Theme.of(context).textTheme.subtitle,
          )),
    );

    if (placeDetail.formattedAddress != null) {
      list.add(
        Padding(
            padding:
            EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              placeDetail.formattedAddress,
              style: Theme.of(context).textTheme.body1,
            )),
      );
    }

    if (placeDetail.types?.first != null) {
      list.add(
        Padding(
            padding:
            EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 0.0),
            child: Text(
              placeDetail.types.first.toUpperCase(),
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    if (placeDetail.formattedPhoneNumber != null) {
      list.add(
        Padding(
            padding:
            EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              placeDetail.formattedPhoneNumber,
              style: Theme.of(context).textTheme.button,
            )),
      );
    }

    if (placeDetail.openingHours != null) {
      final openingHour = placeDetail.openingHours;
      var text = '';
      if (openingHour.openNow) {
        text = 'Opening Now';
      } else {
        text = 'Closed';
      }
      list.add(
        Padding(
            padding:
            EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    if (placeDetail.website != null) {
      list.add(
        Padding(
            padding:
            EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              placeDetail.website,
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    if (placeDetail.rating != null) {
      list.add(
        Padding(
            padding:
            EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              "Rating: ${placeDetail.rating}",
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    return ListView(
      shrinkWrap: true,
      children: list,
    );
  }
}