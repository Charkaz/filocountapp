part of 'line_bloc.dart';

abstract class LineEvent extends Equatable {
  const LineEvent();

  @override
  List<Object> get props => [];
}

class LoadLines extends LineEvent {}

class ListLineEvent extends LineEvent {
  final String countId;

  ListLineEvent(this.countId);
}

class AddLineEvent extends LineEvent {
  final LineEntity line;

  const AddLineEvent({required this.line});

  @override
  List<Object> get props => [line];
}

class UpdateLineEvent extends LineEvent {
  final LineEntity line;

  const UpdateLineEvent({required this.line});

  @override
  List<Object> get props => [line];
}

class DeleteLineEvent extends LineEvent {
  final String id;
  final String countId;

  const DeleteLineEvent({required this.id, required this.countId});

  @override
  List<Object> get props => [id, countId];
}

class UpdateQuantityEvent extends LineEvent {
  final String id;
  final String countId;
  final double quantity;

  const UpdateQuantityEvent({
    required this.id,
    required this.countId,
    required this.quantity,
  });

  @override
  List<Object> get props => [id, countId, quantity];
}
