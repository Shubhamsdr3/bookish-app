import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchWidget extends StatelessWidget {
  final Color? focusedBorder;
  final Color? borderColor;
  final String hint;
  final Function(String) onChanged;
  final TextEditingController editingController;
  final bool isBookSelected;
  final VoidCallback? onClearSelection;

  const SearchWidget({
    super.key,
    required this.hint,
    required this.onChanged,
    required this.editingController,
    this.focusedBorder,
    this.borderColor,
    this.isBookSelected = false,
    this.onClearSelection,
  });

  @override
  Widget build(BuildContext context) {
    // Show the highlighted selection chip when a book is selected
    if (isBookSelected && editingController.text.isNotEmpty) {
      return _buildSelectedBookChip(context);
    }

    return _buildSearchField(context);
  }

  Widget _buildSelectedBookChip(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.06,
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        border: Border.all(color: Colors.teal, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(Icons.book, color: Colors.teal, size: 22.r),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                editingController.text,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.teal.shade900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            InkWell(
              onTap: onClearSelection,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.teal.shade700,
                  size: 18.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.06,
      decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: TextFormField(
          decoration: InputDecoration(
              suffixIcon: const Icon(Icons.search),
              hintText: hint,
              hintStyle:
                  GoogleFonts.roboto(fontSize: 18, color: Colors.black45),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: focusedBorder ?? Colors.lightBlue,
                  width: 1.r,
                ),
              )),
          scrollPadding: const EdgeInsets.all(20.0),
          keyboardType: TextInputType.text,
          maxLines: 10,
          enabled: false,
          autofocus: true,
          onChanged: (newValue) {
            onChanged.call(newValue);
          },
          controller: editingController,
        ),
      ),
    );
  }
}
