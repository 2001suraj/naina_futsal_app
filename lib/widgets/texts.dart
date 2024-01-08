import 'package:flutter/material.dart';
import 'package:futsal_app/const/app_color.dart';

Text texts({required String text, double? size, FontWeight? weight, Color? color, TextAlign? align, String?font}) {
  return Text(
    text,
    textAlign: align ?? TextAlign.start,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
    style: TextStyle(
      color: color ?? AppColor.black,
      fontSize: size ?? 16,
      fontWeight: weight ?? FontWeight.normal,
      fontFamily: font??'Montserrat',
    ),
  );
}
