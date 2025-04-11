import 'package:flutter/material.dart';

class customtextform extends StatelessWidget {
  const customtextform(
      {super.key,
      required this.texthint,
      required this.mycontrol,
      required this.validator});
  final String texthint;
  final TextEditingController mycontrol;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: validator,
        controller: mycontrol,
        decoration: InputDecoration(
          hintText: texthint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          prefixIcon: Icon(Icons.email),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ));
  }
}
