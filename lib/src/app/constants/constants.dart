import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friend_zone/src/app/constants/texts.dart';
import 'package:friend_zone/src/app/widgets/k_dialog.dart';

const kPrimary = Color(0xFF05204A);
const kSecondary = Color(0xFF136F63);
const kBackground = Color(0xFFF9F9F9);
const kWhite = Color(0xFFFFFFFF);
const kBlack = Color(0xFF000000);

const kDot = Color(0xFFacacac);
const kRed = Colors.red;
const kDisabled = Color(0xFFcbcbcb);
const kGrey = Color(0xFFf8f8f8);

const Duration pageTransitionDuration = Duration(milliseconds: 235);
const HitTestBehavior hitTestBehavior = HitTestBehavior.translucent;
const ScrollPhysics kPhysics = AlwaysScrollableScrollPhysics(
  parent: BouncingScrollPhysics(),
);

LinearGradient get kLinearGradient {
  return const LinearGradient(
    colors: [
      const Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      const Color(0xFFEBEBF4),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );
}

//Vibration
Future<void> kVibrateLight() async => await HapticFeedback.lightImpact();
List<BoxShadow> kBoxShadow = [
  BoxShadow(
    blurRadius: 11,
    offset: Offset(-0, -2),
    color: Colors.black.withOpacity(0.09),
  ),
];

TextStyle k26w400AxiVermillionTimerText({Color color = kRed}) {
  return TextStyle(
    color: color,
    fontWeight: FontWeight.w400,
    fontFamily: "Axiforma",
    fontStyle: FontStyle.normal,
    fontSize: 26.0,
  );
}

TextStyle k20w900AxiWhiteHeader({
  Color color = kWhite,
  double? lineHeight = 20,
}) {
  return TextStyle(
    color: color,
    fontWeight: FontWeight.w900,
    fontFamily: "Axiforma",
    fontStyle: FontStyle.normal,
    height: lineHeight == null ? null : lineHeight / 20,
    fontSize: 20.0,
  );
}

TextStyle k16w400AxiBlackText({Color color = kBlack}) {
  return TextStyle(
    color: color,
    fontWeight: FontWeight.w400,
    fontFamily: "Axiforma",
    fontStyle: FontStyle.normal,
    fontSize: 16.0,
  );
}

TextStyle k16w600AxiBlackText({Color color = kBlack}) {
  return TextStyle(
    color: color,
    fontWeight: FontWeight.w600,
    fontFamily: "Axiforma",
    fontStyle: FontStyle.normal,
    fontSize: 16.0,
  );
}

TextStyle k14w500AxiBlackButtonText({Color color = kBlack}) {
  return TextStyle(
      color: color,
      fontWeight: FontWeight.w500,
      fontFamily: "Axiforma",
      fontStyle: FontStyle.normal,
      fontSize: 14.0);
}

TextStyle k14w700AxiBlackUnderlinedText({
  Color color = kBlack,
  TextDecoration textDecoration = TextDecoration.none,
  bool nullHeight = false,
}) {
  return TextStyle(
    color: color,
    fontWeight: FontWeight.w700,
    fontFamily: "Axiforma",
    fontStyle: FontStyle.normal,
    fontSize: 14.0,
    height: nullHeight ? null : 20 / 14,
    decoration: textDecoration,
  );
}

TextStyle k14w400AxiBlackGeneralText({
  Color color = kBlack,
  bool nullHeight = false,
}) {
  return TextStyle(
    color: color,
    fontWeight: FontWeight.w400,
    fontFamily: "Axiforma",
    fontStyle: FontStyle.normal,
    fontSize: 14.0,
    height: nullHeight ? 1.1 : 20 / 14,
  );
}

TextStyle k14w600ProxWhiteButtonText({Color color = kWhite}) {
  return TextStyle(
      color: color,
      fontWeight: FontWeight.w600,
      fontFamily: "ProximaNova",
      fontStyle: FontStyle.normal,
      fontSize: 14.0);
}

TextStyle k13w700AxiBerryHomeContentText({Color color = kSecondary}) {
  return TextStyle(
      color: color,
      fontWeight: FontWeight.w700,
      fontFamily: "Axiforma",
      fontStyle: FontStyle.normal,
      fontSize: 13.0);
}

TextStyle k13w300AxiWhiteProfileHeaderText({Color color = kWhite}) {
  return TextStyle(
      color: color,
      fontWeight: FontWeight.w300,
      fontFamily: "Axiforma",
      fontStyle: FontStyle.normal,
      fontSize: 13.0);
}

TextStyle k12w800MontsBerryShoppingHistoryMontsText(
    {Color color = kSecondary}) {
  return TextStyle(
      color: color,
      fontWeight: FontWeight.w800,
      fontFamily: "Montserrat",
      fontStyle: FontStyle.normal,
      fontSize: 12.0);
}

TextStyle k12w700MontsBlackBottomHeader({Color color = kBlack}) {
  return TextStyle(
    color: color,
    fontWeight: FontWeight.w700,
    fontFamily: "Montserrat",
    fontStyle: FontStyle.normal,
    fontSize: 12.0,
    height: 13 / 12,
  );
}

TextStyle k12w400AxiBlackLoading(
    {Color color = kBlack, bool isUnderline = false}) {
  return TextStyle(
    color: color,
    fontWeight: FontWeight.w400,
    fontFamily: "Axiforma",
    fontStyle: FontStyle.normal,
    fontSize: 12.0,
    decoration: !isUnderline ? TextDecoration.none : TextDecoration.underline,
  );
}

TextStyle k10w400AxiBlackBottomText({
  Color color = kBlack,
  bool isUnderLine = false,
  int lineHeight = 14,
}) {
  return TextStyle(
      color: color,
      fontWeight: FontWeight.w400,
      fontFamily: "Axiforma",
      fontStyle: FontStyle.normal,
      fontSize: 10.0,
      height: lineHeight / 10,
      decoration: isUnderLine ? TextDecoration.underline : TextDecoration.none);
}

TextStyle k10w300AxiBerryHomeShoppingHistoryContentText(
    {Color color = kSecondary}) {
  return TextStyle(
      color: color,
      fontWeight: FontWeight.w300,
      fontFamily: "Axiforma",
      fontStyle: FontStyle.normal,
      fontSize: 10.0);
}

// END OF TEXTSTYLES
Future<void> kShowGenericErrorDialog(BuildContext context,
    {String? content}) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => KDialog(
      header: DefaultTexts.genericErrorHeader,
      imagePath: 'assets/images/svg/dialog-generic-error.svg',
      content: content ?? DefaultTexts.genericErrorContent,
      button1Text: DefaultTexts.okay,
    ),
  );
}

CircularProgressIndicator kCircularProgressIndicator(
    {Color color = kSecondary}) {
  return CircularProgressIndicator(
    color: color,
  );
}
