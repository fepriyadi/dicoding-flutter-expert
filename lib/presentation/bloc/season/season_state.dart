part of 'season_bloc.dart';

@immutable
abstract class FetchSeasonState {}

class FetchSeasonInitial extends FetchSeasonState {}

class FetchSeasonLoading extends FetchSeasonState {}

class SeasonDetailLoaded extends FetchSeasonState {
  final Season season;
  SeasonDetailLoaded({
    required this.season,
  });
}

class SeasonError extends FetchSeasonState {
  final DataError error;
  SeasonError({
    required this.error,
  });
}

class DataError {
  final String message;

  DataError(this.message);
}
