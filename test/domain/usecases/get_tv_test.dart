import 'package:dartz/dartz.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTV usecase;
  late MockTvRepository repo;

  setUp(() {
    repo = MockTvRepository();
    usecase = GetTV(repo);
  });

  final tMovies = <TV>[];
  final tSeason = Season();
  final tTvDetail = TVDetail();
  final tTvId = 1;
  final tSeasonNo = 1;
  final tQuery = 'test';

  group('GetTv by Category Tests', () {
    group('execute', () {
      test(
          'should get list of tv from the repository when execute function is called',
          () async {
        // arrange
        when(repo.getTVSeries(TV_POPULAR))
            .thenAnswer((_) async => Right(tMovies));
        // act
        final result = await usecase.getTV(TV_POPULAR);
        // assert
        expect(result, Right(tMovies));
      });

      test(
          'should get list of tv from the repository when execute function is called',
              () async {
            // arrange
            when(repo.getTVSeries(TV_TOPRATED))
                .thenAnswer((_) async => Right(tMovies));
            // act
            final result = await usecase.getTV(TV_TOPRATED);
            // assert
            expect(result, Right(tMovies));
          });

      test(
          'should get list of tv from the repository when execute function is called',
              () async {
            // arrange
            when(repo.getTVSeries(TV_ONAIR))
                .thenAnswer((_) async => Right(tMovies));
            // act
            final result = await usecase.getTV(TV_ONAIR);
            // assert
            expect(result, Right(tMovies));
          });
    });
  });

  group('GetRecommendationsTV Tests', () {
    group('execute', () {
      test(
          'should get list of tv from the repository when execute function is called',
              () async {
            // arrange
            when(repo.getTVRecommendations(tTvId))
                .thenAnswer((_) async => Right(tMovies));
            // act
            final result = await usecase.getRecommendation(tTvId);
            // assert
            expect(result, Right(tMovies));
          });
    });
  });

  group('GetSeasonDetail Tests', () {
    group('execute', () {
      test(
          'should get Season Detail of tv from the repository when execute function is called',
              () async {
            // arrange
            when(repo.getSeasonDetail(tTvId,tSeasonNo))
                .thenAnswer((_) async => Right(tSeason));
            // act
            final result = await usecase.getSeasonDetail(tTvId, tSeasonNo);
            // assert
            expect(result, Right(tSeason));
          });
    });
  });

  group('GetTVDetail Tests', () {
    group('execute', () {
      test(
          'should get Detail of tv from the repository when execute function is called',
              () async {
            // arrange
            when(repo.getTVDetail(tTvId))
                .thenAnswer((_) async => Right(tTvDetail));
            // act
            final result = await usecase.getDetail(tTvId);
            // assert
            expect(result, Right(tTvDetail));
          });
    });
  });

  group('Search TV Tests', () {
    group('execute', () {
      test(
          'should search tv from the repository when execute function is called',
              () async {
            // arrange
            when(repo.searchTV(tQuery))
                .thenAnswer((_) async => Right(tMovies));
            // act
            final result = await usecase.searchMovie(tQuery);
            // assert
            expect(result, Right(tMovies));
          });
    });
  });

  group('TV Local save Tests', () {
    group('execute', () {
      test('should save tv to the repository', () async {
        // arrange
        when(repo.saveWatchlist(tTvDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        // act
        final result = await usecase.saveWatchlist(tTvDetail);
        // assert
        verify(repo.saveWatchlist(tTvDetail));
        expect(result, Right('Added to Watchlist'));
      });

      test('should remove tv to the repository', () async {
        // arrange
        when(repo.removeWatchlist(tTvDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        // act
        final result = await usecase.removeWatchlist(tTvDetail);
        // assert
        verify(repo.removeWatchlist(tTvDetail));
        expect(result, Right('Added to Watchlist'));
      });

      test('should get watchlist status from repository', () async {
        // arrange
        when(repo.isAddedToWatchlist(tTvId))
            .thenAnswer((_) async => true);
        // act
        final result = await usecase.isAddedToWatchlist(tTvId);
        // assert
        expect(result, true);
      });

      test('should get list of movies from the repository', () async {
        // arrange
        when(repo.getWatchlistTV())
            .thenAnswer((_) async => Right(tMovies));
        // act
        final result = await usecase.getWatchlistTV();
        // assert
        expect(result, Right(tMovies));
      });
    });
  });
}
