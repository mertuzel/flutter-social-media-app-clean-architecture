import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friend_zone/src/app/constants/constants.dart';
import 'package:friend_zone/src/app/widgets/k_button.dart';
import 'package:friend_zone/src/app/widgets/k_textformfield.dart';
import 'package:friend_zone/src/data/helpers/validator_helper.dart';

class AddCommentWidget extends StatefulWidget {
  @override
  State<AddCommentWidget> createState() => _AddCommentToProductDialogState();
}

class _AddCommentToProductDialogState extends State<AddCommentWidget> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 50),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.topRight,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Navigator.of(context).pop(null),
                child: Container(
                  width: 12,
                  height: 12,
                  child: SvgPicture.asset(
                    'assets/icons/svg/close.svg',
                    color: kBlack,
                  ),
                ),
              ),
            ),
            KTextFormField(
              onChanged: (value) {
                setState(() {
                  text = value;
                });
              },
              mainText: 'Your Comment',
              mainTextColor: kBlack,
              contentTextColor: kBlack,
              hintText: '',
              maxLength: 150,
              keyboardType: TextInputType.text,
              validator: ValidatorHelper.kNameValidator,
              nullAutoValidateMode: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              minLines: 9,
              maxLines: 11,
            ),
            SizedBox(height: 20),
            KButton(
              mainText: 'Add',
              onPressed: () {
                if (text.length >= 2) {
                  Navigator.of(context).pop(text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
