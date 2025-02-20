part of 'lines_bloc.dart';

abstract class LinesState {}

class LinesInitial extends LinesState {}

class ListLines extends LinesState {
  final List<LineEntity> lines;
  ListLines(this.lines);
}
