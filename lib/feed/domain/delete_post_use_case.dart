import 'package:bookish/core/error/failures.dart';
import 'package:bookish/data/feed_data.dart';
import 'package:bookish/feed/feed_repository.dart';
import 'package:dartz/dartz.dart';

abstract class DeletePostUseCase {
  Future<Either<Failure, bool>> call(FeedData post);
}

class DeletePostUseCaseImpl extends DeletePostUseCase {
  final IFeedRepository repository;

  DeletePostUseCaseImpl({required this.repository});

  @override
  Future<Either<Failure, bool>> call(FeedData post) {
    return repository.deletePost(post);
  }
}
