part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}
class LoadingPage extends HomeState {
  @override
  List<Object> get props => [];
  @override
  String toString() => 'pageLoading';
}

class LoadedPage extends HomeState {
  Round round;

  LoadedPage(this.round);

  @override
  List<Object> get props => [];
  @override
  String toString() => 'pageLoading';
}
class Page_LoadedError extends HomeState{
  final String error;
  Page_LoadedError(this.error);
  @override
  List<Object> get props => [];
  @override
  String toString() => error;
}