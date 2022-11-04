
import 'package:flutter/material.dart';
import '../widget/pageview_content.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyPageView extends StatelessWidget {
  const MyPageView({Key? key}) : super(key: key);
  final int index = 0;
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: index);
    String title1 =   AppLocalizations.of(context)!.into1;
    String title2 =   AppLocalizations.of(context)!.into2;
    String title3 =   AppLocalizations.of(context)!.into3;
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: controller,
          // onPageChanged: (index) {
          //   if (index == 2) {
          //     Future.delayed(const Duration(seconds: 3)).whenComplete(() =>
          //         Navigator.push(context,
          //             MaterialPageRoute(builder: (_) => const AuthScreen())));
          //   }
          // },
          children: <Widget>[
            pageViewContent(
                context, "assets/firstPageView.png",title1, controller),
            pageViewContent(
                context, "assets/2PageView.png", title2, controller),
            pageViewContent(
                context, "assets/3pageView.png", title3, controller),
          ],
        ),
      ),
    );
  }
}
