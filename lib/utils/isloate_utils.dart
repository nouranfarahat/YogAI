import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as imageLib;


import 'package:tflite_flutter/tflite_flutter.dart';

import '../tflite/PoseEstimator.dart';
import 'image_utils.dart';

/// Manages separate Isolate instance for inference
class IsolateUtils {
  static const String DEBUG_NAME = "InferenceIsolate";

  Isolate? _isolate;
  ReceivePort _receivePort = ReceivePort();
  late SendPort _sendPort;



  static String? _pose_name ;

  static  Future<String> pose_name(String value) async{
    _pose_name = value;
    return _pose_name!;
  }

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: DEBUG_NAME,
    );

    _sendPort = await _receivePort.first;
  }

    static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final IsolateData isolateData in port) {
      if (isolateData != null) {
        PoseEstimator classifier = PoseEstimator(
            interpreter:
            Interpreter.fromAddress(isolateData.interpreterAddress),pose_name:isolateData.pose_name!/*pose_name:isolateData.pose_name*/  /* pose_name: "isolate"*/
           );
        //classifier.pose_name(_pose_name!);
        imageLib.Image? image =
        ImageUtils.convertCameraImage(isolateData.cameraImage);
        if (Platform.isAndroid) {
          image = imageLib.copyRotate(image!, 90);
        }
        Map<String, dynamic>? results = classifier.predict(image!);
        isolateData.responsePort?.send(results);
      }
    }
  }
}

/// Bundles data to pass between Isolate
class IsolateData {
  CameraImage cameraImage;
  int interpreterAddress;
  SendPort? responsePort;
 String pose_name;
  IsolateData(
      this.cameraImage,
      this.interpreterAddress,
      this.pose_name
      );
}