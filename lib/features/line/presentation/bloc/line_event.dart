part of 'line_bloc.dart';

abstract class LineEvent extends Equatable {
  const LineEvent();

  @override
  List<Object> get props => [];
}

class LoadLines extends LineEvent {}

class AddLine extends LineEvent {
  final LineEntity line;

  const AddLine({required this.line});

  @override
  List<Object> get props => [line];
}

class UpdateLine extends LineEvent {
  final LineEntity line;

  const UpdateLine({required this.line});

  @override
  List<Object> get props => [line];
}

class DeleteLine extends LineEvent {
  final int id;

  const DeleteLine({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdateQuantity extends LineEvent {
  final int id;
  final int quantity;

  const UpdateQuantity({required this.id, required this.quantity});

  @override
  List<Object> get props => [id, quantity];
}
