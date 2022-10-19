import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

import '../blocs/favorite_bloc.dart';
import '../models/video.dart';
import 'video_player.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<FavoriteBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAVORITOS"),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<Map<String, Video>>(
        stream: bloc.outFav,
        initialData: {},
        builder: (context, snapshot) {
          return ListView(
            children: snapshot.data!.values.map((v) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VideoPlayer(video: v),
                    ),
                  );
                },
                onLongPress: () {
                  bloc.toggleFavorite(v);
                },
                child: Column(
                  children: [
                    Container(
                      color: Colors.black87,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            height: 50,
                            child: Image.network(
                              v.thumb,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              v.title,
                              style: const TextStyle(color: Colors.white70),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.white70,
                      height: 0,
                    )
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
