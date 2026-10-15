import 'package:bookish/data/book_detail.dart';
import 'package:bookish/search/domain/entities/search_result_entity.dart';

class SearchResultModel extends SearchResultEntity {
  const SearchResultModel({required super.items});

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final itemsList = data?['items'] as List<dynamic>? ?? [];

    return SearchResultModel(
      items: itemsList
          .map((item) => BookDetail.fromJson(item as Map<String, dynamic>?))
          .toList(),
    );
  }

  SearchResultEntity toEntity() {
    return SearchResultEntity(items: items);
  }
}

