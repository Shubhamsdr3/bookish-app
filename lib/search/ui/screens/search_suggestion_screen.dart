import 'package:bookish_module/data/book_detail.dart';
import 'package:bookish_module/widgets/book_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../notifiers/search_state.dart';
import '../providers/search_state_providers.dart';

class SearchSuggestionScreen extends ConsumerStatefulWidget {
  static String routeName = "/search-suggestions";

  const SearchSuggestionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchSuggestionScreen> createState() =>
      _SearchSuggestionScreenState();
}

class _SearchSuggestionScreenState
    extends ConsumerState<SearchSuggestionScreen> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocus;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocus = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchNotifierProvider);
    final notifier = ref.read(searchNotifierProvider.notifier);

    // Sync controller text when suggestion is tapped
    ref.listen<SearchState>(searchNotifierProvider, (prev, next) {
      if (prev?.query != next.query &&
          _searchController.text != next.query) {
        _searchController.text = next.query;
        _searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: next.query.length),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text("")),
      body: Container(
        color: Colors.white10,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16.r),
              SearchInputField(
                hint: '',
                focusNode: _searchFocus,
                searchEditController: _searchController,
                onCameraClicked: () {
                  // TODO: implement camera text recognition
                },
                onChanged: (newValue) {
                  notifier.onSearchChanged(newValue);
                },
              ),
              _buildContent(state, notifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(SearchState state, dynamic notifier) {
    switch (state.status) {
      case SearchStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case SearchStatus.loaded:
        return SearchSuggestions(
          bookItems: state.items,
          searchQuery: state.query,
          onBookSelected: (bookDetail) {
            Navigator.of(context).pop(bookDetail);
          },
        );

      case SearchStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${state.errorMessage ?? "Something went wrong"}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => notifier.onSearchChanged(state.query),
                child: const Text('Retry'),
              ),
            ],
          ),
        );

      case SearchStatus.initial:
        return RecentSearch(
          searchSuggestions: notifier.suggestions,
          onSuggestionItemSelected: (suggestion) {
            notifier.onSuggestionItemSelected(suggestion);
          },
        );
    }
  }
}

// ─── Reusable Widgets (unchanged) ───────────────────────────────────────

class RecentSearch extends StatelessWidget {
  final List<String> searchSuggestions;
  final Function(String) onSuggestionItemSelected;

  const RecentSearch({
    super.key,
    required this.searchSuggestions,
    required this.onSuggestionItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.r, right: 16.r, top: 8.r),
      child: ListView.builder(
        itemCount: searchSuggestions.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = searchSuggestions[index];
          return InkWell(
            onTap: () => onSuggestionItemSelected(item),
            child: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: Colors.black54, size: 24.r),
                  SizedBox(width: 8.r),
                  Text(
                    item,
                    style: GoogleFonts.roboto(
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchInputField extends StatelessWidget {
  final String hint;
  final TextEditingController searchEditController;
  final VoidCallback onCameraClicked;
  final Function(String) onChanged;
  final FocusNode focusNode;

  const SearchInputField({
    super.key,
    required this.hint,
    required this.searchEditController,
    required this.onCameraClicked,
    required this.onChanged,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: const BorderSide(color: Colors.blueGrey, width: 1),
      ),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.06,
        child: Padding(
          padding: EdgeInsets.only(left: 16.r),
          child: TextFormField(
            decoration: InputDecoration(
              suffixIcon: InkWell(
                child: searchEditController.text.isEmpty
                    ? const Icon(Icons.camera_alt)
                    : const Icon(Icons.close),
                onTap: () {
                  if (searchEditController.text.isEmpty) {
                    onCameraClicked();
                  } else {
                    searchEditController.clear();
                    onChanged('');
                  }
                },
              ),
              hintText: hint,
              hintStyle:
                  GoogleFonts.roboto(fontSize: 18, color: Colors.black45),
              border: InputBorder.none,
            ),
            scrollPadding: EdgeInsets.all(20.r),
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            autofocus: true,
            focusNode: focusNode,
            onChanged: onChanged,
            controller: searchEditController,
          ),
        ),
      ),
    );
  }
}

class SearchSuggestions extends StatelessWidget {
  final List<BookDetail> bookItems;
  final String searchQuery;
  final Function(BookDetail) onBookSelected;

  const SearchSuggestions({
    super.key,
    required this.bookItems,
    required this.searchQuery,
    required this.onBookSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (bookItems.isEmpty && searchQuery.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.all(16.r),
        child:
            const Text("Couldn't find what you are looking, please try again."),
      );
    } else {
      return ListView.separated(
        itemCount: bookItems.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = bookItems[index];
          return InkWell(
            onTap: () => onBookSelected(item),
            child: BookDetailCard(
              bookDetail: item,
              showDescription: false,
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 8.r),
      );
    }
  }
}

