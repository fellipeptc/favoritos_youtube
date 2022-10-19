import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

import '../blocs/favorite_bloc.dart';
import '../blocs/videos_bloc.dart';
import '../delegates/data_search.dart';
import '../models/video.dart';
import '../widgets/video_tile.dart';
import 'favorites.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocVideo = BlocProvider.getBloc<VideosBloc>();
    final blocFavorite = BlocProvider.getBloc<FavoriteBloc>();
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 25,
          child: Image.asset("images/yt_logo_rgb_dark.png"),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: blocFavorite.outFav,
              builder: (conext, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "${snapshot.data!.length}",
                    style: const TextStyle(fontSize: 16),
                  );
                }
                return Container();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Favorites(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              String? result =
                  await showSearch(context: context, delegate: DataSearch());
              if (result != null) {
                blocVideo.inSearch.add(result);
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: blocVideo.outVideos,
        initialData: [],
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length + 1,
              itemBuilder: (context, index) {
                if (index < snapshot.data.length) {
                  return VideoTile(video: snapshot.data[index]);
                } else if (index > 1) {
                  blocVideo.inSearch.add('');
                  return Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                }
                return Container(color: Colors.white);
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
