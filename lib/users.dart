import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_12/catogery/add.dart';
import 'package:flutter_application_12/catogery/update.dart';
import 'package:flutter_application_12/notes/view.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  @override
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;
  getUsers() async {
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    QuerySnapshot snapshot =
        await users.orderBy("age", descending: false).startAfter([28]).get();
    snapshot.docs.forEach((element) {
      data.add(element);
    });

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      if (remoteMessage.notification != null) {
        print("++++++++++++++++++++++++++++++++++++++++");
        print(remoteMessage.notification!.title);
        print(remoteMessage.notification!.body);
      }
    });
  }

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addcatogery");
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, i) {
                  return InkWell(
                    child: Card(
                      child: ListTile(
                        subtitle: Text("${snapshot.data!.docs[i]["age"]}"),
                        title: Text("${snapshot.data!.docs[i]["username"]}"),
                      ),
                    ),
                  );
                });
          }),
      appBar: AppBar(
        title: const Text("user"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).restorablePushNamedAndRemoveUntil(
                    "login", (route) => false);
              },
              icon: const Icon(Icons.exit_to_app)),
        ],
      ),
    );
  }
}
