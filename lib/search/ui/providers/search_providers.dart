import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_service/network_manager.dart';
import 'package:bookish/search/data/datasources/search_remote_data_source.dart';
import 'package:bookish/search/data/datasources/search_remote_data_source_impl.dart';
import 'package:bookish/search/data/repositories/search_repository_impl.dart';
import 'package:bookish/search/domain/repositories/search_repository.dart';
import 'package:bookish/search/domain/usecases/search_books_usecase.dart';

// Data Source
final searchRemoteDataSourceProvider = Provider<ISearchRemoteDataSource>((ref) {
  return SearchRemoteDataSourceImpl(networkManager: NetworkManager());
});

// Repository
final searchRepositoryProvider = Provider<ISearchRepository>((ref) {
  final dataSource = ref.watch(searchRemoteDataSourceProvider);
  return SearchRepositoryImpl(remoteDataSource: dataSource);
});

// Use Case
final searchBooksUseCaseProvider = Provider<SearchBooksUseCase>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchBooksUseCaseImpl(repository: repository);
});

