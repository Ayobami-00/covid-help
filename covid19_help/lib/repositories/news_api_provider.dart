import 'dart:async';
import 'package:covid19_help/models/newsModel.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';


class NewsApiProvider {
  Client client = Client();
  final _apiKey = '5e5b32e142b94749a6b3218681ba41db';

  Future<NewsModel> fetchTopHeadlines() async {
    print("entered");
    final response = await client
        .get("http://newsapi.org/v2/top-headlines?country=us&apiKey=$_apiKey");
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

   Future<NewsModel> fetchBySearch(String query) async {
    String _query = query;
    print("entered");
    final response = await client
        .get("http://newsapi.org/v2/everything?q=$_query&apiKey=$_apiKey");
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}