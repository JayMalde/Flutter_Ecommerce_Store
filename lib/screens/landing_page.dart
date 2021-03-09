import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:store/screens/login_page.dart';

import '../constants.dart';
import 'home_page.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        //If snapshot has error
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }
        //Connection Initialized - Firebase App is Running
        if (snapshot.connectionState == ConnectionState.done) {
          //StreamBuilder can check the login state live
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${streamSnapshot.error}"),
                  ),
                );
              }
              //Connection State Active - Do the user login check inside the if statement
              if (streamSnapshot.connectionState == ConnectionState.active) {
                //Get The User
                User _user = streamSnapshot.data;
                //If null
                if (_user == null) {
                  return LoginPage();
                } else {
                  return HomePage();
                }
              }
              //Checking the Auth State
              return Scaffold(
                body: Center(
                  child: Text("Checking Authentication...",
                      style: Constants.regularHeading),
                ),
              );
            },
          );
        }
        // Connecting to Firebase - loading
        return Scaffold(
          body: Center(
            child: Text("Initializing App...", style: Constants.regularHeading),
          ),
        );
      },
    );
  }
}
