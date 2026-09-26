import 'dart:convert';

class PostModel {
  List<PostItem> postItems;

  PostModel({required this.postItems});

  factory PostModel.fromJson(List<dynamic> json) {
    List<PostItem> postItems = [];
    postItems = json.map((postItem) => PostItem.fromJson(postItem)).toList();
    return PostModel(postItems: postItems);
  }

  Map<String, dynamic> toJson() {
    return {
      'postItems': postItems.map((postItem) => postItem.toJson()).toList(),
    };
  }
}

class PostItem {
  String? postId;
  String? userId;
  String? bookTitle;
  String? bookId;
  String? userName;
  String? profileImage;
  List<String>? postImages;
  String? postCaption;
  String? createdAt;
  int? isLiked;
  int? likeCount;
  int? commentCount;
  int? shareCount;

  PostItem({
    required this.postId,
    required this.userId,
    required this.bookTitle,
    required this.bookId,
    required this.userName,
    required this.profileImage,
    required this.postImages,
    required this.postCaption,
    required this.createdAt,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
  });

  factory PostItem.fromJson(Map<String, dynamic>? json) {
    return PostItem(
      postId: json?['post_id'],
      userId: json?['user_id'],
      bookTitle: json?['book_title'],
      bookId: json?['book_id'],
      userName: json?['user_name'],
      profileImage: json?['profile_image'],
      postImages: parseJson(json?['post_images']),
      postCaption: json?['post_caption'],
      createdAt: json?['created_at'],
      isLiked: json?['is_liked'],
      likeCount: json?['like_count'],
      commentCount: json?['comment_count'],
      shareCount: json?['share_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'user_id': userId,
      'book_title': bookTitle,
      'book_id': bookId,
      'user_name': userName,
      'profile_image': profileImage,
      'post_images': jsonEncode(postImages),
      'post_caption': postCaption,
      'created_at': createdAt,
      'is_liked': isLiked,
      'like_count': likeCount,
      'comment_count': commentCount,
      'share_count': shareCount,
    };
  }

  static List<String> parseJson(String? json) {
    if(json == null || json.isEmpty) {
      return [];
    }
    return List<String>.from(jsonDecode(json));
  }
}
