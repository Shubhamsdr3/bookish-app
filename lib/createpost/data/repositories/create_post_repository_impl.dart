import 'package:dartz/dartz.dart';
import 'package:bookish/core/error/exceptions.dart';
import 'package:bookish/core/error/failures.dart';
import 'package:bookish/createpost/data/datasources/create_post_remote_data_source.dart';
import 'package:bookish/createpost/domain/repositories/create_post_repository.dart';
import 'package:bookish/data/feed_data.dart';

class CreatePostRepositoryImpl implements ICreatePostRepository {
  final ICreatePostRemoteDataSource remoteDataSource;

  CreatePostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, FeedData>> createPost(
      Map<String, dynamic> request) async {
    try {
      final feedData = await remoteDataSource.createPost(request);
      return Right(feedData);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

