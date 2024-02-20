import 'package:flutter/material.dart';
import 'package:attendanceadmin/utilities/widgets/text_field_container.dart';

import '../constants.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final IconData? icon;
  final int? typeInput;
   bool? prefixDigit;
   int? totalDigits;
   bool autoFocus=false;
  final ValueChanged<String>? onChanged;
 // final TextEditingController controller;
   RoundedInputField({
    Key? key,
     this.prefixDigit=false,
    this.hintText,
     this.autoFocus=false,
    this.icon = Icons.person,
    this.typeInput=1,
    this.onChanged,
     this.totalDigits=500,
     //this.controller,
    this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: TextField(
          onChanged: onChanged,
          style: const TextStyle(color: Constants.primaryOrangeColor,fontSize: 16,fontWeight: FontWeight.bold),
          autofocus: this.autoFocus,
          maxLength: this.totalDigits,
          cursorColor: Constants.primaryOrangeColor,
          keyboardType: typeInput!=1?TextInputType.numberWithOptions():TextInputType.text,
          decoration: InputDecoration(
            prefix: this.prefixDigit!?const Padding(
              padding: EdgeInsets.all(4),
              child: Text('+92'),
            ):const Padding(
              padding: EdgeInsets.all(1),
              child: Text(''),
            ),
            icon: Icon(
              icon,
              color: Constants.primaryOrangeColor,
            ),
            hintText: hintText,
            border: InputBorder.none,
            labelText: labelText,
          ),
        ),
      ),
    );
  }
}
