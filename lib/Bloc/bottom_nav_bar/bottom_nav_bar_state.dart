part of 'bottom_nav_bar_bloc.dart';

abstract class BottomNavBarState extends Equatable {
  const BottomNavBarState();
}

class CurrentIndexChanged extends BottomNavBarState {
  final int currentIndex;

  CurrentIndexChanged({required this.currentIndex}) ;

  @override
  List<Object> get props => [];
  @override
  String toString() => 'CurrentIndexChanged';
}

class PageLoading extends BottomNavBarState {
  @override
  List<Object> get props => [];
  @override
  String toString() => 'pageLoading';
}

class HomePageLoaded extends BottomNavBarState {

  @override
  List<Object> get props => [];
  @override
  String toString() => 'HomePageLoaded';
}


class ProfilePageLoaded extends BottomNavBarState {

  //final user current_user;
  //ProfilePageLoaded({required this.current_user});

  @override
  List<Object> get props => [];
  @override
  String toString() => 'ProfilePageLoaded';
}
class PosesPageLoaded extends BottomNavBarState {
  final List<Pose> Poses;

  PosesPageLoaded(this.Poses);
  @override
  List<Object> get props => [];
  @override
  String toString() => 'PosesPageLoaded';
}

class PageLoadedError extends BottomNavBarState{
  final String error;
  PageLoadedError(this.error);
  @override
  List<Object> get props => [];
  @override
  String toString() => error;
}