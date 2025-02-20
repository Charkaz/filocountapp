part of 'lines_bloc.dart';

sealed class LinesEvent {}

class ListLineEvent extends LinesEvent {
  final int countId;

  ListLineEvent(this.countId);
}
