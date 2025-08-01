part of 'season_bloc.dart';

@immutable
abstract class FetchSeasonState extends Equatable {}

class FetchSeasonInitial extends FetchSeasonState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchSeasonLoading extends FetchSeasonState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SeasonDetailLoaded extends FetchSeasonState {
  final Season season;
  SeasonDetailLoaded({
    required this.season,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [season];
}

class SeasonError extends FetchSeasonState {
  final DataError error;
  SeasonError({
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
