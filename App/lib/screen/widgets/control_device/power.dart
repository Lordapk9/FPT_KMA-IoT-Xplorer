import 'package:home_iot_device/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Power extends StatelessWidget {
  final bool isActive;
  final Function(bool) onChanged;
  const Power({super.key, required this.isActive, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Power",
            style: TextStyle(
              fontSize: 20,
              color: AppColor.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text: "Off",
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColor.fgColor,
                    fontWeight: FontWeight.w500,
                    
                  ),
                  children: <TextSpan>[
                    TextSpan(
                          text: '/',
                          style:
                              TextStyle(color: AppColor.black.withOpacity(0.3))),
                      TextSpan(
                        text: 'On',
                        style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : Colors.black.withOpacity(0.3),
                        ),
                      ),
                  ],
                ),
              ),
              Transform.scale(
                alignment: Alignment.center,
                scaleY: 0.8,
                scaleX: 0.85,
                child: CupertinoSwitch(
                  onChanged: onChanged,
                  value: isActive,
                  activeColor: Colors.white.withOpacity(0.5),
                  trackColor: Colors.black.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
}