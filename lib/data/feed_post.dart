class FeedPost {
  String? postId;
  String? caption;
  List<String>? images;
  String? bookName;
  String? bookLink;
  String? bookId;
  String? createdAt;
  bool? isAvailableForRent;

  FeedPost({
    this.postId,
    this.caption,
    this.images,
    this.bookName,
    this.bookLink,
    this.bookId,
    this.createdAt,
    this.isAvailableForRent
});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['postId'] = postId;
    data['caption'] = caption;
    data['images'] = images;
    data['bookName'] = bookName;
    data['bookLink'] = bookLink;
    data['bookId'] = bookId;
    data['createdAt'] = createdAt;
    data['isAvailable'] = isAvailableForRent;
    return data;
  }

  FeedPost.fromJson(Map<String, dynamic>? json) {
    postId = json?['postId'];
    caption = json?['caption'];
    bookName = json?['bookName'];
    bookLink = json?['bookLink'];
    bookId = json?['bookId'];
    createdAt = json?['createdAt'].toString();
    images = List<String>.from(json?['images'] as List? ?? []);
    isAvailableForRent = json?['isAvailable'];
  }
}