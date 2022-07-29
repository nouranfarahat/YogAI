import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoga_ai/Bloc/login_bloc/login_bloc.dart';
import 'package:yoga_ai/data/repositories/auth_repository.dart';
import 'package:yoga_ai/presentation/DBicons.dart';
import 'package:yoga_ai/presentation/screens/bottom_nav_bar_screen.dart';
import 'package:yoga_ai/presentation/screens/login_screen.dart';
import 'package:yoga_ai/presentation/screens/my_programs.dart';
import 'package:yoga_ai/presentation/screens/poses_screen.dart';
import 'package:yoga_ai/presentation/screens/registeration_screen.dart';

import 'Bloc/Home_bloc/home_bloc.dart';
import 'Bloc/bottom_nav_bar/bottom_nav_bar_bloc.dart';
import 'Bloc/signUp_bloc/signup_bloc.dart';
import 'data/repositories/poses_repository.dart';
import 'data/repositories/rounds_repository.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp();

runApp( MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider(
        create: (context) => poses_repository()),
      RepositoryProvider(
          create: (context) => AuthRepository()),
    RepositoryProvider(
    create: (context) => roundsRepository())
      ,],

        child: MultiBlocProvider(
        providers: [
    BlocProvider<SignupBloc>(create: (context) => SignupBloc(authRepository:RepositoryProvider.of<AuthRepository>(context))),
          BlocProvider<LoginBloc>(create: (context) => LoginBloc(authRepository: RepositoryProvider.of<AuthRepository>(context))),
          BlocProvider<BottomNavBarBloc>(create: (context) => BottomNavBarBloc(posesRepository: poses_repository(),round_repository:  RepositoryProvider.of<roundsRepository>(context))),

          BlocProvider<HomeBloc>(create: (context) => HomeBloc(current_user: RepositoryProvider.of<AuthRepository>(context).current_user,Focused_area_rounds:  RepositoryProvider.of<roundsRepository>(context).program_focused_area_rounds)),


    ],


    child: MaterialApp(
      debugShowCheckedModeBanner: false,

      home: signUpScreen(),   //myPrograms_screen(),  MyHomePage()
      routes:{

        'home':(context)=>BottomNavBarScreen(),

      },

    ),),);

  }
}




