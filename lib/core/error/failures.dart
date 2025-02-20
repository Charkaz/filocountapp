import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure({String message = 'Cache Failure'})
      : super(message: message);
}

class ServerFailure extends Failure {
  const ServerFailure({String message = 'Server Failure'})
      : super(message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message, String? code})
      : super(message: message);
}

class ValidationFailure extends Failure {
  const ValidationFailure({required String message, String? code})
      : super(message: message);
}
