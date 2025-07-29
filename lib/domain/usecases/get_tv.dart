import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

import '../../common/failure.dart';

class GetTV {
  final TvRepository repository;

  GetTV(this.repository);

  Future<Either<Failure, List<TV>>> getTV(String category) {
    return repository.getTVSeries(category);
  }

  Future<Either<Failure, List<TV>>> getRecommendation(int id) async {
    return repository.getTVRecommendations(id);
  }

  Future<Either<Failure, Season>> getSeasonDetail(int seriesId, int seasonNo) async {
    return await repository.getSeasonDetail(seriesId, seasonNo);
  }

  Future<Either<Failure, TVDetail>> getDetail(int id) async {
    return await repository.getTVDetail(id);
  }

  Future<Either<Failure, List<TV>>> searchMovie(String query) async {
    return await repository.searchTV(query);
  }

  Future<Either<Failure, String>> saveWatchlist(TVDetail movie) async {
    return await repository.saveWatchlist(movie);
  }

  Future<Either<Failure, String>> removeWatchlist(TVDetail movie) async {
    return await repository.removeWatchlist(movie);
  }

  Future<bool> isAddedToWatchlist(int id) async {
    return await repository.isAddedToWatchlist(id);
  }

  Future<Either<Failure, List<TV>>> getWatchlistTV() async {
    return await repository.getWatchlistTV();
  }

}