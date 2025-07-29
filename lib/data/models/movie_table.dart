import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

class MovieTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final int isTV;

  MovieTable({
    required this.isTV,
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
  });

  factory MovieTable.fromEntity(MovieDetail movie) =>
      MovieTable(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        overview: movie.overview,
        isTV: 0,
      );

  factory MovieTable.fromTV(TVDetail tv) =>
      MovieTable(
          id: tv.id,
          title: tv.title,
          posterPath: tv.poster,
          overview: tv.overview,
          isTV: 1);

  factory MovieTable.fromMap(Map<String, dynamic> map) =>
      MovieTable(
          id: map['id'],
          title: map['title'],
          posterPath: map['posterPath'],
          overview: map['overview'],
          isTV: map['isTV']);

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'isTV': isTV
      };

  Movie toEntity() =>
      Movie.watchlist(
          id: id,
          overview: overview,
          posterPath: posterPath,
          title: title,
          isTV: isTV
      );

  TV toTV() =>
      TV(
        id: this.id,
        overview: this.overview ?? '',
        poster: this.posterPath ?? '',
        name: this.title ?? '',
        backdrop: '',
        voteAverage: 0,
        releaseDate: '',
      );

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, posterPath, overview];
}
