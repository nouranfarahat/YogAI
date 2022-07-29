import 'dart:math';

import 'package:flutter/cupertino.dart';


import 'package:flutter/material.dart';

import '../data/models/camera_view_singelton.dart';


//import 'camera_view_singelton.dart';

/// Represents the recognition output from the model
class Recognition {

  double? _score;

  Point? _location ;

  Recognition(this._location , this._score , this.color_);

  Point? get location => _location;
  double? get score => _score;
  Color ?color_ = Colors.red[900];

  /// Returns bounding box rectangle corresponding to the
  /// displayed image on screen
  ///
  /// This is the actual location where rectangle is rendered on
  /// the screen
  ////////////////////////////////////////////////////////////////////TODO:ADD RENDER
  Point get renderLocation {
    // ratioX = screenWidth / imageInputWidth
    // ratioY = ratioX if image fits screenWidth with aspectRatio = constant
    //print("after Israa --> MediaQuery.of(context).size = " + CameraViewSingleton.screenSize.toString());

    double ?ratioX = CameraViewSingleton.ratio;
    double ?ratioY = ratioX;

    double ?transLeft = max(0.1, (location!.x )* ratioX!);
    double? transTop = max(0.1, location!.y * ratioY!);


    Point transformedPoint = Point(transLeft , transTop);
    return transformedPoint;
  }

  @override
  String toString() {
    return 'Recognition(point: $location, score: $score)\n';
  }
}