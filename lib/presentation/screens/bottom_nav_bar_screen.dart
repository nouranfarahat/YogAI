import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_ai/Bloc/Home_bloc/home_bloc.dart';
import 'package:yoga_ai/presentation/screens/poses_screen.dart';

import '../../Bloc/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import '../DBicons.dart';
import 'Home_screen.dart';


class BottomNavBarScreen extends StatefulWidget {


  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {


  BottomNavigationBarItem makeNavigationButton(String Btnlabel,
      IconData icon1) {
    return BottomNavigationBarItem(
      icon: Icon(icon1),
      label: Btnlabel,
    );
  }

  @override
  Widget build(BuildContext context){
    final bottomNavigationBloc = BlocProvider.of<BottomNavBarBloc>(context);
    bottomNavigationBloc.add(AppStarted());
   // final _poses_screen=Poses_screen(bottomNavigationBloc.posesRepository.poses);
  //  final _pose_screen;
    return Scaffold(

      body: BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
          bloc: bottomNavigationBloc,
          builder: (BuildContext context, BottomNavBarState state) {
            if (state is PageLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is HomePageLoaded) {
              return BlocProvider.value(
                value: BlocProvider.of<HomeBloc>(context),
                child: MyHomeBar());
            }
            if (state is ProfilePageLoaded) {
              return Container();
            }
            if (state is PosesPageLoaded) {

             return Poses_screen(state.Poses,false);
            }
            return Container();
          }
      ),
      bottomNavigationBar: BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
          bloc: bottomNavigationBloc,
          builder: (BuildContext context, BottomNavBarState state) {
            return BottomNavigationBar(
              currentIndex: bottomNavigationBloc.current_index,
              backgroundColor: Colors.redAccent,
                selectedItemColor: Colors.grey,
              unselectedItemColor: Colors.white,
              items: <BottomNavigationBarItem>[
                makeNavigationButton('home', Icons.home),
                makeNavigationButton('search', DBIcons.logo),
                makeNavigationButton('profile', Icons.person),
              ],

              onTap: (index) =>
                  bottomNavigationBloc.add(PageTapped(index: index,
                  )),
            );
          }
      ),
    );
  }
}