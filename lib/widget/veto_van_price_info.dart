// this dailog if rider chose a van or veto car it will show dailog price in turkey $100
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../config.dart';
import 'divider_box_.dart';

class VetoVanPriceTurkeyJust extends StatefulWidget {
  const VetoVanPriceTurkeyJust({Key? key}) : super(key: key);

  @override
  State<VetoVanPriceTurkeyJust> createState() => _VetoVanPriceTurkeyJustState();
}

class _VetoVanPriceTurkeyJustState extends State<VetoVanPriceTurkeyJust> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 70 / 100,
        width:double.infinity ,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0), color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                  child: Lottie.asset('assets/84965-warning-yellow.json',
                      fit: BoxFit.fill, height: 40, width: 40)),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "This type of car for torzim trip",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Prices list",
                  style: TextStyle(
                    color: Colors.greenAccent.shade700,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CustomWidget().customDivider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                   setState(() {
                     tourismCityName ="istanbul";
                     tourismCityPrice = "100";
                   });
                  Navigator.pop(context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade700,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: const Offset(3.0, 3.0))
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Trip in  Istanbul City : ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent.shade700,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Text(
                              "\$100",
                              style: TextStyle(color: Colors.redAccent.shade700,
                                fontSize: 20.0
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                   setState(() {
                     tourismCityName ="bursa";
                     tourismCityPrice = "220";
                   });
                   Navigator.pop(context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade700,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: const Offset(3.0, 3.0))
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Trip from Istanbul to Bursa : ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent.shade700,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Text(
                              "\$220",
                              style: TextStyle(color: Colors.redAccent.shade700,
                                  fontSize: 20.0
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                  setState(() {
                    tourismCityName ="izmit";
                    tourismCityPrice = "150";
                  });
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade700,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: const Offset(3.0, 3.0))
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex:1,child: Text(
                              "Trip from Istanbul to Izmit : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent.shade700,fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Text(
                              "\$150",
                              style: TextStyle(color: Colors.redAccent.shade700,
                                  fontSize: 20.0
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tourismCityName ="sabanjah";
                      tourismCityPrice = "180";
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade700,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: const Offset(3.0, 3.0))
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 0,
                            child: Text(
                              " from Istanbul to Sabanjah:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent.shade700
                                  ,fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Text(
                              "\$180",
                              style: TextStyle(color: Colors.redAccent.shade700,
                                  fontSize: 20.0
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tourismCityName ="polo";
                      tourismCityPrice = "300";
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade700,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: const Offset(3.0, 3.0))
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Trip from Istanbul to Polo abant : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent.shade700,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "\$300",
                            style: TextStyle(
                                color: Colors.redAccent.shade700,
                                fontSize: 20.0
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tourismCityName ="sala";
                      tourismCityPrice = "150";
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                      width:double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade700,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: const Offset(3.0, 3.0))
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Trip from Istanbul to Sala:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent.shade700,
                                  fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Text(
                              "\$300",
                              style: TextStyle(color: Colors.redAccent.shade700,
                                  fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tourismCityName ="yalaua";
                      tourismCityPrice = "170";
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade700,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: const Offset(3.0, 3.0))
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Trip from Istanbul to Yalua :",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent.shade700,fontSize: 16.0),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "\$170",
                            style: TextStyle(color: Colors.redAccent.shade700,
                                fontSize: 20.0,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
