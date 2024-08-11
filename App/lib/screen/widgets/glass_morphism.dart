import 'dart:ui';

import 'package:home_iot_device/constants/app_colors.dart';
import 'package:flutter/material.dart';

class GlassMorphism extends StatelessWidget {
  const GlassMorphism({super.key, required this.child});
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.fgColor.withOpacity(.9),
                AppColor.black.withOpacity(.5),
                AppColor.fgColor.withOpacity(.5)
              ],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: child,
        ),
      ),
    );
  }
  

}