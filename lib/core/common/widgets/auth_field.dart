import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final bool isObscureText;
  const AuthField({
    super.key,
    required this.hintText,
    required this.textEditingController,
    this.isObscureText = false
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        labelText: hintText,
      ),
      controller: textEditingController,
      obscureText: isObscureText,
      validator: (value){
        if(value!.isEmpty){
          return "$hintText is missing!";
        }
        return null;
      },
    );
  }
}
