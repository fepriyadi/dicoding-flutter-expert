class Season {
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
}

class Episode {
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
}
