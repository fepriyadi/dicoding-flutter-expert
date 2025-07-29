import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';

class HorizontalListViewMovies extends StatelessWidget {
  final List<TV> list;
  final Color? color;

  const HorizontalListViewMovies({required this.list, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: 7),
          for (var i = 0; i < list.length; i++)
            TVCard(list[i]),
        ],
      ),
    );
  }
}

class HorizontalMovieCard extends StatelessWidget {
  final TV movie;

  const HorizontalMovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: InkWell(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: kElevationToShadow[8],
              borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                  imageUrl: movie.poster,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Container(color: Colors.grey.shade900),
                ),
            ),
          ),
      ),
    );
  }
}
