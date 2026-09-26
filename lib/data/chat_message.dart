class ChatMessage {
  String? message;
  String? messageType;
  String? senderId;
  String? receiverId;
  int? createdAt;
  String? userName;
  String? postId;
  String? channelId;

  ChatMessage({
    this.message,
    this.messageType,
    this.senderId,
    this.receiverId,
    this.createdAt,
    this.userName,
    this.postId,
    this.channelId
  });

  ChatMessage.fromJson(Map<String, dynamic>? json) {
    message = json?['message'];
    messageType = json?['messageType'];
    senderId = json?['senderId'];
    receiverId = json?['receiverId'];
    createdAt = json?['createdAt'];
    userName = json?['userName'];
    postId = json?['postId'];
    channelId = json?['channelId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'messageType': messageType,
      'userId': senderId,
      'createdAt': createdAt,
      'userName': userName,
      'postId': postId,
      'friendId': receiverId,
      'channelId': channelId
    };
  }
}

enum MessageType { INCOMING, OUTGOING, QUOTE, PRIVATE } // private will only to current user.