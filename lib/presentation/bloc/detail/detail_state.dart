part of 'detail_bloc.dart';

@immutable
abstract class DetailState {}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  final List<TV> recommendation;
  final TVDetail detail;
  DetailLoaded({
    required this.recommendation,
    required this.detail,
  });
}

class DetailError extends DetailState {
  final DataError error;
  DetailError({
    required this.error,
  });
}

class DataError {
  final String message;

  DataError(this.message);
}
