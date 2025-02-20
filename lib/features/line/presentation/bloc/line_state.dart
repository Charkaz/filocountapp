part of 'line_bloc.dart';

abstract class LineState extends Equatable {
  const LineState();

  @override
  List<Object?> get props => [];
}

class LineInitial extends LineState {}

class LineLoading extends LineState {}

class ListLines extends LineState {
  final List<LineEntity> lines;

  const ListLines({required this.lines});

  @override
  List<Object?> get props => [lines];
}

class LineError extends LineState {
  final String message;

  const LineError({required this.message});

  @override
  List<Object?> get props => [message];
}

class LineOperationSuccess extends LineState {
  final String message;

  const LineOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
