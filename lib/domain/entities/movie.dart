import 'package:ditonton/domain/entities/list_recommendations.dart';
import 'package:equatable/equatable.dart';

class Movie extends Equatable implements RecommendationEntity {
  final int? isTV;
  final bool? adult;
  final String? backdropPath;
  final List<int>? genreIds;
  final int id;
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;

  const Movie({
    this.adult,
    this.backdropPath,
    this.genreIds,
    required this.id,
    this.originalTitle,
    this.overview,
    this.popularity,
    required this.posterPath,
    this.releaseDate,
    required this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.isTV,
  });

  const Movie.watchlist({
    required this.id,
    this.overview,
    this.posterPath,
    this.title,
    this.isTV,
  })  : adult = null,
        backdropPath = null,
        genreIds = null,
        originalTitle = null,
        popularity = null,
        releaseDate = null,
        video = null,
        voteAverage = null,
        voteCount = null;

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genreIds,
        id,
        originalTitle,
        overview,
        popularity,
        posterPath,
        releaseDate,
        title,
        video,
        voteAverage,
        voteCount,
        isTV,
      ];
}
