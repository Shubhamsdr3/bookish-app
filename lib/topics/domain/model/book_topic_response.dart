import 'package:bookish_module/data/chip_data.dart';

class BookTopicResponse {
  final List<ChipData> fictionList;
  final List<ChipData> nonFictionList;

  BookTopicResponse({
    required this.fictionList,
    required this.nonFictionList,
  });

  factory BookTopicResponse.fromMap(Map<String, dynamic>? map) {
    final fictionList = map?['fictions'] ?? [];
    final nonFictionList = map?['nonFictions'] ?? [];
    return BookTopicResponse(
      fictionList: List<ChipData>.from(
          fictionList.map((name) => ChipData(title: name, isSelected: false))),
      nonFictionList: List<ChipData>.from(nonFictionList
          .map((name) => ChipData(title: name, isSelected: false))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fictionList': fictionList.map((x) => x.toJson()).toList(),
      'nonFictionList': nonFictionList.map((x) => x.toJson()).toList(),
    };
  }
}
