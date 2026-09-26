import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../data/feed_data.dart';
import '../feed_repository.dart';

abstract class GetFeedUserCase {
  Future<Either<Failure, FeedResponse>> call({required int page, required int offset});
}

class GetFeedUserCaseImpl extends GetFeedUserCase {
  final IFeedRepository repository;

  GetFeedUserCaseImpl({required this.repository});

  @override
  Future<Either<Failure, FeedResponse>> call({required int page, required int offset}) {
    return repository.fetchFeed(page: page, offset: offset);
  }
}
