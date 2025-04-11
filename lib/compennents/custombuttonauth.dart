import 'package:flutter/material.dart';

class customButtonAuth extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  const customButtonAuth(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        color: Color.fromARGB(255, 28, 95, 189),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textColor: Colors.white,
        padding: EdgeInsets.only(left: 115, right: 115, top: 10, bottom: 10),
        onPressed: onPressed,
        child: Row(children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )
        ]));
  }
}
