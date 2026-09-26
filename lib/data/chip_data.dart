class ChipData {
  String? title;
  bool? isSelected;

  ChipData({
    this.title,
    this.isSelected
  });

  ChipData.fromJson(Map<String, dynamic>? json) {
    title = json?['title'];
    isSelected = json?['isSelected'];
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isSelected': isSelected
    };
  }
}