import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepository;



  SignupBloc({required this.authRepository}) : super(UnAuthenticated()) {
    on<SignUpRequested>((event, emit) async {
      emit(Loading());
      try{
       await this.authRepository.signUp(email:event.email, password: event.password, username: event.username, age:event.DOB);
      emit(SignUpSuccessfully());
      }
     catch(e){
        emit(SignUpError(e.toString()));
        emit(UnAuthenticated());
     }
    });
  }
  @override
  void onTransition(Transition<SignupEvent, SignupState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}
