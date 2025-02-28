import 'package:flutter/material.dart';
import 'package:client_1/utils/const/color.dart';
import 'package:client_1/utils/const/size.dart';



class QuickAction extends StatelessWidget {

  const QuickAction({
    super.key,
    this.width = 120,
    this.height,
    this.padding = const EdgeInsets.all(8),
    this.onPressed,
    this.applyImageRadius = false,
    this.fit = BoxFit.contain,
    this.backgroundColor = CusColor.buttonPrimaryColor,
    required this.maintext,
    required this.secondtext,
    required this.icon
  });

  final double? width, height;
  final bool applyImageRadius;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final String maintext;
  final String secondtext;
  final Image icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 0.5),
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(height: 10),
            Text(maintext, style: TextStyle(fontSize: CusSize.fontSizeMd, fontWeight: FontWeight.bold)),
            Text(secondtext, style: TextStyle(fontSize: CusSize.fontSizeSm, fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }
}