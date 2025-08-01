import 'package:ditonton/domain/entities/detail_video.dart';
import 'package:ditonton/domain/entities/list_recommendations.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class TV extends RecommendationEntity implements Equatable {
  final String name;
  final String poster;
  final int id;
  final String backdrop;
  final double voteAverage;
  final String releaseDate;
  final String overview;

  TV({
    required this.name,
    required this.poster,
    required this.id,
    required this.backdrop,
    required this.voteAverage,
    required this.releaseDate,
    required this.overview,
  });

  factory TV.fromMovie(Movie movie) => TV(
      id: movie.id,
      overview: movie.overview ?? '',
      poster: movie.posterPath ?? '',
      name: movie.title ?? '',
      backdrop: '',
      voteAverage: 0,
      releaseDate: '');

  double get rating => double.parse(voteAverage.toStringAsFixed(2));

  @override
  String get title => name;

  List<Object?> get props => [id, name, poster, posterPath];

  @override
  // TODO: implement posterPath
  String? get posterPath => poster;

  @override
  // TODO: implement stringify
  bool? get stringify => true;
}

class TVDetail extends DetailVideo {
  final bool adult;
  final int id;
  final String overview;
  final double popularity;
  final String poster;
  final String backdrop;
  final String releaseDate;
  final String title;
  final double voteAverage;
  final List<Season> seasons;

  double get rating => double.parse(voteAverage.toStringAsFixed(2));

  TVDetail({
    this.adult = false,
    this.id = 0,
    this.overview = '',
    this.popularity = 0.0,
    this.poster = '',
    this.backdrop = '',
    this.releaseDate = '',
    this.title = '',
    this.voteAverage = 0.0,
    this.seasons = const [],
  });

  List<Object?> get props =>
      [id, poster, posterPath, title, overview, releaseDate, rating, seasons];

  @override
  String get posterPath => poster;

  @override
  // TODO: implement stringify
  bool? get stringify => true;
}
