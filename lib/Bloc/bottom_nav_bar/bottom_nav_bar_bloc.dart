import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yoga_ai/Bloc/login_bloc/login_bloc.dart';

import '../../data/models/pose.dart';
import '../../data/repositories/poses_repository.dart';
import '../../data/repositories/rounds_repository.dart';

part 'bottom_nav_bar_event.dart';
part 'bottom_nav_bar_state.dart';

class BottomNavBarBloc extends Bloc<BottomNavBarEvent, BottomNavBarState> {
  int current_index=0;

final  poses_repository posesRepository;
final  roundsRepository round_repository;

    BottomNavBarBloc({required this.posesRepository,required this.round_repository }) : super(PageLoading()) {

    on<AppStarted>((event, emit) async{
try{

  await this.posesRepository.getPoses();
  await this.round_repository.get_program_Rounds(this.posesRepository.poses);

 // this.posesRepository.addPoses();
  //List<Pose>? poses=this.posesRepository.poses;

}
  catch(e){
  print(e.toString());
  }
      emit(PageLoading());
      try {
        emit(HomePageLoaded());
      }
      catch(e){
        emit(PageLoadedError(e.toString()));
      }
    });
    on<PageTapped>((event, emit) async {
      this.current_index=event.index;

      if(this.current_index%3==0)
      {      emit(PageLoading());

      try {
        emit(HomePageLoaded());
      }
      catch(e){
        emit(PageLoadedError(e.toString()));
      }}
      if(this.current_index%3==1)
      {      emit(PageLoading());

      try {
          emit(PosesPageLoaded(this.posesRepository.poses));
      }
      catch(e){
        emit(PageLoadedError(e.toString()));
      }}

      if(this.current_index%3==2)
      {      emit(PageLoading());

      try {
        emit(ProfilePageLoaded());
      }
      catch(e){
        emit(PageLoadedError(e.toString()));
      }}
    });
  }
  @override
  void onTransition(Transition<BottomNavBarEvent, BottomNavBarState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}
