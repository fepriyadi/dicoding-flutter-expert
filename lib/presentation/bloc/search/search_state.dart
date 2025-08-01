part of 'search_bloc.dart';

@immutable
abstract class SearchState extends Equatable {}

class SearchInitial extends SearchState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SearchLoading extends SearchState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SearchLoaded extends SearchState {
  final List<TV> tv;
  final List<Movie> movies;
  SearchLoaded({
    required this.tv,
    required this.movies,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [tv, movies];
}

class SearchError extends SearchState {
  final DataError error;
  SearchError({
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
