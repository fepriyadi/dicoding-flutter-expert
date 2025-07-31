part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<TV> tv;
  final List<Movie> movies;
  SearchLoaded({
    required this.tv,
    required this.movies,
  });
}

class SearchError extends SearchState {
  final DataError error;
  SearchError({
    required this.error,
  });
}

class DataError {
  final String message;

  DataError(this.message);
}
