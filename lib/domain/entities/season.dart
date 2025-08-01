import 'package:equatable/equatable.dart';

class Season extends Equatable {
  final String airDate;
  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final int seasonNumber;
  final double voteAverage;
  final List<Episode> episodes;

  const Season({
    this.airDate = '',
    this.episodeCount = 0,
    this.id = 0,
    this.name = '',
    this.overview = '',
    this.posterPath = '',
    this.seasonNumber = 0,
    this.voteAverage = 0.0,
    this.episodes = const [],
  });

  Map<String, dynamic> toJson() => {
        'airDate ': airDate,
        'episodeCount ': episodeCount,
        'id ': id,
        'name ': name,
        'overview ': overview,
        'posterPath ': posterPath,
        'seasonNumber ': seasonNumber,
        'voteAverage ': voteAverage,
        'episodes ': episodes.map((x) => x.toJson()),
      };

  @override
  List<Object?> get props => [
        airDate,
        episodeCount,
        id,
        name,
        overview,
        posterPath,
        seasonNumber,
        voteAverage,
        episodes,
      ];
}

class Episode extends Equatable {
  final int id;
  final String name;
  final int episodeNumber;
  final String airDate;
  final String overview;
  final double voteAverage;

  const Episode({
    required this.id,
    required this.name,
    required this.episodeNumber,
    required this.airDate,
    required this.overview,
    required this.voteAverage,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "episodeNumber": episodeNumber,
        "airDate": airDate,
        "overview": overview,
        "voteAverage": voteAverage,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        episodeNumber,
        airDate,
        overview,
        voteAverage,
      ];
}
