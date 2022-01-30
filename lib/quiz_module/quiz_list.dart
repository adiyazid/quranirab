import 'package:quranirab/quiz_module/quiz_model.dart';

import 'ayat_model.dart';


List<AyatModel> Ayat=[
  AyatModel("ﻭ", "ﻣﺴﺘﻘﻴﻢ"),
  AyatModel("ﻣﺴﺘﻘﻴﻢ", "ﻣﺴﺘﻘﻴﻢ"),
  AyatModel("ﻭ", "ﻣﺴﺘﻘﻴﻢ"),
  AyatModel("ﻣﺴﺘﻘﻴﻢ", "ﻣﺴﺘﻘﻴﻢ"),
  AyatModel("ﻭ", "ﻣﺴﺘﻘﻴﻢ"),
];

List<String> question_quran=[
  "نوع الكلمة؟",
  "نوع الكلمة؟",
  "نوع الكلمة؟",
  "نوع الكلمة؟",
  "نوع الكلمة؟",


];


List<QuestionModel> questions = [
  QuestionModel(
    "Questions: Type of Word?",
    {
      "الاسم": false,
      "الفعل": false,
      "الحرف": true,
    },
  ),
  QuestionModel("Questions: Type of Word?", {
    "الحرف": false,
    "الفعل": false,
    "الاسم": true,
  }),
  QuestionModel("Questions: Type of Word?", {
    "الفعل": true,
    "الاسم": false,
    "الحرف": false,
  }),
  QuestionModel("Questions: Type of Word?", {
    "الفعل": false,
    "الحرف": false,
    "الاسم": true,

  }),
  QuestionModel("Questions: Type of Word?", {
    "الفعل": true,
    "الحرف": false,
    "الاسم": false,
  }),

];
//