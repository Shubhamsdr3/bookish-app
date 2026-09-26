import 'package:network_service/data/reader.dart';

class UserResponse {
  bool? isSuccess;
  Reader? data;

  UserResponse({this.isSuccess, this.data});

  UserResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    data = Reader.fromJson(json['data']);
  }
}