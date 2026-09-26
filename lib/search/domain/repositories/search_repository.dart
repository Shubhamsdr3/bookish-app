import 'package:dartz/dartz.dart';
import 'package:bookish_module/core/error/failures.dart';
import 'package:bookish_module/search/domain/entities/search_result_entity.dart';

abstract class ISearchRepository {
  Future<Either<Failure, SearchResultEntity>> searchBooks(String query);
}

