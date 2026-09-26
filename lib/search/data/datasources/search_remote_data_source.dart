import 'package:bookish_module/search/data/models/search_result_model.dart';

abstract class ISearchRemoteDataSource {
  Future<SearchResultModel> searchBooks(String query);
}

