import 'dart:convert';

import 'package:bookish/data/feed_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:network_service/util/constants.dart';


class NavigationWidget extends StatefulWidget {

  static String routeName = "/navigation";

  final String postId;

  const NavigationWidget({super.key, required this.postId});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState(postId: postId);
}

class _NavigationWidgetState extends State<NavigationWidget> {

  final String postId;

  late Future<FeedData> _feedDataFuture;

  _NavigationWidgetState({required this.postId});

  @override
  void initState() {
    super.initState();
    _feedDataFuture = _fetchFeedDetail();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        GoRouter.of(context).pushReplacement('/home');
      },
      child: Scaffold(
        appBar: AppBar(),
        body: FutureBuilder<FeedData>(
          future: _feedDataFuture,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              final feedData = snapshot.data;
              if(feedData != null) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  if(GoRouter.of(context).canPop()) {
                    GoRouter.of(context).pop();
                  }
                  GoRouter.of(context).push('/feedDetail', extra: feedData);
                });
              } else {
                return Center(child: Text("No data available"));
              }
            } else if(snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            return Center(child: CircularProgressIndicator());
          }
      ),
      ),
    );
  }

  Future<FeedData> _fetchFeedDetail() async {
    final response = await http.get(Uri.parse('${Constants.BASE_URL}/api/bookish/home/feed/detail').replace(queryParameters: {'id': postId}));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return FeedData.fromJson(jsonResponse['data'] as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load album');
    }
  }
}