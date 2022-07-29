part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class UnAuthenticated extends LoginState {
  @override
  List<Object?> get props => [];
  @override
  String toString() => 'UnAuthenticated';
}
class Loading extends LoginState {
  @override
  List<Object?> get props => [];
  @override
  String toString() => 'loading';
}
class loginSuccessfully extends LoginState {
  @override
  List<Object?> get props => [];
  @override
  String toString() => 'loginSuccessfully';
}


class loginError extends LoginState {
  final String error;
  loginError(this.error);
  @override
  List<Object?> get props => [error];
  @override
  String toString() => error.toString();
}