import 'package:ditonton/domain/entities/tv.dart';

import '../../common/utils.dart';
import '../../domain/entities/season.dart';

class TvModel extends TV {
  TvModel(
      {required name,
      required poster,
      required id,
      required backdrop,
      required voteAverage,
      required overview,
      required releaseDate})
      : super(
            name: name,
            poster: poster,
            id: id,
            backdrop: backdrop,
            voteAverage: voteAverage,
            releaseDate: releaseDate,
            overview: overview);

  factory TvModel.fromJson(Map<String, dynamic> json) {
    return TvModel(
      backdrop: json['backdrop_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['backdrop_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      poster: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['poster_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      id: json['id'],
      name: json['name'] ?? '',
      overview: json['overview'] ?? '',
      voteAverage: json['vote_average'].toDouble() ?? 0.0,
      releaseDate: (json['first_air_date'] != null &&
              json['first_air_date'].toString().isNotEmpty)
          ? "${monthgenrater(json['first_air_date'].split("-")[1])} ${json['first_air_date'].split("-")[2]}, ${json['first_air_date'].split("-")[0]}"
          : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'poster': poster,
      'id': id,
      'backdrop': backdrop,
      'voteAverage': voteAverage,
      'releaseDate': releaseDate,
      'overview': overview
    };
  }
}

class TvModelList {
  final List<TvModel> TVs;

  TvModelList({
    required this.TVs,
  });

  factory TvModelList.fromJson(Map<String, dynamic> json) {
    return TvModelList(
        TVs: List<TvModel>.from((json["results"] as List)
            .map((list) => TvModel.fromJson(list))
            .where((element) => element.poster.isNotEmpty)));
  }

  Map<String, dynamic> toJson() {
    return {
      'TVs': List<dynamic>.from(TVs.map((x) => x.toJson())),
    };
  }
}

class TVDetailModel extends TVDetail {
  TVDetailModel(
      {required adult,
      required backdrop,
      required id,
      required overview,
      required popularity,
      required poster,
      required releaseDate,
      required title,
      required voteAverage,
      required voteCount,
      required seasons})
      : super(
            seasons: seasons,
            adult: adult,
            backdrop: backdrop,
            id: id,
            overview: overview,
            popularity: popularity,
            poster: poster,
            releaseDate: releaseDate,
            title: title,
            voteAverage: voteAverage);

  factory TVDetailModel.fromJson(Map<String, dynamic> json) => TVDetailModel(
        seasons: (json['seasons'] as List<dynamic>?)
                ?.map((e) => SeasonModel.fromJson(e))
                .toList() ??
            [],
        adult: json["adult"] ?? false,
        backdrop:
            "https://image.tmdb.org/t/p/w500" + (json['backdrop_path'] ?? ''),
        id: json["id"] ?? 0,
        overview: json["overview"] ?? '',
        popularity: (json["popularity"] ?? 0)?.toDouble(),
        poster: "https://image.tmdb.org/t/p/w500" + (json['poster_path'] ?? ''),
        releaseDate: (json['first_air_date'] != null &&
                json['first_air_date'].toString().isNotEmpty)
            ? "${monthgenrater(json['first_air_date'].split("-")[1])} ${json['first_air_date'].split("-")[2]}, ${json['first_air_date'].split("-")[0]}"
            : "",
        title: json["name"] ?? '',
        voteAverage: (json["vote_average"] ?? 0)?.toDouble(),
        voteCount: json["vote_count"] ?? 0,
      );

  Map<String, dynamic> toJson() {
    return {
      'seasons': List<dynamic>.from(seasons.map((x) => x.toJson())),
      'adult': adult,
      'backdrop': backdrop,
      'id': id,
      'overview': overview,
      'popularity': popularity,
      'poster': poster,
      'releaseDate': releaseDate,
      'title': title,
      'voteAverage': voteAverage
    };
  }
}

class EpisodeModel extends Episode {
  const EpisodeModel({
    required id,
    required name,
    required episodeNumber,
    required airDate,
    required overview,
    required voteAverage,
  }) : super(
            id: id,
            name: name,
            episodeNumber: episodeNumber,
            airDate: airDate,
            overview: overview,
            voteAverage: voteAverage);

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      episodeNumber: json['episode_number'] as int? ?? 0,
      airDate: (json['air_date'] != null &&
              json['air_date'].toString().isNotEmpty)
          ? "${monthgenrater(json['air_date'].split("-")[1])} ${json['air_date'].split("-")[2]}, ${json['air_date'].split("-")[0]}"
          : "",
      overview: json['overview'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SeasonModel extends Season {
  const SeasonModel({
    required id,
    required name,
    required airDate,
    required episodeCount,
    required overview,
    required posterPath,
    required seasonNumber,
    required voteAverage,
    required episodes,
  }) : super(
            airDate: airDate,
            episodeCount: episodeCount,
            id: id,
            name: name,
            overview: overview,
            posterPath: posterPath,
            seasonNumber: seasonNumber,
            voteAverage: voteAverage,
            episodes: episodes);

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      episodes: (json['episodes'] as List<dynamic>? ?? [])
          .map((e) => EpisodeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      airDate: (json['air_date'] != null &&
              json['air_date'].toString().isNotEmpty)
          ? "${monthgenrater(json['air_date'].split("-")[1])} ${json['air_date'].split("-")[2]}, ${json['air_date'].split("-")[0]}"
          : "",
      episodeCount: json['episode_count'] ?? 0,
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['poster_path']
          : "",
      seasonNumber: json['season_number'] ?? 0,
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'air_date': airDate,
      'episode_count': episodeCount,
      'id': id,
      'name': name,
      'overview': overview,
      'poster_path': posterPath,
      'season_number': seasonNumber,
      'vote_average': voteAverage,
      "episodes": List<dynamic>.from(episodes.map((x) => x.toJson())),
    };
  }
}
