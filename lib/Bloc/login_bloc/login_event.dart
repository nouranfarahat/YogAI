part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignInRequested extends LoginEvent {
  final String email;
  final String password;

  SignInRequested({required this.email,required this.password});
}