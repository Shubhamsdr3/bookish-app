import 'package:bookish/home/screens/home_screen.dart';
import 'package:bookish/topics/data/topic_api_service.dart';
import 'package:bookish/topics/data/topic_repository.dart';
import 'package:bookish/util/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/chip_data.dart';
import '../domain/model/book_topic_response.dart';

enum CategoryType { FICTION, NON_FICTION }

class SelectTopicController extends GetxController {

  final Rx<BookTopicResponse?> _bookTopicResponse = Rx(null);
  Rx<BookTopicResponse?> get bookTopicResponse => _bookTopicResponse;

  final RxList<ChipData> _fictionList = <ChipData>[].obs;
  RxList<ChipData> get fictionList => _fictionList;

  final RxList<ChipData> _nonFictionList = <ChipData>[].obs;
  RxList<ChipData> get nonFictionList => _nonFictionList;

  final RxList<String> _selectedFictionList = <String>[].obs;
  RxList<String> get selectedFictionList => _selectedFictionList;

  final RxList<String> _selectedNonFictionList = <String>[].obs;
  RxList<String> get selectedNonFictionList => _selectedNonFictionList;

  final RxInt _currentSelectedIndex = 0.obs;
  RxInt get currentSelectedIndex => _currentSelectedIndex;

  final RxBool _isLoading = false.obs;
  RxBool get isLoading => _isLoading;

  final Rx<ButtonState> _buttonState = ButtonState.disabled.obs;
  Rx<ButtonState> get buttonState => _buttonState;

  late ITopicRepository _repository;

  @override
  void onInit() {
    _repository = Get.put(TopicRepository(services: {TopicApiService()}));
    _fetchBookTopics();
    super.onInit();
  }

  Future<void> _fetchBookTopics() async {
    _isLoading.value = true;
    _repository.fetchTopics().then((response) {
      _isLoading.value = false;
      _bookTopicResponse.value = response.data;
      final List<ChipData>? fictionList = response.data?.fictionList;
      _fictionList.clear();
      _fictionList.addAll(fictionList ?? []);
      final List<ChipData>? nonFictionList = response.data?.nonFictionList;
      _nonFictionList.clear();
      _nonFictionList.addAll(nonFictionList ?? []);
    }).onError((e, s) {
      _isLoading.value = false;
      debugPrint("$e $s");
    });
  }

  void subscribeUserTopics() async {
    _buttonState.value = ButtonState.loading;
    final requestBody = {
      'fictionList': _selectedFictionList,
      'nonFictionList': _selectedNonFictionList
    };
    _repository.subscribeTopic(requestBody).then((response) {
      Get.off(HomeScreen());
    }).onError((e, s) {
      debugPrint("$e $s");
    });
  }

  bool isChipSelected(ChipData chipData) {
    if(_currentSelectedIndex.value == 0) {
      return _selectedFictionList.contains(chipData.title ?? "");
    } else {
      return _selectedNonFictionList.contains(chipData.title ?? "");
    }
  }

  void onChipSelected(ChipData chipData, bool value) {
    if(value) {
      if(_currentSelectedIndex.value == 0) {
        _selectedFictionList.add(chipData.title ?? "");
      } else {
        _selectedNonFictionList.add(chipData.title ?? "");
      }
    } else {
      if(_currentSelectedIndex.value == 0) {
        _selectedFictionList.remove(chipData.title);
      } else {
        _selectedNonFictionList.remove(chipData.title);
      }
    }
  }

  void updateCurrentSelectedIndex(int index) {
    _currentSelectedIndex.value = index;
  }

  void onRetryClicked() {
    _fetchBookTopics();
  }

  @override
  void onClose() {
    _bookTopicResponse.close();
    _buttonState.close();
    super.onClose();
  }
}
