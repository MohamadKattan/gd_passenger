// this class for drop bottom

import 'package:flutter/material.dart';
import 'package:gd_passenger/my_provider/dropBottom_value.dart';
import 'package:provider/provider.dart';

class CustomDropBottom {
  String? value = "Cash";

  Widget DropBottomCustom(BuildContext context, String dropBottomProvider) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0, left: 4.0),
      child: Container(
        padding: EdgeInsets.all(4.0),
        height: MediaQuery.of(context).size.height * 6 / 100,
        width: MediaQuery.of(context).size.width * 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: Colors.purple, width: 2)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
              value: dropBottomProvider,
              isExpanded: true,
              dropdownColor: Colors.white,
              iconSize: 40.0,
              items: <String>[
                'Cash',
                'Credit Card',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                     value=="Cash"? Icon(Icons.money,color: Colors.green,):Icon(Icons.credit_card,color: Colors.black38,),
                      SizedBox(width: 10.0),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (value != null) {
                  value = val;
                  Provider.of<DropBottomValue>(context, listen: false)
                      .updateValue(value!);
                } else {
                  return null;
                }
              }),
        ),
      ),
    );
  }
}
