part of 'season_bloc.dart';

@immutable
abstract class SeasonEvent {}

class FetchSeasonData extends SeasonEvent {
  final int seriesId;
  final int seasonNo;

  FetchSeasonData({required this.seriesId, required this.seasonNo});
}
