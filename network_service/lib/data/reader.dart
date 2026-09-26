class UserData {
  String? token;
  Reader? user;

  UserData({this.token, this.user});

  UserData.fromJson(Map<String, dynamic>? json) {
    token = json?['token'];
    user = Reader.fromJson(json?['user']);
  }

  Map<String, dynamic> toJson() {
    return {"token": token, "user": user};
  }
}

class Reader {
  String? profileIcon;
  String? name;
  String? readingStatus;
  String? userName;
  int? connections;
  int? createdAt;
  int? privacy;
  String? phoneNumber;
  String? userId;
  String? authToken;
  bool? isNewUser;

  Reader(
      {this.profileIcon,
      this.name,
      this.userName,
      this.connections,
      this.createdAt,
      this.privacy,
      this.phoneNumber,
      this.userId,
      this.authToken,
      this.isNewUser});

  Reader.fromJson(Map<String, dynamic>? json) {
    profileIcon = json?['profileIcon'];
    name = json?['name'];
    readingStatus = json?['readingStatus'];
    userName = json?['userName'];
    connections = json?['connections'];
    createdAt = json?['createdAt'];
    privacy = json?['privacy'];
    phoneNumber = json?['phoneNumber'];
    userId = json?['userId'];
    authToken = json?['authToken'];
    isNewUser = json?['isNewUser'];
  }

  Map<String, dynamic> toJson() {
    return {
      'profileIcon': profileIcon,
      'readingStatus': readingStatus,
      'name': name,
      'userName': userName,
      'connections': connections,
      'createdAt': createdAt,
      'privacy': privacy,
      'phoneNumber': phoneNumber,
      'userId': userId,
      'authToken': authToken,
      'isNewUser': isNewUser
    };
  }

  @override
  String toString() {
    return "{ "
        "name: $name, "
        "userName: $userName, "
        "readingStatus: $readingStatus, "
        "profileIcon: $profileIcon"
        "}";
  }
}
