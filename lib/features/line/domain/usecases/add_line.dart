import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/line_entity.dart';
import '../repositories/line_repository.dart';

class AddLine implements UseCase<void, AddLineParams> {
  final LineRepository repository;

  AddLine(this.repository);

  @override
  Future<Either<Failure, void>> call(AddLineParams params) async {
    return await repository.addLine(params.line);
  }
}

class AddLineParams extends Equatable {
  final LineEntity line;

  const AddLineParams({required this.line});

  @override
  List<Object?> get props => [line];
}
