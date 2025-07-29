import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/season.dart';

class TVDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv_detail';

  final int id;

  TVDetailPage({required this.id});

  @override
  _TVDetailPageState createState() => _TVDetailPageState();
}

class _TVDetailPageState extends State<TVDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final tvNotifier = Provider.of<TvNotifier>(context, listen: false);
      await tvNotifier.getDetailTV(widget.id);
      await tvNotifier.getRecommendations(widget.id);

      final movie = Provider.of<TVDetailNotifier>(context, listen: false);
      await movie.loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvNotifier>(
        builder: (context, provider, child) {
          if (provider.tvDetailState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.tvDetailState == RequestState.Loaded) {
            final movie = provider.tvDetail;
            return SafeArea(
              child: DetailContent(movie, provider.series),
            );
          } else {
            return Text(provider.message);
          }
        },
      ),
    );
  }
}

class DetailContent extends StatefulWidget {
  final TVDetail movie;
  final List<TV> recommendations;
  final bool isAddedWatchlist = false;

  DetailContent(this.movie, this.recommendations);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  late Season? selectedSeason;
  late TVDetail movie;

  @override
  void initState() {
    super.initState();
    selectedSeason =
        (widget.movie.seasons.isNotEmpty ? widget.movie.seasons.first : null);

    movie = widget.movie;
    Future.microtask(() async {
      Provider.of<TvNotifier>(context, listen: false)
          .getDetailSeason(movie.id, selectedSeason?.seasonNumber ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: movie.poster,
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                              movie.title,
                              style: kHeading5,
                            ),
                            Consumer<TVDetailNotifier>(
                              builder: (context, provider, child) {
                                return FilledButton(
                                  onPressed: () async {
                                    if (!provider.isAddedToWatchlist) {
                                      await Provider.of<TVDetailNotifier>(
                                              context,
                                              listen: false)
                                          .addWatchlist(movie);
                                    } else {
                                      await Provider.of<TVDetailNotifier>(
                                              context,
                                              listen: false)
                                          .removeFromWatchlist(movie);
                                    }

                                    final message =
                                        Provider.of<TVDetailNotifier>(context,
                                                listen: false)
                                            .watchlistMessage;

                                    if (message ==
                                            TVDetailNotifier
                                                .watchlistAddSuccessMessage ||
                                        message ==
                                            TVDetailNotifier
                                                .watchlistRemoveSuccessMessage) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text(message)));
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text(message),
                                            );
                                          });
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      provider.isAddedToWatchlist
                                          ? Icon(Icons.check)
                                          : Icon(Icons.add),
                                      Text('Watchlist'),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              movie.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            Consumer<TvNotifier>(
                              builder: (context, data, child) {
                                if (data.state == RequestState.Loading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (data.state == RequestState.Error) {
                                  return Text(data.message);
                                } else if (data.state == RequestState.Loaded) {
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie =
                                            widget.recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TVDetailPage.ROUTE_NAME,
                                                arguments: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    movie.poster,
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: widget.recommendations.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            if (movie.seasons.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Flexible(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      DropdownButton<Season>(
                                        dropdownColor: Colors.black54,
                                        items: movie.seasons
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
                                            Future.microtask(() async {
                                              Provider.of<TvNotifier>(context, listen: false)
                                                  .getDetailSeason(movie.id, selectedSeason?.seasonNumber ?? 0);
                                            });
                                          });
                                        },
                                      ),
                                      Consumer<TvNotifier>(
                                        builder: (context, data, child) {
                                          if (data.seasonState ==
                                              RequestState.Loading) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (data.seasonState ==
                                              RequestState.Error) {
                                            return Text(data.message);
                                          } else if (data.seasonState ==
                                              RequestState.Loaded) {
                                            return Container(
                                              height: 290,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  var episode = data
                                                      .seasons.episodes[index];
                                                  return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Container(
                                                                height: 200,
                                                                width: 130,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: Colors
                                                                      .grey
                                                                      .shade900,
                                                                  boxShadow:
                                                                      kElevationToShadow[
                                                                          8],
                                                                ),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    Navigator
                                                                        .pushReplacementNamed(
                                                                      context,
                                                                      TVDetailPage
                                                                          .ROUTE_NAME,
                                                                      arguments:
                                                                          episode
                                                                              .id,
                                                                    );
                                                                  },
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius
                                                                          .circular(
                                                                              8),
                                                                    ),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl: data
                                                                          .seasons
                                                                          .posterPath,
                                                                          fit: BoxFit.cover,
                                                                      placeholder:
                                                                          (context, url) =>
                                                                              Center(
                                                                        child:
                                                                            CircularProgressIndicator(),
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Icon(Icons
                                                                              .error),
                                                                    ),
                                                                  ),
                                                                ))),
                                                        const SizedBox(
                                                            width: 8.0),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Episode ${episode.episodeNumber} ',
                                                                maxLines: 2,
                                                                style:
                                                                    const TextStyle(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                episode.airDate,
                                                                maxLines: 2,
                                                                style:
                                                                    const TextStyle(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ]);
                                                },
                                                itemCount: data
                                                    .seasons.episodes.length,
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      )
                                    ])),
                              ),
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
  }
}

class SeasonEpisodeView extends StatelessWidget {
  final String seasonPoster;
  final Episode seasonEpisode;

  const SeasonEpisodeView({
    required this.seasonEpisode,
    required this.seasonPoster,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: Container(
              constraints: const BoxConstraints(minHeight: 210),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade900,
                      boxShadow: kElevationToShadow[8],
                    ),
                    child: seasonPoster.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: seasonPoster,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Icon(
                                Icons.image_not_supported,
                                size: 48,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.grey,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Episode ${seasonEpisode.episodeNumber} ',
                maxLines: 2,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                seasonEpisode.airDate,
                maxLines: 2,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
