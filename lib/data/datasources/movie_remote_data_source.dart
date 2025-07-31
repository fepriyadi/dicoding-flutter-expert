import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/data/models/movie_response.dart';
import 'package:ditonton/data/models/tv_models.dart';
import 'package:http/io_client.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();

  Future<List<MovieModel>> getPopularMovies();

  Future<List<MovieModel>> getTopRatedMovies();

  Future<MovieDetailResponse> getMovieDetail(int id);

  Future<List<MovieModel>> getMovieRecommendations(int id);

  Future<List<MovieModel>> searchMovies(String query);

  Future<List<TvModel>> getTV(String category);

  Future<TVDetailModel> getTVDetail(int id);

  Future<SeasonModel> getSeasonDetail(int id, int seasonNo);

  Future<List<TvModel>> getTVRecommendations(int id);

  Future<List<TvModel>> searchTV(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final IOClient client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final response = await client.get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    final response =
        await client.get(Uri.parse('$BASE_URL/movie/$id?$API_KEY'));

    if (response.statusCode == 200) {
      return MovieDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/movie/$id/recommendations?$API_KEY'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/movie/popular?$API_KEY'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/movie/top_rated?$API_KEY'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/search/movie?$API_KEY&query=$query'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SeasonModel> getSeasonDetail(int id, int seasonNo) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/tv/$id/season/$seasonNo?$API_KEY'));

    if (response.statusCode == 200) {
      return SeasonModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TVDetailModel> getTVDetail(int id) async {
    // TODO: implement getTVDetail
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if (response.statusCode == 200) {
      return TVDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTVRecommendations(int id) async {
    // TODO: implement getTVRecommendations
    final response = await client
        .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));

    if (response.statusCode == 200) {
      return TvModelList.fromJson(json.decode(response.body)).TVs;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> searchTV(String query) async {
    // TODO: implement searchTV
    final response = await client
        .get(Uri.parse('$BASE_URL/search/tv?query=$query&$API_KEY'));

    if (response.statusCode == 200) {
      return TvModelList.fromJson(json.decode(response.body)).TVs;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTV(String category) async {
    // TODO: implement getTV
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/$category?$API_KEY'));

    if (response.statusCode == 200) {
      return TvModelList.fromJson(json.decode(response.body)).TVs;
    } else {
      throw ServerException();
    }
  }
}
