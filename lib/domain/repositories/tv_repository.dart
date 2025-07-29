import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv.dart';

abstract class TvRepository {
  Future<Either<Failure, List<TV>>> getTVSeries(String category);
  Future<Either<Failure, TVDetail>> getTVDetail(int id);
  Future<Either<Failure, Season>> getSeasonDetail(int id, int seasonNo);
  Future<Either<Failure, List<TV>>> getTVRecommendations(int id);
  Future<Either<Failure, List<TV>>> searchTV(String query);
  Future<Either<Failure, String>> saveWatchlist(TVDetail movie);
  Future<Either<Failure, String>> removeWatchlist(TVDetail movie);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<TV>>> getWatchlistTV();
}
