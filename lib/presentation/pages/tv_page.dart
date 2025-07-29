import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/provider/tv_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TVPage extends StatefulWidget {
  final String category;

  TVPage(this.category);

  @override
  _TVPageState createState() => _TVPageState();
}

class _TVPageState extends State<TVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final tvNotifier = Provider.of<TvNotifier>(context, listen: false);
      if (widget.category == TV_POPULAR) {
        await tvNotifier.fetchPopularTV();
      } else if (widget.category == TV_ONAIR) {
        await tvNotifier.fetchOnAirTV();
      } else {
        await tvNotifier.fetchTopRatedTV();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV ${tv_title(widget.category)}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TvNotifier>(
          builder: (context, data, child) {
            RequestState state;
            List<TV> dataSeries;
            if (widget.category == TV_POPULAR) {
              state = data.popularState;
              dataSeries = data.seriesPopular;
            } else if (widget.category == TV_ONAIR) {
              state = data.onAirState;
              dataSeries = data.seriesOnAir;
            } else {
              state = data.topRatedState;
              dataSeries = data.seriesTopRated;
            }

            if (state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final serie = dataSeries[index];
                  return TVCard(serie);
                },
                itemCount: dataSeries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
