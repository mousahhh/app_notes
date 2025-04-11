import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_12/compennents/custombuttonauth.dart';
import 'package:flutter_application_12/compennents/textformfild.dart';
import 'package:firebase_core/firebase_core.dart';

class updatecatogery extends StatefulWidget {
  const updatecatogery({super.key, required this.decid, required this.oldname});
  final String decid;
  final String oldname;
  @override
  State<updatecatogery> createState() => _addcatogeryState();
}

@override
var isloading = false;
GlobalKey<FormState> formstate = GlobalKey<FormState>();
TextEditingController name = TextEditingController();
CollectionReference catogeris =
    FirebaseFirestore.instance.collection('catogeris');

Future<void> addUser() {
  // Call the user's CollectionReference to add a new user
  return catogeris
      .add({
        'full_name': name.text, // John Doe
        // 42
      })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}

class _addcatogeryState extends State<updatecatogery> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = widget.oldname;
  }

  editcatogery() async {
    try {
      if (formstate.currentState!.validate()) {
        isloading = true;

        await catogeris.doc(widget.decid).update({"name": name.text});
      }
    } catch (r) {
      isloading = false;
      print("error $r");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("update Catogery"),
      ),
      body: Form(
          key: formstate,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: customtextform(
                  texthint: "enter your name",
                  mycontrol: name,
                  validator: (val) {
                    if (val == "") {
                      return "cant text empty";
                    }
                  },
                ),
              ),
              MaterialButton(
                onPressed: () {
                  editcatogery();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("HomePage", (Route) => false);
                },
                child: Text("save"),
                textColor: Colors.white,
                color: Colors.amberAccent,
              )
            ],
          )),
    );
  }
}
