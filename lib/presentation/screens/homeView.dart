

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yoga_ai/presentation/screens/poses_screen.dart';
import '../../data/models/camera_view_singelton.dart';
import '../../data/models/pose.dart';
import '../../tflite/recognition.dart';
import '../../tflite/stats.dart';
import 'box_widget.dart';
import 'camera_view.dart';


/// [HomeView] stacks [CameraView] and [BoxWidget]s with bottom sheet for stats
class HomeView extends StatefulWidget {
  final Pose pose;
 bool? popBck;
  HomeView(this.pose,this.popBck);

  @override
  _HomeViewState createState() => _HomeViewState(this.pose,this.popBck);
}

class _HomeViewState extends State<HomeView> {
  //todo:recieve name from UI
  final Pose pose;
  bool? popBck;
  _HomeViewState(this.pose,this.popBck);

  /// Results to draw bounding boxes
  List<Recognition>? results=[];//=[ Recognition( Point ( 0 , 0 ) , 0.5554)];
  /// Realtime stats
  Stats ? stats;
  /// Scaffold Key
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  void initState() {
    super.initState();
    if(this.popBck==true)
   { Timer(Duration(seconds: 20), (){//time edit
      Navigator.of(context).pop(MaterialPageRoute(builder: (context)=>Poses_screen([],true)));
    });}}
  @override
  Widget build(BuildContext context) {
    print("Home view:                  "+this.pose.pose_name);

    return Scaffold(
      key: scaffoldKey,
     // backgroundColor: Colors.purple,
      body: Stack(
        children: <Widget>[
          // Camera View
          CameraView(resultsCallback, statsCallback,this.pose),
          Stack(
            children:<Widget> [

              Container(
                height: 200,
                width:100,
                decoration: BoxDecoration(

                    borderRadius:BorderRadius.all(Radius.circular(20.0)),

                    color: Colors.deepOrange.shade50,
                    boxShadow:[ BoxShadow(color: Colors.grey,blurRadius: 10.0),]
                ),
              ),
              FutureBuilder(future:pose.pose_Storage_url,
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.done)
                    { if (snapshot.hasData) {
                      return Container(
                        width: 100,
                        height: 200,
                        child: SvgPicture.network(snapshot.data.toString()),
                      );}

                    }return Container();

                  }),


            ],
          ),


          // Bounding boxes
        boundingBoxes(results!),

          // Heading
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                '',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrangeAccent.withOpacity(0.6),
                ),
              ),
            ),
          ),

          // Bottom Sheet
        Align(
            alignment: Alignment.bottomCenter,
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.1,
              maxChildSize: 0.5,
              builder: (_, ScrollController scrollController) => Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BORDER_RADIUS_BOTTOM_SHEET),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.keyboard_arrow_up,
                            size: 48, color: Colors.orange),
                        (stats != null)
                            ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              StatsRow('Inference time:',
                                  '${stats?.inferenceTime} ms'),
                              StatsRow('Total prediction time:',
                                  '${stats?.totalElapsedTime} ms'),
                              StatsRow('Pre-processing time:',
                                  '${stats?.preProcessingTime} ms'),
                              StatsRow('Frame',
                                  '${CameraViewSingleton.inputImageSize?.width} X ${CameraViewSingleton.inputImageSize?.height}'),
                            ],
                          ),
                        )
                            : Container(child: Text('OUT HERE ', style: TextStyle (fontSize: 50),),)


                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Returns Stack of bounding boxes
  Widget boundingBoxes(List<Recognition> results) {
    if (results == null) {
      return Container();
    }
     return Stack(
      children: results
          .map((e) => BoxWidget(

        result: e,keyPointColor:e.color_! ,
      ))
          .toList(),
    );
  }

  /// Callback to get inference results from [CameraView]
  void resultsCallback(List<Recognition> results) {
    setState(() {
      this.results = results;
    });
  }

  /// Callback to get inference stats from [CameraView]
  void statsCallback(Stats stats) {
    setState(() {
      this.stats = stats;
    });
  }


  static const BOTTOM_SHEET_RADIUS = Radius.circular(24.0);
  static const BORDER_RADIUS_BOTTOM_SHEET = BorderRadius.only(
      topLeft: BOTTOM_SHEET_RADIUS, topRight: BOTTOM_SHEET_RADIUS);
}

/// Row for one Stats field
class StatsRow extends StatelessWidget {
  final String left;
  final String right;

  StatsRow(this.left, this.right);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(left), Text(right)],
      ),
    );
  }
}
