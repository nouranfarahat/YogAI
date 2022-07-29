import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../data/models/camera_view_singelton.dart';
import '../../data/models/pose.dart';
import '../../tflite/PoseEstimator.dart';
import '../../tflite/recognition.dart';
import '../../tflite/stats.dart';
import '../../utils/isloate_utils.dart';


/// [CameraView] sends each frame for inference
class CameraView extends StatefulWidget {
  final Pose pose;
  /// Callback to pass results after inference to [HomeView]
  final Function(List<Recognition> recognitions) resultsCallback;

  /// Callback to inference stats to [HomeView]
  final Function(Stats stats) statsCallback;
  /// Constructor
   CameraView(this.resultsCallback, this.statsCallback,this.pose);
  @override
  _CameraViewState createState() => _CameraViewState(this.pose);
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  /// List of available cameras
  List<CameraDescription> ?cameras;

  /// Controller
  CameraController? cameraController;

  /// true when inference is ongoing
  bool? predicting;

  PoseEstimator ?poseEstimator ;
  /// Instance of [IsolateUtils]
  IsolateUtils ? isolateUtils;
  final Pose pose;

  _CameraViewState(this.pose); //_CameraViewState(this.pose_name);

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  void initStateAsync() async {
    WidgetsBinding.instance?.addObserver(this);

    // Spawn a new isolate
    isolateUtils = IsolateUtils();

    await isolateUtils?.start();


    // Camera initialization
    //print("inti_start");
    initializeCamera();
    //print("inti_end");

    // Create an instance of classifier to load model and labels
    //print("PE_start");
    poseEstimator = PoseEstimator();
   // poseEstimator?.pose_name(this.pose.pose_name);
    //print("PE_end");

    // Initially predicting = false

    predicting=false;
  }

  /// Initializes the camera by setting [cameraController]
  void initializeCamera() async {
    cameras = await availableCameras();
    print("canera view:                  "+this.pose.pose_name);
    // cameras[0] for rear-camera
    cameraController = await CameraController(cameras![0], ResolutionPreset.high, enableAudio: false ,imageFormatGroup: ImageFormatGroup.yuv420,);

    cameraController?.initialize().then((_) async {
      if(!mounted)
        return;
      // Stream of image passed to [onLatestImageAvailable] callback
      await cameraController?.startImageStream(onLatestImageAvailable);

      /// previewSize is size of each image frame captured by controller
      ///
      /// 352x288 on iOS, 240p (320x240) on Android with ResolutionPreset.low
      Size? previewSize = cameraController?.value.previewSize;

      /// previewSize is size of raw input image to the model
      CameraViewSingleton.inputImageSize = previewSize;

      // the display width of image on screen is
      // same as screenWidth while maintaining the aspectRatio
      Size screenSize = MediaQuery.of(context).size;
      //print("before Israa --> MediaQuery.of(context).size = " + MediaQuery.of(context).size.toString());
      CameraViewSingleton.screenSize = screenSize;
      CameraViewSingleton.ratio =screenSize.width / previewSize!.height;
    });
    /*print("SIZE SIZE  --->  ");
    print(MediaQuery.of(context).size);*/
  }

  @override
  Widget build(BuildContext context) {
    // Return empty container while the camera is not initialized
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container();
    }



    return CameraBoxFlow();
   }

  /// Callback to receive each frame [CameraImage] perform inference on it
  onLatestImageAvailable(CameraImage cameraImage) async {
    if (poseEstimator?.interpreter != null) {
      // If previous inference has not completed then return
      if (predicting!) {
        return;
      }

      setState(() {
        predicting = true;
      });

      var uiThreadTimeStart = DateTime.now().millisecondsSinceEpoch;

      // Data to be passed to inference isolate
      var isolateData =await IsolateData(cameraImage, poseEstimator!.interpreter!.address,this.pose.pose_name);

      // We could have simply used the compute method as well however
      // it would be as in-efficient as we need to continuously passing data
      // to another isolate.

      /// perform inference in separate isolate
      Map<String, dynamic> inferenceResults = await inference(isolateData);

      var uiThreadInferenceElapsedTime = DateTime.now().millisecondsSinceEpoch - uiThreadTimeStart;

      /*print ("here in inference in camera view class");
      print (inferenceResults["recognitions"] );*/

      // pass results to HomeView
      widget.resultsCallback(inferenceResults["recognitions"]  );

      // pass stats to HomeView
      widget.statsCallback((inferenceResults["stats"] as Stats)..totalElapsedTime = uiThreadInferenceElapsedTime);

      // set predicting to false to allow new frames
      setState(() {
        predicting = false;
      });
    }
  }


  /// Runs inference in another isolate
  Future<Map<String, dynamic>> inference(IsolateData isolateData) async {
    ReceivePort responsePort = ReceivePort();
    isolateUtils?.sendPort
        .send(isolateData..responsePort = responsePort.sendPort);
    var results = await responsePort.first;
    return results;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        cameraController?.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!cameraController!.value.isStreamingImages) {
          //print("imageStream_start");
          await cameraController!.startImageStream(onLatestImageAvailable);
          //print("imageStream_end");
        }
        break;
      default:
    }
  }
Widget CameraBoxFlow()
{
  final screenH = max(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
  final screenW = min(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
  final preview = cameraController!.value.previewSize;
  final previewH = max(preview!.height, preview.width);
  final previewW = min(preview.height, preview.width);
  final screenRatio = screenH / screenW;
  final previewRatio = previewH / previewW;

  final width=screenRatio > previewRatio ? screenH / previewH * previewW : screenW;
      final height=screenRatio > previewRatio ? screenH : screenW / previewW * previewH;
  CameraViewSingleton.screenSize = Size(width,height);
  CameraViewSingleton.ratio =screenH / previewH;
  return OverflowBox(
    maxHeight:height ,
    maxWidth:width ,
    child: CameraPreview(cameraController!),
  );
}
  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    cameraController?.dispose();
    super.dispose();
  }
}