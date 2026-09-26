import 'package:bookish_module/exchange/data/chat_api_service.dart';
import 'package:get/get.dart';
import 'package:network_service/bookish_result.dart';
import 'package:network_service/util/user_store.dart';

import '../../data/chat_user.dart';
import '../../data/feed_data.dart';
import '../data/chat_repository.dart';
import '../ui/chatroom_screen.dart';
import 'chatroom_controller.dart';

class ChatListScreenArgs {
  final FeedData? feedPost;

  ChatListScreenArgs({required this.feedPost});
}

class ChatListController extends GetxController {
  final Rx<Result<List<ChatUser>>> _chatUsers = Rx(Loading());

  Rx<Result<List<ChatUser>>> get chatUsers => _chatUsers;

  late IChatRepository _repository;

  bool _isChannelAccepted = false;

  RxString currentUserId = "".obs;

  final FeedData? feedPost;

  ChatListController({required this.feedPost});

  @override
  void onInit() async {
    super.onInit();
    _getCurrentUser();
    _repository = Get.put(ChatRepository(
      services: {ChatApiService()},
    ));
    final apiResponse = await _repository.fetchChatUsers();
    _chatUsers.value = Success(apiResponse.data);
  }

  void _getCurrentUser() async {
    UserStore.getUserId().then((userId) {
      currentUserId.value = userId;
    });
  }

  void navigateToChatRoom(ChatUser chatUser) {
    Get.toNamed(ChatRoomScreen.routeName,
        arguments: ChatRoomScreenArgs(feedPost: feedPost, chatUser: chatUser));
  }
}
