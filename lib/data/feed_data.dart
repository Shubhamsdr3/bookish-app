import 'package:bookish_module/data/feed_post.dart';
import 'package:bookish_module/data/post_action.dart';
import 'package:network_service/data/reader.dart';
class FeedResponse {
  bool? isSuccess;
  List<FeedData>? data;
  int? currentPage;
  bool? hasNextPage;
  bool? hasPrevPage;

  FeedResponse({
    this.isSuccess,
    this.data,
    this.currentPage,
    this.hasNextPage,
    this.hasPrevPage,
  });

  FeedResponse.fromJson(Map<String, dynamic>? json) {
    isSuccess = json?['isSuccess'];
    data = json?['data']?.map<FeedData>((e) => FeedData.fromJson(e)).toList();
    currentPage = json?['currentPage'];
    hasNextPage = json?['hasNextPage'];
    hasPrevPage = json?['hasPrevPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['data'] = this.data?.map((e) => e.toJson()).toList();
    data['currentPage'] = currentPage;
    data['hasNextPage'] = hasNextPage;
    data['hasPrevPage'] = hasPrevPage;
    return data;
  }
}

class FeedData {
  Reader? user;
  FeedPost? post;
  bool? isLiked;
  PostAction? like;
  PostAction? comment;
  PostAction? share;

  FeedData({
    this.user,
    this.post,
    this.isLiked,
    this.like,
    this.comment,
    this.share,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isLiked'] = isLiked;
    data['reader'] = user?.toJson();
    data['post'] = post?.toJson();
    data['like'] = like?.toJson();
    data['comment'] = comment?.toJson();
    data['share'] = share?.toJson();
    return data;
  }

  FeedData.fromJson(Map<String, dynamic>? json) {
    isLiked = json?['isLiked'];
    user = Reader.fromJson(json?['reader'] as Map<String, dynamic>?);
    post = FeedPost.fromJson(json?['post']);
    like = PostAction.fromJson(json?['like'] as Map<String, dynamic>?);
    comment = PostAction.fromJson(json?['comment'] as Map<String, dynamic>?);
    share = PostAction.fromJson(json?['share'] as Map<String, dynamic>?);
  }
}