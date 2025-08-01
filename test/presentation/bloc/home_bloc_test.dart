import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/home/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late HomeBloc bloc;
  late MockGetTV mockGetTV;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  setUp(() {
    mockGetTV = MockGetTV();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    bloc = HomeBloc(mockGetTV, mockGetPopularMovies, mockGetNowPlayingMovies, mockGetTopRatedMovies);
  });

  test('initial state is SeasonState("initial")', () {
    expect(bloc.state, HomeInitial());
  });

  blocTest<HomeBloc, HomeState>(
    'emits [Loading, Loaded] when both GetMovieDetail and GetMovieRecommendations succeed',
    build: () {
      when(mockGetTV.getTV(TV_POPULAR))
          .thenAnswer((_) async => Right(<TV>[]));

      when(mockGetTV.getTV(TV_ONAIR))
          .thenAnswer((_) async => Right(<TV>[]));

      when(mockGetTV.getTV(TV_TOPRATED))
          .thenAnswer((_) async => Right(<TV>[]));

      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));

      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));

      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));

      return bloc;
    },
    act: (bloc) => bloc.add(HomeData()),
    expect: () => [
      HomeLoading(),
      HomeLoaded(tranding: <TV>[],toprated: <TV>[], upcoming: <TV>[], movieNowPlaying: testMovieList,
          moviePopular: testMovieList, movieTopRated: testMovieList),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits [loading, error] when failure',
    build: () {
      when(mockGetTV.getTV(TV_POPULAR))
          .thenAnswer((_) async => Left(ServerFailure('error')));

      when(mockGetTV.getTV(TV_ONAIR))
          .thenAnswer((_) async => Left(ServerFailure('error')));

      when(mockGetTV.getTV(TV_TOPRATED))
          .thenAnswer((_) async => Left(ServerFailure('error')));

      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('error')));

      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('error')));

      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('error')));

      return bloc;
    },
    act: (bloc) => bloc.add(HomeData()),
    expect: () => [
      HomeLoading(),
      HomeError(error: DataError('error')),
      HomeLoaded(tranding: <TV>[],toprated: <TV>[], upcoming: <TV>[], movieNowPlaying: <Movie>[],
          moviePopular: <Movie>[], movieTopRated: <Movie>[]),
    ],
  );
}