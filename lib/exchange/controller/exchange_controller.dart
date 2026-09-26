import 'package:get/get.dart';

import '../../data/feed_data.dart';
import '../data/chat_api_service.dart';
import '../data/chat_repository.dart';

class ExchangeScreenArgs {

  final FeedData? feedData;

  ExchangeScreenArgs({required this.feedData});
}

class ExchangeController extends GetxController {

  late IChatRepository _repository;

  @override
  void onInit() {
    super.onInit();
    _repository = Get.put(ChatRepository(services: {ChatApiService()}));
  }

  void sendQuote() async {
    _repository.sendQuote();
  }
}