import 'package:flutter/material.dart';
import 'Strings.dart';
import 'MoviesListWidget.dart';

void main() => runApp(MoviesApp());

class MoviesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'Movies',
      home: new MoviesListWidget()
    );
  }
}