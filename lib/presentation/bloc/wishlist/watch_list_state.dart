part of 'watch_list_bloc.dart';

@immutable
abstract class WatchlistState {}

class WatchlistInitial extends WatchlistState {}

class WatchlistStatus extends WatchlistState {
  final bool isInWatchlist;
  WatchlistStatus(this.isInWatchlist);
}

class WatchlistActionSuccess extends WatchlistState {
  final String message;
  WatchlistActionSuccess(this.message);
}

class WatchlistSuccess extends WatchlistState {
  final List<Movie> movies;
  WatchlistSuccess(this.movies);
}

class WatchlistActionFailure extends WatchlistState {
  final String error;
  WatchlistActionFailure(this.error);
}
