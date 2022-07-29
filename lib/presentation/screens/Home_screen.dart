import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../Bloc/Home_bloc/home_bloc.dart';
import '../../Bloc/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import '../Custom_widgets/rounds_card_widget.dart';
import '../DBicons.dart';

class MyHomeBar extends StatefulWidget {



  @override
  State<MyHomeBar> createState() => _MyHomeBarState();
}

class _MyHomeBarState extends State<MyHomeBar> {

  Container makeProgramContainer(){
    return
      Container(
      height: 200,
      width:300,
      decoration: BoxDecoration(

          borderRadius:BorderRadius.all(Radius.circular(20.0)),

          color: Colors.blue.shade100,
          boxShadow:[ BoxShadow(color: Colors.grey,blurRadius: 10.0),]
      ),
    );

  }
  Widget makeTextContainer(AlignmentGeometry a,String text,double fontSize,Color c){
    return Container(
      alignment:a,
      child: Text(text,
        style: TextStyle(fontSize: fontSize,color: c),
      ),);}


  @override
  Widget build(BuildContext context) {
    final _HomeBloc = BlocProvider.of<HomeBloc>(context);
   // _HomeBloc.add( FirstInitiate());

    return Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(
        bloc: _HomeBloc,
        builder: (BuildContext context, HomeState state)
    {
      if (state is LoadingPage) {
        return Center(child: CircularProgressIndicator());
      }
      /*if(state is HomeInitial)
        return Center(child:Text("initiate"));*/
      if (state is HomeInitial){

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(scrollDirection: Axis.vertical,
            children: [

              SizedBox(height: 50,),
              Container(
                alignment: Alignment.center,
                height: 40,
                child:Image.asset("assets/Logo.png",width: 100,height: 100,),


              ),
              makeTextContainer(Alignment.center, 'YogAi', 30, Colors.lightBlueAccent),

              Row(children: <Widget>[
                makeTextContainer(Alignment.centerLeft, ' Hi,', 40, Colors.black),
                makeTextContainer(
                    Alignment.centerLeft, _HomeBloc.current_user.user_name, 40,
                    Colors.redAccent.shade200),
              ]),
              makeTextContainer(
                  Alignment.centerLeft, _HomeBloc.current_user.level.toString(),
                  20, Colors.black),
              SizedBox(height: 50,),
              InkWell(
                onLongPress: () {},
                onTap: () {

                  /* Navigator.push(
              context,
              MaterialPageRoute(
                  ));*/
                },
                child:
                Container(
                    height: 200,

                    child: Stack(
                        children: <Widget>[Container(
                          height: 200,
                          width: 370,
                          decoration: BoxDecoration(

                              borderRadius: BorderRadius.all(
                                  Radius.circular(20.0)),

                              color: Colors.blue.shade50,
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 10.0),
                              ]
                          ),
                        ), Image.asset(
                          "assets/my_programs.png",
                          // color: Colors.redAccent,
                          height: 400,
                          width: 300,
                            alignment: Alignment.centerRight
                        ),
                          Column(
                            children: [
                              SizedBox(
                                height: 25,),
                              Row(children: [ SizedBox(
                                width: 20,), Container(
//color:
                                height: 50,
                                width: 150,
                                child:
                                Text("my program", style: TextStyle(
                                  fontSize: 20, color: Colors.black,),),),
                              ],)


                            ],
                          )


                        ]
                    )),),

              makeTextContainer(
                  Alignment.topLeft, "Focused area", 30, Colors.black),
              SizedBox(height: 10,),

              // SizedBox(height: 50,),
              Container(
                  height: 200,
                  child:
                  ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: (_HomeBloc.Focused_area_rounds!.length),

                      itemBuilder: (contex, index) =>
                          Custom_round_widget(
                              _HomeBloc.Focused_area_rounds![index])
                  )
              ),
              SizedBox(height: 50,),
              makeTextContainer(
                  Alignment.topLeft, "Recommended Flows", 30, Colors.black),
              SizedBox(height: 50,),
            ]),
        );
    }

    // ],),
    // This trailing comma makes auto-formatting nicer for build methods.


  return Container();}
        ),
  );
  }}