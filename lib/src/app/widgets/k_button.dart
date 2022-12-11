import 'package:flutter/material.dart';
import 'package:friend_zone/src/app/constants/constants.dart';

class KButton extends StatelessWidget {
  final EdgeInsets? buttonMargin;
  final String mainText;
  final TextStyle textStyle;
  final Color bgColor;
  final Color borderColor;
  final double borderWidth;
  final String iconPath;
  final double? width;
  final double? height;
  final Function() onPressed;
  final double borderRadiusTopRight;
  final double borderRadiusTopLeft;
  final double borderRadiusBottomLeft;
  final double borderRadiusBottomRight;
  final Color? iconColor;

  // ignore: use_key_in_widget_constructors
  const KButton({
    this.buttonMargin,
    required this.mainText,
    this.textStyle = const TextStyle(
      color: kWhite,
      fontWeight: FontWeight.w600,
      fontFamily: "ProximaNova",
      fontStyle: FontStyle.normal,
      fontSize: 14.0,
    ),
    required this.onPressed,
    this.bgColor = kPrimary,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.iconPath = '',
    this.width,
    this.height,
    this.borderRadiusBottomRight = 9,
    this.borderRadiusBottomLeft = 9,
    this.borderRadiusTopLeft = 9,
    this.borderRadiusTopRight = 9,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? size.width * 0.76,
        height: height ?? 51,
        margin: buttonMargin,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(borderRadiusBottomLeft),
              bottomRight: Radius.circular(borderRadiusBottomRight),
              topLeft: Radius.circular(borderRadiusTopLeft),
              topRight: Radius.circular(borderRadiusTopRight),
            ),
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            )),
        child: Row(
          mainAxisAlignment: iconPath != ''
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            if (iconPath != '')
              Container(
                width: 22,
                height: 22,
                margin: EdgeInsets.only(
                  left: 30,
                  right:
                      (width == null ? size.width : size.width * 0.76) * 0.07,
                ),
                child: Image.asset(
                  iconPath,
                  color: iconColor,
                ),
              ),
            Text(
              mainText,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
