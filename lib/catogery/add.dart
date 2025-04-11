import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_12/compennents/custombuttonauth.dart';
import 'package:flutter_application_12/compennents/textformfild.dart';
import 'package:firebase_core/firebase_core.dart';

class addcatogery extends StatefulWidget {
  const addcatogery({super.key});

  @override
  State<addcatogery> createState() => _addcatogeryState();
}

var isloading = false;
GlobalKey<FormState> formstate = GlobalKey<FormState>();
TextEditingController name = TextEditingController();
CollectionReference catogeris =
    FirebaseFirestore.instance.collection('catogeris');
addCatogery() async {
  try {
    if (formstate.currentState!.validate()) {
      isloading = true;
      DocumentReference response = await catogeris.add(
          {"name": name.text, "id": FirebaseAuth.instance.currentUser!.uid});
      isloading = false;
    }
  } catch (r) {
    isloading = false;
    print("error $r");
  }
}

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

class _addcatogeryState extends State<addcatogery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Catogery"),
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
                  addCatogery();
                  name.clear();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("HomePage", (Route) => false);
                },
                child: Text("add"),
                textColor: Colors.white,
                color: Colors.amberAccent,
              )
            ],
          )),
    );
  }
}
