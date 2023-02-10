import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await _googleSignIn.currentUser!.authentication;
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/accounts/register/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": _googleSignIn.currentUser!.displayName,
          "email": _googleSignIn.currentUser!.email,
          "password": googleAuth.idToken,
        }),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 201) {
        // Store the token for future requests
        print(responseData);
      } else {
        throw Exception('Failed to register user.');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: const Icon(Icons.ads_click),
        onPressed: _handleSignIn,
      ),
    );
  }
}
