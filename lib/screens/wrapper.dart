import 'package:assignment_fluter/screens/Authenticate/authenticate.dart';
import 'package:assignment_fluter/screens/Authenticate/register.dart';
import 'package:assignment_fluter/screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Home();
            } else {
              return Authenticate();
            }
          },
        ),
      );
  //return either home or authenticate
  // return Authenticate();

}
