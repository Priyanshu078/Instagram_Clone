import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/colors.dart';

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto(
      {super.key,
      required this.height,
      required this.width,
      required this.wantBorder});

  final double height;
  final double width;
  final bool wantBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: wantBorder
            ? Border.all(
                color: profilePhotoBorder,
              )
            : null,
      ),
      child: const CircleAvatar(
        backgroundImage: AssetImage('assets/images/priyanshuphoto.jpg'),
      ),
    );
  }
}
