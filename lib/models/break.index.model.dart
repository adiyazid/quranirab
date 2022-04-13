// To parse this JSON data, do
//
//     final breakIndex = breakIndexFromJson(jsonString);

import 'dart:convert';

BreakIndex breakIndexFromJson(String str) =>
    BreakIndex.fromJson(json.decode(str));

String breakIndexToJson(BreakIndex data) => json.encode(data.toJson());

class BreakIndex {
  BreakIndex({
    required this.page1,
    required this.page2,
    required this.page3,
    required this.page4,
    required this.page5,
    required this.page6,
    required this.page7,
    required this.page8,
    required this.page9,
    required this.page10,
    required this.page11,
    required this.page12,
    required this.page13,
    required this.page14,
    required this.page15,
    required this.page16,
    required this.page17,
    required this.page18,
    required this.page19,
    required this.page20,
    required this.page21,
    required this.page22,
    required this.page23,
    required this.page24,
    required this.page25,
    required this.page26,
    required this.page27,
    required this.page28,
    required this.page29,
    required this.page30,
    required this.page31,
    required this.page32,
    required this.page33,
    required this.page34,
    required this.page35,
    required this.page36,
    required this.page37,
    required this.page38,
    required this.page39,
    required this.page40,
    required this.page41,
    required this.page42,
    required this.page43,
    required this.page44,
    required this.page45,
    required this.page46,
    required this.page47,
    required this.page48,
    required this.page49,
    required this.page50,
    required this.page51,
    required this.page52,
    required this.page53,
    required this.page54,
    required this.page55,
    required this.page56,
    required this.page57,
    required this.page58,
    required this.page59,
    required this.page60,
    required this.page61,
    required this.page62,
    required this.page63,
    required this.page64,
    required this.page65,
    required this.page66,
    required this.page67,
    required this.page68,
    required this.page69,
    required this.page70,
    required this.page71,
    required this.page72,
    required this.page73,
    required this.page74,
    required this.page75,
    required this.page76,
    required this.page77,
    required this.page78,
    required this.page79,
    required this.page80,
    required this.page81,
    required this.page82,
    required this.page83,
    required this.page84,
    required this.page85,
    required this.page86,
    required this.page87,
    required this.page88,
    required this.page89,
    required this.page90,
    required this.page91,
    required this.page92,
    required this.page93,
    required this.page94,
    required this.page95,
    required this.page96,
    required this.page97,
    required this.page98,
    required this.page99,
    required this.page100,
    required this.page101,
    required this.page102,
    required this.page103,
    required this.page104,
    required this.page105,
    required this.page106,
    required this.page107,
    required this.page108,
    required this.page109,
    required this.page110,
    required this.page111,
    required this.page112,
    required this.page113,
    required this.page114,
    required this.page115,
    required this.page116,
    required this.page117,
    required this.page118,
    required this.page119,
    required this.page120,
    required this.page121,
    required this.page122,
    required this.page123,
    required this.page124,
    required this.page125,
    required this.page126,
    required this.page127,
    required this.page128,
    required this.page129,
    required this.page130,
    required this.page131,
    required this.page132,
    required this.page133,
    required this.page134,
    required this.page135,
    required this.page136,
    required this.page137,
    required this.page138,
    required this.page139,
    required this.page140,
    required this.page141,
    required this.page142,
    required this.page143,
    required this.page144,
    required this.page145,
    required this.page146,
    required this.page147,
    required this.page148,
    required this.page149,
    required this.page150,
    required this.page151,
    required this.page152,
    required this.page153,
    required this.page154,
    required this.page155,
    required this.page156,
    required this.page157,
    required this.page158,
    required this.page159,
    required this.page160,
    required this.page161,
    required this.page162,
    required this.page163,
    required this.page164,
    required this.page165,
    required this.page166,
    required this.page167,
    required this.page168,
    required this.page169,
    required this.page170,
    required this.page171,
    required this.page172,
    required this.page173,
    required this.page174,
    required this.page175,
    required this.page176,
    required this.page177,
    required this.page178,
    required this.page179,
    required this.page180,
    required this.page181,
    required this.page182,
    required this.page183,
    required this.page184,
    required this.page185,
    required this.page186,
    required this.page187,
    required this.page188,
    required this.page189,
    required this.page190,
    required this.page191,
    required this.page192,
    required this.page193,
    required this.page194,
    required this.page195,
    required this.page196,
    required this.page197,
    required this.page198,
    required this.page199,
    required this.page200,
    required this.page201,
    required this.page202,
    required this.page203,
    required this.page204,
    required this.page205,
    required this.page206,
    required this.page207,
    required this.page208,
    required this.page209,
    required this.page210,
    required this.page211,
    required this.page212,
    required this.page213,
    required this.page214,
    required this.page215,
    required this.page216,
    required this.page217,
    required this.page218,
    required this.page219,
    required this.page220,
    required this.page221,
    required this.page222,
    required this.page223,
    required this.page224,
    required this.page225,
    required this.page226,
    required this.page227,
    required this.page228,
    required this.page229,
    required this.page230,
    required this.page231,
    required this.page232,
    required this.page233,
    required this.page234,
    required this.page235,
    required this.page236,
    required this.page237,
    required this.page238,
    required this.page239,
    required this.page240,
    required this.page241,
    required this.page242,
    required this.page243,
    required this.page244,
    required this.page245,
    required this.page246,
    required this.page247,
    required this.page248,
    required this.page249,
    required this.page250,
    required this.page251,
    required this.page252,
    required this.page253,
    required this.page254,
    required this.page255,
    required this.page256,
    required this.page257,
    required this.page258,
    required this.page259,
    required this.page260,
    required this.page261,
    required this.page262,
    required this.page263,
    required this.page264,
    required this.page265,
    required this.page266,
    required this.page267,
    required this.page268,
    required this.page269,
    required this.page270,
    required this.page271,
    required this.page272,
    required this.page273,
    required this.page274,
    required this.page275,
    required this.page276,
    required this.page277,
    required this.page278,
  });

  List<int> page1;
  List<int> page2;
  List<int> page3;
  List<int> page4;
  List<int> page5;
  List<int> page6;
  List<int> page7;
  List<int> page8;
  List<int> page9;
  List<int> page10;
  List<int> page11;
  List<int> page12;
  List<int> page13;
  List<int> page14;
  List<int> page15;
  List<int> page16;
  List<int> page17;
  List<int> page18;
  List<int> page19;
  List<int> page20;
  List<int> page21;
  List<int> page22;
  List<int> page23;
  List<int> page24;
  List<int> page25;
  List<int> page26;
  List<int> page27;
  List<int> page28;
  List<int> page29;
  List<int> page30;
  List<int> page31;
  List<int> page32;
  List<int> page33;
  List<int> page34;
  List<int> page35;
  List<int> page36;
  List<int> page37;
  List<int> page38;
  List<int> page39;
  List<int> page40;
  List<int> page41;
  List<int> page42;
  List<int> page43;
  List<int> page44;
  List<int> page45;
  List<int> page46;
  List<int> page47;
  List<int> page48;
  List<int> page49;
  List<int> page50;
  List<int> page51;
  List<int> page52;
  List<int> page53;
  List<int> page54;
  List<int> page55;
  List<int> page56;
  List<int> page57;
  List<int> page58;
  List<int> page59;
  List<int> page60;
  List<int> page61;
  List<int> page62;
  List<int> page63;
  List<int> page64;
  List<int> page65;
  List<int> page66;
  List<int> page67;
  List<int> page68;
  List<int> page69;
  List<int> page70;
  List<int> page71;
  List<int> page72;
  List<int> page73;
  List<int> page74;
  List<int> page75;
  List<int> page76;
  List<int> page77;
  List<int> page78;
  List<int> page79;
  List<int> page80;
  List<int> page81;
  List<int> page82;
  List<int> page83;
  List<int> page84;
  List<int> page85;
  List<int> page86;
  List<int> page87;
  List<int> page88;
  List<int> page89;
  List<int> page90;
  List<int> page91;
  List<int> page92;
  List<int> page93;
  List<int> page94;
  List<int> page95;
  List<int> page96;
  List<int> page97;
  List<int> page98;
  List<int> page99;
  List<int> page100;
  List<int> page101;
  List<int> page102;
  List<int> page103;
  List<int> page104;
  List<int> page105;
  List<int> page106;
  List<int> page107;
  List<int> page108;
  List<int> page109;
  List<int> page110;
  List<int> page111;
  List<int> page112;
  List<int> page113;
  List<int> page114;
  List<int> page115;
  List<int> page116;
  List<int> page117;
  List<int> page118;
  List<int> page119;
  List<int> page120;
  List<int> page121;
  List<int> page122;
  List<int> page123;
  List<int> page124;
  List<int> page125;
  List<int> page126;
  List<int> page127;
  List<int> page128;
  List<int> page129;
  List<int> page130;
  List<int> page131;
  List<int> page132;
  List<int> page133;
  List<int> page134;
  List<int> page135;
  List<int> page136;
  List<int> page137;
  List<int> page138;
  List<int> page139;
  List<int> page140;
  List<int> page141;
  List<int> page142;
  List<int> page143;
  List<int> page144;
  List<int> page145;
  List<int> page146;
  List<int> page147;
  List<int> page148;
  List<int> page149;
  List<int> page150;
  List<int> page151;
  List<int> page152;
  List<int> page153;
  List<int> page154;
  List<int> page155;
  List<int> page156;
  List<int> page157;
  List<int> page158;
  List<int> page159;
  List<int> page160;
  List<int> page161;
  List<int> page162;
  List<int> page163;
  List<int> page164;
  List<int> page165;
  List<int> page166;
  List<int> page167;
  List<int> page168;
  List<int> page169;
  List<int> page170;
  List<int> page171;
  List<int> page172;
  List<int> page173;
  List<int> page174;
  List<int> page175;
  List<int> page176;
  List<int> page177;
  List<int> page178;
  List<int> page179;
  List<int> page180;
  List<int> page181;
  List<int> page182;
  List<int> page183;
  List<int> page184;
  List<int> page185;
  List<int> page186;
  List<int> page187;
  List<int> page188;
  List<int> page189;
  List<int> page190;
  List<int> page191;
  List<int> page192;
  List<int> page193;
  List<int> page194;
  List<int> page195;
  List<int> page196;
  List<int> page197;
  List<int> page198;
  List<int> page199;
  List<int> page200;
  List<int> page201;
  List<int> page202;
  List<int> page203;
  List<int> page204;
  List<int> page205;
  List<int> page206;
  List<int> page207;
  List<int> page208;
  List<int> page209;
  List<int> page210;
  List<int> page211;
  List<int> page212;
  List<int> page213;
  List<int> page214;
  List<int> page215;
  List<int> page216;
  List<int> page217;
  List<int> page218;
  List<int> page219;
  List<int> page220;
  List<int> page221;
  List<int> page222;
  List<int> page223;
  List<int> page224;
  List<int> page225;
  List<int> page226;
  List<int> page227;
  List<int> page228;
  List<int> page229;
  List<int> page230;
  List<int> page231;
  List<int> page232;
  List<int> page233;
  List<int> page234;
  List<int> page235;
  List<int> page236;
  List<int> page237;
  List<int> page238;
  List<int> page239;
  List<int> page240;
  List<int> page241;
  List<int> page242;
  List<int> page243;
  List<int> page244;
  List<int> page245;
  List<int> page246;
  List<int> page247;
  List<int> page248;
  List<int> page249;
  List<int> page250;
  List<int> page251;
  List<int> page252;
  List<int> page253;
  List<int> page254;
  List<int> page255;
  List<int> page256;
  List<int> page257;
  List<int> page258;
  List<int> page259;
  List<int> page260;
  List<int> page261;
  List<int> page262;
  List<int> page263;
  List<int> page264;
  List<int> page265;
  List<int> page266;
  List<int> page267;
  List<int> page268;
  List<int> page269;
  List<int> page270;
  List<int> page271;
  List<int> page272;
  List<int> page273;
  List<int> page274;
  List<int> page275;
  List<int> page276;
  List<int> page277;
  List<int> page278;

  factory BreakIndex.fromJson(Map<String, dynamic> json) => BreakIndex(
        page1: List<int>.from(json["page_1"].map((x) => x)),
        page2: List<int>.from(json["page_2"].map((x) => x)),
        //add
        page3: List<int>.from(json["page_3"].map((x) => x)),
        page4: List<int>.from(json["page_4"].map((x) => x)),
        page5: List<int>.from(json["page_5"].map((x) => x)),
        page6: List<int>.from(json["page_6"].map((x) => x)),
        page7: List<int>.from(json["page_7"].map((x) => x)),
        page8: List<int>.from(json["page_8"].map((x) => x)),
        page9: List<int>.from(json["page_9"].map((x) => x)),
        page10: List<int>.from(json["page_10"].map((x) => x)),
        page11: List<int>.from(json["page_11"].map((x) => x)),
        page12: List<int>.from(json["page_12"].map((x) => x)),
        page13: List<int>.from(json["page_13"].map((x) => x)),
        page14: List<int>.from(json["page_14"].map((x) => x)),
        page15: List<int>.from(json["page_15"].map((x) => x)),
        page16: List<int>.from(json["page_16"].map((x) => x)),
        page17: List<int>.from(json["page_17"].map((x) => x)),
        page18: List<int>.from(json["page_18"].map((x) => x)),
        page19: List<int>.from(json["page_19"].map((x) => x)),
        page20: List<int>.from(json["page_20"].map((x) => x)),
        page21: List<int>.from(json["page_21"].map((x) => x)),
        page22: List<int>.from(json["page_22"].map((x) => x)),
        page23: List<int>.from(json["page_23"].map((x) => x)),
        page24: List<int>.from(json["page_24"].map((x) => x)),
        page25: List<int>.from(json["page_25"].map((x) => x)),
        page26: List<int>.from(json["page_26"].map((x) => x)),
        page27: List<int>.from(json["page_27"].map((x) => x)),
        page28: List<int>.from(json["page_28"].map((x) => x)),
        page29: List<int>.from(json["page_29"].map((x) => x)),
        page30: List<int>.from(json["page_30"].map((x) => x)),
        page31: List<int>.from(json["page_31"].map((x) => x)),
        page32: List<int>.from(json["page_32"].map((x) => x)),
        page33: List<int>.from(json["page_33"].map((x) => x)),
        page34: List<int>.from(json["page_34"].map((x) => x)),
        page35: List<int>.from(json["page_35"].map((x) => x)),
        page36: List<int>.from(json["page_36"].map((x) => x)),
        page37: List<int>.from(json["page_37"].map((x) => x)),
        page38: List<int>.from(json["page_38"].map((x) => x)),
        page39: List<int>.from(json["page_39"].map((x) => x)),
        page40: List<int>.from(json["page_40"].map((x) => x)),
        page41: List<int>.from(json["page_41"].map((x) => x)),
        page42: List<int>.from(json["page_42"].map((x) => x)),
        page43: List<int>.from(json["page_43"].map((x) => x)),
        page44: List<int>.from(json["page_44"].map((x) => x)),
        page45: List<int>.from(json["page_45"].map((x) => x)),
        page46: List<int>.from(json["page_46"].map((x) => x)),
        page47: List<int>.from(json["page_47"].map((x) => x)),
        page48: List<int>.from(json["page_48"].map((x) => x)),
        page49: List<int>.from(json["page_49"].map((x) => x)),
        page50: List<int>.from(json["page_50"].map((x) => x)),
        page51: List<int>.from(json["page_51"].map((x) => x)),
        page52: List<int>.from(json["page_52"].map((x) => x)),
        page53: List<int>.from(json["page_53"].map((x) => x)),
        page54: List<int>.from(json["page_54"].map((x) => x)),
        page55: List<int>.from(json["page_55"].map((x) => x)),
        page56: List<int>.from(json["page_56"].map((x) => x)),
        page57: List<int>.from(json["page_57"].map((x) => x)),
        page58: List<int>.from(json["page_58"].map((x) => x)),
        page59: List<int>.from(json["page_59"].map((x) => x)),
        page60: List<int>.from(json["page_60"].map((x) => x)),
        page61: List<int>.from(json["page_61"].map((x) => x)),
        page62: List<int>.from(json["page_62"].map((x) => x)),
        page63: List<int>.from(json["page_63"].map((x) => x)),
        page64: List<int>.from(json["page_64"].map((x) => x)),
        page65: List<int>.from(json["page_65"].map((x) => x)),
        page66: List<int>.from(json["page_66"].map((x) => x)),
        page67: List<int>.from(json["page_67"].map((x) => x)),
        page68: List<int>.from(json["page_68"].map((x) => x)),
        page69: List<int>.from(json["page_69"].map((x) => x)),
        page70: List<int>.from(json["page_70"].map((x) => x)),
        page71: List<int>.from(json["page_71"].map((x) => x)),
        page72: List<int>.from(json["page_72"].map((x) => x)),
        page73: List<int>.from(json["page_73"].map((x) => x)),
        page74: List<int>.from(json["page_74"].map((x) => x)),
        page75: List<int>.from(json["page_75"].map((x) => x)),
        page76: List<int>.from(json["page_76"].map((x) => x)),
        page77: List<int>.from(json["page_77"].map((x) => x)),
        page78: List<int>.from(json["page_78"].map((x) => x)),
        page79: List<int>.from(json["page_79"].map((x) => x)),
        page80: List<int>.from(json["page_80"].map((x) => x)),
        page81: List<int>.from(json["page_81"].map((x) => x)),
        page82: List<int>.from(json["page_82"].map((x) => x)),
        page83: List<int>.from(json["page_83"].map((x) => x)),
        page84: List<int>.from(json["page_84"].map((x) => x)),
        page85: List<int>.from(json["page_85"].map((x) => x)),
        page86: List<int>.from(json["page_86"].map((x) => x)),
        page87: List<int>.from(json["page_87"].map((x) => x)),
        page88: List<int>.from(json["page_88"].map((x) => x)),
        page89: List<int>.from(json["page_89"].map((x) => x)),
        page90: List<int>.from(json["page_90"].map((x) => x)),
        page91: List<int>.from(json["page_91"].map((x) => x)),
        page92: List<int>.from(json["page_92"].map((x) => x)),
        page93: List<int>.from(json["page_93"].map((x) => x)),
        page94: List<int>.from(json["page_94"].map((x) => x)),
        page95: List<int>.from(json["page_95"].map((x) => x)),
        page96: List<int>.from(json["page_96"].map((x) => x)),
        page97: List<int>.from(json["page_97"].map((x) => x)),
        page98: List<int>.from(json["page_98"].map((x) => x)),
        page99: List<int>.from(json["page_99"].map((x) => x)),
        page100: List<int>.from(json["page_100"].map((x) => x)),
        page101: List<int>.from(json["page_101"].map((x) => x)),
        page102: List<int>.from(json["page_102"].map((x) => x)),
        page103: List<int>.from(json["page_103"].map((x) => x)),
        page104: List<int>.from(json["page_104"].map((x) => x)),
        page105: List<int>.from(json["page_105"].map((x) => x)),
        page106: List<int>.from(json["page_106"].map((x) => x)),
        page107: List<int>.from(json["page_107"].map((x) => x)),
        page108: List<int>.from(json["page_108"].map((x) => x)),
        page109: List<int>.from(json["page_109"].map((x) => x)),
        page110: List<int>.from(json["page_110"].map((x) => x)),
        page111: List<int>.from(json["page_111"].map((x) => x)),
        page112: List<int>.from(json["page_112"].map((x) => x)),
        page113: List<int>.from(json["page_113"].map((x) => x)),
        page114: List<int>.from(json["page_114"].map((x) => x)),
        page115: List<int>.from(json["page_115"].map((x) => x)),
        page116: List<int>.from(json["page_116"].map((x) => x)),
        page117: List<int>.from(json["page_117"].map((x) => x)),
        page118: List<int>.from(json["page_118"].map((x) => x)),
        page119: List<int>.from(json["page_119"].map((x) => x)),
        page120: List<int>.from(json["page_120"].map((x) => x)),
        page121: List<int>.from(json["page_121"].map((x) => x)),
        page122: List<int>.from(json["page_122"].map((x) => x)),
        page123: List<int>.from(json["page_123"].map((x) => x)),
        page124: List<int>.from(json["page_124"].map((x) => x)),
        page125: List<int>.from(json["page_125"].map((x) => x)),
        page126: List<int>.from(json["page_126"].map((x) => x)),
        page127: List<int>.from(json["page_127"].map((x) => x)),
        page128: List<int>.from(json["page_128"].map((x) => x)),
        page129: List<int>.from(json["page_129"].map((x) => x)),
        page130: List<int>.from(json["page_130"].map((x) => x)),
        page131: List<int>.from(json["page_131"].map((x) => x)),
        page132: List<int>.from(json["page_132"].map((x) => x)),
        page133: List<int>.from(json["page_133"].map((x) => x)),
        page134: List<int>.from(json["page_134"].map((x) => x)),
        page135: List<int>.from(json["page_135"].map((x) => x)),
        page136: List<int>.from(json["page_136"].map((x) => x)),
        page137: List<int>.from(json["page_137"].map((x) => x)),
        page138: List<int>.from(json["page_138"].map((x) => x)),
        page139: List<int>.from(json["page_139"].map((x) => x)),
        page140: List<int>.from(json["page_140"].map((x) => x)),
        page141: List<int>.from(json["page_141"].map((x) => x)),
        page142: List<int>.from(json["page_142"].map((x) => x)),
        page143: List<int>.from(json["page_143"].map((x) => x)),
        page144: List<int>.from(json["page_144"].map((x) => x)),
        page145: List<int>.from(json["page_145"].map((x) => x)),
        page146: List<int>.from(json["page_146"].map((x) => x)),
        page147: List<int>.from(json["page_147"].map((x) => x)),
        page148: List<int>.from(json["page_148"].map((x) => x)),
        page149: List<int>.from(json["page_149"].map((x) => x)),
        page150: List<int>.from(json["page_150"].map((x) => x)),
        page151: List<int>.from(json["page_151"].map((x) => x)),
        page152: List<int>.from(json["page_152"].map((x) => x)),
        page153: List<int>.from(json["page_153"].map((x) => x)),
        page154: List<int>.from(json["page_154"].map((x) => x)),
        page155: List<int>.from(json["page_155"].map((x) => x)),
        page156: List<int>.from(json["page_156"].map((x) => x)),
        page157: List<int>.from(json["page_157"].map((x) => x)),
        page158: List<int>.from(json["page_158"].map((x) => x)),
        page159: List<int>.from(json["page_159"].map((x) => x)),
        page160: List<int>.from(json["page_160"].map((x) => x)),
        page161: List<int>.from(json["page_161"].map((x) => x)),
        page162: List<int>.from(json["page_162"].map((x) => x)),
        page163: List<int>.from(json["page_163"].map((x) => x)),
        page164: List<int>.from(json["page_164"].map((x) => x)),
        page165: List<int>.from(json["page_165"].map((x) => x)),
        page166: List<int>.from(json["page_166"].map((x) => x)),
        page167: List<int>.from(json["page_167"].map((x) => x)),
        page168: List<int>.from(json["page_168"].map((x) => x)),
        page169: List<int>.from(json["page_169"].map((x) => x)),
        page170: List<int>.from(json["page_170"].map((x) => x)),
        page171: List<int>.from(json["page_171"].map((x) => x)),
        page172: List<int>.from(json["page_172"].map((x) => x)),
        page173: List<int>.from(json["page_173"].map((x) => x)),
        page174: List<int>.from(json["page_174"].map((x) => x)),
        page175: List<int>.from(json["page_175"].map((x) => x)),
        page176: List<int>.from(json["page_176"].map((x) => x)),
        page177: List<int>.from(json["page_177"].map((x) => x)),
        page178: List<int>.from(json["page_178"].map((x) => x)),
        page179: List<int>.from(json["page_179"].map((x) => x)),
        page180: List<int>.from(json["page_180"].map((x) => x)),
        page181: List<int>.from(json["page_181"].map((x) => x)),
        page182: List<int>.from(json["page_182"].map((x) => x)),
        page183: List<int>.from(json["page_183"].map((x) => x)),
        page184: List<int>.from(json["page_184"].map((x) => x)),
        page185: List<int>.from(json["page_185"].map((x) => x)),
        page186: List<int>.from(json["page_186"].map((x) => x)),
        page187: List<int>.from(json["page_187"].map((x) => x)),
        page188: List<int>.from(json["page_188"].map((x) => x)),
        page189: List<int>.from(json["page_189"].map((x) => x)),
        page190: List<int>.from(json["page_190"].map((x) => x)),
        page191: List<int>.from(json["page_191"].map((x) => x)),
        page192: List<int>.from(json["page_192"].map((x) => x)),
        page193: List<int>.from(json["page_193"].map((x) => x)),
        page194: List<int>.from(json["page_194"].map((x) => x)),
        page195: List<int>.from(json["page_195"].map((x) => x)),
        page196: List<int>.from(json["page_196"].map((x) => x)),
        page197: List<int>.from(json["page_197"].map((x) => x)),
        page198: List<int>.from(json["page_198"].map((x) => x)),
        page199: List<int>.from(json["page_199"].map((x) => x)),
        page200: List<int>.from(json["page_200"].map((x) => x)),
        page201: List<int>.from(json["page_201"].map((x) => x)),
        page202: List<int>.from(json["page_202"].map((x) => x)),
        page203: List<int>.from(json["page_203"].map((x) => x)),
        page204: List<int>.from(json["page_204"].map((x) => x)),
        page205: List<int>.from(json["page_205"].map((x) => x)),
        page206: List<int>.from(json["page_206"].map((x) => x)),
        page207: List<int>.from(json["page_207"].map((x) => x)),
        page208: List<int>.from(json["page_208"].map((x) => x)),
        page209: List<int>.from(json["page_209"].map((x) => x)),
        page210: List<int>.from(json["page_210"].map((x) => x)),
        page211: List<int>.from(json["page_211"].map((x) => x)),
        page212: List<int>.from(json["page_212"].map((x) => x)),
        page213: List<int>.from(json["page_213"].map((x) => x)),
        page214: List<int>.from(json["page_214"].map((x) => x)),
        page215: List<int>.from(json["page_215"].map((x) => x)),
        page216: List<int>.from(json["page_216"].map((x) => x)),
        page217: List<int>.from(json["page_217"].map((x) => x)),
        page218: List<int>.from(json["page_218"].map((x) => x)),
        page219: List<int>.from(json["page_219"].map((x) => x)),
        page220: List<int>.from(json["page_220"].map((x) => x)),
        page221: List<int>.from(json["page_221"].map((x) => x)),
        page222: List<int>.from(json["page_222"].map((x) => x)),
        page223: List<int>.from(json["page_223"].map((x) => x)),
        page224: List<int>.from(json["page_224"].map((x) => x)),
        page225: List<int>.from(json["page_225"].map((x) => x)),
        page226: List<int>.from(json["page_226"].map((x) => x)),
        page227: List<int>.from(json["page_227"].map((x) => x)),
        page228: List<int>.from(json["page_228"].map((x) => x)),
        page229: List<int>.from(json["page_229"].map((x) => x)),
        page230: List<int>.from(json["page_230"].map((x) => x)),
        page231: List<int>.from(json["page_231"].map((x) => x)),
        page232: List<int>.from(json["page_232"].map((x) => x)),
        page233: List<int>.from(json["page_233"].map((x) => x)),
        page234: List<int>.from(json["page_234"].map((x) => x)),
        page235: List<int>.from(json["page_235"].map((x) => x)),
        page236: List<int>.from(json["page_236"].map((x) => x)),
        page237: List<int>.from(json["page_237"].map((x) => x)),
        page238: List<int>.from(json["page_238"].map((x) => x)),
        page239: List<int>.from(json["page_239"].map((x) => x)),
        page240: List<int>.from(json["page_240"].map((x) => x)),
        page241: List<int>.from(json["page_241"].map((x) => x)),
        page242: List<int>.from(json["page_242"].map((x) => x)),
        page243: List<int>.from(json["page_243"].map((x) => x)),
        page244: List<int>.from(json["page_244"].map((x) => x)),
        page245: List<int>.from(json["page_245"].map((x) => x)),
        page246: List<int>.from(json["page_246"].map((x) => x)),
        page247: List<int>.from(json["page_247"].map((x) => x)),
        page248: List<int>.from(json["page_248"].map((x) => x)),
        page249: List<int>.from(json["page_249"].map((x) => x)),
        page250: List<int>.from(json["page_250"].map((x) => x)),
        page251: List<int>.from(json["page_251"].map((x) => x)),
        page252: List<int>.from(json["page_252"].map((x) => x)),
        page253: List<int>.from(json["page_253"].map((x) => x)),
        page254: List<int>.from(json["page_254"].map((x) => x)),
        page255: List<int>.from(json["page_255"].map((x) => x)),
        page256: List<int>.from(json["page_256"].map((x) => x)),
        page257: List<int>.from(json["page_257"].map((x) => x)),
        page258: List<int>.from(json["page_258"].map((x) => x)),
        page259: List<int>.from(json["page_259"].map((x) => x)),
        page260: List<int>.from(json["page_260"].map((x) => x)),
        page261: List<int>.from(json["page_261"].map((x) => x)),
        page262: List<int>.from(json["page_262"].map((x) => x)),
        page263: List<int>.from(json["page_263"].map((x) => x)),
        page264: List<int>.from(json["page_264"].map((x) => x)),
        page265: List<int>.from(json["page_265"].map((x) => x)),
        page266: List<int>.from(json["page_266"].map((x) => x)),
        page267: List<int>.from(json["page_267"].map((x) => x)),
        page268: List<int>.from(json["page_268"].map((x) => x)),
        page269: List<int>.from(json["page_269"].map((x) => x)),
        page270: List<int>.from(json["page_270"].map((x) => x)),
        page271: List<int>.from(json["page_271"].map((x) => x)),
        page272: List<int>.from(json["page_272"].map((x) => x)),
        page273: List<int>.from(json["page_273"].map((x) => x)),
        page274: List<int>.from(json["page_274"].map((x) => x)),
        page275: List<int>.from(json["page_275"].map((x) => x)),
        page276: List<int>.from(json["page_276"].map((x) => x)),
        page277: List<int>.from(json["page_277"].map((x) => x)),
        page278: List<int>.from(json["page_278"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "page_1": List<dynamic>.from(page1.map((x) => x)),
        "page_2": List<dynamic>.from(page2.map((x) => x)),
        "page_3": List<dynamic>.from(page3.map((x) => x)),
        "page_4": List<dynamic>.from(page4.map((x) => x)),
        "page_5": List<dynamic>.from(page5.map((x) => x)),
        "page_6": List<dynamic>.from(page6.map((x) => x)),
        "page_7": List<dynamic>.from(page7.map((x) => x)),
        "page_8": List<dynamic>.from(page8.map((x) => x)),
        "page_9": List<dynamic>.from(page9.map((x) => x)),
        "page_10": List<dynamic>.from(page10.map((x) => x)),
        "page_11": List<dynamic>.from(page11.map((x) => x)),
        "page_12": List<dynamic>.from(page12.map((x) => x)),
        "page_13": List<dynamic>.from(page13.map((x) => x)),
        "page_14": List<dynamic>.from(page14.map((x) => x)),
        "page_15": List<dynamic>.from(page15.map((x) => x)),
        "page_16": List<dynamic>.from(page16.map((x) => x)),
        "page_17": List<dynamic>.from(page17.map((x) => x)),
        "page_18": List<dynamic>.from(page18.map((x) => x)),
        "page_19": List<dynamic>.from(page19.map((x) => x)),
        "page_20": List<dynamic>.from(page20.map((x) => x)),
        "page_21": List<dynamic>.from(page21.map((x) => x)),
        "page_22": List<dynamic>.from(page22.map((x) => x)),
        "page_23": List<dynamic>.from(page23.map((x) => x)),
        "page_24": List<dynamic>.from(page24.map((x) => x)),
        "page_25": List<dynamic>.from(page25.map((x) => x)),
        "page_26": List<dynamic>.from(page26.map((x) => x)),
        "page_27": List<dynamic>.from(page27.map((x) => x)),
        "page_28": List<dynamic>.from(page28.map((x) => x)),
        "page_29": List<dynamic>.from(page29.map((x) => x)),
        "page_30": List<dynamic>.from(page30.map((x) => x)),
        "page_31": List<dynamic>.from(page31.map((x) => x)),
        "page_32": List<dynamic>.from(page32.map((x) => x)),
        "page_33": List<dynamic>.from(page33.map((x) => x)),
        "page_34": List<dynamic>.from(page34.map((x) => x)),
        "page_35": List<dynamic>.from(page35.map((x) => x)),
        "page_36": List<dynamic>.from(page36.map((x) => x)),
        "page_37": List<dynamic>.from(page37.map((x) => x)),
        "page_38": List<dynamic>.from(page38.map((x) => x)),
        "page_39": List<dynamic>.from(page39.map((x) => x)),
        "page_40": List<dynamic>.from(page40.map((x) => x)),
        "page_41": List<dynamic>.from(page41.map((x) => x)),
        "page_42": List<dynamic>.from(page42.map((x) => x)),
        "page_43": List<dynamic>.from(page43.map((x) => x)),
        "page_44": List<dynamic>.from(page44.map((x) => x)),
        "page_45": List<dynamic>.from(page45.map((x) => x)),
        "page_46": List<dynamic>.from(page46.map((x) => x)),
        "page_47": List<dynamic>.from(page47.map((x) => x)),
        "page_48": List<dynamic>.from(page48.map((x) => x)),
        "page_49": List<dynamic>.from(page49.map((x) => x)),
        "page_50": List<dynamic>.from(page50.map((x) => x)),
        "page_51": List<dynamic>.from(page51.map((x) => x)),
        "page_52": List<dynamic>.from(page52.map((x) => x)),
        "page_53": List<dynamic>.from(page53.map((x) => x)),
        "page_54": List<dynamic>.from(page54.map((x) => x)),
        "page_55": List<dynamic>.from(page55.map((x) => x)),
        "page_56": List<dynamic>.from(page56.map((x) => x)),
        "page_57": List<dynamic>.from(page57.map((x) => x)),
        "page_58": List<dynamic>.from(page58.map((x) => x)),
        "page_59": List<dynamic>.from(page59.map((x) => x)),
        "page_60`": List<dynamic>.from(page60.map((x) => x)),
        "page_61`": List<dynamic>.from(page61.map((x) => x)),
        "page_62`": List<dynamic>.from(page62.map((x) => x)),
        "page_63`": List<dynamic>.from(page63.map((x) => x)),
        "page_64`": List<dynamic>.from(page64.map((x) => x)),
        "page_65`": List<dynamic>.from(page65.map((x) => x)),
        "page_66`": List<dynamic>.from(page66.map((x) => x)),
        "page_67`": List<dynamic>.from(page67.map((x) => x)),
        "page_68`": List<dynamic>.from(page68.map((x) => x)),
        "page_69`": List<dynamic>.from(page69.map((x) => x)),
        "page_70`": List<dynamic>.from(page70.map((x) => x)),
        "page_71`": List<dynamic>.from(page71.map((x) => x)),
        "page_72`": List<dynamic>.from(page72.map((x) => x)),
        "page_73`": List<dynamic>.from(page73.map((x) => x)),
        "page_74`": List<dynamic>.from(page74.map((x) => x)),
        "page_75`": List<dynamic>.from(page75.map((x) => x)),
        "page_76`": List<dynamic>.from(page76.map((x) => x)),
        "page_77`": List<dynamic>.from(page77.map((x) => x)),
        "page_78`": List<dynamic>.from(page78.map((x) => x)),
        "page_79`": List<dynamic>.from(page79.map((x) => x)),
        "page_80`": List<dynamic>.from(page80.map((x) => x)),
        "page_81`": List<dynamic>.from(page81.map((x) => x)),
        "page_82`": List<dynamic>.from(page82.map((x) => x)),
        "page_83`": List<dynamic>.from(page83.map((x) => x)),
        "page_84`": List<dynamic>.from(page84.map((x) => x)),
        "page_85`": List<dynamic>.from(page85.map((x) => x)),
        "page_86`": List<dynamic>.from(page86.map((x) => x)),
        "page_87`": List<dynamic>.from(page87.map((x) => x)),
        "page_88`": List<dynamic>.from(page88.map((x) => x)),
        "page_89`": List<dynamic>.from(page89.map((x) => x)),
        "page_90`": List<dynamic>.from(page90.map((x) => x)),
        "page_91`": List<dynamic>.from(page91.map((x) => x)),
        "page_92`": List<dynamic>.from(page92.map((x) => x)),
        "page_93`": List<dynamic>.from(page93.map((x) => x)),
        "page_94`": List<dynamic>.from(page94.map((x) => x)),
        "page_95`": List<dynamic>.from(page95.map((x) => x)),
        "page_96`": List<dynamic>.from(page96.map((x) => x)),
        "page_97`": List<dynamic>.from(page97.map((x) => x)),
        "page_98`": List<dynamic>.from(page98.map((x) => x)),
        "page_99`": List<dynamic>.from(page99.map((x) => x)),
        "page_100`": List<dynamic>.from(page100.map((x) => x)),
        "page_101`": List<dynamic>.from(page101.map((x) => x)),
        "page_102`": List<dynamic>.from(page102.map((x) => x)),
        "page_103`": List<dynamic>.from(page103.map((x) => x)),
        "page_104`": List<dynamic>.from(page104.map((x) => x)),
        "page_105`": List<dynamic>.from(page105.map((x) => x)),
        "page_106`": List<dynamic>.from(page106.map((x) => x)),
        "page_107`": List<dynamic>.from(page107.map((x) => x)),
        "page_108`": List<dynamic>.from(page108.map((x) => x)),
        "page_109`": List<dynamic>.from(page109.map((x) => x)),
        "page_110`": List<dynamic>.from(page110.map((x) => x)),
        "page_111`": List<dynamic>.from(page111.map((x) => x)),
        "page_112": List<dynamic>.from(page112.map((x) => x)),
        "page_113": List<dynamic>.from(page113.map((x) => x)),
        "page_114": List<dynamic>.from(page114.map((x) => x)),
        "page_115": List<dynamic>.from(page115.map((x) => x)),
        "page_116": List<dynamic>.from(page116.map((x) => x)),
        "page_117": List<dynamic>.from(page117.map((x) => x)),
        "page_118": List<dynamic>.from(page118.map((x) => x)),
        "page_119": List<dynamic>.from(page119.map((x) => x)),
        "page_120": List<dynamic>.from(page120.map((x) => x)),
        "page_121": List<dynamic>.from(page121.map((x) => x)),
        "page_122": List<dynamic>.from(page122.map((x) => x)),
        "page_123": List<dynamic>.from(page123.map((x) => x)),
        "page_124": List<dynamic>.from(page124.map((x) => x)),
        "page_125": List<dynamic>.from(page125.map((x) => x)),
        "page_126": List<dynamic>.from(page126.map((x) => x)),
        "page_127": List<dynamic>.from(page127.map((x) => x)),
        "page_128": List<dynamic>.from(page128.map((x) => x)),
        "page_129": List<dynamic>.from(page129.map((x) => x)),
        "page_130": List<dynamic>.from(page130.map((x) => x)),
        "page_131": List<dynamic>.from(page131.map((x) => x)),
        "page_132": List<dynamic>.from(page132.map((x) => x)),
        "page_133": List<dynamic>.from(page133.map((x) => x)),
        "page_134": List<dynamic>.from(page134.map((x) => x)),
        "page_135": List<dynamic>.from(page135.map((x) => x)),
        "page_136": List<dynamic>.from(page136.map((x) => x)),
        "page_137": List<dynamic>.from(page137.map((x) => x)),
        "page_138": List<dynamic>.from(page138.map((x) => x)),
        "page_139": List<dynamic>.from(page139.map((x) => x)),
        "page_140": List<dynamic>.from(page140.map((x) => x)),
        "page_141": List<dynamic>.from(page141.map((x) => x)),
        "page_142": List<dynamic>.from(page142.map((x) => x)),
        "page_143": List<dynamic>.from(page143.map((x) => x)),
        "page_144": List<dynamic>.from(page144.map((x) => x)),
        "page_145": List<dynamic>.from(page145.map((x) => x)),
        "page_146": List<dynamic>.from(page146.map((x) => x)),
        "page_147": List<dynamic>.from(page147.map((x) => x)),
        "page_148": List<dynamic>.from(page148.map((x) => x)),
        "page_149": List<dynamic>.from(page149.map((x) => x)),
        "page_150": List<dynamic>.from(page150.map((x) => x)),
        "page_151": List<dynamic>.from(page151.map((x) => x)),
        "page_152": List<dynamic>.from(page152.map((x) => x)),
        "page_153": List<dynamic>.from(page153.map((x) => x)),
        "page_154": List<dynamic>.from(page154.map((x) => x)),
        "page_155": List<dynamic>.from(page155.map((x) => x)),
        "page_156": List<dynamic>.from(page156.map((x) => x)),
        "page_157": List<dynamic>.from(page157.map((x) => x)),
        "page_158": List<dynamic>.from(page158.map((x) => x)),
        "page_159": List<dynamic>.from(page159.map((x) => x)),
        "page_160": List<dynamic>.from(page160.map((x) => x)),
        "page_161": List<dynamic>.from(page161.map((x) => x)),
        "page_162": List<dynamic>.from(page162.map((x) => x)),
        "page_163": List<dynamic>.from(page163.map((x) => x)),
        "page_164": List<dynamic>.from(page164.map((x) => x)),
        "page_165": List<dynamic>.from(page165.map((x) => x)),
        "page_166": List<dynamic>.from(page166.map((x) => x)),
        "page_167": List<dynamic>.from(page167.map((x) => x)),
        "page_168": List<dynamic>.from(page168.map((x) => x)),
        "page_169": List<dynamic>.from(page169.map((x) => x)),
        "page_170": List<dynamic>.from(page170.map((x) => x)),
        "page_171": List<dynamic>.from(page171.map((x) => x)),
        "page_172": List<dynamic>.from(page172.map((x) => x)),
        "page_173": List<dynamic>.from(page173.map((x) => x)),
        "page_174": List<dynamic>.from(page174.map((x) => x)),
        "page_175": List<dynamic>.from(page175.map((x) => x)),
        "page_176": List<dynamic>.from(page176.map((x) => x)),
        "page_177": List<dynamic>.from(page177.map((x) => x)),
        "page_178": List<dynamic>.from(page178.map((x) => x)),
        "page_179": List<dynamic>.from(page179.map((x) => x)),
        "page_180": List<dynamic>.from(page180.map((x) => x)),
        "page_181": List<dynamic>.from(page181.map((x) => x)),
        "page_182": List<dynamic>.from(page182.map((x) => x)),
        "page_183": List<dynamic>.from(page183.map((x) => x)),
        "page_184": List<dynamic>.from(page184.map((x) => x)),
        "page_185": List<dynamic>.from(page185.map((x) => x)),
        "page_186": List<dynamic>.from(page186.map((x) => x)),
        "page_187": List<dynamic>.from(page187.map((x) => x)),
        "page_188": List<dynamic>.from(page188.map((x) => x)),
        "page_189": List<dynamic>.from(page189.map((x) => x)),
        "page_190": List<dynamic>.from(page190.map((x) => x)),
        "page_191": List<dynamic>.from(page191.map((x) => x)),
        "page_192": List<dynamic>.from(page192.map((x) => x)),
        "page_193": List<dynamic>.from(page193.map((x) => x)),
        "page_194": List<dynamic>.from(page194.map((x) => x)),
        "page_195": List<dynamic>.from(page195.map((x) => x)),
        "page_196": List<dynamic>.from(page196.map((x) => x)),
        "page_197": List<dynamic>.from(page197.map((x) => x)),
        "page_198": List<dynamic>.from(page198.map((x) => x)),
        "page_199": List<dynamic>.from(page199.map((x) => x)),
        "page_200": List<dynamic>.from(page200.map((x) => x)),
        "page_201": List<dynamic>.from(page201.map((x) => x)),
        "page_202": List<dynamic>.from(page202.map((x) => x)),
        "page_203": List<dynamic>.from(page203.map((x) => x)),
        "page_204": List<dynamic>.from(page204.map((x) => x)),
        "page_205": List<dynamic>.from(page205.map((x) => x)),
        "page_206": List<dynamic>.from(page206.map((x) => x)),
        "page_207": List<dynamic>.from(page207.map((x) => x)),
        "page_208": List<dynamic>.from(page208.map((x) => x)),
        "page_209": List<dynamic>.from(page209.map((x) => x)),
        "page_210": List<dynamic>.from(page210.map((x) => x)),
        "page_211": List<dynamic>.from(page211.map((x) => x)),
        "page_212": List<dynamic>.from(page212.map((x) => x)),
        "page_213": List<dynamic>.from(page213.map((x) => x)),
        "page_214": List<dynamic>.from(page214.map((x) => x)),
        "page_215": List<dynamic>.from(page215.map((x) => x)),
        "page_216": List<dynamic>.from(page216.map((x) => x)),
        "page_217": List<dynamic>.from(page217.map((x) => x)),
        "page_218": List<dynamic>.from(page218.map((x) => x)),
        "page_219": List<dynamic>.from(page219.map((x) => x)),
        "page_220": List<dynamic>.from(page220.map((x) => x)),
        "page_221": List<dynamic>.from(page221.map((x) => x)),
        "page_222": List<dynamic>.from(page222.map((x) => x)),
        "page_223": List<dynamic>.from(page223.map((x) => x)),
        "page_224": List<dynamic>.from(page224.map((x) => x)),
        "page_225": List<dynamic>.from(page225.map((x) => x)),
        "page_226": List<dynamic>.from(page226.map((x) => x)),
        "page_227": List<dynamic>.from(page227.map((x) => x)),
        "page_228": List<dynamic>.from(page228.map((x) => x)),
        "page_229": List<dynamic>.from(page229.map((x) => x)),
        "page_230": List<dynamic>.from(page230.map((x) => x)),
        "page_231": List<dynamic>.from(page231.map((x) => x)),
        "page_232": List<dynamic>.from(page232.map((x) => x)),
        "page_233": List<dynamic>.from(page233.map((x) => x)),
        "page_234": List<dynamic>.from(page234.map((x) => x)),
        "page_235": List<dynamic>.from(page235.map((x) => x)),
        "page_236": List<dynamic>.from(page236.map((x) => x)),
        "page_237": List<dynamic>.from(page237.map((x) => x)),
        "page_238": List<dynamic>.from(page238.map((x) => x)),
        "page_239": List<dynamic>.from(page239.map((x) => x)),
        "page_240": List<dynamic>.from(page240.map((x) => x)),
        "page_241": List<dynamic>.from(page241.map((x) => x)),
        "page_242": List<dynamic>.from(page242.map((x) => x)),
        "page_243": List<dynamic>.from(page243.map((x) => x)),
        "page_244": List<dynamic>.from(page244.map((x) => x)),
        "page_245": List<dynamic>.from(page245.map((x) => x)),
        "page_246": List<dynamic>.from(page246.map((x) => x)),
        "page_247": List<dynamic>.from(page247.map((x) => x)),
        "page_248": List<dynamic>.from(page248.map((x) => x)),
        "page_249": List<dynamic>.from(page249.map((x) => x)),
        "page_250": List<dynamic>.from(page250.map((x) => x)),
        "page_251": List<dynamic>.from(page251.map((x) => x)),
        "page_252": List<dynamic>.from(page252.map((x) => x)),
        "page_253": List<dynamic>.from(page253.map((x) => x)),
        "page_254": List<dynamic>.from(page254.map((x) => x)),
        "page_255": List<dynamic>.from(page255.map((x) => x)),
        "page_256": List<dynamic>.from(page256.map((x) => x)),
        "page_257": List<dynamic>.from(page257.map((x) => x)),
        "page_258": List<dynamic>.from(page258.map((x) => x)),
        "page_259": List<dynamic>.from(page259.map((x) => x)),
        "page_260": List<dynamic>.from(page260.map((x) => x)),
        "page_261": List<dynamic>.from(page261.map((x) => x)),
        "page_262": List<dynamic>.from(page262.map((x) => x)),
        "page_263": List<dynamic>.from(page263.map((x) => x)),
        "page_264": List<dynamic>.from(page264.map((x) => x)),
        "page_265": List<dynamic>.from(page264.map((x) => x)),
        "page_266": List<dynamic>.from(page266.map((x) => x)),
        "page_267": List<dynamic>.from(page267.map((x) => x)),
        "page_268": List<dynamic>.from(page268.map((x) => x)),
        "page_269": List<dynamic>.from(page269.map((x) => x)),
        "page_270": List<dynamic>.from(page270.map((x) => x)),
        "page_271": List<dynamic>.from(page271.map((x) => x)),
        "page_272": List<dynamic>.from(page272.map((x) => x)),
        "page_273": List<dynamic>.from(page273.map((x) => x)),
        "page_274": List<dynamic>.from(page274.map((x) => x)),
        "page_275": List<dynamic>.from(page275.map((x) => x)),
        "page_276": List<dynamic>.from(page276.map((x) => x)),
        "page_277": List<dynamic>.from(page277.map((x) => x)),
        "page_278": List<dynamic>.from(page278.map((x) => x)),
      };
}
