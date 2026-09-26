class ChatUserResponse {
  List<ChatUser>? data;

  ChatUserResponse({this.data});

  ChatUserResponse.fromJson(Map<String, dynamic> json) {
    if (json['friends'] != null) {
      data = <ChatUser>[];
      json['friends'].forEach((v) {
        data!.add(ChatUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'friends': data!.map((e) => e.toJson()).toList(),
    };
  }
}

class ChatUser {
  String? channelId;
  String? name;
  int? updatedAt;
  String? phoneNumber;
  String? lastMessage;
  String? profileIcon;
  String? userId;

  ChatUser(
      {this.channelId,
      this.name,
      this.updatedAt,
      this.phoneNumber,
      this.lastMessage,
      this.profileIcon,
      this.userId});

  ChatUser.fromJson(Map<String, dynamic> json) {
    channelId = json['channelId'];
    name = json['name'];
    updatedAt = json['updatedAt'];
    phoneNumber = json['phoneNumber'];
    lastMessage = json['lastMessage'];
    profileIcon = json['profileIcon'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'channelId': channelId,
      'name': name,
      'updatedAt': updatedAt,
      'phoneNumber': phoneNumber,
      'lastMessage': lastMessage,
      'profileIcon': profileIcon,
      'userId': userId,
    };
  }
}
