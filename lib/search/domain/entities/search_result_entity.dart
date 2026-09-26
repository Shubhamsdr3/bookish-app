import 'package:bookish_module/data/book_detail.dart';
import 'package:equatable/equatable.dart';

class SearchResultEntity extends Equatable {
  final List<BookDetail> items;

  const SearchResultEntity({required this.items});

  @override
  List<Object?> get props => [items];
}

