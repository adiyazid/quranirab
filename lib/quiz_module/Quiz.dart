import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quranirab/quiz_module/quiz_list.dart';
import 'package:quranirab/quiz_module/utils/AppColor.java';
import 'package:quranirab/quiz_module/Quiz.Score.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  _QuizState createState() => _QuizState();

}

class _QuizState extends State<Quiz> {
  final PageController _controller = PageController(initialPage: 0);
  var windowWidth;
  var windowHeight;
  double windowSize = 0;

  int score = 0;
  bool btnPressed = false;
  String btnText = "Next";
  bool answered = false;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery
        .of(context)
        .size
        .width;
    windowHeight = MediaQuery
        .of(context)
        .size
        .height;
    windowSize = min(windowWidth, windowHeight);
    return Scaffold(

      body: PageView.builder(
        controller: _controller,
        onPageChanged: (page) {
          if (page == questions.length - 1) {
            setState(() {
              btnText = "See Results";
            });
          }
          setState(() {
            answered = false;
          });
        },
        itemBuilder: (context, index) {
          return Column(
            children: [
              const SizedBox(
                height: 30.0,
              ),
              Container(
                color: const Color(0xffffb55f),
                padding: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width * 0.7, //0.8
                        height: MediaQuery.of(context).size.height * 0.7,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 3,
                              blurRadius: 9,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20.0,
                            ),
                            Center(
                              child: SizedBox(
                                height: 40.0,
                                child: Text(
                                  ayat_quran[index].toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.black,
                              indent:30.0,
                              endIndent: 30.0,
                            ),
                            Center(
                              child: SizedBox(
                                height: 40.0,
                                child: Text(
                                  word_quran[index].toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.black,
                              indent:30.0,
                              endIndent: 30.0,
                            ),
                            Center(
                              child: SizedBox(
                                height: 40.0,
                                child: Text(
                                  question_quran[index].toString(),
                                  style:const TextStyle(
                                      color: Colors.black,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                child: Text(
                                  questions[index].question,
                                  style:const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50.00,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = 0; i < questions[index].answers!.length; i++)
                                    Container(
                                      margin:const EdgeInsets.all(3),
                                      child: RawMaterialButton(
                                        shape:RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5)),
                                        elevation: 0.0,
                                        fillColor: btnPressed
                                            ? questions[index].answers!.values.toList()[i]
                                            ? Colors.green
                                            : Colors.red
                                            : AppColor.secondaryColor,
                                        onPressed: !answered
                                            ? () {
                                          if (questions[index]
                                              .answers!
                                              .values
                                              .toList()[i]) {
                                            score++;
                                            print("yes");
                                          } else {
                                            print("no");
                                          }
                                          setState(() {
                                            btnPressed = true;
                                            answered = true;
                                          });
                                        }
                                            : null,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(questions[index].answers!.keys.toList()[i],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //below is next button coding
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  RawMaterialButton(

                    onPressed: () {
                      if (_controller.page?.toInt() == questions.length - 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuizScore(score)));
                      } else {
                        _controller.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInExpo);

                        setState(() {
                          btnPressed = false;
                        });
                      } },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    fillColor: Colors.orange[200],
                    padding: const EdgeInsets.all(15.0),
                    elevation: 0.0,
                    child: Text(
                      btnText,
                      style: const TextStyle(color: Colors.black),
                    ),

                  ),
                ],
              ),
            ],

          );
        },
      ),
    );
  }
}