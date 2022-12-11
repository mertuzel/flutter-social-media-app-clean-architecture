import 'package:flutter/material.dart';
import 'package:friend_zone/src/app/constants/constants.dart';

class KTextButton extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Function() onPressed;
  const KTextButton({
    Key? key,
    required this.text,
    this.textStyle = const TextStyle(
      color: kBlack,
      fontWeight: FontWeight.w400,
      fontFamily: "Axiforma",
      fontStyle: FontStyle.normal,
      fontSize: 12.0,
    ),
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.resolveWith(
          (states) => const Size(0, 0),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: MaterialStateProperty.resolveWith(
          (states) => EdgeInsets.zero,
        ),
        overlayColor: MaterialStateProperty.resolveWith(
          (states) => Colors.transparent,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
