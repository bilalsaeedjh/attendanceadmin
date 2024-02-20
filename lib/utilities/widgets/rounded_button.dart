import 'package:flutter/material.dart';
import 'package:attendanceadmin/utilities/constants.dart';



class RoundedButton extends StatelessWidget {
   String? text;
   void Function()? press;
   Color color, textColor;
   double height;
   double width;
   double fontSize;
   bool isTextButton = false;
   RoundedButton({
    Key? key,
    @required this.text,
    this.press,
     required this.isTextButton,
    required this.color,
    this.textColor = Colors.white,
    this.height = .057,
     this.fontSize = Constants.textH6Size,
    this.width =0.4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isTextButton?SizedBox(

      //margin: EdgeInsets.symmetric(vertical: 5),
      width: size.width * width,
      height: size.height * height,
      child: TextButton(
        //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
       /* style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                )
            )
        ),*/



        onPressed: press,
        child:   Wrap(
          children: [
            Text(
              text!,
              style: TextStyle(color: textColor,fontSize: fontSize),
            ),
          ],
        ),
      ),
    ):SizedBox(

      //margin: EdgeInsets.symmetric(vertical: 5),
      width: size.width * width,
      height: size.height * height,
      child: ElevatedButton(
        //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                )
            )
        ),


        onPressed: press,
        child:   Wrap(
          children: [
            Text(
              text!,
              style: TextStyle(color: textColor,fontSize: fontSize),
            ),
          ],
        ),
      ),
    );
  }
}
