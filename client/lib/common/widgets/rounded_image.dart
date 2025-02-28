import 'package:flutter/material.dart';
import 'package:client_1/utils/const/color.dart';



class RoundedImg extends StatelessWidget {
  const RoundedImg({
    super.key,
    this.border,
    this.width,
    this.height,
    this.padding,
    this.onPressed,
    this.applyImageRadius = false,
    this.fit = BoxFit.fill,
    this.backgroundColor = CusColor.buttonPrimaryColor,
    this.isNetWorkImage = false, 
    required this.imageURL
  });

  final double? width, height;
  final String imageURL;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetWorkImage;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.zero,
          child: Image(fit: fit, image: isNetWorkImage ? NetworkImage(imageURL): AssetImage(imageURL) as ImageProvider)
          ),
      ),
    );
  }
}