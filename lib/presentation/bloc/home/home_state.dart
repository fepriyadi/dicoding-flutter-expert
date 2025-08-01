part of 'home_bloc.dart';

@immutable
abstract class HomeState extends Equatable {}

class HomeInitial extends HomeState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

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

  @override
  // TODO: implement props
  List<Object?> get props => [
        tranding,
        upcoming,
        toprated,
        movieNowPlaying,
        movieTopRated,
        movieNowPlaying
      ];
}

class HomeError extends HomeState {
  final DataError error;
  HomeError({
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
