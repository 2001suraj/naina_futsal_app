import 'package:flutter/material.dart';
import 'package:futsal_app/widgets/texts.dart';

showsnackBar({
  required BuildContext context,
  required String text,
  required Color color,
  Color? textColor,
  double? fsize,
  Widget? icon,
  double? width,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // width: width ?? MediaQuery.of(context).size.width / 2,
      content: Container(
        color: color,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: texts(
         text: text,

        ),
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
