import 'dart:convert';
import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/video.dart';
import 'dart:async';

class FavoriteBloc implements BlocBase {
  Map<String, Video> _favorites = {};

  ///Vários observadores, um para cada item do map
  //final _favController = StreamController<Map<String, Video>>.broadcast();
  final _favController = BehaviorSubject<Map<String, Video>>.seeded({});

  FavoriteBloc() {
    SharedPreferences.getInstance().then(
      (prefs) {
        if (prefs.getKeys().contains("favorites")) {
          _favorites = jsonDecode(prefs.getString("favorites")!).map(
            (k, v) {
              return MapEntry(k, Video.fromJson(v));
            },
          ).cast<String, Video>();
          _favController.add(_favorites);
        }
      },
    );
  }

  Stream<Map<String, Video>> get outFav => _favController.stream;

  void toggleFavorite(Video video) {
    if (_favorites.containsKey(video.id)) {
      _favorites.remove(video.id);
    } else {
      _favorites[video.id] = video;
    }
    _favController.sink.add(_favorites);
    _saveFavorite();
  }

  _saveFavorite() {
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setString("favorites", jsonEncode(_favorites));
      },
    );
  }

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _favController.close();
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }
}
