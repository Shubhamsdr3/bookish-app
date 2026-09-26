import 'package:dartz/dartz.dart';
import 'package:bookish_module/core/error/exceptions.dart';
import 'package:bookish_module/core/error/failures.dart';
import 'package:bookish_module/createpost/data/datasources/create_post_remote_data_source.dart';
import 'package:bookish_module/createpost/domain/repositories/create_post_repository.dart';
import 'package:bookish_module/data/feed_data.dart';

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

