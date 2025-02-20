import 'package:birincisayim/features/line/data/models/line_model.dart';
import 'package:bloc/bloc.dart';

import 'package:birincisayim/features/line/data/services/line_service.dart';

part 'lines_event.dart';
part 'lines_state.dart';

class LinesBloc extends Bloc<LinesEvent, LinesState> {
  LinesBloc() : super(LinesInitial()) {
    on<ListLineEvent>((event, emit) async {
      var lines = await LineService.getLinesByCount(event.countId);
      emit(ListLines(lines));
    });
  }
}
