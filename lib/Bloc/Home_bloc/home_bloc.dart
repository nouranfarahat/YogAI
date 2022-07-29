import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/Rounds_model.dart';
import '../../data/models/user.dart';
import '../../data/repositories/rounds_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final user current_user;
  int current_index=0;

 final List<dynamic> Focused_area_rounds;


  HomeBloc({required this.current_user,required this.Focused_area_rounds}) : super(HomeInitial()) {
  /*on<FirstInitiate>((event, emit) {
    try {


     emit(HomeInitial());
   }
   catch(e)
    {
      emit(Page_LoadedError(e.toString()));
    }});*/
    on<FocusedAreaRoundTap>((event, emit) {
       current_index=event.Taped_index;
       emit(LoadedPage(Focused_area_rounds![current_index]));


    });
  }@override
  void onTransition(Transition<HomeEvent, HomeState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}
