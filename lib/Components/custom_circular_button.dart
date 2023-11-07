import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/Theme/colors.dart';

class CustomButton extends StatelessWidget {
  final Widget? title;
  final String? btnTxt;
  final Icon? leading;
  final Icon? action;
  final Function()? onTap;
  final EdgeInsets? padding;
  final Color? bgColor;
  final EdgeInsets? margin;
  final double? borderRadius;
  final double? height;
  final double? width;
  final MainAxisSize btnTxtAxisSize;
  final Widget? btnChild;
  final bool isBtnRounded;

  CustomButton(
      {Key? key,
      this.title,
      this.btnTxt,
      this.leading,
      this.onTap,
      this.padding,
      this.bgColor,
      this.margin,
      this.borderRadius,
      this.height,
      this.width,
      this.btnTxtAxisSize = MainAxisSize.max,
      this.btnChild,
        this.action,
      this.isBtnRounded = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor:
              bgColor == null ? Theme.of(context).colorScheme.primary : bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? (isBtnRounded ? 50 : 15),
            ),
          ),
        ),
        onPressed: onTap,
        child: btnChild ??
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: btnTxtAxisSize,
              children: [
                leading == null ? SizedBox.shrink() : leading!,
                title ??
                    Text(btnTxt ?? 'submit'.tr,
                        style: TextStyle(color: Colors.white)),
                action == null ? SizedBox.shrink() : action!
              ],
            ),
      ),
    );
  }
}
