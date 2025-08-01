import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/wishlist/watch_list_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistBloc>().add(GetAllWatchlist());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void didPopNext() {
    context.read<WatchlistBloc>().add(GetAllWatchlist());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Watchlist'),
        ),
        body: WatchlistWidget());
  }
}

class WatchlistWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
      if (state is WatchlistSuccess) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                if (movie.isTV == 1)
                  return TVCard(TV.fromMovie(movie));
                else
                  return MovieCard(movie);
              },
              itemCount: state.movies.length,
            ));
      } else if (state is WatchlistActionFailure) {
        return Center(
          key: Key('error_message'),
          child: Text(state.error),
        );
      }
      return Scaffold();
    });
  }
}
