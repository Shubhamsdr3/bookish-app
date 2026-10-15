import 'package:bookish/core/error/exceptions.dart';
import 'package:bookish/createpost/data/datasources/create_post_remote_data_source.dart';
import 'package:bookish/data/feed_data.dart';
import 'package:network_service/api.dart';
import 'package:network_service/network_manager.dart';

class CreatePostRemoteDataSourceImpl implements ICreatePostRemoteDataSource {
  final NetworkManager networkManager;

  CreatePostRemoteDataSourceImpl({required this.networkManager});

  late final IApi _createPostApi = Api(
    name: '/api/bookish/createPost',
    method: ApiMethod.post,
  );

  @override
  Future<FeedData> createPost(Map<String, dynamic> request) async {
    try {
      final response = await networkManager.makeNetworkCall(
        api: _createPostApi,
        body: request,
        converter: (json) => FeedData.fromJson(json),
        resultKey: 'data',
      );

      if (response.data == null) {
        throw ServerException(message: 'Failed to create post');
      }

      return response.data!;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}

