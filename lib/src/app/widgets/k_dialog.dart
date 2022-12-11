import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/widgets/k_button.dart';

class KDialog extends StatelessWidget {
  final String header;
  final String? imagePath;
  final String content;
  final String? button1Text;
  final String? button2Text;
  const KDialog({
    required this.header,
    this.imagePath,
    required this.content,
    this.button1Text,
    this.button2Text,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      child: Container(
        width: size.width * 0.63,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Text(
              header,
              style: k12w700MontsBlackBottomHeader(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            if (imagePath != null)
              SvgPicture.asset(
                imagePath!,
                height: size.height * 0.175,
              ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: k10w400AxiBlackBottomText(),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                if (button1Text != null)
                  KButton(
                    width: button2Text == null
                        ? size.width * 0.7
                        : size.width * 0.7 / 2,
                    mainText: button1Text!,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    borderRadiusBottomLeft: 14,
                    borderRadiusTopLeft: 0,
                    borderRadiusTopRight: 0,
                    borderRadiusBottomRight: button2Text == null ? 14 : 0,
                    height: 44,
                  ),
                if (button2Text != null)
                  KButton(
                    width: button2Text == null
                        ? size.width * 0.7
                        : size.width * 0.7 / 2,
                    mainText: button2Text!,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    bgColor: kDisabled,
                    borderRadiusBottomLeft: 0,
                    borderRadiusTopLeft: 0,
                    borderRadiusTopRight: 0,
                    borderRadiusBottomRight: 14,
                    height: 44,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
