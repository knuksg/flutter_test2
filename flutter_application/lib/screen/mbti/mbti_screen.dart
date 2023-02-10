import 'package:flutter/material.dart';
import 'package:flutter_application/model/api_adapter.dart';
import 'package:flutter_application/model/mbit_question_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'question_screen.dart';
import '../login/widget/logout_button.dart';

class MbtiScreen extends StatefulWidget {
  final String user;
  const MbtiScreen({super.key, required this.user});

  @override
  _MbtiScreenState createState() => _MbtiScreenState();
}

class _MbtiScreenState extends State<MbtiScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<MbtiQuestion> questions = [];
  bool isLoading = false;

  _fetchQuestions() async {
    setState(() {
      isLoading = true;
    });
    final response =
        await http.get(Uri.parse("http://10.0.2.2:8000/mbti/mbti"));
    if (response.statusCode == 200) {
      setState(() {
        questions = parseMbtiQuestions(utf8.decode(response.bodyBytes));
        isLoading = false;
      });
    } else {
      throw Exception('failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text('My MBTI APP'),
            backgroundColor: Colors.deepPurple,
            leading: Container(),
            actions: [logoutButton()],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(width * 0.024),
              ),
              Text(
                '플러터 MBTI 앱',
                style: TextStyle(
                  fontSize: width * 0.065,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '질문을 보기 전 안내사항입니다.\n${widget.user}님, 꼼꼼히 읽고 대답해주세요.',
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.048),
              ),
              _buildStep(width, '1. 랜덤으로 나오는 질문 3개에 대답해보세요.'),
              _buildStep(width, '2. 질문을 잘 읽고 대답을 고른 뒤\n다음 질문 버튼을 눌러주세요.'),
              _buildStep(width, '3. 당신의 MBTI를 확인해보세요!'),
              Padding(
                padding: EdgeInsets.all(width * 0.048),
              ),
              Container(
                padding: EdgeInsets.only(bottom: width * 0.036),
                child: Center(
                  child: ButtonTheme(
                    minWidth: width * 0.8,
                    height: height * 0.05,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      child: const Text(
                        '지금 질문 보기',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _fetchQuestions().whenComplete(() {
                          return Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuestionScreen(
                                questions: questions,
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(double width, String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        width * 0.048,
        width * 0.024,
        width * 0.048,
        width * 0.024,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.check_box,
            size: width * 0.04,
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.024),
          ),
          Text(title),
        ],
      ),
    );
  }
}
