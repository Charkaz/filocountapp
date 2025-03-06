import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/line_entity.dart';
import '../../domain/usecases/get_lines_by_count.dart';
import '../../domain/usecases/add_line.dart';
import '../../domain/usecases/update_line.dart';
import '../../domain/usecases/delete_line.dart';
import '../../domain/usecases/update_quantity.dart';

part 'line_event.dart';
part 'line_state.dart';

class LinesBloc extends Bloc<LineEvent, LineState> {
  final GetLinesByCount getLinesByCount;
  final AddLine addLine;
  final UpdateLine updateLine;
  final DeleteLine deleteLine;
  final UpdateQuantity updateQuantity;

  LinesBloc({
    required this.getLinesByCount,
    required this.addLine,
    required this.updateLine,
    required this.deleteLine,
    required this.updateQuantity,
  }) : super(LineInitial()) {
    on<LoadLines>(_onLoadLines);
    on<ListLineEvent>(_onListLines);
    on<AddLineEvent>(_onAddLine);
    on<UpdateLineEvent>(_onUpdateLine);
    on<DeleteLineEvent>(_onDeleteLine);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
  }

  Future<void> _onLoadLines(
    LoadLines event,
    Emitter<LineState> emit,
  ) async {
    emit(LineLoading());
    try {
      final result =
          await getLinesByCount(const GetLinesByCountParams(countId: ""));
      result.fold(
        (failure) => emit(LineError(message: failure.toString())),
        (lines) => emit(ListLines(lines: lines)),
      );
    } catch (e) {
      emit(LineError(message: e.toString()));
    }
  }

  Future<void> _onListLines(
    ListLineEvent event,
    Emitter<LineState> emit,
  ) async {
    emit(LineLoading());
    try {
      final result =
          await getLinesByCount(GetLinesByCountParams(countId: event.countId));
      result.fold(
        (failure) => emit(LineError(message: failure.toString())),
        (lines) => emit(ListLines(lines: lines)),
      );
    } catch (e) {
      emit(LineError(message: e.toString()));
    }
  }

  Future<void> _onAddLine(
    AddLineEvent event,
    Emitter<LineState> emit,
  ) async {
    try {
      final result = await addLine(AddLineParams(line: event.line));
      await result.fold(
        (failure) async => emit(LineError(message: failure.toString())),
        (_) async {
          emit(const LineOperationSuccess(message: 'Satır başarıyla eklendi'));
          final linesResult = await getLinesByCount(
              GetLinesByCountParams(countId: event.line.countId));
          await linesResult.fold(
            (failure) async => emit(LineError(message: failure.toString())),
            (lines) async => emit(ListLines(lines: lines)),
          );
        },
      );
    } catch (e) {
      emit(LineError(message: e.toString()));
    }
  }

  Future<void> _onUpdateLine(
    UpdateLineEvent event,
    Emitter<LineState> emit,
  ) async {
    try {
      final result = await updateLine(UpdateLineParams(line: event.line));
      await result.fold(
        (failure) async => emit(LineError(message: failure.toString())),
        (_) async {
          emit(const LineOperationSuccess(
              message: 'Satır başarıyla güncellendi'));
          final linesResult = await getLinesByCount(
              GetLinesByCountParams(countId: event.line.countId));
          await linesResult.fold(
            (failure) async => emit(LineError(message: failure.toString())),
            (lines) async => emit(ListLines(lines: lines)),
          );
        },
      );
    } catch (e) {
      emit(LineError(message: e.toString()));
    }
  }

  Future<void> _onDeleteLine(
    DeleteLineEvent event,
    Emitter<LineState> emit,
  ) async {
    try {
      final result = await deleteLine(DeleteLineParams(id: event.id));
      await result.fold(
        (failure) async => emit(LineError(message: failure.toString())),
        (_) async {
          emit(const LineOperationSuccess(message: 'Satır başarıyla silindi'));
          final linesResult = await getLinesByCount(
              GetLinesByCountParams(countId: event.countId));
          await linesResult.fold(
            (failure) async => emit(LineError(message: failure.toString())),
            (lines) async => emit(ListLines(lines: lines)),
          );
        },
      );
    } catch (e) {
      emit(LineError(message: e.toString()));
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<LineState> emit,
  ) async {
    try {
      final result = await updateQuantity(
        UpdateQuantityParams(id: event.id, quantity: event.quantity),
      );

      await result.fold(
        (failure) async => emit(LineError(message: failure.toString())),
        (_) async {
          emit(const LineOperationSuccess(
              message: 'Miktar başarıyla güncellendi'));
          final linesResult = await getLinesByCount(
              GetLinesByCountParams(countId: event.countId));
          await linesResult.fold(
            (failure) async => emit(LineError(message: failure.toString())),
            (lines) async => emit(ListLines(lines: lines)),
          );
        },
      );
    } catch (e) {
      emit(LineError(message: e.toString()));
    }
  }
}
