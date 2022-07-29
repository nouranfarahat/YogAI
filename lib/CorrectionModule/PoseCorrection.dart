import 'dart:math';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

//import 'dart:html';
///import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart' ;

import '../tflite/recognition.dart';
import 'PoseAngles.dart';

class PoseCorrection_repository {
  /*// TensorFlow Lite Interpreter object
  Interpreter? _ComparetorNet_interpreter;*/
  static int cnt=0;
  var joints_map = {
    "left_shoulder": 0,
    "right_shoulder": 1,
    "left_elbow": 2,
    "right_elbow": 3,
    "left_wrist": 4,
    "right_wrist": 5,
    "left_hip": 6,
    "right_hip": 7,
    "left_knee": 8,
    "right_knee": 9,
    "left_ankle": 10,
    "right_ankle": 11,
    "thorax": 12,
    "pelvis": 13
  };

  var wrong_angles = [];
  // TensorFlow Lite Interpreter object
   Interpreter? _ComparetorNet_interpreter;

  //todo: Manager
  dynamic manager(List<double> results, String pose_name) {
    cnt++;
    var extracted_points = extract_points(results);
    /*print("extracted_points length : ");
    print(results.length);*/

    var preproccessed_points = model_preprocess(extracted_points);

    var c_arr = correct_pose(preproccessed_points, pose_name);

    //print("poseName in manger:  " + pose_name + "  ------------------------------------------------------------------------");
    var x_arr = List.filled(17, Colors.red[900], growable: false);
    if(cnt%2 == 0)  x_arr = List.filled(17, Colors.green[900], growable: false);
    return c_arr;
  }

  load_ComparatorNet_Model() async
  {
    _ComparetorNet_interpreter = await Interpreter.fromAsset("pose_classifier2_14.tflite");
    //
    print('ComparetorNet loaded successfully');

    /*PoseCorrection.get_interpreter(_ComparetorNet_interpreter);
    print('Interprreter sent successfully');*/
  }

  correct_pose(var extracted_input , String pose_name) //extracted input -->processed (scaled + normalized)
  {
    var c_arr = List.filled(17, Colors.green[900], growable: false );
    PoseAngles poseAngles = new PoseAngles();

    wrong_angles = poseAngles.check_ranges(pose_name, extracted_input);

    for (var i in wrong_angles)
      {
        c_arr[i] = Colors.red[900];
      }

    if(wrong_angles.length > 2)
      return List.filled(17, Colors.red[900], growable: false );
    /*
    for(int i=0;i<wrong_joints_index.length;i++)
    {
      C_arr[wrong_joints_index[i]] = Colors.red[900];
    }
    */
    return c_arr;
  }

  /*PoseCorrection_repository({ Interpreter? interpreter}) {
    load_ComparatorNet_Model();
  }*/

  List<dynamic> extract_points(var results) //return 51
  {
    var x_list = [];
    var y_list = [];
    dynamic fused_list = [];
    //print("outside re loop");

    for (int i = 5; i < 17; i++) //without nose ,2 eyes,2 ears
        {
      var x = results[i * 3];
      var y = results[i * 3 + 1];
      x_list.add(x);
      y_list.add(y);
    }

    //get thorax
    var x = (x_list[joints_map["right_shoulder"]! ] +
        x_list[joints_map["left_shoulder"]! ]) / 2;
    var y = (y_list[joints_map["right_shoulder"]! ] +
        y_list[joints_map["left_shoulder"]! ]) / 2;
    x_list.add(x);
    y_list.add(y);

    //get Pelvis
    x = (x_list[joints_map["right_hip"]! ] + x_list[joints_map["left_hip"]! ]) /
        2;
    y = (y_list[joints_map["right_hip"]! ] + y_list[joints_map["left_hip"]! ]) /
        2;
    x_list.add(x);
    y_list.add(y);


   /* print("extracted points size : ");
    print(x_list.length);*/

    return [x_list, y_list];
  }

  List<dynamic> model_preprocess(List<dynamic> extracted_points) {
    //input 14 points
    //print("preprocess function : ");
    int sz = extracted_points.length;

    var normalized_list = scale_transform_normalize(
        extracted_points[0], extracted_points[1]);

    return normalized_list;
  }

  List<dynamic> scale_transform_normalize(List<dynamic> x_list, List<dynamic> y_list) {
    //input 14 points
    //print("preprocess function : ");
    int sz = 2; //extracted_points.length;
    //print(sz);

    //scale_transform
    var numOfKeypoints = x_list.length;

    var max_x = x_list.reduce((curr, next) => curr > next ? curr : next);
    var min_x = x_list.reduce((curr, next) => curr < next ? curr : next);
    var max_y = y_list.reduce((curr, next) => curr > next ? curr : next);
    var min_y = y_list.reduce((curr, next) => curr < next ? curr : next);
    var mean_x = x_list.reduce((a, b) => a + b) / numOfKeypoints;
    var mean_y = y_list.reduce((a, b) => a + b) / numOfKeypoints;

    var width = max_x - min_x;
    var height = max_y - min_y;

    var scaleFactor = [width, height].reduce((curr, next) =>
    curr > next
        ? curr
        : next);

    /*for (int i = 0; i < numOfKeypoints; i++) {
      x_list[i] = (x_list[i] - mean_x) / scaleFactor;
      y_list[i] = (y_list[i] - mean_y) / scaleFactor;
    }*/


    //getNorm
    var normalized_list = getNorm([x_list, y_list]);

    int dummy = 0;

    return normalized_list;
  }

  List<dynamic> getNorm(List<dynamic> extracted_points) {
    List<dynamic>flatten_list = [];
    double sum = 0;
    for (int i = 0; i < extracted_points[0].length; i++) {
      flatten_list.add(extracted_points[0][i]);
      flatten_list.add(extracted_points[1][i]);
      sum += (extracted_points[0][i] * extracted_points[0][i]) +
          (extracted_points[1][i] * extracted_points[1][i]);
    }
    /*var norm = sqrt(sum);
    for (int i = 0; i < flatten_list.length; i++) {
      flatten_list[i] /= norm;
    }*/
    return flatten_list;
  }



  /*load_ComparatorNet_Model({ Interpreter? interpreter}) async
  {
    try {
      _ComparetorNet_interpreter =
      await Interpreter.fromAsset("pose_classifier_14.tflite" , options: InterpreterOptions()..threads = 4,);
      print(
          "Comp Net loaded*********************************************************************************");
    }
    catch (e) {
      print("Error while creating CompNet interpreter:*************************** $e");
    }
  }

  /// Gets the interpreter instance
  Interpreter? get interpreter => _ComparetorNet_interpreter;*/
}