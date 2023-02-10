import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Widget logoutButton() {
  return const IconButton(onPressed: signOut, icon: Icon(Icons.logout));
}

void signOut() async {
  await FacebookAuth.instance.logOut();
  await GoogleSignIn().signOut();
}
