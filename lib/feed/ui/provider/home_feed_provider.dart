import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_service/network_info.dart';

import 'package:bookish_module/database/app_database.dart';
import 'package:bookish_module/feed/data/feed_api_service.dart';
import 'package:bookish_module/feed/data/local_data_source.dart';
import 'package:bookish_module/feed/domain/delete_post_use_case.dart';
import 'package:bookish_module/feed/domain/get_feed_user_case.dart';
import 'package:bookish_module/feed/domain/post_data_mappers.dart';
import 'package:bookish_module/feed/feed_repository.dart';

// --- Dependency Providers ---

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl();
});

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSourceImpl(appDatabase: AppDatabase.appDatabase);
});

final postDataMapperProvider = Provider<PostDataMapper>((ref) {
  return PostDataMapper();
});

final feedApiServiceProvider = Provider<FeedApiService>((ref) {
  return FeedApiService();
});

// --- Repository Provider ---

final feedRepositoryProvider = Provider<IFeedRepository>((ref) {
  return FeedRepositoryImpl(
    services: {ref.watch(feedApiServiceProvider)},
    networkInfo: ref.watch(networkInfoProvider),
    localDataSource: ref.watch(localDataSourceProvider),
    postDataMapper: ref.watch(postDataMapperProvider),
  );
});

// --- Use Case Providers ---

final getFeedUseCaseProvider = Provider<GetFeedUserCase>((ref) {
  return GetFeedUserCaseImpl(repository: ref.watch(feedRepositoryProvider));
});

final deletePostUseCaseProvider = Provider<DeletePostUseCase>((ref) {
  return DeletePostUseCaseImpl(repository: ref.watch(feedRepositoryProvider));
});
