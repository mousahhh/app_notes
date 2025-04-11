import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_12/catogery/add.dart';
import 'package:flutter_application_12/catogery/update.dart';
import 'package:flutter_application_12/notes/view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;
  getData() async {
    QuerySnapshot querysnapshot = await FirebaseFirestore.instance
        .collection("catogeris")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
          Navigator.of(context).pushNamed("addcatogery");
        },
        child: const Icon(Icons.add),
      ),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            NoteView(categoryId: data[i].id)));
                  },
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
                            .doc(data[i].id)
                            .delete();
                        Navigator.of(context).pushReplacementNamed("HomePage");
                      },
                      btnOkOnPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => updatecatogery(
                                decid: data[i].id, oldname: data[i]["name"])));
                      },
                    )..show();
                  },
                  child: Card(
                      child: Container(
                    height: 200,
                    color: Colors.amber,
                    child: Text("${data[i]["name"]}"),
                  )),
                );
              }),
      appBar: AppBar(
        title: Text("HomePage"),
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
