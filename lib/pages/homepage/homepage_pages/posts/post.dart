import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/colors.dart';
import 'package:instagram_clone/widgets/insta_button.dart';
import '../../../../widgets/instatext.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: textFieldBackgroundColor,
          title: SizedBox(
            height: AppBar().preferredSize.height * 0.8,
            width: width * 0.3,
            child: Image.asset('assets/images/instagram.png'),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const InstaText(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                text: "Post on Instagram"),
            SizedBox(
              height: height * 0.1,
            ),
            InstaButton(
                postButton: true,
                onPressed: () {},
                text: "Choose Image",
                fontSize: 14,
                textColor: Colors.white,
                fontWeight: FontWeight.w700,
                buttonColor: Colors.black,
                height: height * 0.08)
          ],
        ),
      ),
    );
  }
}
