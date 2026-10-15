import 'package:bookish/settings/account_setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AccountSettingScreen extends GetView<AccountSettingController> {
  static String routeName = "/account-setting";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Account settings"),
        ),
        body: Container(
          padding: EdgeInsets.all(16.r),
          child: Column(
              children: controller.accountSettings.map((item) {
            return InkWell(
              child: AccountItem(item.title, item.subtitle, item.iconUrl),
              onTap: () {
                item.onClick();
              },
            );
          }).toList()),
        )

        //
        // ChangeNotifierProvider(
        //   create: (_) => TimeWidgetProvider(),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       TimerWidget()
        //     ],
        //   ),
        // ),
        );
  }
}

class AccountItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconUrl;

  AccountItem(this.title, this.subtitle, this.iconUrl);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.settings),
            SizedBox(
              width: 8.r,
            ),
            Text(title)
          ],
        ),
        Text(subtitle)
      ],
    );
  }
}
