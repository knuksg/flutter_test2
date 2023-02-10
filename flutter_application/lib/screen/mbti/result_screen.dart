import 'package:flutter/material.dart';
import 'package:flutter_application/model/mbit_question_model.dart';
import 'package:flutter_application/screen/mbti/mbti_screen.dart';
import 'package:http/http.dart' as http;

class ResultScreen extends StatelessWidget {
  List<int> answers;
  List<MbtiQuestion> questions;
  List<String> mbtiCountList = [];
  String mbti = '';
  ResultScreen({super.key, required this.answers, required this.questions});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    for (int i = 0; i < questions.length; i++) {
      mbtiCountList.add(questions[i].answers[answers[i]]);
    }

    Map frequency = {
      'e': 0,
      'i': 0,
      's': 0,
      'n': 0,
      'f': 0,
      't': 0,
      'j': 0,
      'p': 0
    };

    for (var element in mbtiCountList) {
      frequency[element] = frequency[element] + 1;
    }

    if (frequency['e'] > frequency['i']) {
      mbti = '${mbti}e';
    } else {
      mbti = '${mbti}i';
    }
    if (frequency['n'] > frequency['s']) {
      mbti = '${mbti}n';
    } else {
      mbti = '${mbti}s';
    }
    if (frequency['t'] > frequency['f']) {
      mbti = '${mbti}t';
    } else {
      mbti = '${mbti}f';
    }
    if (frequency['j'] > frequency['p']) {
      mbti = '${mbti}j';
    } else {
      mbti = '${mbti}p';
    }

    Future<http.Response> updateMBTI(
        String email, String username, String mbti) async {
      final responce = await http.put(
          Uri.parse("http://10.0.2.2:8000/accounts/$email/"),
          headers: {"Content-Type": "application/json"},
          body:
              '{"email": "$email", "username": "$username", "mbti": "$mbti"}');
      return responce;
    }

    if (mbti.isNotEmpty) {
      print(mbti);
      updateMBTI('ksgyo0121@gmail.com', "test", mbti);
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('My MBTI APP'),
            backgroundColor: Colors.deepPurple,
            leading: Container(),
          ),
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.deepPurple),
                color: Colors.deepPurple,
              ),
              width: width * 0.85,
              height: height * 0.5,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: width * 0.048),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.deepPurple),
                      color: Colors.white,
                    ),
                    width: width * 0.73,
                    height: height * 0.25,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              0, width * 0.048, 0, width * 0.012),
                          child: Text(
                            '수고하셨습니다!',
                            style: TextStyle(
                              fontSize: width * 0.055,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '당신의 MBTI는',
                          style: TextStyle(
                            fontSize: width * 0.048,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Text(
                          mbti,
                          style: TextStyle(
                            fontSize: width * 0.21,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(width * 0.012),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: width * 0.048),
                    child: ButtonTheme(
                      minWidth: width * 0.73,
                      height: height * 0.05,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const MbtiScreen(
                              user: 'test',
                            );
                          }));
                        },
                        child: const Text('홈으로 돌아가기'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
