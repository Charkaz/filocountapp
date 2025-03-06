import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/line_repository.dart';

class UpdateQuantity implements UseCase<void, UpdateQuantityParams> {
  final LineRepository repository;

  UpdateQuantity(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateQuantityParams params) async {
    return await repository.updateQuantity(params.id, params.quantity);
  }
}

class UpdateQuantityParams extends Equatable {
  final String id;
  final double quantity;

  const UpdateQuantityParams({
    required this.id,
    required this.quantity,
  });

  @override
  List<Object?> get props => [id, quantity];
}
