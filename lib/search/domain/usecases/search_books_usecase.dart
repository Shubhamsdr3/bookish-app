import 'package:dartz/dartz.dart';
import 'package:bookish_module/core/error/failures.dart';
import 'package:bookish_module/search/domain/entities/search_result_entity.dart';
import 'package:bookish_module/search/domain/repositories/search_repository.dart';

abstract class SearchBooksUseCase {
  Future<Either<Failure, SearchResultEntity>> call(String query);
}

class SearchBooksUseCaseImpl implements SearchBooksUseCase {
  final ISearchRepository repository;

  SearchBooksUseCaseImpl({required this.repository});

  @override
  Future<Either<Failure, SearchResultEntity>> call(String query) async {
    return await repository.searchBooks(query);
  }
}

