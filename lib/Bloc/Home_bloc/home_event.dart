part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class FirstInitiate extends HomeEvent {
  @override
  List<Object> get props => [];

}
class FocusedAreaRoundTap extends HomeEvent {
  final int Taped_index;

  FocusedAreaRoundTap(this.Taped_index);
}