import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../config.dart';

import 'divider_box_.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RatingWidget extends StatefulWidget {
  final String id;
  const RatingWidget({Key? key, required this.id}) : super(key: key);

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  @override
  Widget build(BuildContext context) {
    // final id = Provider.of<RiderId>(context).id;
    return Dialog(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      child: Container(
        height: 225,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: const Color(0xFF00A3E0)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.rate,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              SmoothStarRating(
                allowHalfRating: false,
                starCount: 5,
                rating: rating,
                size: 40.0,
                color: Colors.yellow.shade700,
                borderColor: Colors.yellow,
                spacing: 0.0,
                onRatingChanged: (v) {
                  rating = v;
                  setState(() {
                    if (rating == 0.0) {
                      titleRate = "";
                    } else {
                      titleRate = AppLocalizations.of(context)!.thanks;
                    }
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(titleRate,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 20.0)),
              ),
              const SizedBox(height: 10),
              CustomWidget().customDivider(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  rateTODateBase(widget.id);
                },
                child: Center(
                  child: Container(
                    width: 120,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: const Color(0xFFFBC408)),
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context)!.ok,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// this method for set rate to data base
  Future<void> rateTODateBase(String id) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child("driver").child(id);

    await reference.child("rating").once().then((value) {
      if (value.snapshot.value != null) {
        double oldRating = double.parse(value.snapshot.value.toString());
        double newRating = oldRating + rating;
        double result = newRating / 2;
        reference.child('rating').set(result.toStringAsFixed(2));
      } else {
        reference.child("rating").set(rating.toStringAsFixed(2));
      }
    });
    Navigator.pop(context);
  }
}
