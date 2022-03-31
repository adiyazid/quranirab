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
  });

  List<int> page1;
  List<int> page2;

  factory BreakIndex.fromJson(Map<String, dynamic> json) => BreakIndex(
        page1: List<int>.from(json["page_1"].map((x) => x)),
        page2: List<int>.from(json["page_2"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "page_1": List<dynamic>.from(page1.map((x) => x)),
        "page_2": List<dynamic>.from(page2.map((x) => x)),
      };
}
