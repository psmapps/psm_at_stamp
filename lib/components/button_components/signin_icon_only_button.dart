import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

Widget signInIconOnlyButton({
  @required String svgAsset,
  @required Color buttonColor,
  @required Function onPressed,
}) {
  return Expanded(
    child: MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: buttonColor,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: SvgPicture.asset(
          svgAsset,
          height: 30,
        ),
      ),
      onPressed: () {
        HapticFeedback.mediumImpact();
        onPressed();
      },
    ),
  );
}
