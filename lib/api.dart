import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/video.dart';

const youtubeApiKey = "AIzaSyC1oteYKimZVUIckUidkolPwXjt488tZhA";

class Api {
  late String _search;
  late String _nextToken;

  Future<List<Video>> search(String search) async {
    _search = search;
    Uri url = Uri.parse(
      "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$youtubeApiKey&maxResults=10",
    );
    http.Response response = await http.get(url);
    return decode(response);
  }

  Future<List<Video>> nextPage() async {
    Uri url = Uri.parse(
      "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$youtubeApiKey&maxResults=10&pageToken=$_nextToken",
    );
    http.Response response = await http.get(url);
    return decode(response);
  }

  List<Video> decode(http.Response response) {
    if (response.statusCode == 200) {
      final deCoded = jsonDecode(response.body);

      _nextToken = deCoded['nextPageToken'];

      List<Video> videos = deCoded['items']
          .map<Video>(
            (map) => Video.fromJson(map),
          )
          .toList();
      return videos;
    }
    throw Exception('Failed to load videos.');
  }
}
