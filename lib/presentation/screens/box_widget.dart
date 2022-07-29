import 'package:flutter/material.dart';

import '../../tflite/recognition.dart';


/// Individual bounding box
class BoxWidget extends StatelessWidget {
  final Recognition result;
  final Color keyPointColor;

  const BoxWidget({Key? key,required this.result,required this.keyPointColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Color for bounding box



    return Positioned(
      left:result.renderLocation.x.toDouble(),
      top: result.renderLocation!.y.toDouble(),
      width: 100,
      height: 12,
      child: Container(
        child: Text(
          "● ${""}",
          style: TextStyle(
            color: keyPointColor,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}