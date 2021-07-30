import 'package:flutter/material.dart';
import 'package:lobardestination/pallete.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    Key key,
    @required this.icon,
    @required this.hint,
    @required this.validate,
    this.inputAction,
    this.inputType,
    this.onSaved,
    this.controller,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputAction inputAction;
  final TextInputType inputType;
  final validate;
  final onSaved;
  final controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Container(
        height: size.height * 0.08,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.grey[500].withOpacity(0.5),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Center(
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(
                  icon,
                  size: 20,
                  color: kWhite,
                ),
              ),
              hintText: hint,
              hintStyle: kBodyText,
            ),
            obscureText: true,
            style: kBodyText,
            keyboardType: inputType,
            textInputAction: inputAction,
            validator: validate,
            onSaved: onSaved,
            controller: controller,
          ),
        ),
      ),
    );
  }
}
