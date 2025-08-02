import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/bloc/wishlist/watch_list_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/video_detail_page.dart';
import 'package:ditonton/presentation/pages/view_all_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/usecases/get_tv.dart';
import 'domain/usecases/get_watchlist_movies.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("✅ Firebase initialized successfully");
  } catch (e, s) {
    debugPrint("❌ Firebase init failed: $e\n$s");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<GetTV>(
            create: (_) => di.locator<GetTV>(),
          ),
          RepositoryProvider<GetNowPlayingMovies>(
            create: (_) => di.locator<GetNowPlayingMovies>(),
          ),
          RepositoryProvider<GetPopularMovies>(
            create: (_) => di.locator<GetPopularMovies>(),
          ),
          RepositoryProvider<GetTopRatedMovies>(
            create: (_) => di.locator<GetTopRatedMovies>(),
          ),
          RepositoryProvider<GetWatchListStatus>(
            create: (_) => di.locator<GetWatchListStatus>(),
          ),
          RepositoryProvider<SaveWatchlist>(
            create: (_) => di.locator<SaveWatchlist>(),
          ),
          RepositoryProvider<RemoveWatchlist>(
            create: (_) => di.locator<RemoveWatchlist>(),
          ),
          RepositoryProvider<SearchMovies>(
            create: (_) => di.locator<SearchMovies>(),
          ),
          RepositoryProvider<GetMovieDetail>(
            create: (_) => di.locator<GetMovieDetail>(),
          ),
          RepositoryProvider<GetMovieRecommendations>(
            create: (_) => di.locator<GetMovieRecommendations>(),
          ),
          RepositoryProvider<GetWatchlistMovies>(
            create: (_) => di.locator<GetWatchlistMovies>(),
          )
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.dark().copyWith(
            colorScheme: kColorScheme,
            primaryColor: kRichBlack,
            scaffoldBackgroundColor: kRichBlack,
            textTheme: kTextTheme,
            drawerTheme: kDrawerTheme,
          ),
          home: HomeMoviePage(),
          navigatorObservers: [routeObserver],
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/home':
                return MaterialPageRoute(builder: (_) => HomeMoviePage());
              case ViewAllPage.ROUTE_NAME:
                final args = settings.arguments as Map<String, dynamic>? ?? {};
                ;
                final ContentType type = args['type'] ?? '';
                final CategoryType categoryType = args['category'] ?? '';
                return MaterialPageRoute(
                  builder: (_) => ViewAllPage(
                      contentType: type, categoryType: categoryType),
                  settings: settings,
                );
              case VideoDetailPage.ROUTE_NAME:
                final args = settings.arguments as Map<String, dynamic>? ?? {};
                ;
                final int id = args['id'] ?? 0;
                final bool isTV = args['isTV'] ?? false;
                return MaterialPageRoute(
                  builder: (_) => VideoDetailPage(id: id, isTV: isTV),
                  settings: settings,
                );
              case SearchPage.ROUTE_NAME:
                return CupertinoPageRoute(builder: (_) => SearchPage());
              case WatchlistMoviesPage.ROUTE_NAME:
                return MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (_) => WatchlistBloc(
                              context.read<GetTV>(),
                              context.read<SaveWatchlist>(),
                              context.read<RemoveWatchlist>(),
                              context.read<GetWatchListStatus>(),
                              context.read<GetWatchlistMovies>()),
                          child:
                              WatchlistMoviesPage(), // or pass whatever param
                        ));
              case AboutPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => AboutPage());
              default:
                return MaterialPageRoute(builder: (_) {
                  return Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                });
            }
          },
        ));
  }
}
