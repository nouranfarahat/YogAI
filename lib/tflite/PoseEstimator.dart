import 'dart:math';
import 'dart:ui';
import 'package:image/image.dart' as imageLib ;

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:yoga_ai/tflite/recognition.dart';
import 'package:yoga_ai/tflite/stats.dart';

import '../CorrectionModule/PoseCorrection.dart';

class PoseEstimator {

  /// Instance of Interpreter
  Interpreter? _interpreter;
  String? _pose_name ;
  PoseCorrection_repository poseCorrection = PoseCorrection_repository();

  static const String MODEL_FILE_NAME = "movenet_lightening.tflite";

  static const int INPUT_SIZE = 192;

  /// [ImageProcessor] used to pre-process the image
  ImageProcessor? imageProcessor;

  /// Padding the image to transform into square
  int? padSize;

  /// Shapes of output tensors
  List<List<int>>? _outputShapes;
/*
 Future<String> pose_name(String value) async{
    this._pose_name = value;
    print("PE setter :        "+ this._pose_name!);
    return _pose_name!;
  } //PoseCorrection_repository
*/


  /// Types of output tensors
  List<TfLiteType>? _outputTypes;

  Map<int, Object> outputs = {};

  PoseEstimator({ Interpreter ? interpreter, String? pose_name}) {
    //this.pose_name=pose_name!;
    //print("poseName in estimator:  " + pose_name! + "  ------------------------------------------------------------------------");
    loadModel(interpreter: interpreter);
    //poseCorrection.load_ComparatorNet_Model();
    this._pose_name=pose_name;
    //print("PoseEstimator Constructor");
  }

  void loadModel({ Interpreter? interpreter}) async {
    try {
      _interpreter = interpreter ??
          await Interpreter.fromAsset(
            MODEL_FILE_NAME,
            options: InterpreterOptions()
              ..threads = 4,
          );

      var outputTensors = _interpreter?.getOutputTensors();
      _outputShapes = [];
      _outputTypes = [];
      int i=0;
      outputTensors?.forEach((tensor) {
        i++;
        _outputShapes?.add(tensor.shape);
        _outputTypes?.add(tensor.type);
      });
      /*print ("input shape :   " + i.toString());
      print ("MODEL LOADED SUCESSFULLY  CORRECT CORRECT CORRECT CORRECT");*/
    } catch (e) {
      //print("Error while creating interpreter: $e");
    }
  }

  TensorImage getProcessedImage(TensorImage inputImage) {
    padSize = max(inputImage.height, inputImage.width);
    if (imageProcessor == null) {
      imageProcessor = ImageProcessorBuilder()
          .add(ResizeWithCropOrPadOp(padSize!, padSize!))
          .add(ResizeOp(INPUT_SIZE, INPUT_SIZE, ResizeMethod.BILINEAR))
          .build();
    }
   // print("before size without padding : " +"Height  :   " + inputImage.height.toString() + "    width  :   " + inputImage.width.toString());

    inputImage = imageProcessor!.process(inputImage);
    //print("size without padding : " +"Height  :   " + inputImage.height.toString() + "    width  :   " + inputImage.width.toString());

    return inputImage;
  }



  Map<String, dynamic>? predict(imageLib.Image image) {
if (this._pose_name==null)
  {
    this._pose_name="no pred.";
    print ("here in predict   "+  this._pose_name!);

    print(this._pose_name);
  }else{
  print ("here in predict   "+  this._pose_name!);
  }
    //print ("here in predict   "+  this._pose_name!);

    //`print ("Height  :   " + image.height.toString() + "    width  :   " + image.width.toString());*/
    // [1] check interperter status
    var predictStartTime = DateTime.now().millisecondsSinceEpoch;

    if (_interpreter == null) {
      //print("Interpreter not initialized");
      return null;
    }
    else {
       //print ("iam intialized   interpreter");
    }

    var preProcessStart = DateTime.now().millisecondsSinceEpoch;

    // Create TensorImage from image
    // [2] change input frame from imagelib  --> tensor image
    TensorImage inputImage = TensorImage.fromImage(image);

    // Pre-process TensorImage
    //[3] call get processed image [input image] padded and resized  to 192
    inputImage = getProcessedImage(inputImage);

    var preProcessElapsedTime = DateTime.now().millisecondsSinceEpoch - preProcessStart;

    // TensorBuffers for output tensors
    //[4] prepare the output and input tensors
    TensorBuffer outputLocations = TensorBufferFloat(_outputShapes![0]);

    // Inputs object for runForMultipleInputs
    // Use [TensorImage.buffer] or [TensorBuffer.buffer] to pass by reference
    List<Object> inputs = [inputImage.buffer];

    // Outputs map
    Map<int, Object> outputs = {
      0: outputLocations.buffer,
    };

    var inferenceTimeStart = DateTime.now().millisecondsSinceEpoch;

    // run inference
    // [5] Run the model -->  input of model input image from step [3] (192 x 192) && output ratios from [0 1] mapped on input image of size 192
     _interpreter!.runForMultipleInputs(inputs, outputs);

    var inferenceTimeElapsed = DateTime.now().millisecondsSinceEpoch - inferenceTimeStart;

    // Maximum number of results to show
    //int resultsCount = max(0,  );

    List <Recognition> recognitions = [];
    List<double> data = outputLocations.getDoubleList();

    //todo:Pose Correction
    //this._pose_name=this._pose_name!+"-l";
    var c_arr = poseCorrection.manager(data! ,this._pose_name!);
    int indx=0;
    for (var i = 0; i < 51; i += 3) {
      var y = ((data[0 + i] ).toDouble() *192)-3.5;
      var x = ((data[1 + i]).toDouble() *192 )-7.5;
      var c = (data[2 + i]);



      Point transformedPoint = imageProcessor?.inverseTransform(Point(x , y ), image.height, image.width) as Point;
      //Point(x , y );

      recognitions.add( Recognition (transformedPoint , c, c_arr[indx]));
      indx++;

    }

    //print (recognitions);

    var predictElapsedTime = DateTime.now().millisecondsSinceEpoch - predictStartTime;

    return {
      "recognitions": recognitions,
      "stats": Stats(
          totalPredictTime: predictElapsedTime,
          inferenceTime: inferenceTimeElapsed,
          preProcessingTime: preProcessElapsedTime)
    };

  }


  /// Gets the interpreter instance
  Interpreter? get interpreter => _interpreter;


}