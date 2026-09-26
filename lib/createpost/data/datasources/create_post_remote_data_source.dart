import 'package:bookish_module/data/feed_data.dart';

abstract class ICreatePostRemoteDataSource {
  Future<FeedData> createPost(Map<String, dynamic> request);
}

