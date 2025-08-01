import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/presentation/bloc/season/season_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late FetchSeasonBloc bloc;
  late MockGetTV mockGetTV;
  setUp(() {
    mockGetTV = MockGetTV();
    bloc = FetchSeasonBloc(mockGetTV);
  });

  const tId = 1;
  const tSeasonNo = 1;

  test('initial state is SeasonState("initial")', () {
    expect(bloc.state, FetchSeasonInitial());
  });

  blocTest<FetchSeasonBloc, FetchSeasonState>(
    'emits [Loading, Loaded] when both GetMovieDetail and GetMovieRecommendations succeed',
    build: () {
      when(mockGetTV.getSeasonDetail(tId, tSeasonNo))
          .thenAnswer((_) async => Right(Season()));

      return bloc;
    },
    act: (bloc) => bloc.add(FetchSeasonData(seriesId: tId, seasonNo: tSeasonNo)),
    expect: () => [
      FetchSeasonLoading(),
      SeasonDetailLoaded(season: Season()),
    ],
  );

  blocTest<FetchSeasonBloc, FetchSeasonState>(
    'emits [loading, error] when failure',
    build: () {
      when(mockGetTV.getSeasonDetail(tId, tSeasonNo))
          .thenAnswer((_) async => Left(ServerFailure('error')));

      return bloc;
    },
    act: (bloc) => bloc.add(FetchSeasonData(seasonNo: tSeasonNo, seriesId: tId)),
    expect: () => [
      FetchSeasonLoading(),
      SeasonError(error: DataError('error')),
      SeasonDetailLoaded(season: Season()),
    ],
  );
}