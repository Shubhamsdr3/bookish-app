import 'package:bookish/createpost/ui/notifiers/create_post_state.dart';
import 'package:bookish/createpost/ui/providers/create_post_state_providers.dart';
import 'package:bookish/widgets/image_grid_widget.dart';
import 'package:bookish/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../home/screens/home_screen.dart';
import '../../search/ui/screens/search_suggestion_screen.dart';
import '../../util/app_state.dart';
import '../../util/enums.dart';
import '../../widgets/profile_widget.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  static String routeName = "/createPost";

  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {

  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _bookTitleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  Color _borderColor = Colors.grey;

  @override
  void dispose() {
    _captionController.dispose();
    _bookTitleController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createPostNotifierProvider);
    final notifier = ref.read(createPostNotifierProvider.notifier);

    // Listen for success/error status changes
    ref.listen<CreatePostState>(createPostNotifierProvider, (prev, next) {
      if (next.status == CreatePostStatus.success && next.createdPost != null) {
        AppState().feedData.value = next.createdPost!;
        AppState().tabIndex.value = 0;
        Get.off(HomeScreen());
      } else if (next.status == CreatePostStatus.error &&
          next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.r, top: 12.r),
          child: IconButton(
            icon: ImageIcon(
              const AssetImage('assets/image/close.png'),
              size: 16.r,
            ),
            onPressed: () {
              AppState().tabIndex.value = 0;
            },
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 12.r, right: 16.r, bottom: 4.r),
            child: PostButton(
              buttonState:
                  state.canPost ? ButtonState.enabled : ButtonState.disabled,
              onPressed: () => notifier.createPost(),
            ),
          ),
        ],
        title: Padding(
          padding: EdgeInsets.only(top: 12.r),
          child: Text(
            "Create post",
            style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Book, you are reading?",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    SizedBox(height: 8.r),
                    GestureDetector(
                      onTap: () {
                        if (!state.isBookSelected) {
                          _navigateToSearchSuggestion(notifier);
                        }
                      },
                      child: SearchWidget(
                        hint: "Lord of the rings",
                        onChanged: (newValue) {
                          _bookTitleController.text = newValue;
                        },
                        editingController: _bookTitleController,
                        isBookSelected: state.isBookSelected,
                        onClearSelection: () {
                          _bookTitleController.clear();
                          notifier.clearBookSelection();
                        },
                      ),
                    ),
                    SizedBox(height: 24.r),
                    _buildPostEditWidget(notifier),
                    SizedBox(height: 24.r),
                    GestureDetector(
                      onTap: () => _pickPhotos(context, notifier),
                      child: state.imagePaths.isNotEmpty
                          ? ImageGridWidget(
                              imagePaths: state.imagePaths,
                              onRemoved: (index) =>
                                  notifier.removeImage(index),
                            )
                          : _buildImageUploadCard(context, notifier),
                    ),
                  ],
                ),
              ),
            ),
            if (state.status == CreatePostStatus.loading)
              const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 7),
                    Text("Posting..."),
                  ],
                ),
              ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _buildPostEditWidget(dynamic notifier) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.all(Radius.circular(16.r)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 12.r),
            child: Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  _borderColor = hasFocus ? Colors.lightBlue : Colors.grey;
                });
              },
              child: TextField(
                decoration: InputDecoration(
                  hintText: "What did you read today ?",
                  hintStyle: GoogleFonts.roboto(
                      fontSize: 18, color: Colors.black45),
                  border: InputBorder.none,
                ),
                scrollPadding: const EdgeInsets.all(20.0),
                keyboardType: TextInputType.text,
                maxLines: 10,
                onChanged: (value) => notifier.onCaptionChanged(value),
                controller: _captionController,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSearchSuggestion(dynamic notifier) async {
    var result = await Get.toNamed(SearchSuggestionScreen.routeName);
    if (result != null) {
      notifier.onBookSelected(result);
      _bookTitleController.text = result?.volumeInfo?.title ?? "";
    }
  }

  void _pickPhotos(BuildContext context, dynamic notifier) {
    showModalBottomSheet(
      context: context,
      builder: (builder) => ProfileWidget(
        onChosePictureClicked: (NativePickSource source) {
          Navigator.pop(context);
          switch (source) {
            case NativePickSource.camera:
              notifier.openCamera();
            case NativePickSource.gallery:
              notifier.openGallery();
          }
        },
      ),
    );
  }

  Widget _buildImageUploadCard(BuildContext context, dynamic notifier) {
    return GestureDetector(
      onTap: () => _pickPhotos(context, notifier),
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.3,
        width: MediaQuery.sizeOf(context).width,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
            side: const BorderSide(color: Colors.blueGrey, width: 1),
          ),
          child: Image.asset(
            'assets/image/image_gallery.png',
            fit: BoxFit.scaleDown,
            height: 24.r,
            width: 24.r,
          ),
        ),
      ),
    );
  }
}

class PostButton extends StatelessWidget {
  final ButtonState buttonState;
  final VoidCallback onPressed;

  const PostButton(
      {super.key, required this.buttonState, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: buttonState == ButtonState.enabled
                    ? Colors.blueGrey
                    : Colors.grey,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: EdgeInsets.all(10.r),
              textStyle: const TextStyle(fontSize: 18),
            ),
            onPressed: () {
              buttonState == ButtonState.enabled ? onPressed.call() : null;
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}

class LinkInputField extends StatelessWidget {
  final String hint;
  final Function(String) onChanged;
  final TextEditingController linkEditController;

  const LinkInputField(
      {super.key,
      required this.hint,
      required this.onChanged,
      required this.linkEditController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.06,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                GoogleFonts.roboto(fontSize: 18, color: Colors.black45),
            border: InputBorder.none,
          ),
          scrollPadding: EdgeInsets.all(20.r),
          keyboardType: TextInputType.multiline,
          maxLines: 10,
          onChanged: (newValue) {
            onChanged.call(newValue);
          },
          controller: linkEditController,
        ),
      ),
    );
  }
}

