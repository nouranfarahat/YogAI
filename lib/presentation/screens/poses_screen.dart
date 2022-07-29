
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoga_ai/data/models/pose.dart';
import 'package:yoga_ai/presentation/Custom_widgets/poses_card_widget.dart';

import '../../Bloc/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import '../DBicons.dart';
import 'homeView.dart';



class Poses_screen extends StatelessWidget {

 final List<Pose> _poses;
bool  start_button_appear;

Poses_screen(this._poses,this.start_button_appear);

  @override
  Widget build(BuildContext context) {
   // final _Bottom_nav_bar_Bloc=BlocProvider.of<BottomNavBarBloc>(context);
   List<String>_selectedIndex=[];
   int x=0;
    return Scaffold(

      body: ListView.builder(

        itemCount: (this._poses.length),

        itemBuilder: (contex, index) =>
            Custom_pose_widget(pose:this._poses[index],selectedIndex:_selectedIndex ,),

      ),
        floatingActionButton:start_button( start_button_appear,_poses, context),
    );
  }

  Widget start_button(bool  start_button_appear,List<Pose> poses,BuildContext context) {
    if (start_button_appear) {
      return FloatingActionButton(
        backgroundColor: Colors.redAccent,

        onPressed: () async {

          for(int i=0;i<poses.length;i++)
          {
            await
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeView(poses[i],true)));

          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.play_arrow,),
      );
    }
    else{
      return Container();
    }


  }









}

