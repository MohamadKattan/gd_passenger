import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../config.dart';
import '../my_provider/rider_id.dart';
import 'divider_box_.dart';

class RatingWidget extends StatefulWidget {
 // final String id;
 //  required this.id
  const RatingWidget({Key? key}) : super(key: key);

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  @override
  Widget build(BuildContext context) {
    final id = Provider.of<RiderId>(context).id;
    return Dialog(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 35 / 100,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Rate this driver",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 3 / 100),
              SmoothStarRating(
                  allowHalfRating: false,
                  starCount: 5,
                  rating: rating,
                  size: 40.0,
                  color: Colors.yellow.shade700,
                  borderColor: Colors.yellow,
                  spacing:0.0,
                onRatingChanged: (v) {
                  rating = v;
                  setState(() {
                    if(rating ==0.0){
                      titleRate = "";
                    }else{
                      titleRate = "Thanks for your rating";
                    }
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(titleRate,
                    style:
                    const TextStyle(color: Colors.black87, fontSize: 20.0)),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 1 / 100),
              CustomWidget().customDivider(),
              SizedBox(height: MediaQuery.of(context).size.height * 1/ 100),
              GestureDetector(
                onTap: () {
                  rateTODateBase(id);
                  Navigator.pop(context);
                },
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 30 / 100,
                    height: MediaQuery.of(context).size.height * 8 / 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.greenAccent.shade700),
                    child: const Center(
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
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
 Future <void> rateTODateBase(String id) async{
    DatabaseReference reference =   FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(id)
        .child("rating");

     await reference.once().then((value){
       if(value.snapshot.value != null){
       double oldRating = double.parse(value.snapshot.value.toString());
       double newRating = oldRating + rating;
       double result = newRating / 2;
       reference.set(result.toStringAsFixed(2));

       }else{
         reference.set(rating.toStringAsFixed(2));
       }
     });
  }
}
