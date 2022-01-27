import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quranirab/models/option-model.dart';
import 'package:quranirab/quiz_module/quiz_list.dart';
import 'package:quranirab/quiz_module/quiz_model.dart';
import 'package:quranirab/quiz_module/utils/AppColor.java';
import 'package:quranirab/quiz_module/Quiz.Score.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quranirab/quiz_module/words.model.dart';

import '../word-relationship-model.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  _QuizState createState() => _QuizState();

}

class _QuizState extends State<Quiz> {
  int page = 1;
  int count = 0;
  String level = 'beginner';

  List<Words> wordList = [];
  List<String> words = [];
  List<String> wordIds = [];
  List<String> options_malay = [];
  List<Option> options_arabic = [];
  late QuestionModel question;
  bool dataReady = false;
  bool correctAnswer = false;
  //late String question;
  late String selectedOption;
  late QuerySnapshot relations;
  late QuerySnapshot optionTSnap;
  List<WordRelationship> wordRelationships = [];

  final PageController _controller = PageController(initialPage: 0);
  var windowWidth;
  var windowHeight;
  double windowSize = 0;

  int score = 0;
  bool btnPressed = false;
  String btnText = "Next";
  bool answered = false;

  @override
  void initState() {
    generateQuestions();
    super.initState();
  }
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

      body: dataReady? PageView.builder(
        controller: _controller,
        onPageChanged: (page) {
          if (page == wordList.length - 1) {
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
                                  'Ayat',
                                  //ayat_quran[index].toString(),
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
                                  wordList[index].text.toString(),
                                  //word_quran[index].toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    fontFamily: 'MeQuran2',
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
                                height: 40,
                                child: Text(
                                  'Question ' + (index + 1).toString() + ' / ' + wordList.length.toString(),
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
                                height: 40.0,
                                child: Text(
                                  question.translation,
                                  //question_quran[index].toString(),
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
                                  question.question,
                                  //questions[index].question,
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
                                  for (int i = 0; i < options_arabic.length; i++)
                                    Container(
                                      margin:const EdgeInsets.all(3),
                                      child: RawMaterialButton(
                                        shape:RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5)),
                                        elevation: 0.0,
                                        fillColor: btnPressed
                                            ?
                                        correctAnswer ?
                                        options_arabic[i].correct
                                            ? Colors.green
                                            : Colors.red
                                        :Colors.amber
                                            : AppColor.secondaryColor,
                                        onPressed: !answered
                                            ? () {
                                          selectedOption = options_arabic[i].id;
                                          checkAnswer(wordList[index].id.toString(), selectedOption);

                                          /**
                                          if (questions[index]
                                              .answers!
                                              .values
                                              .toList()[i]) {
                                            score++;
                                            print("yes");
                                          } else {
                                            print("no");
                                          }
                                              **/
                                          setState(() {
                                            btnPressed = true;
                                            answered = true;
                                          });
                                        }
                                            : null,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            options_arabic[i].text,
                                            //questions[index].answers!.keys.toList()[i],
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
                      if (_controller.page?.toInt() == wordList.length - 1) {
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
                          correctAnswer = false;
                          for (int i = 0; i < options_arabic.length; i++) {
                            options_arabic[i].correct =false;
                          }
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
      ):
      Center(
        child: SizedBox(
          child: CircularProgressIndicator(),
          width: 50,
          height: 50,

        ),
      ),
    );
  }


  Future<void> getQuestion() async {
    QuerySnapshot questions = await FirebaseFirestore.instance
        .collection('quiz_type')
        .where('level', isEqualTo: level).get();

    if(level =='beginner') {
      question = QuestionModel(
        question: questions.docs[0].get('question').toString(),
        translation: questions.docs[0].get('translation').toString()
      );

      //print(question);
    } else {
      print('else');
    }


  }

  Future<List<dynamic>> getWords() async {
    QuerySnapshot wordsQuerySnapshot = await FirebaseFirestore.instance
        .collection('words').
    where('medina_mushaf_page_id', isEqualTo: page.toString()).get();

    //print(wordsQuerySnapshot.docs.length);
    for(int i =0; i< wordsQuerySnapshot.docs.length; i++) {
      wordList.add(
          Words.fromWords(id: wordsQuerySnapshot.docs[i].get('id').toString(),
              text: wordsQuerySnapshot.docs[i].get('text').toString()
          )
      );

      //wordIds.add(wordsQuerySnapshot.docs[i].get('id').toString());
      //words.add(wordsQuerySnapshot.docs[i].get('text').toString()) ;



    }

    return words.map((e) => e).toList();



  }

  Future<List<dynamic>> getRelationships() async {
    /*
     relations = await FirebaseFirestore.instance
         .collection('word_relationships').
     where('word_id', isEqualTo: wordId).get();

     for(int i = 0; i < relations.docs.length; i++) {
       wordRelationships.add(
           WordRelationship(
               wordId: relations.docs[i].get('word_id'),
               relationship: relations.docs[i].get('word_category_id'))
       );
      //print('relationships found..');
      // print(wordRelationships[i].relationship);
     }

      */


    //get all relationships for the word
    for(int i =0; i< wordList.length; i++) {
      //print(wordList[i].id);

      relations = await FirebaseFirestore.instance
          .collection('word_relationships').
      where('word_id', isEqualTo: wordList[i].id).get();

      for (int j=0; j< relations.docs.length; j++) {
        wordRelationships.add(
            WordRelationship(
                wordId: relations.docs[j].get('word_id'),
                relationship: relations.docs[j].get('word_category_id'))
        );

      }



    }



    //print(wordRelationships[0].wordId);

    return  Future.delayed(Duration(seconds: 1),
            () => wordRelationships.map((e) => e).toList());
  }

  Future<List<dynamic>> getNonTranslatedOptions() async {
    //get the options untranslated
    QuerySnapshot optionSnap = await FirebaseFirestore.instance
        .collection('word_categories').
    where('word_type', isEqualTo: 'main').get();

    for(int i =0; i< optionSnap.docs.length; i++) {
      options_malay.add(optionSnap.docs[i].get('id').toString());
      //print(options_malay[i]);

      //print(wordsQuerySnapshot.docs[i].get('id').toString());
    }


    return  options_malay.map((e) => e).toList();
  }

  Future<List<dynamic>> getTranslatedOptions() async {

    optionTSnap = await FirebaseFirestore.instance
        .collection('category_translations').get();


    for (int i = 0 ; i < options_malay.length; i ++) {
      for (int j = 0; j < optionTSnap.docs.length; j ++) {
        if(optionTSnap.docs[j].id ==
            options_malay[i]) {
          options_arabic.add(
              Option(
                  id: optionTSnap.docs[j].id,
                  text: optionTSnap.docs[j].get('name'))
          );

        }
      }
    }

    return options_arabic.map((e) => e).toList();
  }


  void generateQuestions() async {
    await getWords();
    await getQuestion();
    await getRelationships();
    await getNonTranslatedOptions();
    await getTranslatedOptions();

    setState(() {
      dataReady = true;
    });

  }

  void checkAnswer(String wordId, String selectedOption) async {



    for(int i = 0; i < wordRelationships.length; i++) {

      if(wordId == wordRelationships[i].wordId
          &&  wordRelationships[i].relationship == selectedOption) {
        correctAnswer = true;
        print('Correct Answer');

        for (int j = 0; j < options_arabic.length; j++) {
          if(options_arabic[j].id == selectedOption) {
            options_arabic[j].correct = true;
          }
        }

      }
    }
  }


}




