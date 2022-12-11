import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/navigator/navigator.dart';
import 'package:friend_zone/src/app/pages/core/core_view.dart';
import 'package:friend_zone/src/app/widgets/k_dialog.dart';

class KAppBar extends StatelessWidget {
  final String header;
  final bool close;
  final bool back;
  final bool exit;
  final Function()? onPressed;
  const KAppBar({
    Key? key,
    required this.header,
    this.close = false,
    this.back = true,
    this.onPressed,
    this.exit = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;

    return Container(
      width: size.width,
      height: 60 + padding.top,
      child: Container(
        padding: EdgeInsets.only(
          top: padding.top,
          left: 5,
          right: 5,
        ),
        decoration: BoxDecoration(
          color: kWhite,
          boxShadow: kBoxShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith(
                    (_) => Colors.transparent),
                padding: MaterialStateProperty.resolveWith(
                  (_) => EdgeInsets.zero,
                ),
              ),
              child: SvgPicture.asset(
                close
                    ? 'assets/icons/svg/close.svg'
                    : 'assets/icons/svg/arrow_back.svg',
                color: back ? kSecondary : Colors.transparent,
              ),
              onPressed: onPressed != null
                  ? onPressed
                  : !back
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
            ),
            Text(
              header,
              style: k20w900AxiWhiteHeader(
                color: kSecondary,
                lineHeight: 40,
              ),
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith(
                    (_) => Colors.transparent),
                padding: MaterialStateProperty.resolveWith(
                  (_) => EdgeInsets.zero,
                ),
              ),
              child: !exit
                  ? SvgPicture.asset(
                      close
                          ? 'assets/icons/svg/close.svg'
                          : 'assets/icons/svg/arrow_back.svg',
                      color: exit ? kSecondary : Colors.transparent,
                    )
                  : Icon(
                      Icons.exit_to_app_rounded,
                      color: kSecondary,
                    ),
              onPressed: exit
                  ? () async {
                      bool? response = await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => KDialog(
                          header: 'You are leaving the app',
                          imagePath:
                              'assets/images/svg/dialog-generic-error.svg',
                          content: '',
                          button1Text: 'No',
                          button2Text: 'Yes',
                        ),
                      );
                      if (response == null || response) return;

                      await FirebaseAuth.instance.signOut();
                      Future.delayed(Duration.zero).then((value) =>
                          KNavigator.navigateToSplash(CoreViewHolderController()
                              .coreViewHolderContext));
                    }
                  : () {},
            ),
          ],
        ),
      ),
    );
  }
}
