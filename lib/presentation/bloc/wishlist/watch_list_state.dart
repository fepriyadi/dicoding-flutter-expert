part of 'watch_list_bloc.dart';

@immutable
abstract class WatchlistState extends Equatable {}

class WatchlistInitial extends WatchlistState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WatchlistStatus extends WatchlistState {
  final bool isInWatchlist;
  WatchlistStatus(this.isInWatchlist);

  @override
  // TODO: implement props
  List<Object?> get props => [isInWatchlist];
}

class WatchlistActionSuccess extends WatchlistState {
  final String message;
  WatchlistActionSuccess(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class WatchlistSuccess extends WatchlistState {
  final List<Movie> movies;
  WatchlistSuccess(this.movies);

  @override
  // TODO: implement props
  List<Object?> get props => [movies];
}

class WatchlistActionFailure extends WatchlistState {
  final String error;
  WatchlistActionFailure(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
