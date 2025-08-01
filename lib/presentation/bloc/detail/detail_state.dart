part of 'detail_bloc.dart';

@immutable
abstract class DetailState extends Equatable {}

class DetailInitial extends DetailState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DetailLoading extends DetailState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DetailLoaded extends DetailState {
  final List<TV> recommendation;
  final TVDetail detail;
  DetailLoaded({
    required this.recommendation,
    required this.detail,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [detail, recommendation];
}

class DetailError extends DetailState {
  final DataError error;
  DetailError({
    required this.error,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class DataError extends Equatable {
  final String message;

  DataError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
