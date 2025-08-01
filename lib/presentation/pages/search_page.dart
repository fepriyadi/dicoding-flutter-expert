import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/search/search_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/no_result.dart';
import '../../domain/usecases/get_tv.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
        create: (_) =>
            SearchBloc(context.read<GetTV>(), context.read<SearchMovies>()),
        child: SearchPageWidget());
  }
}

class SearchPageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onSubmitted: (query) {
                context.read<SearchBloc>()..add(SearchData(query: query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'TV Result',
              style: kHeading6,
            ),
            Container(child:
                BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
              if (state is SearchLoaded) {
                if (state.tv.isNotEmpty)
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tv = state.tv[index];
                        return TVCard(tv);
                      },
                      itemCount: state.tv.length,
                    ),
                  );
                else
                  return Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(17),
                      child: Text('No tv series found'),
                    ),
                  );
              }
              if (state is SearchError) {
                return ErrorPage();
              } else if (state is SearchLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white54,
                    strokeWidth: 2,
                    backgroundColor: Colors.black87,
                  ),
                );
              }
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(17),
                child: Text('No tv series found'),
              );
            })),
            Text(
              'Movie Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
              if (state is SearchLoaded) {
                if (state.movies.isNotEmpty)
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final movie = state.movies[index];
                        return MovieCard(movie);
                      },
                      itemCount: state.movies.length,
                    ),
                  );
                else
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(17),
                    child: Text('No Movies found'),
                  );
              }
              if (state is SearchError) {
                return ErrorPage();
              } else if (state is SearchLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white54,
                    strokeWidth: 2,
                    backgroundColor: Colors.black87,
                  ),
                );
              }
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(17),
                child: Text('No Movies found'),
              );
            })
          ],
        ),
      ),
    );
  }
}
