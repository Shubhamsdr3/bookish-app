import 'dart:async';

import 'package:bookish/data/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:network_service/util/user_store.dart';

import '../../data/chat_message.dart';
import '../../data/feed_data.dart';
import '../../firebase/firestore_util.dart';
import '../../socket/socket_service.dart';
import '../data/chat_api_service.dart';
import '../data/chat_repository.dart';

class ChatRoomScreenArgs {
  final ChatUser chatUser;
  final FeedData? feedPost;

  ChatRoomScreenArgs({required this.chatUser, required this.feedPost});
}

class ChatRoomController extends GetxController {
  late IChatRepository _repository;

  RxString currentUserId = "".obs;

  final socketService = SocketService();

  final _chatMessages = StreamController<List<ChatMessage>>.broadcast();

  Stream<List<ChatMessage>> get chatMessages => _chatMessages.stream;

  List<ChatMessage> chatMessageList = [];

  final FireStoreUtil fireStoreUtil = new FireStoreUtil();
  final ScrollController scrollController = new ScrollController();
  final TextEditingController commentController = TextEditingController();

  final ChatUser chatUser;
  final FeedData? feedPost;

  ChatRoomController({required this.feedPost, required this.chatUser});

  @override
  void onInit() {
    super.onInit();
    _getCurrentUser();
    _setupSocket();
    _repository = Get.put(ChatRepository(services: {ChatApiService()}));
  }

  void _setupSocket() async {
    await socketService.initSocket();
    socketService.on("chat_message", (data) {
      print("Received message: $data");
      chatMessageList.add(ChatMessage.fromJson(data));
      _chatMessages.sink.add(chatMessageList);
    });
  }

  void _getCurrentUser() async {
    UserStore.getUserId().then((userId) {
      currentUserId.value = userId;
    });
  }

  bool isOutGoingMessage(ChatMessage? chatMessage) {
    return chatMessage?.senderId == currentUserId;
  }

  void sendMessage(String comment, bool bool) {
    if (comment.isNotEmpty) {
      socketService.emit("chat_message", comment);
      commentController.clear();
    }
  }

  getChatMessageStream() {
    return fireStoreUtil.getChatMessage(chatUser.channelId ?? '');
  }
}
