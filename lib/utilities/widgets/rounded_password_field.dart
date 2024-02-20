import 'package:flutter/material.dart';
import 'package:attendanceadmin/utilities/constants.dart';
import 'package:attendanceadmin/utilities/widgets/text_field_container.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String?>? onChanged;
  final labelText;
  final TextEditingController? controller;

  const RoundedPasswordField({
    Key? key,
    this.onChanged,
    this.labelText,
    this.controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: Material(
        elevation: 5.0,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        child: TextField(
          controller: controller,
          obscureText: true,
          onChanged: onChanged,
          cursorColor: Constants.primaryOrangeColor,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: "Password",
            icon: const Icon(
              Icons.lock,
              color: Constants.primaryOrangeColor,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
