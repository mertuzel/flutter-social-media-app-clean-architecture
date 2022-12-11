import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friend_zone/src/app/constants/constants.dart';

// ignore: must_be_immutable
class KTextFormField extends StatefulWidget {
  final Function(String value)? validator;
  final Function(String value) onChanged;
  final String mainText;
  final Color mainTextColor;
  final Color contentTextColor;
  final String hintText;
  final int maxLength;
  final int? minLines;
  final int? maxLines;
  final TextInputFormatter? textInputFormatter;
  final TextInputType keyboardType;
  final String? iconPath;
  final bool isSecurityCode;
  final AutovalidateMode autovalidateMode;
  final bool nullAutoValidateMode;
  final TextEditingController? textEditingController;
  final EdgeInsets? padding;

  KTextFormField({
    Key? key,
    this.validator,
    required this.onChanged,
    required this.mainText,
    required this.mainTextColor,
    required this.contentTextColor,
    required this.hintText,
    required this.maxLength,
    this.minLines,
    this.maxLines,
    this.textInputFormatter,
    required this.keyboardType,
    this.iconPath = '',
    this.isSecurityCode = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    required this.nullAutoValidateMode,
    this.textEditingController,
    this.padding,
  }) : super(key: key);

  @override
  State<KTextFormField> createState() =>
      // ignore: no_logic_in_create_state
      _KTextFormFieldState(mainTextColor, contentTextColor, iconPath);
}

class _KTextFormFieldState extends State<KTextFormField> {
  String errorWidget = '';
  Color mainTextColor;
  Color contentTextColor;
  String? iconPath;

  _KTextFormFieldState(
      this.mainTextColor, this.contentTextColor, this.iconPath);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          errorWidget == '' ? widget.mainText : errorWidget,
          style: k10w400AxiBlackBottomText(color: mainTextColor),
        ),
        const SizedBox(height: 6),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            TextFormField(
              controller: widget.textEditingController,
              textAlign:
                  widget.isSecurityCode ? TextAlign.center : TextAlign.start,
              maxLength: widget.maxLength,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              autovalidateMode:
                  widget.nullAutoValidateMode ? null : widget.autovalidateMode,
              style: k12w400AxiBlackLoading(color: contentTextColor),
              onChanged: (value) {
                widget.onChanged(value.trim());
              },
              inputFormatters: widget.textInputFormatter == null
                  ? []
                  : [widget.textInputFormatter!],
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                errorStyle: const TextStyle(height: 0),
                counterText: '',
                fillColor: kWhite,
                filled: true,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: kBlack.withOpacity(0.3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(9),
                  ),
                  borderSide: BorderSide(color: mainTextColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(9),
                  ),
                  borderSide: BorderSide(color: mainTextColor, width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(9),
                  ),
                  borderSide: BorderSide(color: kRed, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(9),
                  ),
                  borderSide: BorderSide(color: kRed, width: 1),
                ),
                contentPadding: widget.padding ??
                    EdgeInsets.only(left: widget.isSecurityCode ? 0 : 27),
              ),
              validator: (value) {
                String? a;
                if (widget.validator != null) {
                  a = widget.validator!(
                    value!.trim(),
                  );
                  if (a != null || widget.mainTextColor == kRed) {
                    Future.delayed(Duration.zero).then((value) => setState(() {
                          if (a != null) errorWidget = a;
                          mainTextColor = kRed;
                          contentTextColor = kRed;
                          iconPath = 'assets/icons/svg/close.svg';
                        }));

                    return '';
                  } else {
                    Future.delayed(Duration.zero).then((value) => setState(() {
                          errorWidget = '';
                          mainTextColor = widget.mainTextColor;
                          contentTextColor = widget.contentTextColor;
                          iconPath = 'assets/icons/svg/correct.svg';
                        }));
                  }
                }
              },
            ),
            if (iconPath != '')
              Positioned(
                right: 17,
                child: SvgPicture.asset(
                  iconPath!,
                  width: 12,
                  height: 12,
                  color: iconPath == 'assets/icons/svg/close.svg' ? kRed : null,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
