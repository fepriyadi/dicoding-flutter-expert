part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<TV> tranding;
  final List<TV> upcoming;
  final List<TV> toprated;
  final List<Movie> movieNowPlaying;
  final List<Movie> moviePopular;
  final List<Movie> movieTopRated;
  HomeLoaded({
    required this.tranding,
    required this.upcoming,
    required this.toprated,
    required this.movieNowPlaying,
    required this.moviePopular,
    required this.movieTopRated,
  });
}

class HomeError extends HomeState {
  final DataError error;
  HomeError({
    required this.error,
  });
}

class DataError {
  final String message;

  DataError(this.message);
}
