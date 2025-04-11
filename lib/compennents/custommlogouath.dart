import 'package:flutter/material.dart';

class customLogoAuth extends StatelessWidget {
  const customLogoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: CircleAvatar(
          maxRadius: 50,
          child: Image.network(
              fit: BoxFit.fill,
              "https://static.vecteezy.com/system/resources/previews/017/221/853/original/google-pay-logo-transparent-free-png.png")),
    );
  }
}
