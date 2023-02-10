import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/screen/mbti/mbti_screen.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  @override
  void initState() {
    super.initState();
    _asyncMethod();
  }

  _asyncMethod() async {
    // await FacebookAuth.instance.logOut();
    // await GoogleSignIn().signOut();

    // 로그인 상태 체크, 구글->페이스북 순서대로

    bool isSignedIn = await googleSignIn.isSignedIn();
    if (isSignedIn) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MbtiScreen(
                    user: 'test',
                  )));
    }

    final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MbtiScreen(
                    user: 'test',
                  )));
    }
  }

  void signOut() async {
    await FacebookAuth.instance.logOut();
    await GoogleSignIn().signOut();
  }

  void signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final url = Uri.https('graph.facebook.com', '/v2.12/me', {
        'fields': 'id, email, name',
        'access_token': result.accessToken!.token
      });

      final response = await http.get(url);

      final profileInfo = json.decode(response.body);
      // print(profileInfo.toString());
      // setState(() {
      //   _loginPlatform = LoginPlatform.facebook;
      //   _loginStatus = true;
      //   userName = profileInfo['name'];
      // });
      print(result.accessToken!.userId);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MbtiScreen(
                    user: 'test',
                  )));
    }
  }

  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    Future<http.Response> signInOrSignUp(String email, String username) async {
      final responce = await http.post(
          Uri.parse("http://10.0.2.2:8000/accounts/"),
          headers: {"Content-Type": "application/json"},
          body: '{"email": "$email", "username": "$username"}');
      print(responce);
      return responce;
    }

    if (googleUser != null) {
      await signInOrSignUp(googleUser.email, googleUser.displayName!);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MbtiScreen(
                    user: googleUser.displayName!,
                  )));
    }
  }

  Widget _loginButton(String path, VoidCallback onTap) {
    return Card(
      elevation: 18.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage('assets/images/$path.png'),
        width: 60,
        height: 60,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(35.0),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return ElevatedButton(
      onPressed: signOut,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color(0xff0165E1),
        ),
      ),
      child: const Text('로그아웃'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _loginButton(
          'facebook_logo',
          signInWithFacebook,
        ),
        _loginButton(
          'google_logo',
          signInWithGoogle,
        ),
      ],
    );
  }
}
