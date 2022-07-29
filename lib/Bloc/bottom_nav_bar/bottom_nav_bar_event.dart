part of 'bottom_nav_bar_bloc.dart';

abstract class BottomNavBarEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class AppStarted extends BottomNavBarEvent {

}

class PageTapped extends BottomNavBarEvent {
  final int index;
  //final user current_user;

  PageTapped({required this.index});

}