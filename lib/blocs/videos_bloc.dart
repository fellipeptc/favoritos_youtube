import 'dart:ui';
import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';

import '../api.dart';
import '../models/video.dart';

class VideosBloc implements BlocBase {
  late Api api;
  List<Video> videos = [];

  final _videosController = StreamController<List<Video>>();
  Stream get outVideos => _videosController.stream; //Saída

  final _searchController = StreamController<String>();
  Sink get inSearch => _searchController.sink; //Entrada

  VideosBloc() {
    api = Api();
    /// Fica escutando todas as entradas de dados
    _searchController.stream.listen(_search);
  }

  Future<void> _search(String search) async {
    if(search != ''){
      _videosController.sink.add([]);
      videos = await api.search(search.toString());
    } else{
      videos += await api.nextPage();
    }
    _videosController.sink.add(videos);
  }

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
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
