part of 'watch_list_bloc.dart';

@immutable
abstract class WatchlistEvent {}

class AddToWatchlist extends WatchlistEvent {
  final DetailVideo movie;
  final ContentType type;
  AddToWatchlist(this.movie, this.type);
}

class GetAllWatchlist extends WatchlistEvent {}

class RemoveFromWatchlist extends WatchlistEvent {
  final DetailVideo movie;
  final ContentType type;
  RemoveFromWatchlist(this.movie, this.type);
}

class CheckWatchlistStatus extends WatchlistEvent {
  final int movieId;
  final ContentType type;
  CheckWatchlistStatus(this.movieId, this.type);
}
