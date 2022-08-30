import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageSliderDemo extends StatelessWidget {
  ImageSliderDemo({Key? key}) : super(key: key);
  final List<String> imgList = [
    "assets/01.jpg",
    "assets/02.jpg",
    "assets/03.jpg",
    "assets/04.jpg",
    "assets/05.jpg",
    "assets/06.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: 25.0,right: AppLocalizations.of(context)!.hi=="مرحبا"?120.0:50.0,left: 8.0),
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 20 / 100,
          width : MediaQuery.of(context).size.width * 60 / 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 1.0,
              enlargeCenterPage: true,
            ),
            items: imgList
                .map((item) => Center(
                    child: Image.asset(item, fit: BoxFit.cover, width: 300)))
                .toList(),
          ),
        ),
      ),
    );
  }
}
