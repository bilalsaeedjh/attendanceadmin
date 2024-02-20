import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:attendanceadmin/utilities/config.dart';
import 'package:attendanceadmin/utilities/constants.dart';
import 'package:attendanceadmin/utilities/languages.dart';

class webCard extends StatefulWidget {
  final String? columnFirst;
  final String? columnSecond;
  final String? rowSecond;

  const webCard(
      {Key? key,
      @required this.columnFirst,
      @required this.columnSecond,
      @required this.rowSecond})
      : super(key: key);

  @override
  State<webCard> createState() => _webCardState();
}

class _webCardState extends State<webCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height *0.18,
      width: size.width * 0.245,
      child: Card(
        elevation: 18.0,
        shadowColor: Colors.black87,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  widget.columnFirst!,height: size.height *0.06,
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  Languages.skeleton_language_objects[Config.app_language.value]![
                      widget.columnSecond]!,style: TextStyle(fontSize: (size.height *0.035).toDouble()),
                ),
              ],
            ),
            Text(
              widget.rowSecond.toString(),
              style: TextStyle(
                  color: Constants.primaryOrangeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: (size.height *0.055).toDouble()),
            )
          ],
        ),
      ),
    );
  }
}
