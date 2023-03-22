import 'package:auto_size_text/auto_size_text.dart';
import 'package:birds_learning_network/src/utils/global_constants/colors/colors.dart';
import 'package:birds_learning_network/src/utils/global_constants/styles/home_styles/course_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

mixin ContentWidget on Object implements CourseContentStyle {
  AutoSizeText titleText(String title) {
    return AutoSizeText(
      title,
      maxLines: 2,
      style: CourseContentStyle.titleStyle,
    );
  }

  Text buttonText(String text, Color color) {
    return Text(
      text,
      style: CourseContentStyle.buttonStyle.copyWith(color: color),
    );
  }

  Text titleAmountText(String amount) {
    return Text(
      "NGN$amount",
      style: CourseContentStyle.amountStyle,
    );
  }

  Text bigAmountText(String amount) {
    return Text(
      amount,
      style: CourseContentStyle.bigAmountStyle,
    );
  }

  Row benefitText(String benefit, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: grey100,
        ),
        const SizedBox(width: 10),
        Text(benefit, style: CourseContentStyle.benefitStyle)
      ],
    );
  }

  RichText contentOwnerText(String owner, VoidCallback onClick) {
    return RichText(
        text: TextSpan(
            text: "by  ",
            style: CourseContentStyle.richStyle1,
            children: [
          TextSpan(
              text: owner,
              style: CourseContentStyle.richStyle2,
              recognizer: TapGestureRecognizer()..onTap = onClick),
        ]));
  }

  Text ratingText(String rating) {
    return Text(
      "($rating)",
      style: CourseContentStyle.richStyle1,
    );
  }

  Text headerText(String header) {
    return Text(
      header,
      style: CourseContentStyle.headerStyle,
    );
  }

  Text totalStudentText(dynamic number) {
    return Text(
      "($number) Students",
      style: CourseContentStyle.style,
    );
  }
}
