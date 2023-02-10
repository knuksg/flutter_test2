import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/model/mbit_question_model.dart';
import 'package:flutter_application/screen/mbti/result_screen.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

class QuestionScreen extends StatefulWidget {
  List<MbtiQuestion> questions;
  QuestionScreen({super.key, required this.questions});
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final List<int> _answers = [-1, -1, -1];
  List<bool> _answerState = [false, false, false, false];
  int _currentIndex = 0;
  final SwiperController _controller = SwiperController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.deepPurple),
            ),
            width: width * 0.85,
            height: height * 0.5,
            child: Swiper(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              loop: false,
              itemCount: widget.questions.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildQuestionCard(
                    widget.questions[index], width, height);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(
      MbtiQuestion question, double width, double height) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, width * 0.024, 0, width * 0.024),
            child: Text(
              'Q${_currentIndex + 1}.',
              style: TextStyle(
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: width * 0.8,
            padding: EdgeInsets.only(top: width * 0.012),
            child: AutoSizeText(
              question.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: width * 0.048,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Column(
            children: _buildCandidates(width, question),
          ),
          Container(
            padding: EdgeInsets.all(width * 0.024),
            child: Center(
              child: ButtonTheme(
                minWidth: width * 0.5,
                height: height * 0.05,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: _answers[_currentIndex] == -1
                      ? null
                      : () {
                          if (_currentIndex == widget.questions.length - 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultScreen(
                                  answers: _answers,
                                  questions: widget.questions,
                                ),
                              ),
                            );
                          } else {
                            _answerState = [false, false, false, false];
                            _currentIndex += 1;
                            _controller.next();
                          }
                        },
                  child: _currentIndex == widget.questions.length - 1
                      ? const Text('결과보기')
                      : const Text('다음질문'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildCandidates(double width, MbtiQuestion question) {
    List<Widget> children = [];
    for (int i = 0; i < 2; i++) {
      // i = 선택지 개수
      children.add(
        CandWidget(
          index: i,
          text: question.candidates[i],
          width: width,
          answerState: _answerState[i],
          tap: () {
            setState(() {
              for (int j = 0; j < 4; j++) {
                if (j == i) {
                  _answerState[j] = true;
                  _answers[_currentIndex] = j;
                } else {
                  _answerState[j] = false;
                }
              }
            });
          },
        ),
      );
      children.add(
        Padding(
          padding: EdgeInsets.all(width * 0.024),
        ),
      );
    }
    return children;
  }
}

class CandWidget extends StatefulWidget {
  VoidCallback tap;
  String text;
  int index;
  double width;
  bool answerState;

  CandWidget({
    super.key,
    required this.tap,
    required this.index,
    required this.width,
    required this.text,
    required this.answerState,
  });
  @override
  _CandWidgetState createState() => _CandWidgetState();
}

class _CandWidgetState extends State<CandWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 0.8,
      height: widget.width * 0.1,
      padding: EdgeInsets.fromLTRB(
        widget.width * 0.048,
        widget.width * 0.024,
        widget.width * 0.048,
        widget.width * 0.024,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.deepPurple),
        color: widget.answerState ? Colors.deepPurple : Colors.white,
      ),
      child: InkWell(
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.width * 0.035,
            color: widget.answerState ? Colors.white : Colors.black,
          ),
        ),
        onTap: () {
          setState(() {
            widget.tap();
            widget.answerState = !widget.answerState;
          });
        },
      ),
    );
  }
}
