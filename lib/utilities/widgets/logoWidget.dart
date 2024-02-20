import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:attendanceadmin/utilities/config.dart';
import 'package:attendanceadmin/utilities/constants.dart';

class LogoWidget extends StatelessWidget {
  final double? width;
  final double? height;
  const LogoWidget({Key? key,   this.width,  this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height??null,
        width: width??null,
        child: Image.asset('assets/logo.png'));
  }
}
class LanguageChanger extends StatefulWidget {
   LanguageChanger({Key? key,required this.showImage}) : super(key: key);
  bool showImage = false;
  @override
  State<LanguageChanger> createState() => _LanguageChangerState();
}

class _LanguageChangerState extends State<LanguageChanger> {
  bool isEnglishSelected = true;
  @override
  void initState() {
    // TODO: implement initState
    if(Config.app_language.value == 'english'){
      isEnglishSelected = true;
    }else{
      isEnglishSelected = false;
    }
  }
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.showImage?Image.asset('assets/languageChanged.png',height: 30,width: 70,):Text(''),
        widget.showImage?SizedBox(height: 10,):Text(''),
        AnimatedContainer(

            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOutCirc,
          height: 35,
            width: clicked?200:150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Constants.primaryOrangeColor
              )
            ),

          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async{
                  setState(() {
                    clicked = true;
                  });
                  try{
                    await FirebaseFirestore.instance.collection('admin').doc('aadmin').update({
                      'selectedLanguage':'english'
                    }).then((value){
                      Config.app_language.value = 'english';
                      isEnglishSelected = true;
                      setState(() {
                      });
                    });
                  }catch(e){
                    debugPrint(e.toString());
                  }
                  setState(() {
                    clicked = false;
                  });
                },
                child: Container(
                  height: 25,
                  width: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isEnglishSelected?Constants.primaryOrangeColor:Colors.white,
                    //borderRadius: BorderRadius.circular(12),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text('English',style: TextStyle(fontWeight: FontWeight.bold,color:isEnglishSelected?Colors.white:Colors.grey.shade500 ),),
                ),
              ),
              InkWell(
                onTap: () async{
                 setState(() {
                    clicked = true;
                 });
                  try{
                    await FirebaseFirestore.instance.collection('admin').doc('aadmin').update({
                      'selectedLanguage':'french'
                    }).then((value){
                      Config.app_language.value = 'french';
                      setState(() {
                        isEnglishSelected = false;
                      });
                    });
                  }catch(e){
                    debugPrint(e.toString());
                  }
                 setState(() {
                    clicked = false;
                 });
                },
                child: Container(
                  height: 25,
                  width: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isEnglishSelected?Colors.white:Constants.primaryOrangeColor,
                    //borderRadius: BorderRadius.circular(12),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text('French',style: TextStyle(fontWeight: FontWeight.bold,color:isEnglishSelected?Colors.grey.shade500:Colors.white )),
                ),
              ),
            ],
          )
        ),
      ],
    );
  }
}

