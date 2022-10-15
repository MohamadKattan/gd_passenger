import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HowToUse extends StatelessWidget {
  const HowToUse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(backgroundColor: const Color(0xFF00A3E0),elevation: 0.0),
            body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color:const Color(0xFF00A3E0),
            child:   Center(child: Image.asset("assets/splash.png", width: 120, height: 120)),
          ),
         const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/002.png",height: 160,),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppLocalizations.of(context)!.st1,style:const TextStyle(color: Color(0xFF00A3E0),fontSize: 16,fontWeight: FontWeight.bold )),
          ),
          Image.asset("assets/Varlık17.png",width:width ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/Varlık11.png",height: 160),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppLocalizations.of(context)!.st3,style:const TextStyle(color: Color(0xFF00A3E0),fontSize: 16,fontWeight: FontWeight.bold )),
          ),
          Image.asset("assets/Varlık17.png",width:width ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/003.png",height: 160),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppLocalizations.of(context)!.st4,style:const TextStyle(color: Color(0xFF00A3E0),fontSize: 16,fontWeight: FontWeight.bold )),
          ),
          Image.asset("assets/Varlık17.png",width:width ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/Varlık 13.png",height: 160),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppLocalizations.of(context)!.st5,style:const TextStyle(color: Color(0xFF00A3E0),fontSize: 16,fontWeight: FontWeight.bold )),
          ),
          Image.asset("assets/Varlık17.png",width:width ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/001.png",height: 160),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppLocalizations.of(context)!.st6,textAlign: TextAlign.center,style:const TextStyle(color: Color(0xFF00A3E0),fontSize: 16,fontWeight: FontWeight.bold )),
          ),

        ],
      ),
    )));
  }
}
