import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quranirab/models/words.model.dart';
import 'package:quranirab/quiz_module/models/quiz_model.dart';
import 'package:quranirab/quiz_module/utils/AppColor.java';
import 'package:quranirab/quiz_module/Quiz.Score.dart';
import 'package:intl/intl.dart';
import 'package:quranirab/views/home.page.dart';
import 'models/answer_model.dart';
import 'models/option_model.dart';
import 'models/question_model.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int page = 1;
  int noOfAnswers = 0;

  //int count = 0;
  double progress = 0;
  String level = 'beginner';
  late String quizTypeId;
  List<String> words = [];
  List<String> wordIds = [];
  List<String> options_malay = [];
  List<Words> wordList = [];
  List<Option> options_arabic = [];
  List<WordRelationship> wordRelationships = [];
  List<WordRelationship> answers = [];

  bool dataReady = false;
  bool correctAnswer = false;
  late String quizId;

  late String selectedOption;
  late QuerySnapshot relationshipSnapshot;
  late QuestionModel question;
  late QuerySnapshot optionTSnap;

  final PageController _controller = PageController(initialPage: 0);
  var windowWidth;
  var windowHeight;
  double windowSize = 0;

  int score = 0; //Score were set in Button onpressed
  int totalAnsweredQuestion = 0; // were set in button onpressed
  bool btnPressed = false;
  String btnText = "Next";
  bool answered = false;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Scaffold(
      body: dataReady
          ? PageView.builder(
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
                    SizedBox(
                      //This is Top white Box
                      height: 30.0,
                      width: double.infinity,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Total Answered Question
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "Total Answered :",
                                    style: TextStyle(
                                        backgroundColor:
                                            AppColor.secondaryColor),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("${index}" "/" "${wordList.length}"),
                                ],
                              ),
                            ),
                            //Total Answered Question
                            Row(
                              children: [
                                Text(
                                  "Total Correct Answers:",
                                  style: TextStyle(
                                      backgroundColor: AppColor.secondaryColor),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("$totalAnsweredQuestion"
                                    "/"
                                    "${wordList.length}"),
                              ],
                            ),
                            //Current Score
                            Row(
                              children: [
                                Text(
                                  "Current Score:",
                                  style: TextStyle(
                                      backgroundColor: AppColor.secondaryColor),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("$score" "/" "${wordList.length}"),
                              ],
                            ),
                            //Highest Score
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "Highest Score:",
                                    style: TextStyle(
                                        backgroundColor:
                                            AppColor.secondaryColor),
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
                              width: MediaQuery.of(context).size.width * 0.7,
                              //0.8
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
                                    child: Text(
                                      'Question ${index + 1} / ${wordList.length}',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: SizedBox(
                                      height: 40.0,
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'Ayat',
                                              //Ayat[index].ayat_quran.toString(),
                                            ),
                                            TextSpan(
                                              text: 'Ayat',
                                              //Ayat[index].word_ayat.toString(),
                                              style: const TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    indent: 30.0,
                                    endIndent: 30.0,
                                  ),
                                  Center(
                                    child: SizedBox(
                                      height: 40.0,
                                      child: Text(
                                        wordList[index].text.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'MeQuran2'),
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    indent: 30.0,
                                    endIndent: 30.0,
                                  ),
                                  Center(
                                    child: SizedBox(
                                      height: 40.0,
                                      child: Text(
                                        question.translation,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: SizedBox(
                                      child: Text(
                                        question.question,
                                        style: TextStyle(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        for (int i = 0;
                                            i < options_arabic.length;
                                            i++)
                                          Container(
                                            margin: EdgeInsets.all(3),
                                            child: RawMaterialButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              elevation: 0.0,
                                              fillColor: btnPressed
                                                  ? options_arabic[i].isSelected
                                                      ? options_arabic[i]
                                                              .isCorrect
                                                          ? Colors.green
                                                          : Colors.red
                                                      : !correctAnswer
                                                          ? options_arabic[i]
                                                                  .isCorrect
                                                              ? Colors.green
                                                              : !options_arabic[
                                                                          i]
                                                                      .isSelected
                                                                  ? AppColor
                                                                      .secondaryColor
                                                                  : null
                                                          : AppColor
                                                              .secondaryColor
                                                  : AppColor.secondaryColor,
                                              onPressed: !answered
                                                  ? () {
                                                      selectedOption =
                                                          options_arabic[i].id;
                                                      options_arabic[i]
                                                          .isSelected = true;
                                                      checkAnswer(
                                                          wordList[index]
                                                              .id
                                                              .toString(),
                                                          selectedOption);

                                                      setState(() {
                                                        btnPressed = true;
                                                        answered = true;
                                                      });
                                                    }
                                                  : null,
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text(
                                                  options_arabic[i].text,
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

                              if (_controller.page?.toInt() ==
                                  wordList.length - 1) {
                                noOfAnswers++;
                                saveQuiz();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            QuizScore(score, wordList.length)));
                              } else {
                                if (!btnPressed) {
                                  Fluttertoast.showToast(
                                    msg: 'Please answer the questions',
                                    fontSize: 20,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                  );
                                  return;
                                }
                                noOfAnswers++;
                                _controller.nextPage(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInExpo);

                                setState(() {
                                  btnPressed = false;
                                  correctAnswer = false;
                                  for (int i = 0;
                                      i < options_arabic.length;
                                      i++) {
                                    options_arabic[i].isCorrect = false;
                                    options_arabic[i].isSelected = false;
                                  }
                                });
                              }
                            },
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
                        Expanded(
                          child: SizedBox(),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 10.0),
                          child: RawMaterialButton(
                            onPressed: () {
                              saveQuiz();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            fillColor: Colors.orange[200],
                            padding: const EdgeInsets.all(15.0),
                            elevation: 0.0,
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            )
          : Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                width: 50,
                height: 50,
              ),
            ),
    );
  }

  Future<bool> quizExist() async {
    bool exist;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userId = user?.uid;
    String? uid = userId?.toString();
    QuerySnapshot takenQuiz =
        await FirebaseFirestore.instance.collection('quiz').
    where('userId', isEqualTo: '0123').where('mushaf_page', isEqualTo: page).get();


    if (takenQuiz.docs.length > 0) {
      exist = true;
      quizId = takenQuiz.docs[0].id;

      /*
      final value = await FirebaseFirestore.instance
          .collection("quiz")
          .doc(doc)
          .get();
      wordList = value.data()!['remainingWords'];
      print(wordList);

      //wordList = takenQuizes.docs[0].get('remainingWords');
      print(wordList[0].id);

       */
    } else {
      exist = false;
    }
    return exist;
  }

  Future<bool> quizCompleted(String quizId) async {
    bool isCompleted;
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('quiz').doc(quizId).get();

      if (doc.exists) {
        print('doc exist');
        if( doc.get('progress') == 100) {
          print('progress = 100');
          isCompleted = true;
        } else {
          isCompleted = false;
    }
      } else {
        isCompleted = false;
      }


    return isCompleted;
  }

  Future<List<Words>> getRemainingWords(String quizId) async {
    List<String>? wordIds = [];
    late DocumentSnapshot remainingWords;
    final value = await FirebaseFirestore.instance
        .collection("quiz")
        .doc(quizId)
        .get();
    QuizModel quiz = QuizModel.fromMap(value.data());

    wordIds = quiz.remainingWords.cast<String>();
    print('word ids');
    print(wordIds.length);

    for (int i = 0; i < wordIds.length; i ++) {
      remainingWords =  await FirebaseFirestore.instance
          .collection('words').doc(wordIds[i]).get();

      wordList.add(
          Words.fromWords(
              id: remainingWords.get('id'),
              text: remainingWords.get('text')
          )
      );
    }

    if(wordList.isEmpty) {
      await getWords();
    }
    return wordList.map((e) => e).toList();
  }


  void saveQuiz() async{

    //files quiz list not needed

    QuizModel quiz;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    List<String> remainingWords = [];
    bool exist = await quizExist();

    bool isCompleted;


    if(noOfAnswers > 0) {


      if (noOfAnswers == wordList.length) {
        progress = 100;
        remainingWords = [];
        isCompleted = true;
      }
      else  {
        progress = (noOfAnswers * 100) / wordList.length;
        progress = progress.roundToDouble();
        isCompleted = false;

        //get remaining words
        for (int i = noOfAnswers; i < wordList.length; i++) {
          remainingWords.add(wordList[i].id.toString());
        }
      }
      
      final DateTime now = DateTime.now();
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      final String date = dateFormat.format(now);

      if(exist) {
        bool wasCompleted = await quizCompleted(quizId);
        DocumentSnapshot quizInfo = await FirebaseFirestore.instance.collection('quiz').doc(quizId).get();
        int oldScore = quizInfo.get('score');
        int oldProgress = quizInfo.get('progress');
        if(wasCompleted) {
          print('was completed');
          if(isCompleted)
          {
            print('is completed');
            if(score > oldScore)
            {
              print('overwrite the quiz');
              quiz = QuizModel(
                userId: '456',
                level: level,
                progress: progress,
                mushaf_page: page,
                score: score,
                date_taken: date,
                quiz_type_id: quizTypeId.toString(),
                remainingWords: remainingWords,
              );
              FirebaseFirestore.instance.collection('quiz').doc(quizId).update(quiz.toMap()).then((value) =>
              {
                print('quiz overwritten'),
              });


            }
            else
              {
              print('ignore quiz');
            }
          }
          else
            {
            print('done before but now not complete');
          }
        }
        else
          {
          print('was not completed');
          score = score + oldScore;
          if(isCompleted) {
            progress = 100;
          } else {
            progress = progress + oldProgress;
          }

          quiz = QuizModel(
            userId: 'null',
            level: level,
            progress: progress,
            mushaf_page: page,
            score: score,
            date_taken: date,
            quiz_type_id: quizTypeId.toString(),
            remainingWords: remainingWords,
          );
          FirebaseFirestore.instance.collection('quiz').doc(quizId).update(quiz.toMap()).then((value) =>
          {
            print('quiz updated'),
          });

        }


      }
      else
      {
        //first time taking quiz
        quiz = QuizModel(
          userId: 'user',
          level: level,
          progress: progress,
          mushaf_page: page,
          score: score,
          date_taken: date,
          quiz_type_id: quizTypeId.toString(),
          remainingWords: remainingWords,
        );

        FirebaseFirestore.instance.collection('quiz').add(quiz.toMap()).then((value) => {});
      }
    }
    
    




  }

  void generateQuestions() async {
    bool isExist = await quizExist();
    if (isExist) {
      await getRemainingWords(quizId);
    } else {
      await getWords();
    }
    //await getWords();
    await getQuestion();
    await getNonTranslatedOptions();
    await getTranslatedOptions();
    await getAnswers();

    setState(() {
      dataReady = true;
    });
  }

  List<Words> removeDuplicates(List<Words> words) {
    List<Words> distinct;
    List<Words> dummy = words;

    for(int i = 0; i < words.length; i++) {
      for (int j = 1; j < dummy.length; j++) {
        if (words[i].text == words[j].text) {
          dummy.removeAt(j);
        }
      }
    }


    ///distinct = words.toSet().toList();
    distinct = dummy;
    //print(distinct.length);

    return distinct.map((e) => e).toList();
  }
  Future<List<Words>> getWords() async {

    QuerySnapshot wordsQuerySnapshot = await FirebaseFirestore.instance
        .collection('words')
        .where('medina_mushaf_page_id', isEqualTo: page.toString())
        .get();

      for (int i = 0; i < wordsQuerySnapshot.docs.length; i++) {
        wordList.add(Words.fromWords(
            id: wordsQuerySnapshot.docs[i].get('id').toString(),
            text: wordsQuerySnapshot.docs[i].get('text').toString()));
      }

     wordList = removeDuplicates(wordList);
      wordList.shuffle();
    //print(wordList.length);
    return wordList.map((e) => e).toList();
  }

  Future<void> getQuestion() async {
    QuerySnapshot questions = await FirebaseFirestore.instance
        .collection('quiz_type')
        .where('level', isEqualTo: level)
        .get();

    if (level == 'beginner') {
      question = QuestionModel(
          question: questions.docs[0].get('question').toString(),
          translation: questions.docs[0].get('translation').toString());
      quizTypeId = questions.docs[0].id;
      //print(quizTypeId);
      //print(question.translation);
    } else {
      print('else');
    }
  }

  Future<List<dynamic>> getNonTranslatedOptions() async {
    //get the options untranslated
    QuerySnapshot optionSnap = await FirebaseFirestore.instance
        .collection('word_categories')
        .where('word_type', isEqualTo: 'main')
        .get();

    for (int i = 0; i < optionSnap.docs.length; i++) {
      options_malay.add(optionSnap.docs[i].get('id').toString());
      //print(options_malay[i]);

      //print(wordsQuerySnapshot.docs[i].get('id').toString());
    }

    return options_malay.map((e) => e).toList();
  }

  Future<List<dynamic>> getTranslatedOptions() async {
    optionTSnap = await FirebaseFirestore.instance
        .collection('category_translations')
        .get();

    for (int i = 0; i < options_malay.length; i++) {
      for (int j = 0; j < optionTSnap.docs.length; j++) {
        if (optionTSnap.docs[j].id == options_malay[i]) {
          options_arabic.add(Option(
              id: optionTSnap.docs[j].id,
              text: optionTSnap.docs[j].get('name')));
        }
      }
    }
    print(options_arabic.length);

    return options_arabic.map((e) => e).toList();
  }

  Future<List<dynamic>> getAnswers() async {

    for (int i = 0; i < wordList.length; i++) {
      relationshipSnapshot = await FirebaseFirestore.instance
          .collection('word_relationships')
          .where('word_id', isEqualTo: wordList[i].id)
          .get();

      for (int j = 0; j < relationshipSnapshot.docs.length; j++) {
        wordRelationships.add(WordRelationship(
            wordId: relationshipSnapshot.docs[j].get('word_id'),
            relationship:
                relationshipSnapshot.docs[j].get('word_category_id')));
      }
    }

    for (int i = 0; i < wordRelationships.length; i++) {
      for (int j = 0; j < options_arabic.length; j++) {
        if (wordRelationships[i].relationship == options_arabic[j].id) {
          answers.add(wordRelationships[i]);
          break;
        }
      }
    }

    print(answers.length);
    return answers.map((e) => e).toList();
  }

  void checkAnswer(String wordId, String selectedOption) async {
    for (int i = 0; i < answers.length; i++) {
      if (wordId == answers[i].wordId &&
          answers[i].relationship == selectedOption) {
        correctAnswer = true;
        score++;
        totalAnsweredQuestion++;
        //print('Correct Answer');

        for (int j = 0; j < options_arabic.length; j++) {
          if (options_arabic[j].id == selectedOption) {
            options_arabic[j].isCorrect = true;
          }
        }
      }
    }
    if (!correctAnswer) {
      for (int i = 0; i < answers.length; i++) {
        for (int j = 0; j < options_arabic.length; j++) {
          if (wordId == answers[i].wordId &&
              options_arabic[j].id == answers[i].relationship) {
            options_arabic[j].isCorrect = true;
          }
        }
      }
    }
  }

  @override
  void initState() {
    generateQuestions();
    super.initState();
  }
}
