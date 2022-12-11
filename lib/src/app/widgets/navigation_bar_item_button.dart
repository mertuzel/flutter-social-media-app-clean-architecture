import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friend_zone/src/app/constants/constants.dart';

class NavigationBarItemButton extends StatelessWidget {
  final String iconPath;
  final String text;
  final Function(int index) onPressed;
  final int index;
  final bool isSelected;
  final double width;

  NavigationBarItemButton({
    required this.iconPath,
    required this.text,
    required this.onPressed,
    required this.index,
    required this.isSelected,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isSelected ? kPrimary : kDot.withOpacity(0.8);
    return Container(
      width: width,
      height: 75,
      child: TextButton(
        style: ButtonStyle(
          overlayColor:
              MaterialStateColor.resolveWith((_) => Colors.transparent),
        ),
        onPressed: () => onPressed(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 20,
              child: SvgPicture.asset(
                'assets/icons/svg/$iconPath',
                color: color,
              ),
            ),
            SizedBox(height: 5),
            Text(
              text,
              style: k14w500AxiBlackButtonText(
                color: isSelected ? kPrimary : kDot.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
