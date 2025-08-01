import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/view_all_bloc/viewall_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late ViewAllBloc blocPopular;
  late ViewAllBloc blocOnAir;
  late ViewAllBloc blocTopRated;
  late MockGetTV mockGetTV;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  setUp(() {
    mockGetTV = MockGetTV();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    blocPopular = ViewAllBloc(mockGetTV, mockGetPopularMovies);
    blocOnAir = ViewAllBloc(mockGetTV, mockGetNowPlayingMovies);
    blocTopRated = ViewAllBloc(mockGetTV, mockGetTopRatedMovies);
  });

  test('initial state is SeasonState("initial")', () {
    expect(blocPopular.state, ViewAllInitial());
    expect(blocOnAir.state, ViewAllInitial());
    expect(blocTopRated.state, ViewAllInitial());
  });

  group('TV View All', () {
    group('execute', () {
      blocTest<ViewAllBloc, ViewAllState>(
        'should return list of TV ON AIR ',
        build: () {
          when(mockGetTV.getTV(TV_ONAIR)).thenAnswer((_) async => Right(<TV>[]));

          return blocOnAir;
        },
        act: (bloc) => bloc.add(FetchCategoryItems(
            categoryType: CategoryType.onair, type: ContentType.tv)),
        expect: () => [
          ViewAllLoading(),
          ViewAllSuccess([], <TV>[]),
        ],
      );

      blocTest<ViewAllBloc, ViewAllState>(
        'should return error to fetch TV ON AIR',
        build: () {
          when(mockGetTV.getTV(TV_ONAIR))
              .thenAnswer((_) async => Left(ServerFailure('error')));

          return blocOnAir;
        },
        act: (bloc) => bloc.add(FetchCategoryItems(
            type: ContentType.tv, categoryType: CategoryType.onair)),
        expect: () => [
          ViewAllLoading(),
          ViewAllFailure('error'),
        ],
      );
    });

    group('execute', () {
      blocTest<ViewAllBloc, ViewAllState>(
        'should return list of TV POPULAR ',
        build: () {
          when(mockGetTV.getTV(TV_POPULAR)).thenAnswer((_) async => Right(<TV>[]));

          return blocPopular;
        },
        act: (bloc) => bloc.add(FetchCategoryItems(
            categoryType: CategoryType.popular, type: ContentType.tv)),
        expect: () => [
          ViewAllLoading(),
          ViewAllSuccess([], <TV>[]),
        ],
      );

      blocTest<ViewAllBloc, ViewAllState>(
        'should return error to fetch TV POPULAR',
        build: () {
          when(mockGetTV.getTV(TV_POPULAR))
              .thenAnswer((_) async => Left(ServerFailure('error')));

          return blocPopular;
        },
        act: (bloc) => bloc.add(FetchCategoryItems(
            type: ContentType.tv, categoryType: CategoryType.popular)),
        expect: () => [
          ViewAllLoading(),
          ViewAllFailure('error'),
        ],
      );
    });

    group('execute', () {
      blocTest<ViewAllBloc, ViewAllState>(
        'should return list of TV TOP RATED ',
        build: () {
          when(mockGetTV.getTV(TV_TOPRATED)).thenAnswer((_) async => Right(<TV>[]));

          return blocTopRated;
        },
        act: (bloc) => bloc.add(FetchCategoryItems(
            categoryType: CategoryType.topRated, type: ContentType.tv)),
        expect: () => [
          ViewAllLoading(),
          ViewAllSuccess([], <TV>[]),
        ],
      );

      blocTest<ViewAllBloc, ViewAllState>(
        'should return error to fetch TV TOP RATED',
        build: () {
          when(mockGetTV.getTV(TV_TOPRATED))
              .thenAnswer((_) async => Left(ServerFailure('error')));

          return blocTopRated;
        },
        act: (bloc) => bloc.add(FetchCategoryItems(
            type: ContentType.tv, categoryType: CategoryType.topRated)),
        expect: () => [
          ViewAllLoading(),
          ViewAllFailure('error'),
        ],
      );
    });
  });


  group('Movie View All', () {
    group('execute', () {
      blocTest<ViewAllBloc, ViewAllState>(
        'should return list of Movie ON AIR ',
        build: () {
          when(mockGetNowPlayingMovies.execute()).thenAnswer((_) async => Right(testMovieList));
          return blocOnAir;
        },
        act: (bloc) => bloc.add(FetchCategoryItems(
            categoryType: CategoryType.onair, type: ContentType.movie)),
        expect: () => [
          ViewAllLoading(),
          ViewAllSuccess(testMovieList, []),
        ],
      );

      blocTest<ViewAllBloc, ViewAllState>(
        'should return error to fetch Movie ON AIR',
        build: () {
          when(mockGetNowPlayingMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('error')));

          return blocOnAir;
        },
        act: (bloc) => bloc.add(FetchCategoryItems(
            type: ContentType.movie, categoryType: CategoryType.onair)),
        expect: () => [
          ViewAllLoading(),
          ViewAllFailure('error'),
        ],
      );
    });

    group('execute', () {
      blocTest<ViewAllBloc, ViewAllState>(
        'should return list of Movie POPULAR ',
        build: () {
          when(mockGetPopularMovies.execute()).thenAnswer((_) async => Right(testMovieList));

          return blocPopular;
        },
        act: (bloc) => bloc.add(FetchCategoryItems(
            categoryType: CategoryType.popular, type: ContentType.movie)),
        expect: () => [
          ViewAllLoading(),
          ViewAllSuccess(testMovieList, []),
        ],
      );

      blocTest<ViewAllBloc, ViewAllState>(
        'should return error to fetch Movie POPULAR',
        build: () {
          when(mockGetPopularMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('error')));

          return blocPopular;
        },
        act: (bloc) => bloc.add(FetchCategoryItems(
            type: ContentType.movie, categoryType: CategoryType.popular)),
        expect: () => [
          ViewAllLoading(),
          ViewAllFailure('error'),
        ],
      );
    });

    group('execute', () {
      blocTest<ViewAllBloc, ViewAllState>(
        'should return list of Movie TOP RATED ',
        build: () {
          when(mockGetTopRatedMovies.execute()).thenAnswer((_) async => Right(testMovieList));

          return blocTopRated;
        },
        act: (bloc) => bloc.add(FetchCategoryItems(
            categoryType: CategoryType.topRated, type: ContentType.movie)),
        expect: () => [
          ViewAllLoading(),
          ViewAllSuccess(testMovieList, []),
        ],
      );

      blocTest<ViewAllBloc, ViewAllState>(
        'should return error to fetch Movie TOP RATED',
        build: () {
          when(mockGetTopRatedMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('error')));

          return blocTopRated;
        },
        act: (bloc) => bloc.add(FetchCategoryItems(
            type: ContentType.movie, categoryType: CategoryType.topRated)),
        expect: () => [
          ViewAllLoading(),
          ViewAllFailure('error'),
        ],
      );
    });
  });

}
