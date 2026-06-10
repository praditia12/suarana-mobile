import 'package:flutter/material.dart';

import 'app_text_field.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<PasswordField> createState() =>
      _PasswordFieldState();
}

class _PasswordFieldState
    extends State<PasswordField> {

  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      hintText: "Masukkan Kata Sandi",
      obscureText: isHidden,
      suffixIcon: IconButton(
        icon: Icon(
          isHidden
              ? Icons.visibility_off
              : Icons.visibility,
        ),
        onPressed: () {
          setState(() {
            isHidden = !isHidden;
          });
        },
      ),
    );
  }
}