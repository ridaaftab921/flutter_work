import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movies_app/Movie.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Strings.dart';
import 'Movie.dart';

class MoviesState extends State<MoviesListWidget> {

  var movieList = [];
  //var _list = <Movie>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  var image_url = 'https://image.tmdb.org/t/p/w500/';
  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(Strings.appTitle),
      ),
      body: new ListView.builder(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          itemCount: movieList.length,
          itemBuilder: (BuildContext context, int pos) {
            return _buildRow(pos);
          }),
    ) ;
  }


  Widget _buildRow(int i) {
    return ListTile(
      title: new Text("${movieList[i]["Title"]}", style: _biggerFont),
      leading: new CircleAvatar(
        backgroundColor: Colors.green,
//        backgroundImage: new NetworkImage(_list[i].avatarUrl),
      ),
    );
    //return new Text("${_list[i]["login"]}", style: _biggerFont);
  }


  _loadData() async {
    String dataUrl = "http://www.omdbapi.com/?i=tt3896198&apikey=2b107971";
    http.Response response = await http.get(dataUrl);
    setState(() {
      movieList = json.decode(response.body);
      print(response.body);
//      final moviesJSON = json.decode(response.body);
//      for ( var movieItem in moviesJSON) {
//        final movie = new Movie(movieItem["title"], movieItem["Poster"]);
//        _list.add(movie);
//      }
    });
  }

}

class MoviesListWidget extends StatefulWidget {

  @override
  createState() => new MoviesState();

}