class LoginRequest {
  const LoginRequest({
    this.firebaseIdToken,
    this.userId,
    this.userName,
    this.name,
    this.profileIcon,
    this.phoneNumber,
    this.privacy = 0,
    this.connections = 0,
    required this.createdAt,
  });

  final String? firebaseIdToken;
  final String? userId;
  final String? userName;
  final String? name;
  final String? profileIcon;
  final String? phoneNumber;
  final int privacy;
  final int connections;
  final int createdAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (_hasText(firebaseIdToken)) 'idToken': firebaseIdToken,
      if (_hasText(userId)) 'userId': userId,
      if (_hasText(userName)) 'userName': userName,
      if (_hasText(name)) 'name': name,
      if (_hasText(profileIcon)) 'profileIcon': profileIcon,
      'privacy': privacy,
      'createdAt': createdAt,
      'connections': connections,
      'phoneNumber': phoneNumber,
    };
  }

  bool _hasText(String? value) {
    return value != null && value.isNotEmpty;
  }
}
