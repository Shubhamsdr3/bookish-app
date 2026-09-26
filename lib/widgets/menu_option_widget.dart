import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum MenuActions { SAVE, DELETE }

typedef void MenuActionClick(MenuActions action);

class MenuOptionWidget extends StatelessWidget {
  final bool isAdminUser;
  final MenuActionClick onMenuClick;

  const MenuOptionWidget(
      {super.key, required this.isAdminUser, required this.onMenuClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.12,
        child: Column(
          children: [
            InkWell(
              child: Row(
                children: [
                  Icon(Icons.bookmark_add_outlined,
                      size: 32, color: Colors.black87),
                  SizedBox(
                    width: 12.r,
                  ),
                  Text(
                    "Save",
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  )
                ],
              ),
              onTap: () {
                onMenuClick.call(MenuActions.SAVE);
              },
            ),
            SizedBox(
              height: 20.r,
            ),
            Row(
              children: [
                Icon(Icons.report_gmailerrorred),
                SizedBox(
                  width: 12.r,
                ),
                Text(
                  "Report",
                  style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                )
              ],
            ),
            if (isAdminUser) ...[
              InkWell(
                child: Row(
                  children: [
                    Icon(Icons.delete_forever, size: 32, color: Colors.black87),
                    SizedBox(
                      width: 12.r,
                    ),
                    Text(
                      "Delete post",
                      style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87),
                    )
                  ],
                ),
                onTap: () {
                  onMenuClick.call(MenuActions.DELETE);
                },
              ),
            ]
          ],
        ),
      ),
    );
  }
}
