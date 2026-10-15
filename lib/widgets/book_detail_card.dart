import 'package:bookish/data/book_detail.dart';
import 'package:bookish/util/utility.dart';
import 'package:bookish/widgets/bookish_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BookDetailCard extends StatelessWidget {

  final BookDetail bookDetail;
  final bool showDescription;

  const BookDetailCard({
    super.key,
    required this.bookDetail,
    this.showDescription = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 0,
                  child: BookishNetworkImage(
                    imageUrl:
                    bookDetail.volumeInfo?.imageLinks?.thumbnail ?? "",
                    fit: BoxFit.cover,
                    width: MediaQuery.sizeOf(context).width * 0.20,
                  ),
                ),
                SizedBox(
                  width: 8.r,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookDetail.volumeInfo?.title ?? "",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      if (bookDetail.volumeInfo?.subtitle != null &&
                          bookDetail.volumeInfo?.subtitle?.isNotEmpty ==
                              true) ...[
                        Text(bookDetail.volumeInfo?.subtitle ?? "",
                            softWrap: true,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.normal, fontSize: 14)),
                      ],
                      Padding(
                        padding: EdgeInsets.only(top: 4.r),
                        child: Text(
                          Utility.getAuthors(bookDetail.volumeInfo?.authors),
                          style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 10.r,
                      ),
                      RatingBar.builder(
                        initialRating:
                        (bookDetail.volumeInfo?.averageRating ?? 0)
                            .toDouble(),
                        minRating: 1,
                        itemSize: 24.r,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      SizedBox(
                        height: 8.r,
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Rating",
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black54),
                                ),
                                Text(
                                  '${(bookDetail.volumeInfo?.averageRating ?? 0).toDouble()}',
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text("Reviews",
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black54)),
                                Text(
                                    '${bookDetail.volumeInfo?.ratingsCount ?? 0}',
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w500))
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            if (showDescription) ...[
              SizedBox(
                height: 16.r,
              ),
              Text(
                "About",
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(
                height: 16.r,
              ),
              Html(data: bookDetail.volumeInfo?.description ?? "")
            ],
          ],
        ),
      ),
    );
  }
}
