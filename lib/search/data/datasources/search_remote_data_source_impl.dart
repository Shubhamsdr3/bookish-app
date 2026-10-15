import 'package:bookish/core/error/exceptions.dart';
import 'package:bookish/search/data/datasources/search_remote_data_source.dart';
import 'package:bookish/search/data/models/search_result_model.dart';
import 'package:network_service/network_manager.dart';
import 'package:network_service/api.dart';
import 'package:network_service/api_endpoints.dart';

class SearchRemoteDataSourceImpl implements ISearchRemoteDataSource {
  final NetworkManager networkManager;

  SearchRemoteDataSourceImpl({required this.networkManager});

  late final IApi _searchApi = Api(
    name: ApiEndPoint.BOOK_SEARCH_URL,
    method: ApiMethod.get,
  );

  @override
  Future<SearchResultModel> searchBooks(String query) async {
    try {
      final response = await networkManager.makeNetworkCall(
        api: _searchApi,
        body: {'searchTerm': query},
        converter: (json) => SearchResultModel.fromJson(json),
        resultKey: 'data',
      );

      if (response.data == null) {
        throw ServerException(message: 'Failed to search books');
      }

      return response.data!;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}

