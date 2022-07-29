
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoga_ai/data/models/pose.dart';
import 'package:yoga_ai/presentation/Custom_widgets/poses_card_widget.dart';
import 'package:yoga_ai/presentation/screens/poses_screen.dart';

import '../../Bloc/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import '../DBicons.dart';

class myPrograms_screen extends StatelessWidget {
List<Pose>poses;

myPrograms_screen({required this.poses});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Column(
        children: <Widget>[
          SizedBox(height: 50,),
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              " MY Programs",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),

            ),),
          SizedBox(height: 30,),
          Container(
            child: Stack(
              children: <Widget>[

                Container(
                  height: 200,
                  width: 395,
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.all(Radius.circular(20.0)),

                      color: Colors.blue.shade50,
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 10.0),
                      ]
                  ),
                ),


                SvgPicture.asset(
                  "assets/yoga_poses.svg",
                  // color: Colors.redAccent,
                  height: 200,
                  width: 100,
                ),


              ],
            ),


          ),

          /*  ListView.builder(
          itemCount: (this._poses.length),
          itemBuilder: (contex, index) =>
              Custom_pose_widget(pose:this._poses[index]),
        )*/
        ]
        ,),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,

        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => Poses_screen(this.poses, false)));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add,),
      ),);
  }

}

