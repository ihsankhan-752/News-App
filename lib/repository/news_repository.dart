import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/model/category_news_model.dart';
import 'package:news_app/model/news_channel_headlines_model.dart';

class NewsRepository {
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(String channelName) async {
    String url = 'https://newsapi.org/v2/top-headlines?sources=$channelName&apiKey=2f2e459ea514438688962e673ea883e0';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    } else {
      throw Exception('Error');
    }
  }

  Future<CategoryNewsModel> fetchCategoryBaseNews(String category) async {
    String url = 'https://newsapi.org/v2/everything?q=$category&apiKey=2f2e459ea514438688962e673ea883e0';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoryNewsModel.fromJson(body);
    } else {
      throw Exception('Error');
    }
  }
}
