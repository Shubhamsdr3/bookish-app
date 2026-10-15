import 'package:bookish/data/feed_data.dart';
import 'package:network_service/api.dart';
import 'package:network_service/network_manager.dart';

abstract class ICreatePostRepository {
  Future<ApiResponse<FeedData>> createPost(Map<String, dynamic> request);
}

class CreatePostRepository extends ICreatePostRepository {

  final NetworkManager networkManager;

  CreatePostRepository({required this.networkManager});

  late final IApi _createPostApi = Api(
    name: "/api/bookish/createPost",
    method: ApiMethod.post,
  );

  @override
  Future<ApiResponse<FeedData>> createPost(Map<String, dynamic> request) async {
    try {
      final _response = await networkManager.makeNetworkCall(
          api: _createPostApi,
          body: request,
          converter: (json) => FeedData.fromJson(json),
          resultKey: "data"
      );
      return _response;
    } catch (ex) {
      rethrow;
    }
  }
}
