import 'package:flutter/material.dart';

class TextFormInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final int maxLines;
  final bool isNumber;
  Widget? prefix;
  int? maxLength;

  TextFormInput(
      {Key? key,
      required this.textEditingController,
      this.isPass = false,
      required this.hintText,
      required this.textInputType,
      this.maxLines = 1,
      this.prefix,
      this.isNumber = false,
      this.maxLength})
      : super(key: key);

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is mandatory';
        }

        if (isNumber && !isNumeric(value)) {
          return 'Numeric value expected';
        }
        return null;
      },
      controller: textEditingController,
      decoration: InputDecoration(
        prefix: prefix,
        hintText: hintText,
        border: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
      maxLines: maxLines,
      maxLength: maxLength,
    );
  }
}
