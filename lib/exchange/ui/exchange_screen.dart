import 'package:bookish_module/exchange/controller/exchange_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ExchangeScreen extends GetView<ExchangeController> {
  static String routeName = "/exchange";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Instructions:",
                    style: GoogleFonts.roboto(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 12, color: Colors.grey),
                      Text(
                        "This is first instruction:",
                        style: GoogleFonts.roboto(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 12, color: Colors.grey),
                      Text(
                        "This is first instruction:",
                        style: GoogleFonts.roboto(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 12,
                        color: Colors.grey,
                      ),
                      Text(
                        "This is first instruction:",
                        style: GoogleFonts.roboto(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 32,
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  height: 50,
                  child: TextButton(
                      style: ButtonStyle(
                          elevation: WidgetStateProperty.all(0),
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          backgroundColor: WidgetStateProperty.all<Color>(
                              Colors.teal.shade500)),
                      onPressed: () {
                        controller.sendQuote();
                      },
                      child: Text(
                        "Send quote",
                        style: GoogleFonts.roboto(fontSize: 16),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
