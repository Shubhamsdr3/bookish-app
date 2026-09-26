import 'package:bookish_module/core/data_mapper.dart';
import 'package:bookish_module/data/feed_data.dart';
import 'package:bookish_module/feed/domain/model/post_item.dart';
import 'package:network_service/data/reader.dart';

import '../../data/feed_post.dart';
import '../../data/post_action.dart';

class PostDataMapper extends DataMapper<PostItem, FeedData> {

  @override
  PostItem toEntity(FeedData model) {
    return PostItem(
        postId: model.post?.postId ?? "",
        userId: model.user?.userId ?? "",
        bookTitle: model.post?.bookName,
        bookId: model.post?.bookId,
        userName: model.user?.userName,
        profileImage: model.user?.profileIcon,
        postImages: model.post?.images,
        postCaption: model.post?.caption ?? "",
        createdAt: model.post?.createdAt ?? "",
        isLiked: (model.isLiked ?? false) ? 1 : 0,
        likeCount: model.like?.count ?? 0,
        commentCount: model.comment?.count ?? 0,
        shareCount: model.share?.count ?? 0);
  }

  @override
  FeedData toModel(PostItem entity) {
    return FeedData(
        user: Reader(
            userId: entity.userId, userName: entity.userName, profileIcon: entity.profileImage),
        post: FeedPost(
            postId: entity.postId,
            bookName: entity.bookTitle,
            bookId: entity.bookId,
            images: entity.postImages,
            caption: entity.postCaption,
            createdAt: entity.createdAt),
        isLiked: entity.isLiked == 1,
        like: PostAction(count: entity.likeCount),
        comment: PostAction(count: entity.commentCount),
        share: PostAction(count: entity.shareCount));
  }
}
