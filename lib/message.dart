import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_12/catogery/add.dart';
import 'package:flutter_application_12/catogery/update.dart';
import 'package:flutter_application_12/notes/view.dart';

class TokenMessag extends StatefulWidget {
  const TokenMessag({super.key});

  @override
  State<TokenMessag> createState() => _TokenMessagState();
}

class _TokenMessagState extends State<TokenMessag> {
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

  requistPermision() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  getToken() async {
    String? mytoken = await FirebaseMessaging.instance.getToken();
    print("++++++++++++++++++++++++++");
    print(mytoken);
  }

  @override
  void initState() {
    super.initState();
    getToken();
    requistPermision();
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
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
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
        title: Text("user"),
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
