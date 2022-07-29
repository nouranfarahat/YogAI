part of 'signup_bloc.dart';
@immutable
abstract class SignupState extends Equatable {
  const SignupState();
}
class UnAuthenticated extends SignupState {
  @override
  List<Object?> get props => [];
  @override
  String toString() => 'UnAuthenticated';
}
class Loading extends SignupState {
  @override
  List<Object?> get props => [];
  @override
  String toString() => 'loading';
}
class SignUpSuccessfully extends SignupState {
  @override
  List<Object?> get props => [];
  @override
  String toString() => 'SignUpSuccessfully';
}


class SignUpError extends SignupState {
  final String error;
  SignUpError(this.error);
  @override
  List<Object?> get props => [error];
  @override
  String toString() => error.toString();
}