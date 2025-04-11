import "dart:io";

import "package:awesome_dialog/awesome_dialog.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_application_12/compennents/custombuttonauth.dart";
import "package:flutter_application_12/compennents/custommlogouath.dart";
import "package:flutter_application_12/compennents/textformfild.dart";

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() {
    return _loginState();
  }
}

class _loginState extends State<SignUp> {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: ListView(
      children: [
        const Column(
          children: [customLogoAuth()],
        ),
        const SizedBox(
          height: 15,
        ),
        Form(
          key: formstate,
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: const Text(
                    "SignUp",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: const Text("SignUp to continu using app")),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: const Text(
                    "User Name",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                customtextform(
                  texthint: "user Name",
                  mycontrol: name,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "لايكمن ان يكون الحقل فارغ";
                    }
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: const Text(
                    "Email",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                customtextform(
                  texthint: "enter your email",
                  mycontrol: email,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "لايكمن ان يكون الحقل فارغ";
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: const Text(
                    "password",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                customtextform(
                  texthint: "inter your password",
                  mycontrol: password,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "لايكمن ان يكون الحقل فارغ";
                    }
                  },
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text("forgat password?")],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        customButtonAuth(
                            title: "SignUp",
                            onPressed: () async {
                              if (formstate.currentState!.validate()) {
                                try {
                                  final credential = await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: email.text,
                                    password: password.text,
                                  );
                                  FirebaseAuth.instance.currentUser!
                                      .sendEmailVerification();
                                  Navigator.of(context)
                                      .pushReplacementNamed("login");
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    print('The password provided is too weak.');
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.info,
                                      animType: AnimType.rightSlide,
                                      title: 'error',
                                      desc:
                                          'The password provided is too weak.',
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {},
                                    ).show();
                                  } else if (e.code == 'email-already-in-use') {
                                    print(
                                        'The account already exists for that email.');
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.info,
                                      animType: AnimType.rightSlide,
                                      title: 'error',
                                      desc:
                                          'The account already exists for that email.',
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {},
                                    )..show();
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              }
                            }),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Have Acount? "),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed("login");
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Colors.amber),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    )));
  }
}
