class PostAction {
  String? icon;
  String? text;
  int? count;
  List<String>? userIds;

  PostAction({this.icon, this.text, this.count, this.userIds});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['icon'] = icon;
    data['text'] = text;
    data['count'] = count;
    data['userIds'] = userIds;
    return data;
  }

  PostAction.fromJson(Map<String, dynamic>? json) {
    userIds = List<String>.from(json?['userIds'] as List? ?? []);
    icon = json?['icon'];
    text = json?['text'];
    count = json?['count'] ?? 0;
  }
}
