import 'package:network_service/data/reader.dart';

class UserComment {
  String? comments;
  Reader? user;

  UserComment({
    this.comments,
    this.user
  });

  UserComment.fromJson(Map<String, dynamic>? json) {
    comments = json?['comments'];
    user = Reader.fromJson(json?['user'] as Map<String, dynamic>?);
  }

  Map<String, dynamic> toJson() {
    return {
      'comment': comments,
      'user': user?.toJson()
    };
  }
}