// To parse this JSON data, do
//
//     final surahSplit = surahSplitFromJson(jsonString);

import 'dart:convert';

SurahSplit surahSplitFromJson(String str) =>
    SurahSplit.fromJson(json.decode(str));

String surahSplitToJson(SurahSplit data) => json.encode(data.toJson());

class SurahSplit {
  SurahSplit({
    required this.splitSura,
  });

  List<SplitSura> splitSura;

  factory SurahSplit.fromJson(Map<String, dynamic> json) => SurahSplit(
        splitSura: List<SplitSura>.from(
            json["split_sura"].map((x) => SplitSura.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "split_sura": List<dynamic>.from(splitSura.map((x) => x.toJson())),
      };
}

class SplitSura {
  SplitSura({
    required this.page,
    required this.suraId,
    required this.start,
    required this.end,
    required this.numStart,
  });

  int page;
  int suraId;
  int start;
  int end;
  int numStart;

  factory SplitSura.fromJson(Map<String, dynamic> json) => SplitSura(
        page: json["page"],
        suraId: json["sura_id"],
        start: json["start"],
        end: json["end"],
        numStart: json["numStart"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "sura_id": suraId,
        "start": start,
        "end": end,
        "numStart": numStart,
      };
}
