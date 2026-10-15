import 'package:dartz/dartz.dart';
import 'package:bookish/core/error/exceptions.dart';
import 'package:bookish/core/error/failures.dart';
import 'package:bookish/search/data/datasources/search_remote_data_source.dart';
import 'package:bookish/search/domain/entities/search_result_entity.dart';
import 'package:bookish/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements ISearchRepository {
  final ISearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SearchResultEntity>> searchBooks(String query) async {
    try {
      final model = await remoteDataSource.searchBooks(query);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

