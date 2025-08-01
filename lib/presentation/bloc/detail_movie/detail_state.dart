part of 'detail_bloc.dart';

@immutable
abstract class DetailMovieState extends Equatable {}

class DetailMovieInitial extends DetailMovieState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DetailMovieLoading extends DetailMovieState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DetailMovieLoaded extends DetailMovieState {
  final MovieDetail detail;
  final List<Movie> recommendations;
  DetailMovieLoaded({required this.detail, required this.recommendations});

  @override
  List<Object?> get props => [detail, recommendations];
}

class DetailMovieError extends DetailMovieState {
  final DataError error;
  DetailMovieError({
    required this.error,
  });

  @override
  // TODO: implement props
  @override
  List<Object?> get props => [error];
}

class DataError extends Equatable {
  final String message;

  DataError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
