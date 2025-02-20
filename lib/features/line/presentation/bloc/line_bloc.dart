import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/line_entity.dart';

part 'line_event.dart';
part 'line_state.dart';

class LinesBloc extends Bloc<LineEvent, LineState> {
  LinesBloc() : super(LineInitial()) {
    on<LoadLines>(_onLoadLines);
    on<AddLine>(_onAddLine);
    on<UpdateLine>(_onUpdateLine);
    on<DeleteLine>(_onDeleteLine);
  }

  Future<void> _onLoadLines(
    LoadLines event,
    Emitter<LineState> emit,
  ) async {
    emit(LineLoading());
    try {
      // TODO: Implement loading lines
      emit(ListLines(lines: []));
    } catch (e) {
      emit(LineError(message: e.toString()));
    }
  }

  Future<void> _onAddLine(
    AddLine event,
    Emitter<LineState> emit,
  ) async {
    try {
      // TODO: Implement adding line
    } catch (e) {
      emit(LineError(message: e.toString()));
    }
  }

  Future<void> _onUpdateLine(
    UpdateLine event,
    Emitter<LineState> emit,
  ) async {
    try {
      // TODO: Implement updating line
    } catch (e) {
      emit(LineError(message: e.toString()));
    }
  }

  Future<void> _onDeleteLine(
    DeleteLine event,
    Emitter<LineState> emit,
  ) async {
    try {
      // TODO: Implement deleting line
    } catch (e) {
      emit(LineError(message: e.toString()));
    }
  }
}
