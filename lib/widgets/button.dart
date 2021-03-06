import 'package:flutter/material.dart';
import 'package:lobardestination/pallete.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    @required this.buttonName,
    @required this.routeName,
    @required this.onpress,
  }) : super(key: key);

  final String buttonName;
  final String routeName;
  final onpress;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: kBlue,
      ),
      child: FlatButton(
        onPressed: onpress,
        child: Text(
          buttonName,
          style: kBodyText.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
