import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_service/network_manager.dart';
import 'package:bookish_module/createpost/data/datasources/create_post_remote_data_source.dart';
import 'package:bookish_module/createpost/data/datasources/create_post_remote_data_source_impl.dart';
import 'package:bookish_module/createpost/data/repositories/create_post_repository_impl.dart';
import 'package:bookish_module/createpost/domain/repositories/create_post_repository.dart';
import 'package:bookish_module/createpost/domain/usecases/create_post_usecase.dart';

final createPostRemoteDataSourceProvider =
    Provider<ICreatePostRemoteDataSource>((ref) {
  return CreatePostRemoteDataSourceImpl(
    networkManager: NetworkManager(),
  );
});


final createPostRepositoryProvider = Provider<ICreatePostRepository>((ref) {
  final dataSource = ref.watch(createPostRemoteDataSourceProvider);
  return CreatePostRepositoryImpl(remoteDataSource: dataSource);
});


final createPostUseCaseProvider = Provider<CreatePostUseCase>((ref) {
  final repository = ref.watch(createPostRepositoryProvider);
  return CreatePostUseCaseImpl(repository: repository);
});

