import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_12/compennents/custombuttonauth.dart';
import 'package:flutter_application_12/compennents/textformfild.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_12/notes/view.dart';

class EditeNote extends StatefulWidget {
  const EditeNote(
      {super.key,
      required this.idcat,
      required this.idnote,
      required this.value});
  final String idcat;
  final String idnote;
  final String value;
  @override
  State<EditeNote> createState() => _EditeNoteState();
}

class _EditeNoteState extends State<EditeNote> {
  @override
  var isloading = false;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  EditeNote() async {
    try {
      CollectionReference catogeris = FirebaseFirestore.instance
          .collection("catogeris")
          .doc(widget.idcat)
          .collection("note");
      if (formstate.currentState!.validate()) {
        isloading = true;
        await catogeris.doc(widget.idnote).update({
          "note": note.text,

          // "Id": FirebaseAuth.instance.currentUser!.uid
        });
        isloading = false;
      }
    } catch (r) {
      isloading = false;
      print("error $r");
    }
  }

  @override
  void initState() {
    note.text = widget.value;
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edite note"),
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
                  EditeNote();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          NoteView(categoryId: widget.idcat)));
                },
                child: Text("Edite"),
                textColor: Colors.white,
                color: Colors.amberAccent,
              )
            ],
          )),
    );
  }
}
