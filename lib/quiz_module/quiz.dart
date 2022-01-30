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

  int score = 0; //Score were set in Button onpressed
  int totalAnsweredQuestion=0;// were set in button onpressed
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
              SizedBox( //This is Top white Box
                height: 30.0,
                width: double.infinity,
                child: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Total Answered Question
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Text("Total Answered :",
                              style : TextStyle(backgroundColor: AppColor.secondaryColor),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("${index}""/""${questions.length}"),
                          ],
                        ),
                      ),
                      //Total Answered Question
                      Row(
                        children: [
                          Text("Total Answered Correct:",
                            style : TextStyle(backgroundColor: AppColor.secondaryColor),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("$totalAnsweredQuestion""/""${questions.length}"),
                        ],
                      ),
                      //Current Score
                      Row(
                        children: [
                          Text("Current Score:",
                            style : TextStyle(backgroundColor: AppColor.secondaryColor),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("$score""/""${questions.length}"),
                        ],
                      ),
                      //Highest Score
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            Text("Highest Score:",
                              style : TextStyle(backgroundColor: AppColor.secondaryColor),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("$score"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Middle Container
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
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: Ayat[index].ayat_quran.toString(),
                                      ),
                                      TextSpan(
                                        text: Ayat[index].word_ayat.toString(),
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
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
                                  Ayat[index].ayat_quran,
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
                                  style:TextStyle(
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
                                  style:TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50.00,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = 0; i < questions[index].answers!.length; i++)
                                    Container(
                                      margin:EdgeInsets.all(3),
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
                                            score++; //Set Score here
                                            totalAnsweredQuestion++;
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
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(questions[index].answers!.keys.toList()[i],
                                            style: TextStyle(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: RawMaterialButton(
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
                  ),
                  Expanded(child: SizedBox(

                  ),),
                  Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    child: RawMaterialButton(
                      onPressed: (){},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      fillColor: Colors.orange[200],
                      padding: const EdgeInsets.all(15.0),
                      elevation: 0.0,
                      child: const Text("Save",
                        style: TextStyle(color: Colors.black),
                      ),

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