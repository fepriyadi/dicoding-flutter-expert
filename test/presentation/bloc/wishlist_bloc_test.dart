import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/wishlist/watch_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late WatchlistBloc bloc;
  late MockGetTV mockGetTV;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchListStatus;

  setUp(() {
    mockGetTV = MockGetTV();
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    mockGetWatchListStatus = MockGetWatchListStatus();
    bloc = WatchlistBloc(mockGetTV, mockSaveWatchlist, mockRemoveWatchlist, mockGetWatchListStatus, mockGetWatchlistMovies);
  });

  group('TV Watchlist', () {
    test('initial state is SeasonState("initial")', () {
      expect(bloc.state, WatchlistInitial());
    });

    group('execute', () {
      blocTest<WatchlistBloc, WatchlistState>(
        'should return success to get Watchlist status TV ',
        build: () {
          when(mockGetTV.isAddedToWatchlist(1)).thenAnswer((_) async => true);

          return bloc;
        },
        act: (bloc) => bloc.add(CheckWatchlistStatus(1, ContentType.tv)),
        expect: () => [WatchlistStatus(true)],
      );

      blocTest<WatchlistBloc, WatchlistState>(
        'should return error for get watchlist status',
        build: () {
          when(mockGetTV.isAddedToWatchlist(1)).thenAnswer((_) async => false);

          return bloc;
        },
        act: (bloc) => bloc.add(CheckWatchlistStatus(1, ContentType.tv)),
        expect: () => [
          WatchlistStatus(false),
        ],
      );
    });

    group('execute', () {
      blocTest<WatchlistBloc, WatchlistState>(
        'should return success to get Watchlist ',
        build: () {
          when(mockGetWatchlistMovies.execute())
              .thenAnswer((_) async => Right(testMovieList));

          return bloc;
        },
        act: (bloc) => bloc.add(GetAllWatchlist()),
        expect: () => [WatchlistSuccess(testMovieList)],
      );

      blocTest<WatchlistBloc, WatchlistState>(
        'should return error for get watchlist',
        build: () {
          when(mockGetWatchlistMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('error')));

          return bloc;
        },
        act: (bloc) => bloc.add(GetAllWatchlist()),
        expect: () => [
          WatchlistActionFailure('error'),
        ],
      );
    });

    group('execute', () {
      blocTest<WatchlistBloc, WatchlistState>(
        'should return success for save TV to watchlist when the response code is 200',
        build: () {
          when(mockGetTV.saveWatchlist(TVDetail()))
              .thenAnswer((_) async => Right('success'));

          return bloc;
        },
        act: (bloc) => bloc.add(AddToWatchlist(TVDetail(), ContentType.tv)),
        expect: () =>
            [WatchlistActionSuccess('success'), WatchlistStatus(true)],
      );

      blocTest<WatchlistBloc, WatchlistState>(
        'should return error for save TV to watchlist',
        build: () {
          when(mockGetTV.saveWatchlist(TVDetail()))
              .thenAnswer((_) async => Left(ServerFailure('error')));

          return bloc;
        },
        act: (bloc) => bloc.add(AddToWatchlist(TVDetail(), ContentType.tv)),
        expect: () => [
          WatchlistActionFailure('error'),
        ],
      );
    });

    group('execute', () {
      blocTest<WatchlistBloc, WatchlistState>(
        'should return success for remove tv to watchlist when the response code is 200',
        build: () {
          when(mockGetTV.removeWatchlist(TVDetail()))
              .thenAnswer((_) async => Right('success'));

          return bloc;
        },
        act: (bloc) =>
            bloc.add(RemoveFromWatchlist(TVDetail(), ContentType.tv)),
        expect: () =>
            [WatchlistActionSuccess('success'), WatchlistStatus(false)],
      );

      blocTest<WatchlistBloc, WatchlistState>(
        'should return error for remove TV to watchlist',
        build: () {
          when(mockGetTV.removeWatchlist(TVDetail()))
              .thenAnswer((_) async => (Left(ServerFailure('error'))));

          return bloc;
        },
        act: (bloc) =>
            bloc.add(RemoveFromWatchlist(TVDetail(), ContentType.tv)),
        expect: () => [WatchlistActionFailure('error')],
      );
    });
  });

  group('Movie Watchlist', () {
    group('execute', () {
      blocTest<WatchlistBloc, WatchlistState>(
        'should return success to get Watchlist status Movie ',
        build: () {
          when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => true);

          return bloc;
        },
        act: (bloc) => bloc.add(CheckWatchlistStatus(1, ContentType.movie)),
        expect: () => [WatchlistStatus(true)],
      );

      blocTest<WatchlistBloc, WatchlistState>(
        'should return error for get watchlist status',
        build: () {
          when(mockGetWatchListStatus.execute(1))
              .thenAnswer((_) async => false);

          return bloc;
        },
        act: (bloc) => bloc.add(CheckWatchlistStatus(1, ContentType.movie)),
        expect: () => [
          WatchlistStatus(false),
        ],
      );
    });
    group('execute', () {
      blocTest<WatchlistBloc, WatchlistState>(
        'should return success for save movie to watchlist when the response code is 200',
        build: () {
          when(mockSaveWatchlist.execute(MovieDetail()))
              .thenAnswer((_) async => Right('success'));

          return bloc;
        },
        act: (bloc) =>
            bloc.add(AddToWatchlist(MovieDetail(), ContentType.movie)),
        expect: () =>
            [WatchlistActionSuccess('success'), WatchlistStatus(true)],
      );

      blocTest<WatchlistBloc, WatchlistState>(
        'should return success for save Movie to watchlist',
        build: () {
          when(mockSaveWatchlist.execute(MovieDetail()))
              .thenAnswer((_) async => Left(ServerFailure('error')));

          return bloc;
        },
        act: (bloc) =>
            bloc.add(AddToWatchlist(MovieDetail(), ContentType.movie)),
        expect: () => [
          WatchlistActionFailure('error'),
        ],
      );
    });

    group('execute', () {
      blocTest<WatchlistBloc, WatchlistState>(
        'should return success for remove movie to watchlist when the response code is 200',
        build: () {
          when(mockRemoveWatchlist.execute(MovieDetail()))
              .thenAnswer((_) async => Right('success'));

          return bloc;
        },
        act: (bloc) =>
            bloc.add(RemoveFromWatchlist(MovieDetail(), ContentType.movie)),
        expect: () =>
            [WatchlistActionSuccess('success'), WatchlistStatus(false)],
      );

      blocTest<WatchlistBloc, WatchlistState>(
        'should return error for remove movie to watchlist',
        build: () {
          when(mockRemoveWatchlist.execute(MovieDetail()))
              .thenAnswer((_) async => Left(ServerFailure('error')));

          return bloc;
        },
        act: (bloc) =>
            bloc.add(RemoveFromWatchlist(MovieDetail(), ContentType.movie)),
        expect: () => [
          WatchlistActionFailure('error'),
        ],
      );
    });
  });
}
