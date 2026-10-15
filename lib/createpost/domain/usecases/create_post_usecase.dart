import 'package:dartz/dartz.dart';
import 'package:bookish/core/error/failures.dart';
import 'package:bookish/createpost/domain/repositories/create_post_repository.dart';
import 'package:bookish/data/feed_data.dart';

abstract class CreatePostUseCase {
  Future<Either<Failure, FeedData>> call(Map<String, dynamic> request);
}

class CreatePostUseCaseImpl implements CreatePostUseCase {
  final ICreatePostRepository repository;

  CreatePostUseCaseImpl({required this.repository});

  @override
  Future<Either<Failure, FeedData>> call(Map<String, dynamic> request) async {
    return await repository.createPost(request);
  }
}

