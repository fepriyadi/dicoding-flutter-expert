import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_tv.dart';
import 'package:ditonton/presentation/bloc/view_all_bloc/viewall_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/no_result.dart';

class ViewAllPage extends StatelessWidget {
  static const ROUTE_NAME = '/view_all';

  final ContentType contentType;
  final CategoryType categoryType;

  ViewAllPage({required this.contentType, required this.categoryType});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        if (categoryType == CategoryType.onair)
          BlocProvider(
            create: (_) => ViewAllBloc(
                context.read<GetTV>(), context.read<GetNowPlayingMovies>())
              ..add(FetchCategoryItems(
                  categoryType: categoryType, type: contentType)),
          )
        else if (categoryType == CategoryType.popular)
          BlocProvider<ViewAllBloc>(
            create: (context) => ViewAllBloc(
                context.read<GetTV>(), context.read<GetPopularMovies>())
              ..add(FetchCategoryItems(
                  categoryType: categoryType, type: contentType)),
          )
        else if (categoryType == CategoryType.topRated)
          BlocProvider<ViewAllBloc>(
              create: (context) => ViewAllBloc(
                  context.read<GetTV>(), context.read<GetTopRatedMovies>())
                ..add(FetchCategoryItems(
                    categoryType: categoryType, type: contentType)))
      ],
      child: ViewAllPageWidget(
          contentType: contentType, categoryType: categoryType),
    );
  }
}

class ViewAllPageWidget extends StatelessWidget {
  final ContentType contentType;
  final CategoryType categoryType;

  ViewAllPageWidget({required this.contentType, required this.categoryType});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ViewAllBloc, ViewAllState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
                title: Text(
                    'All ${categoryType.name.toUpperCase()} ${contentType.name.toUpperCase()}')),
            body: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(8),
                child: Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                  if (state is ViewAllSuccess)
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (context, index) {
                        final isTV = contentType == ContentType.tv;
                        final content =
                            isTV ? state.tv[index] : state.movies[index];

                        return isTV
                            ? TVCard(content as TV)
                            : MovieCard(content as Movie);
                      },
                      itemCount: contentType == ContentType.tv
                          ? state.tv.length
                          : state.movies.length,
                    ))
                  else if (state is ViewAllFailure)
                    ErrorPage()
                  else
                    Center(
                      child: CircularProgressIndicator(
                        color: Colors.white54,
                        strokeWidth: 2,
                        backgroundColor: Colors.black87,
                      ),
                    )
                ]))));
      },
    );
  }
}
