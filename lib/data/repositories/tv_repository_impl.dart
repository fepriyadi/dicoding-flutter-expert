import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/detail_video.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

import '../../domain/entities/season.dart';

class TvRepositoryImpl implements TvRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  TvRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<TV>>> getTVRecommendations(int id) async {
    try {
      final result = await remoteDataSource.getTVRecommendations(id);
      return Right(result.map((model) => model).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> getTVSeries(String category) async {
    try {
      final result = await remoteDataSource.getTV(category);
      return Right(result.map((model) => model).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> searchTV(String query) async {
    try {
      final result = await remoteDataSource.searchTV(query);
      return Right(result.map((model) => model).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(DetailVideo detail) async {
    try {
      final result =
          await localDataSource.insertWatchlist(MovieTable.fromTV(detail));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(DetailVideo movie) async {
    try {
      final result =
          await localDataSource.removeWatchlist(MovieTable.fromTV(movie));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await localDataSource.getMovieById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<TV>>> getWatchlistTV() async {
    final result = await localDataSource.getWatchlistMovies();
    return Right(result.map((data) => data.toTV()).toList());
  }

  @override
  Future<Either<Failure, Season>> getSeasonDetail(int id, int seasonNo) async {
    try {
      final result = await remoteDataSource.getSeasonDetail(id, seasonNo);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, TVDetail>> getTVDetail(int id) async {
    // TODO: implement getTvDetail
    try {
      final result = await remoteDataSource.getTVDetail(id);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
