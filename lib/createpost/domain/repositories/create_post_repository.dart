import 'package:dartz/dartz.dart';
import 'package:bookish_module/core/error/failures.dart';
import 'package:bookish_module/data/feed_data.dart';

abstract class ICreatePostRepository {
  Future<Either<Failure, FeedData>> createPost(Map<String, dynamic> request);
}

