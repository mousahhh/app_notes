import "package:awesome_dialog/awesome_dialog.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_application_12/compennents/custombuttonauth.dart";
import "package:flutter_application_12/compennents/custommlogouath.dart";
import "package:flutter_application_12/compennents/textformfild.dart";
import "package:google_sign_in/google_sign_in.dart";

class login extends StatefulWidget {
  @override
  State<login> createState() {
    return _loginState();
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class _loginState extends State<login> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var children2 = [
      Container(
        margin: EdgeInsets.only(left: 5),
        child: Text(
          "Login",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 3,
      ),
      Container(
          margin: EdgeInsets.only(left: 5),
          child: Text("login to continu using app")),
      SizedBox(
        height: 30,
      ),
      Container(
        margin: EdgeInsets.only(left: 5),
        child: Text(
          "Email",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
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
      SizedBox(
        height: 30,
      ),
      Container(
        margin: EdgeInsets.only(left: 5),
        child: Text(
          "password",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
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
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [Text("forgat password?")],
      ),
      SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              customButtonAuth(
                title: "Login",
                onPressed: ()async{
                  if (formstate.currentState!.validate()) {
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email.text, password: password.text);
                      if (credential.user!.emailVerified) {
                        Navigator.of(context).pushReplacementNamed("HomePage");
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'error',
                          desc: 'قم بتوجه الى بريد الالكتروني ',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {},
                        )..show();
                      }
                    } on FirebaseAuthException catch (e) {
                      String errorMessage;
                      if (e.code == 'user-not-found') {
                        errorMessage = 'No user found for that email.';
                      } else if (e.code == 'wrong-password') {
                        errorMessage = 'Wrong password provided for that user.';
                      } else {
                        errorMessage =
                            'An unexpected error occurred. Please try again later.';
                      }
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Login Error'),
                            content: Text(errorMessage),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    print("no valid");
                  }
                  ;
                },
              ),
              MaterialButton(
                padding:
                    EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 10),
                onPressed: () {
                  signInWithGoogle();
                },
                child: Row(
                  children: [
                    Text(
                      "Login With Google",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Container(
                      child: Image.network(
                          width: 30,
                          "https://th.bing.com/th/id/OIP.TbiBtvD2jY4eLAJjU0Z4FAAAAA?w=256&h=256&rs=1&pid=ImgDetMain"),
                    ),
                  ],
                ),
                color: Color.fromARGB(255, 28, 95, 189),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textColor: Colors.white,
              ),
            ],
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("dont Have Acount? "),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed("SignUp");
            },
            child: Text(
              "Register",
              style: TextStyle(color: Colors.amber),
            ),
          ),
        ],
      )
    ];
    return Scaffold(
        body: Container(
            child: ListView(
      children: [
        Column(
          children: [customLogoAuth()],
        ),
        SizedBox(
          height: 15,
        ),
        Form(
          key: formstate,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children2,
            ),
          ),
        )
      ],
    )));
  }
}
