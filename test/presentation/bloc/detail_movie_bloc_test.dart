import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/detail_movie/detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late DetailMovieBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    bloc = DetailMovieBloc(mockGetMovieDetail, mockGetMovieRecommendations);
  });

  const tId = 1;

  test('initial state is SeasonState("initial")', () {
    expect(bloc.state, DetailMovieInitial());
  });

  blocTest<DetailMovieBloc, DetailMovieState>(
    'emits [Loading, Loaded] when both GetMovieDetail and GetMovieRecommendations succeed',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));

      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testMovieList));

      return bloc;
    },
    act: (bloc) => bloc.add(DetailMovieData(id: tId)),
    expect: () => [
      DetailMovieLoading(),
      DetailMovieLoaded(detail: testMovieDetail, recommendations: testMovieList),
    ],
  );

  blocTest<DetailMovieBloc, DetailMovieState>(
    'emits [loading, error] when failure',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('error')));

      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('error')));

      return bloc;
    },
    act: (bloc) => bloc.add(DetailMovieData(id: tId)),
    expect: () => [
      DetailMovieLoading(),
      DetailMovieError(error: DataError('error')),
      DetailMovieLoaded(detail: MovieDetail(), recommendations: []),
    ],
  );
}