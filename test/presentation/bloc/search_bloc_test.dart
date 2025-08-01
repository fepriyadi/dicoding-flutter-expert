import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/search/search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchBloc bloc;
  late MockGetTV mockGetTV;
  late MockSearchMovies mockSearchMovies;
  setUp(() {
    mockGetTV = MockGetTV();
    mockSearchMovies = MockSearchMovies();
    bloc = SearchBloc(mockGetTV, mockSearchMovies);
  });

  const tQuery = 'Spiderman';

  test('initial state is SeasonState("initial")', () {
    expect(bloc.state, SearchInitial());
  });

  blocTest<SearchBloc, SearchState>(
    'emits [Loading, Loaded] when both GetMovieDetail and GetMovieRecommendations succeed',
    build: () {
      when(mockGetTV.searchMovie(tQuery))
          .thenAnswer((_) async => Right(<TV>[]));

      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(testMovieList));

      return bloc;
    },
    act: (bloc) => bloc.add(SearchData(query: tQuery)),
    expect: () => [
      SearchLoading(),
      SearchLoaded(tv: <TV>[], movies: testMovieList),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'emits [loading, error] when failure',
    build: () {
      when(mockGetTV.searchMovie(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('error')));

      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('error')));

      return bloc;
    },
    act: (bloc) => bloc.add(SearchData(query: tQuery)),
    expect: () => [
      SearchLoading(),
      SearchError(error: DataError('error')),
      SearchLoaded(movies: <Movie>[], tv: <TV>[]),
    ],
  );
}