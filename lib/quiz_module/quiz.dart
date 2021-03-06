import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/option-model.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/quiz_module/Quiz.Score.dart';
import 'package:quranirab/quiz_module/quiz_model.dart';
import 'package:quranirab/quiz_module/utils/AppColor.java';
import 'package:quranirab/quiz_module/utils/colors.dart';
import 'package:quranirab/quiz_module/words.model.dart';

import '../theme/theme_provider.dart';
import '../word-relationship-model.dart';

class Quiz extends StatefulWidget {
  final int page;
  final int oldScore;
  const Quiz(this.page, this.oldScore, {Key? key}) : super(key: key);

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
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

  late String selectedOption;
  late QuerySnapshot relationshipSnapshot;
  late QuerySnapshot optionTSnap;
  List<WordRelationship> wordRelationships = [];
  List<WordRelationship> answers = [];

  final PageController _controller = PageController(initialPage: 0);
  late String btnText;
  int btnIndex = 0;
  int score = 0;
  bool btnPressed = false;
  String status = 'Loading ...';
  bool answered = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      generateQuestions();
      btnText = AppLocalizations.of(context)!.next;
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor:
            themeProvider.isDarkMode ? Color(0xff666666) : ManyColors.color17,
        body: dataReady
            ? PageView.builder(
                controller: _controller,
                onPageChanged: (page) {
                  if (page == wordList.length - 1) {
                    setState(() {
                      btnText = AppLocalizations.of(context)!.seeResult;
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
                        color: themeProvider.isDarkMode
                            ? Color(0xff666666)
                            : ManyColors.color17,
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
                                      height: 40.0,
                                    ),
                                    Center(
                                      child: SizedBox(
                                        height: 40,
                                        child: Text(
                                          AppLocalizations.of(context)!.question +
                                              (index + 1).toString() +
                                              ' / ' +
                                              wordList.length.toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 60),
                                    Center(
                                      child: SizedBox(
                                        height: 40.0,
                                        child: Text(
                                          AppLocalizations.of(context)!.sentence,
                                          //ayat_quran[index].toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold),
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
                                      indent: 30.0,
                                      endIndent: 30.0,
                                    ),
                                    Center(
                                      child: SizedBox(
                                        height: 60.0,
                                        child: Text(
                                          question.translation,
                                          //question_quran[index].toString(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'MeQuran2',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: SizedBox(
                                        child: Text(
                                          question.question,
                                          //questions[index].question,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20.00,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          for (int i = 0;
                                              i < options_arabic.length;
                                              i++)
                                            Flexible(
                                              fit: FlexFit.loose,
                                              flex: 1,
                                              child: Container(
                                                margin: const EdgeInsets.all(3),
                                                child: RawMaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  elevation: 0.0,
                                                  fillColor: btnPressed
                                                      ? options_arabic[i]
                                                              .isSelected
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
                                                                      ? themeProvider
                                                                              .isDarkMode
                                                                          ? AppColor
                                                                              .secondaryColor
                                                                          : AppColor
                                                                              .pripmaryColor
                                                                      : null
                                                              : themeProvider
                                                                      .isDarkMode
                                                                  ? AppColor
                                                                      .secondaryColor
                                                                  : AppColor
                                                                      .pripmaryColor
                                                      : themeProvider.isDarkMode
                                                          ? AppColor
                                                              .secondaryColor
                                                          : AppColor
                                                              .pripmaryColor,
                                                  onPressed: !answered
                                                      ? () {
                                                          selectedOption =
                                                              options_arabic[i]
                                                                  .id;
                                                          options_arabic[i]
                                                              .isSelected = true;
                                                          checkAnswer(
                                                              wordList[index]
                                                                  .id
                                                                  .toString(),
                                                              selectedOption);

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
                                                    padding:
                                                        const EdgeInsets.all(5.0),
                                                    child: AutoSizeText(
                                                      options_arabic[i].text,
                                                      //questions[index].answers!.keys.toList()[i],
                                                      softWrap: false,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0,
                                                        fontFamily: 'MeQuran2',
                                                      ),
                                                      maxFontSize: 18.0,
                                                      minFontSize: 16.0,
                                                      maxLines: 1,
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
                              if (_controller.page?.toInt() ==
                                  wordList.length - 1) {
                                addScore(score);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => QuizScore(score,
                                            wordList.length, widget.page)));
                              } else {
                                if (!btnPressed) {
                                  Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)!
                                        .pleaseAnswerQuestion,
                                    fontSize: 20,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                  );
                                  return;
                                }
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
                            fillColor: themeProvider.isDarkMode
                                ? Color(0xff808ba1)
                                : Colors.orange[200],
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
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: CircularProgressIndicator(),
                      width: 50,
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        status,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
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

      //print(question);
    } else {
      print('else');
    }
  }

  Future<List<dynamic>> getWords() async {
    QuerySnapshot wordsQuerySnapshot = await FirebaseFirestore.instance
        .collection('words')
        .where('medina_mushaf_page_id', isEqualTo: widget.page.toString())
        .get();

    //print(wordsQuerySnapshot.docs.length);
    for (int i = 0; i < wordsQuerySnapshot.docs.length; i++) {
      wordList.add(Words.fromWords(
          id: wordsQuerySnapshot.docs[i].get('id').toString(),
          text: wordsQuerySnapshot.docs[i].get('text').toString()));

      //wordIds.add(wordsQuerySnapshot.docs[i].get('id').toString());
      //words.add(wordsQuerySnapshot.docs[i].get('text').toString()) ;

    }

    return words.map((e) => e).toList();
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

    return Future.delayed(
        Duration(seconds: 1), () => answers.map((e) => e).toList());
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

    return options_arabic.map((e) => e).toList();
  }

  void generateQuestions() async {
    setState(() {
      status = 'Retrieving words ...';
    });
    await getWords();
    setState(() {
      status = 'Retrieving questions ...';
    });
    await getQuestion();
    setState(() {
      status = 'Retrieving non-translate options ...';
    });
    await getNonTranslatedOptions();
    setState(() {
      status = 'Retrieving translated options ...';
    });
    await getTranslatedOptions();
    setState(() {
      status = 'Finishing up ...';
    });
    await getAnswers();
    setState(() {
      dataReady = true;
    });
  }

  void checkAnswer(String wordId, String selectedOption) async {
    for (int i = 0; i < answers.length; i++) {
      if (wordId == answers[i].wordId &&
          answers[i].relationship == selectedOption) {
        correctAnswer = true;
        score++;
        print('Correct Answer');

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

  Future<void> addScore(int score) async {
    CollectionReference quiz = FirebaseFirestore.instance
        .collection('quranIrabUsers')
        .doc(AppUser.instance.user!.uid)
        .collection('quizs');
    int old = widget.oldScore;
    if (old < score) {
      quiz
          // existing document in 'users' collection: "ABC123"
          .doc(widget.page.toString())
          .set(
            {
              'user-id': AppUser.instance.user!.uid,
              'score': score,
              'date-taken': DateTime.now(),
              'medina_mushaf_page_id': widget.page,
              'level': level,
              'pic-url': AppUser.instance.user!.photoURL ?? ''
            },
            SetOptions(merge: true),
          )
          .then((value) => print("'score' & 'date' merged with existing data!"))
          .catchError((error) => print("Failed to merge data: $error"));
    } else {
      print('try again');
    }
  }
}
