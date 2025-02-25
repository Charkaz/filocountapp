part of 'lines_bloc.dart';

sealed class LinesEvent {}

class ListLineEvent extends LinesEvent {
  final String countId;

  ListLineEvent(this.countId);
}
