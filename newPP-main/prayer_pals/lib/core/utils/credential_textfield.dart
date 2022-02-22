import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:prayer_pals/core/utils/size_config.dart';

class CredentialTextfield extends HookWidget {
  final String hintText;
  final bool obscure;
  final TextEditingController controller;
  const CredentialTextfield({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.obscure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal! * 4,
      ),
      decoration: BoxDecoration(
          color: Colors.lightBlueAccent.shade100,
          borderRadius: BorderRadius.circular(32)),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(
          color: Colors.white,
        ),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(18),
        ),
      ),
    );
  }
}
