import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/detail_video.dart';
import 'package:ditonton/domain/entities/list_recommendations.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/detail_movie/detail_bloc.dart';
import 'package:ditonton/presentation/bloc/wishlist/watch_list_bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../common/no_result.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/season.dart';
import '../../domain/usecases/get_tv.dart';
import '../bloc/detail/detail_bloc.dart';
import '../bloc/season/season_bloc.dart';

class VideoDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv_detail';

  final int id;
  final bool isTV;

  VideoDetailPage({required this.id, required this.isTV});

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return widget.isTV
        ? BlocProvider(
            create: (_) => DetailTVBloc(context.read<GetTV>())
              ..add(DetailData(id: widget.id)),
            child: DetailTVWidget(),
          )
        : BlocProvider(
            create: (_) => DetailMovieBloc(context.read<GetMovieDetail>(),
                context.read<GetMovieRecommendations>())
              ..add(DetailMovieData(id: widget.id)),
            child: DetailMovieWidget(),
          );
  }
}

class DetailMovieWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<DetailMovieBloc, DetailMovieState>(
      builder: (context, state) {
        if (state is DetailMovieLoaded) {
          return Scaffold(
              body: SafeArea(
            child: DetailContent(
                detail: state.detail,
                tvRecommendations: [],
                movieRecommendations: state.recommendations),
          ));
        } else if (state is DetailMovieError) {
          return ErrorPage();
        } else if (state is DetailMovieLoading) {
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
    );
  }
}

class DetailTVWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<DetailTVBloc, DetailState>(
      builder: (context, state) {
        if (state is DetailLoaded) {
          return Scaffold(
              body: SafeArea(
            child: DetailContent(
              detail: state.detail,
              tvRecommendations: state.recommendation,
              movieRecommendations: [],
            ),
          ));
        } else if (state is DetailError) {
          return ErrorPage();
        } else if (state is DetailLoading) {
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
    );
  }
}

class DetailContent extends StatelessWidget {
  final List<TV> tvRecommendations;
  final List<Movie> movieRecommendations;
  final DetailVideo detail;

  DetailContent(
      {required this.detail,
      required this.tvRecommendations,
      required this.movieRecommendations});

  isTV() => detail is TVDetail;

  @override
  Widget build(BuildContext context) {
    var selectedSeason =
        (detail.seasons.isNotEmpty ? detail.seasons.first : null);
    return MultiBlocProvider(
      providers: [
        if (isTV())
          BlocProvider<FetchSeasonBloc>(
            create: (context) => FetchSeasonBloc(context.read<GetTV>())
              ..add(
                FetchSeasonData(
                  seriesId: detail.id,
                  seasonNo: selectedSeason?.seasonNumber ?? 0,
                ),
              ),
          ),
        BlocProvider<WatchlistBloc>(
            create: (context) => WatchlistBloc(
                context.read<GetTV>(),
                context.read<SaveWatchlist>(),
                context.read<RemoveWatchlist>(),
                context.read<GetWatchListStatus>(),
                context.read<GetWatchlistMovies>())),
      ],
      child: isTV()
          ? DetailBlocContent(
              isTV: true, detail: detail, recommendations: tvRecommendations)
          : DetailBlocContent(
              isTV: false,
              detail: detail,
              recommendations: movieRecommendations),
    );
  }
}

class DetailBlocContent extends StatefulWidget {
  final DetailVideo detail;
  final List<RecommendationEntity> recommendations;
  final bool isTV;

  DetailBlocContent(
      {required this.detail,
      required this.recommendations,
      required this.isTV});

  @override
  State<DetailBlocContent> createState() => _DetailBlocContentState();
}

class _DetailBlocContentState extends State<DetailBlocContent> {
  late Season? selectedSeason;
  List<RecommendationEntity> recommendations = [];
  late bool isTV;
  late ContentType contentType;

  @override
  void initState() {
    super.initState();
    selectedSeason =
        (widget.detail.seasons.isNotEmpty ? widget.detail.seasons.first : null);
    recommendations = widget.recommendations;
    isTV = widget.isTV;
    contentType = widget.isTV ? ContentType.tv : ContentType.movie;
    context
        .read<WatchlistBloc>()
        .add(CheckWatchlistStatus(widget.detail.id, contentType));

    FirebaseAnalytics.instance.logEvent(
      name: 'select_content',
      parameters: {
        'movie_id': widget.detail.id,
        'movie_title': widget.detail.title,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Builder(builder: (context) {
      return Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.detail.posterPath,
            width: screenWidth,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
            margin: const EdgeInsets.only(top: 48 + 8),
            child: DraggableScrollableSheet(
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: kRichBlack,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 16,
                    right: 16,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.detail.title,
                                style: kHeading5,
                              ),
                              WatchListWidget(
                                  detail: widget.detail,
                                  contentType: contentType),
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: widget.detail.voteAverage / 2,
                                    itemCount: 5,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: kMikadoYellow,
                                    ),
                                    itemSize: 24,
                                  ),
                                  Text('${widget.detail.voteAverage}')
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Overview',
                                style: kHeading6,
                              ),
                              Text(
                                widget.detail.overview,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Recommendations',
                                style: kHeading6,
                              ),
                              RecommendationsWidget(
                                recommendations: recommendations,
                                isTV: isTV,
                              ),
                              if (widget.detail.seasons.isNotEmpty)
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      DropdownButton<Season>(
                                        dropdownColor: Colors.black54,
                                        items: widget.detail.seasons
                                            .map(
                                              (season) =>
                                                  DropdownMenuItem<Season>(
                                                value: season,
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text(season.name)),
                                              ),
                                            )
                                            .toList(),
                                        value: selectedSeason,
                                        style: normalText.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        hint: Text('Select season'),
                                        onChanged: (Season? value) {
                                          setState(() {
                                            selectedSeason = value;
                                            context
                                                .read<FetchSeasonBloc>()
                                                .add(FetchSeasonData(
                                                  seriesId: widget.detail.id,
                                                  seasonNo:
                                                      value?.seasonNumber ?? 0,
                                                ));
                                          });
                                        },
                                      ),
                                      EpisodeWidget()
                                    ]),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          color: Colors.white,
                          height: 4,
                          width: 48,
                        ),
                      ),
                    ],
                  ),
                );
              },
              // initialChildSize: 0.5,
              minChildSize: 0.25,
              // maxChildSize: 1.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: kRichBlack,
              foregroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      );
    });
  }
}

class RecommendationsWidget extends StatelessWidget {
  final List<RecommendationEntity> recommendations;
  final bool isTV;

  RecommendationsWidget({required this.recommendations, required this.isTV});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = recommendations[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, VideoDetailPage.ROUTE_NAME,
                    arguments: {
                      'id': movie.id,
                      'isTV': isTV, // or false
                    });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                child: CachedNetworkImage(
                  imageUrl: movie.posterPath ?? '',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: recommendations.length,
      ),
    );
  }
}

class WatchListWidget extends StatelessWidget {
  final DetailVideo detail;
  final ContentType contentType;

  WatchListWidget({required this.detail, required this.contentType});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocListener<WatchlistBloc, WatchlistState>(
        listener: (context, state) {
          if (state is WatchlistActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is WatchlistActionFailure) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(content: Text(state.error)),
            );
          }
        },
        child: BlocBuilder<WatchlistBloc, WatchlistState>(
            buildWhen: (previous, current) => current is WatchlistStatus,
            builder: (context, state) {
              final isInWatchlist =
                  state is WatchlistStatus && state.isInWatchlist;
              return FilledButton(
                onPressed: () async {
                  if (!isInWatchlist) {
                    context.read<WatchlistBloc>()
                      ..add(AddToWatchlist(detail, contentType));
                  } else {
                    context.read<WatchlistBloc>()
                      ..add(RemoveFromWatchlist(detail, contentType));
                  }

                  if (state is WatchlistActionSuccess) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  } else if (state is WatchlistActionFailure) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(state.error),
                          );
                        });
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(isInWatchlist ? Icons.check : Icons.add),
                    Text('Watchlist'),
                  ],
                ),
              );
            }));
  }
}

class EpisodeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<FetchSeasonBloc, FetchSeasonState>(
      builder: (context, state) {
        if (state is SeasonDetailLoaded) {
          return Container(
            height: 290,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var episode = state.season.episodes[index];
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                              height: 200,
                              width: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade900,
                                boxShadow: kElevationToShadow[8],
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, VideoDetailPage.ROUTE_NAME,
                                      arguments: {
                                        'id': episode.id,
                                        'isTV': true, // or false
                                      });
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: state.season.posterPath,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ))),
                      const SizedBox(width: 8.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Episode ${episode.episodeNumber} ',
                              maxLines: 2,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              episode.airDate,
                              maxLines: 2,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ]);
              },
              itemCount: state.season.episodes.length,
            ),
          );
        } else if (state is SeasonError) {
          return ErrorPage();
        } else if (state is FetchSeasonLoading) {
          return const SizedBox(
            height: 290,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black54,
                strokeWidth: 2,
                backgroundColor: Colors.black87,
              ),
            ),
          );
        }
        return const SizedBox(height: 290);
      },
    );
  }
}
