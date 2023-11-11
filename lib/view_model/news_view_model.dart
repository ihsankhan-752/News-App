import 'package:news_app/model/category_news_model.dart';
import 'package:news_app/repository/news_repository.dart';

import '../model/news_channel_headlines_model.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(String channelName) async {
    final response = await _rep.fetchNewsChannelHeadlinesApi(channelName);
    return response;
  }

  Future<CategoryNewsModel> fetchCategoryBaseNews(String category) async {
    final response = await _rep.fetchCategoryBaseNews(category);
    return response;
  }
}
