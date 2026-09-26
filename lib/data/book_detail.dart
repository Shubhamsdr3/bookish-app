class BookDetailResponse {
  final String? status;
  final BookDetail? data;

  BookDetailResponse({
    this.status,
    this.data,
  });

  factory BookDetailResponse.fromJson(Map<String, dynamic>? json) {
    return BookDetailResponse(
      status: json?['status'],
      data: BookDetail.fromJson(json?['data'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['data'] = data;
    return data;
  }
}

class BookDetail {
  String? bookId;
  VolumeInfo? volumeInfo;

  BookDetail({this.bookId, this.volumeInfo});

  BookDetail.fromJson(Map<String, dynamic>? json) {
    bookId = json?['id'];
    volumeInfo =
        VolumeInfo.fromJson(json?['volumeInfo'] as Map<String, dynamic>?);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = bookId;
    data['volumeInfo'] = volumeInfo?.toJson();
    return data;
  }
}

class VolumeInfo {
  String? title;
  String? subtitle;
  List<String>? authors;
  ImageLinks? imageLinks;
  num? averageRating;
  num? ratingsCount;
  String? description;
  List<String>? bookCategories;

  VolumeInfo(
      {this.title,
      this.subtitle,
      this.authors,
      this.averageRating,
      this.ratingsCount,
      this.description});

  VolumeInfo.fromJson(Map<String, dynamic>? json) {
    title = json?['title'];
    subtitle = json?['subtitle'];
    imageLinks =
        ImageLinks.fromJson(json?['imageLinks'] as Map<String, dynamic>?);
    final List<dynamic>? list = json?['authors'];
    authors = list?.map((e) => e.toString()).toList();
    averageRating = json?['averageRating'];
    ratingsCount = json?['ratingsCount'];
    description = json?['description'];
    final List<dynamic>? categoryList = json?['categories'];
    bookCategories = categoryList?.map((e) => e.toString()).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['authors'] = authors;
    data['imageLinks'] = imageLinks?.toJson();
    data['averageRating'] = averageRating;
    data['ratingsCount'] = ratingsCount;
    data['description'] = description;
    data['categories'] = bookCategories;
    return data;
  }
}

class ImageLinks {
  String? smallThumbnail;
  String? thumbnail;
  String? small;
  String? medium;
  String? large;

  ImageLinks(
      {this.smallThumbnail,
      this.thumbnail,
      this.small,
      this.medium,
      this.large});

  ImageLinks.fromJson(Map<String, dynamic>? json) {
    smallThumbnail = json?['smallThumbnail'];
    thumbnail = json?['thumbnail'];
    small = json?['small'];
    medium = json?['medium'];
    large = json?['large'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['smallThumbnail'] = smallThumbnail;
    data['thumbnail'] = thumbnail;
    data['small'] = small;
    data['medium'] = medium;
    data['large'] = large;
    return data;
  }
}
