import 'package:bookish/core/base_repository.dart';
import 'package:bookish/core/error/failures.dart';
import 'package:bookish/data/book_detail.dart';
import 'package:bookish/feed/data/local_data_source.dart';
import 'package:bookish/feed/domain/model/post_item.dart';
import 'package:bookish/feed/domain/post_data_mappers.dart';
import 'package:dartz/dartz.dart';
import 'package:network_service/api.dart';
import 'package:network_service/exceptions/http_api_exception.dart';
import 'package:network_service/exceptions/unauthorized_exception.dart';
import 'package:network_service/network_info.dart';
import 'package:network_service/network_manager.dart';
import 'package:network_service/util/user_store.dart';

import '../data/feed_data.dart';
import 'data/feed_api_service.dart';

abstract class IFeedRepository extends IRepository {
  IFeedRepository({required super.services});

  Future<Either<Failure, FeedResponse>> fetchFeed({required int page, required int offset});

  Future<Either<Failure, bool>> deletePost(FeedData feedData);

  Future<Either<Failure, BookDetailResponse>> fetchBookDetail(String bookId);
}

class FeedRepositoryImpl extends IFeedRepository {
  final NetworkInfo networkInfo;
  final LocalDataSource localDataSource;
  final PostDataMapper postDataMapper;

  FeedRepositoryImpl(
      {required super.services,
      required this.networkInfo,
      required this.localDataSource,
      required this.postDataMapper});

  late final FeedApiService _apiService = getService<FeedApiService>();

  @override
  Future<Either<Failure, FeedResponse>> fetchFeed({required int page, required int offset}) async {
    try {
      final List<PostItem> localItems = await localDataSource.getFeedItems();
      bool isInternetConnected = await networkInfo.isConnected;
      if (isInternetConnected) {
        final postResponse = await NetworkManager().makeNetworkCall(
          api: _apiService.feedData,
          converter: (json) => FeedResponse.fromJson(json),
          body: {'page': page, 'offset': offset},
          onApiError: handleApiError,
        );
        final postItems = postResponse.data?.data?.map((e) => postDataMapper.toEntity(e));
        await localDataSource.cacheFeedItems(postItems!.toList());
        return Right(postResponse.data!);
      } else {
        return Right(FeedResponse(data: localItems.map((e) => postDataMapper.toModel(e)).toList()));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deletePost(FeedData feedData) async {
    final userId = await UserStore.getUserId();
    final postId = feedData.post?.postId ?? "";
    if (feedData.user?.userId != userId) {
      return Left(ValidationFailure(message: "Unauthorized to delete this post"));
    }
    try {
      await NetworkManager().makeNetworkCall(
        api: _apiService.deletePost,
        body: {'postId': postId},
      );
      return Right(true);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, BookDetailResponse>> fetchBookDetail(String bookId) async {
    try {
      final _response = await NetworkManager().makeNetworkCall(
          api: _apiService.bookDetail,
          converter: (json) => BookDetailResponse.fromJson(json),
          body: {'id': bookId},
          resultKey: 'data');
      return Right(_response.data!);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  String handleApiError(Object e, [StackTrace? s]) {
    if (e is HttpApiException && e.response?.statusCode == 401) {
      throw UnAuthorizedException(e.message);
    }
    return 'Error: ${e.toString()}';
  }
}
