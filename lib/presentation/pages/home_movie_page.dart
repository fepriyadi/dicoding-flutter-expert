import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/list_recommendations.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/home/home_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/video_detail_page.dart';
import 'package:ditonton/presentation/pages/view_all_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/no_result.dart';
import '../../domain/usecases/get_tv.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (context) => HomeBloc(
          context.read<GetTV>(),
          context.read<GetPopularMovies>(),
          context.read<GetNowPlayingMovies>(),
          context.read<GetTopRatedMovies>())
        ..add(HomeData()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded) {
            return HomeScreenWidget(
              tvTranding: state.tranding,
              tvOnAir: state.upcoming,
              tvTopRated: state.toprated,
              movieOnAir: state.movieNowPlaying,
              movieTopRated: state.movieTopRated,
              movieTranding: state.moviePopular,
            );
          } else if (state is HomeError) {
            return ErrorPage();
          } else if (state is HomeLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white54,
                  strokeWidth: 2,
                  backgroundColor: Colors.black87,
                ),
              ),
            );
          }
          return const Scaffold();
        },
      ),
    );
  }
}

class HomeScreenWidget extends StatelessWidget {
  final List<TV> tvTranding;
  final List<TV> tvOnAir;
  final List<TV> tvTopRated;
  final List<Movie> movieTranding;
  final List<Movie> movieOnAir;
  final List<Movie> movieTopRated;

  const HomeScreenWidget({
    required this.tvTranding,
    required this.tvOnAir,
    required this.tvTopRated,
    required this.movieTranding,
    required this.movieOnAir,
    required this.movieTopRated,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
              ),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'TV popular',
                onTap: () => navigateToViewAll(
                    context, ContentType.tv, CategoryType.popular),
              ),
              MovieList(tv: tvTranding, movies: []),
              _buildSubHeading(
                title: 'TV On Air',
                onTap: () => navigateToViewAll(
                    context, ContentType.tv, CategoryType.onair),
              ),
              MovieList(tv: tvOnAir, movies: []),
              _buildSubHeading(
                title: 'TV Top Rated',
                onTap: () => navigateToViewAll(
                    context, ContentType.tv, CategoryType.topRated),
              ),
              MovieList(tv: tvTopRated, movies: []),
              _buildSubHeading(
                title: 'Now Playing',
                onTap: () => navigateToViewAll(
                    context, ContentType.movie, CategoryType.onair),
              ),
              MovieList(tv: [], movies: movieOnAir),
              _buildSubHeading(
                title: 'Movie Popular',
                onTap: () => navigateToViewAll(
                    context, ContentType.movie, CategoryType.popular),
              ),
              MovieList(tv: [], movies: movieTranding),
              _buildSubHeading(
                  title: 'Top Rated',
                  onTap: () => navigateToViewAll(
                      context, ContentType.movie, CategoryType.topRated)),
              MovieList(tv: [], movies: movieTopRated)
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }

  void navigateToViewAll(
      BuildContext context, ContentType type, CategoryType category) {
    Navigator.pushNamed(context, ViewAllPage.ROUTE_NAME, arguments: {
      'type': type,
      'category': category,
    });
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;
  final List<TV> tv;

  bool isTV() => tv.isNotEmpty ? true : false;

  MovieList({required this.tv, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie =
              isTV() ? tv[index] : movies[index] as RecommendationEntity;
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, VideoDetailPage.ROUTE_NAME,
                    arguments: {
                      'id': movie.id,
                      'isTV': tv.isNotEmpty, // or false
                    });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: isTV() ? tv.length : movies.length,
      ),
    );
  }
}
