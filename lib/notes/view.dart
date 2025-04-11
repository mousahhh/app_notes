import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_12/catogery/add.dart';
import 'package:flutter_application_12/catogery/update.dart';
import 'package:flutter_application_12/homepage.dart';
import 'package:flutter_application_12/notes/add.dart';
import 'package:flutter_application_12/notes/edite.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key, required this.categoryId});
  final categoryId;

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;
  getData() async {
    QuerySnapshot querysnapshot = await FirebaseFirestore.instance
        .collection("catogeris")
        .doc(widget.categoryId)
        .collection("note")
        // .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querysnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Map DA = {
    "name": "MOUSA",
    "age": 44,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNote(idcat: widget.categoryId)));
        },
        child: Icon(Icons.add),
      ),
      body: WillPopScope(
          child: isLoading == true
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                  itemCount: data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, i) {
                    return InkWell(
                      onLongPress: () async {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: 'اختار',
                          desc: 'ماذا تريد ان تفعل ',
                          btnCancelText: "حذف",
                          btnOkText: "تعديل",
                          btnCancelOnPress: () async {
                            await FirebaseFirestore.instance
                                .collection("catogeris")
                                .doc(widget.categoryId)
                                .collection("note")
                                .doc(data[i].id)
                                .delete();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    NoteView(categoryId: widget.categoryId)));
                          },
                          btnOkOnPress: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditeNote(
                                    idcat: widget.categoryId,
                                    idnote: data[i].id,
                                    value: data[i]["note"])));
                          },
                        )..show();
                      },
                      child: Card(
                          child: Container(
                        height: 200,
                        color: Colors.amber,
                        child: Text("${data[i]["note"]}"),
                      )),
                    );
                  }),
          onWillPop: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("HomePage", (route) => false);
            return Future.value(false);
          }),
      appBar: AppBar(
        title: Text("notes"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).restorablePushNamedAndRemoveUntil(
                    "login", (route) => false);
              },
              icon: Icon(Icons.exit_to_app)),
        ],
      ),
    );
  }
}
