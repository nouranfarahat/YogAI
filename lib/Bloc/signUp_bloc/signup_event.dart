part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class SignUpRequested extends SignupEvent {
  final String email;
  final String password;
  final String username;
 final DateTime DOB;
  SignUpRequested({required this.email,required this.password,required this.username,required this.DOB});
}