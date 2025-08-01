import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/detail/detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late DetailTVBloc bloc;
  late MockGetTV mockGetTV;
  setUp(() {
    mockGetTV = MockGetTV();
    bloc = DetailTVBloc(mockGetTV);
  });

  const tId = 1;

  test('initial state is SeasonState("initial")', () {
    expect(bloc.state, DetailInitial());
  });

  blocTest<DetailTVBloc, DetailState>(
    'emits [Loading, Loaded] when both GetMovieDetail and GetMovieRecommendations succeed',
    build: () {
      when(mockGetTV.getDetail(tId))
          .thenAnswer((_) async => Right(TVDetail()));

      when(mockGetTV.getRecommendation(tId))
          .thenAnswer((_) async => Right(<TV>[]));

      return bloc;
    },
    act: (bloc) => bloc.add(DetailData(id: tId)),
    expect: () => [
      DetailLoading(),
      DetailLoaded(detail: TVDetail(), recommendation: <TV>[]),
    ],
  );

  blocTest<DetailTVBloc, DetailState>(
    'emits [loading, error] when failure',
    build: () {
      when(mockGetTV.getDetail(tId))
          .thenAnswer((_) async => Left(ServerFailure('error')));

      when(mockGetTV.getRecommendation(tId))
          .thenAnswer((_) async => Left(ServerFailure('error')));

      return bloc;
    },
    act: (bloc) => bloc.add(DetailData(id: tId)),
    expect: () => [
      DetailLoading(),
      DetailError(error: DataError('error')),
      DetailLoaded(detail: TVDetail(), recommendation: <TV>[]),
    ],
  );
}