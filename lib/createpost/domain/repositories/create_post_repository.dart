import 'package:dartz/dartz.dart';
import 'package:bookish/core/error/failures.dart';
import 'package:bookish/data/feed_data.dart';

abstract class ICreatePostRepository {
  Future<Either<Failure, FeedData>> createPost(Map<String, dynamic> request);
}

