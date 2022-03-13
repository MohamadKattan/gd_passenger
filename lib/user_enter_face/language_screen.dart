import 'package:flutter/material.dart';
import 'package:gd_passenger/my_provider/dropBottom_value.dart';
import 'package:gd_passenger/my_provider/info_user_database_provider.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final info=  Provider.of<UserAllInfoDatabase>(context).users;
    final dropBottomProvider = Provider.of<DropBottomValue>(context).valueDropBottom;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("${info?.email}"),
            Text(dropBottomProvider),
          ],
        ),
      ),
    );
  }

}
