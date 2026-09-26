class NotificationInfo {
  String? title;
  String? message;
  String? deeplink;
  bool? isRead;
  String? icon;
  int? createdAt;

  NotificationInfo({
    this.title,
    this.message,
    this.deeplink,
    this.isRead,
    this.icon,
    this.createdAt
  });

  NotificationInfo.fromJson(Map<String, dynamic>? json) {
    title = json?['title'];
    message = json?['message'];
    deeplink = json?['deeplink'];
    isRead = json?['isRead'];
    icon = json?['icon'];
    createdAt = json?['createdAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'deeplink': deeplink,
      'isRead': isRead,
      'icon': icon,
      'createdAt': createdAt
    };
  }
}