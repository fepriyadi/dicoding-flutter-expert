part of 'detail_bloc.dart';

@immutable
abstract class DetailMovieState {}

class DetailMovieInitial extends DetailMovieState {}

class DetailMovieLoading extends DetailMovieState {}

class DetailMovieLoaded extends DetailMovieState {
  final MovieDetail detail;
  final List<Movie> recommendations;
  DetailMovieLoaded({required this.detail, required this.recommendations});
}

class DetailMovieError extends DetailMovieState {
  final DataError error;
  DetailMovieError({
    required this.error,
  });
}

class DataError {
  final String message;

  DataError(this.message);
}
