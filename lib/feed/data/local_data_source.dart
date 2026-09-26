import 'package:bookish_module/database/app_database.dart';
import 'package:bookish_module/feed/domain/model/post_item.dart';

abstract class LocalDataSource {
  Future<List<PostItem>> getFeedItems();
  Future<PostItem> getFeedItem(String id);
  Future<void> cacheFeedItems(List<PostItem> postItems);
  Future<void> saveFeedItem(PostItem item);
}

class LocalDataSourceImpl extends LocalDataSource {

  final AppDatabase _appDatabase;

  LocalDataSourceImpl({required AppDatabase appDatabase}) : _appDatabase = appDatabase;

  @override
  Future<void> cacheFeedItems(List<PostItem> postItems) async {
    for (final post in postItems) {
      await _appDatabase.insert("feed_post", post.toJson());
    }
  }

  @override
  Future<PostItem> getFeedItem(String postId) async {
    final Map<String, dynamic>? json = await _appDatabase.queryItemById("feed_post", postId);
    return PostItem.fromJson(json ?? {});
  }

  @override
  Future<List<PostItem>> getFeedItems() async {
    final List<Map<String, dynamic>> maps = await _appDatabase.queryItems('feed_post');
    return List.generate(maps.length, (i) => PostItem.fromJson(maps[i]));
  }

  @override
  Future<void> saveFeedItem(PostItem item) async {
    await _appDatabase.insert("feed_post", item.toJson());
  }
}