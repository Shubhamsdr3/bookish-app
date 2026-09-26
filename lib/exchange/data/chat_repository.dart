import 'dart:convert';

import 'package:bookish_module/data/chat_user.dart';
import 'package:bookish_module/exchange/data/chat_api_service.dart';
import 'package:network_service/api.dart';
import 'package:network_service/old_api_service.dart';
import 'package:network_service/network_manager.dart';
import 'package:network_service/util/user_store.dart';

import '../../core/base_repository.dart';
import '../../data/chat_message.dart';

abstract class IChatRepository extends IRepository {
  IChatRepository({required super.services});

  Future<void> sendQuote();

  Future<ApiResponse<List<ChatUser>>> fetchChatUsers();
}

class ChatRepository extends IChatRepository {
  ChatRepository({required super.services});

  late final ChatApiService _apiService = getService<ChatApiService>();

  @override
  Future<void> sendQuote() async {
    final response = await OldApiService.instance
        .request(endpoint: "/api/bookish/home/feed", method: DioMethod.get);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.data) as Map<String, dynamic>;
      final quoteMessage = ChatMessage.fromJson(jsonResponse['data']);
      // Navigator.push(context, MaterialPageRoute(builder: (context) => UserChatList()));
      // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatWidget(feedPost: widget.feedData, chatMessage: quoteMessage,)));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Future<ApiResponse<List<ChatUser>>> fetchChatUsers() async {
    String? userId = await UserStore.getUserId();
    final response = await NetworkManager().makeNetworkCall(
      api: _apiService.chatUsers(userId),
      converter: (json) {
        final List friends = json is List ? json : json['friends'];
        return friends.map((e) => ChatUser.fromJson(e as Map<String, dynamic>)).toList();
      },
      resultKey: 'data',
    );
    return response;
  }
}
