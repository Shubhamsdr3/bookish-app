import 'package:bookish_module/feed/ui/feed_card_widget.dart';
import 'package:bookish_module/feed/ui/provider/home_feed_notifier.dart';
import 'package:bookish_module/feed/ui/provider/home_feed_state.dart';
import 'package:bookish_module/profile/ui/screens/user_profile_screen.dart';
import 'package:bookish_module/uikit/bookish_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/feed_data.dart';
import '../../feeddetail/screens/feed_detail_screen.dart';

class HomeFeedScreen extends ConsumerWidget {
  static String routeName = "/home_feed";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeFeedNotifierProvider);
    final notifier = ref.read(homeFeedNotifierProvider.notifier);
    final BookishSize size = Theme.of(context).extension<BookishSize>()!;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.r),
        child: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: Padding(
            padding: EdgeInsets.only(top: size.regularPadding),
            child: Text(
              "Home",
              style: GoogleFonts.roboto(fontWeight: FontWeight.w400),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 24.r, top: 10.r),
              child: InkWell(
                onTap: () => notifier.showNotification(),
                child: Stack(
                  children: [
                    Icon(Icons.notifications,
                        size: size.largePadding, color: Colors.black),
                    if (state.notificationCount > 0)
                      Positioned(
                        top: 0,
                        right: 0,
                        left: size.mediumPadding,
                        child: Container(
                          width: 18.r,
                          height: 18.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent,
                          ),
                          child: Center(
                            child: Text(
                              '${state.notificationCount}',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 24.r, top: 10.r),
              child: InkWell(
                onTap: () => notifier.showChatList(),
                child: Stack(
                  children: [
                    Icon(Icons.chat,
                        size: size.largePadding, color: Colors.black),
                    if (state.notificationCount > 0)
                      Positioned(
                        top: 0,
                        right: 0,
                        left: size.mediumPadding,
                        child: Container(
                          width: 18.r,
                          height: 18.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent,
                          ),
                          child: Center(
                            child: Text(
                              '${state.notificationCount}',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
          leading: Padding(
            padding: EdgeInsets.only(
                left: size.regularPadding, top: size.regularPadding),
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueGrey, width: 2.0),
                ),
                child: CircleAvatar(
                  backgroundImage: state.userProfileIcon.isNotEmpty
                      ? NetworkImage(state.userProfileIcon)
                      : const AssetImage('assets/image/reader.gif')
                          as ImageProvider,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfileScreen()),
                );
              },
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: notifier.onRefresh,
        child: _buildBody(state, notifier),
      ),
    );
  }

  Widget _buildBody(HomeFeedState state, HomeFeedNotifier notifier) {
    switch (state.status) {
      case HomeFeedStatus.initial:
      case HomeFeedStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case HomeFeedStatus.error:
        return Center(child: Text(state.errorMessage ?? 'Something went wrong'));
      case HomeFeedStatus.loaded:
        if (state.feeds.isEmpty) {
          return const Center(child: Text("Unable to load data"));
        }
        return _buildFeedItems(state, notifier);
    }
  }

  Widget _buildFeedItems(HomeFeedState state, HomeFeedNotifier notifier) {
    final feedItems = state.feeds.where((item) {
      return item.post != null &&
          item.post!.postId != null &&
          item.post!.postId!.isNotEmpty;
    }).toList();

    return ListView.builder(
      controller: notifier.scrollController,
      padding: EdgeInsets.only(top: 8.r),
      itemCount: feedItems.length,
      itemBuilder: (context, index) {
        final post = feedItems[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 4.r, horizontal: 12.r),
          width: double.maxFinite,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                FeedDetailScreen.routeName,
                arguments: FeedDetailArgs(post),
              );
            },
            child: state.isPageLoading && index == feedItems.length - 1
                ? const Center(child: CircularProgressIndicator())
                : FeedCardWidget(
                    feedData: post,
                    callback: (String postId) {
                      notifier.deletePost(post);
                    },
                  ),
          ),
        );
      },
    );
  }
}
