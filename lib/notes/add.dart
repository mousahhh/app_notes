import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_12/compennents/custombuttonauth.dart';
import 'package:flutter_application_12/compennents/textformfild.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_12/notes/view.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key, required this.idcat});
  final String idcat;
  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  @override
  var isloading = false;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  addNote() async {
    try {
      CollectionReference catogeris = FirebaseFirestore.instance
          .collection("catogeris")
          .doc(widget.idcat)
          .collection("note");
      if (formstate.currentState!.validate()) {
        isloading = true;
        DocumentReference response = await catogeris.add({
          "note": note.text,
          "age": 12,
          //  "Id": FirebaseAuth.instance.currentUser!.uid
        });
        isloading = false;
      }
    } catch (r) {
      isloading = false;
      print("error $r");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add note"),
      ),
      body: Form(
          key: formstate,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: customtextform(
                  texthint: "enter your note",
                  mycontrol: note,
                  validator: (val) {
                    if (val == "") {
                      return "cant text empty";
                    }
                  },
                ),
              ),
              MaterialButton(
                onPressed: () {
                  addNote();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          NoteView(categoryId: widget.idcat)));
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
