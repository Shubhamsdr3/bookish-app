import 'package:bookish/data/feed_data.dart';

class FeedResponse{
  bool? isSuccess;
  List<FeedData>? data;

  FeedResponse({this.isSuccess, this.data});

  FeedResponse.fromJson(Map<String, dynamic>? json) {
    isSuccess = json?['isSuccess'];
    data = json?['data'] as List<FeedData>;
  }
}