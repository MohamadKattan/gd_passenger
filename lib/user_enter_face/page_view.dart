import 'package:flutter/material.dart';
import '../widget/pageview_content.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyPageView extends StatelessWidget {
  const MyPageView({Key? key}) : super(key: key);
  final int index = 0;
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: index);
    String title0 = AppLocalizations.of(context)!.into0;
    String title1 = AppLocalizations.of(context)!.into1;
    String title2 = AppLocalizations.of(context)!.into2;
    String title3 = AppLocalizations.of(context)!.into3;
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: controller,
          children: <Widget>[
            pageViewContent(context, "assets/discount.jpeg", title0, controller,
                firstPage: true, paddingBottom: 30),
            pageViewContent(
                context, "assets/firstPageView.png", title1, controller,
                firstPage: false, paddingBottom: 15),
            pageViewContent(context, "assets/2PageView.png", title2, controller,
                firstPage: false, paddingBottom: 15),
            pageViewContent(context, "assets/3pageView.png", title3, controller,
                firstPage: false, paddingBottom: 15),
          ],
        ),
      ),
    );
  }
}
