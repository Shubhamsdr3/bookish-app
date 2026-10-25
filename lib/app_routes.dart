import 'package:bookish/commnets/comments_controller.dart';
import 'package:bookish/commnets/comments_screen.dart';
import 'package:bookish/data/chat_user.dart';
import 'package:bookish/data/feed_data.dart';
import 'package:bookish/native/native_android_plugin.dart';
import 'package:bookish/exchange/controller/chatlist_controller.dart';
import 'package:bookish/exchange/controller/chatroom_controller.dart';
import 'package:bookish/exchange/ui/chat_list_screen.dart';
import 'package:bookish/exchange/ui/chatroom_screen.dart';
import 'package:bookish/feed/ui/home_feed_screen.dart';
import 'package:bookish/feedback/controllers/feedback_controller.dart';
import 'package:bookish/feedback/screens/feedback_screen.dart';
import 'package:bookish/feeddetail/screens/feed_detail_screen.dart';
import 'package:bookish/home/controller/home_screen_controller.dart';
import 'package:bookish/home/screens/home_screen.dart';
import 'package:bookish/onboarding/controller/bookish_login_controller.dart';
import 'package:bookish/onboarding/screen/otp_verification_screen.dart';
import 'package:bookish/preview/controller/post_preview_controller.dart';
import 'package:bookish/preview/screen/post_preview_screen.dart';
import 'package:bookish/search/ui/screens/search_suggestion_screen.dart';
import 'package:bookish/settings/account_setting_controller.dart';
import 'package:bookish/settings/account_setting_screen.dart';
import 'package:bookish/topics/controller/book_topics_controller.dart';
import 'package:bookish/topics/screens/select_topics_screen.dart';
import 'package:bookish/webview/webview_route.dart';
import 'package:get/get.dart';
import 'onboarding/controller/otp_verification_controller.dart';
import 'onboarding/data/auth_api_service.dart';
import 'onboarding/data/onboarding_repository.dart';
import 'onboarding/screen/bookish_login_screen.dart';

final List<GetPage> appRoutes = [
  GetPage(
      name: HomeScreen.routeName,
      page: () => HomeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeScreenController(), fenix: true);
      })),
  GetPage(
      name: HomeFeedScreen.routeName,
      page: () => HomeFeedScreen(),
  ),
  GetPage(
      name: LoginScreen.routeName,
      page: () => LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => BookishLoginController(), fenix: true);
      })),
  GetPage(
      name: OtpVerificationScreen.routeName,
      page: () => OtpVerificationScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(
            () => OtpVerificationController(
                  onboardingRepository: OnboardingRepository(
                    services: {AuthApiService()},
                  ),
                  phoneNumber: Get.arguments as String?,
                ),
            fenix: true);
      })),
  // GetPage(
  //     name: EditProfileScreen.routeName,
  //     page: () => EditProfileScreen(),
  //     binding: BindingsBuilder(() {
  //       Get.put(() => EditProfileController(phoneNumber: (Get.arguments as String?)));
  //     })),
  GetPage(
      name: PostPreviewScreen.routeName,
      page: () => PostPreviewScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => PostPreviewController((Get.arguments as FeedData)),
            fenix: true);
      })),
  GetPage(name: WebViewRoute.webviewRouteName, page: () => const WebViewRoute()),
  GetPage(
      name: FeedDetailScreen.routeName,
      page: () => FeedDetailScreen(),
  ),
  GetPage(
      name: AccountSettingScreen.routeName,
      page: () => AccountSettingScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AccountSettingController());
      })),
  GetPage(
      name: CommentsScreen.routeName,
      page: () => CommentsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CommentsController(
            feedData: (Get.arguments as FeedDetailArgs).feedData));
      })),
  GetPage(
      name: FeedbackScreen.routeName,
      page: () => FeedbackScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => FeedbackController());
      })),
  GetPage(
      name: SearchSuggestionScreen.routeName,
      page: () => const SearchSuggestionScreen(),
  ),
  GetPage(
      name: UserChatListScreen.routeName,
      page: () => UserChatListScreen(),
      binding: BindingsBuilder(() {
        FeedData? feedData = (Get.arguments as ChatListScreenArgs).feedPost;
        Get.lazyPut(() => ChatListController(feedPost: feedData));
      })),
  GetPage(
      name: SelectTopicsScreen.routeName,
      page: () => SelectTopicsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SelectTopicController());
      })),
  GetPage(
      name: NativeAndroidPlugin.routeName,
      page: () => NativeAndroidPlugin(),
      // binding: BindingsBuilder(() {})
  ),
  GetPage(
      name: ChatRoomScreen.routeName,
      page: () => ChatRoomScreen(),
      binding: BindingsBuilder(() {
        FeedData? feedData = (Get.arguments as ChatRoomScreenArgs).feedPost;
        ChatUser? chatUser = (Get.arguments as ChatRoomScreenArgs).chatUser;
        Get.lazyPut(
            () => ChatRoomController(feedPost: feedData, chatUser: chatUser));
      })),
];
